/* eslint-disable jsx-a11y/media-has-caption */
/* eslint-disable react/no-unused-state */

import React, { Component } from 'react';
import PropTypes from 'prop-types';
import axios from '../../packs/axios_utils.js';
import { toCamel, userNameFromExternalUserId } from '../../packs/video_call_utils/index.js';
import {
  createSessionConfigObject,
  getDeviceIds,
  generateConstants,
  realtimeAttendeeHandler,
  bindVideoTiles,
  deviceLabelTriggerHandler,
  getUserTileElements,
  handleVideoCamerasChanged,
} from '../../packs/video_call_utils/audio_video_helpers.js';
import TestSound from '../../packs/video_call_utils/test_sound.js';
import TileOrganizer from '../../packs/video_call_utils/tile_organizer.js';
import VideoChatConfig from './VideoChatConfig';
import VideoChatRoom from './VideoChatRoom';
import VideoChatFull from './VideoChatFull';

class VideoChatConversation extends Component {
  constructor() {
    super();

    this.state = {
      full: false,
      logger: null,
      configuring: true,
      videoCallConfiguration: null,
      meetingSession: null,
      audioVideo: null,
      webAudio: true,
      deviceController: null,
      videoInputDeviceIds: [],
      videoInputDeviceSelected: '',
      audioOutputDeviceSelected: 'default',
      audioOutputDeviceIds: [],
      audioInputDeviceSelected: 'default',
      audioInputDevicesIds: [],
      videoPreviewRef: React.createRef(),
      participants: {},
      muted: false,
      showCamera: true,
      speakerOn: false,
      tileOrganizer: new TileOrganizer(),
    };
  }

  componentDidMount() {
    this.startMeeting();
  }

  componentDidUpdate(_prevProps, prevState) {
    const { videoCallConfiguration } = this.state;

    if (prevState.videoCallConfiguration !== videoCallConfiguration) {
      this.initializeMeeting();
    }
  }

  componentWillUnmount() {
    const { audioVideo } = this.state;

    audioVideo.stop();
  }

  startMeeting = () => {
    const { channelSid } = this.props;
    const params = { channel_sid: channelSid };

    axios.post('/video-calls', params)
      .then(({ data }) => {
        this.setState({
          videoCallConfiguration: createSessionConfigObject(data),
          full: false,
        });
      })
      .catch(({ response }) => {
        if (response.status === 422) this.setState({ full: true });
      });
  }

  initializeMeeting = async () => {
    const { videoCallConfiguration, webAudio } = this.state;
    videoCallConfiguration.enableWebAudio = webAudio;

    const { logger, deviceController, meetingSession } = generateConstants(videoCallConfiguration);
    const { audioVideo } = meetingSession;

    this.getDevices(audioVideo);
    this.initializeLifecycles(audioVideo, meetingSession);
    this.setupParticipantsEvents(audioVideo, meetingSession);

    this.setState({
      logger,
      deviceController,
      meetingSession,
      audioVideo,
    });
  }

  setupParticipantsEvents = (audioVideo) => {
    audioVideo.realtimeSubscribeToAttendeeIdPresence(
      (...params) => {
        const state = () => this.state;
        const setState = (newState) => this.setState(newState);
        realtimeAttendeeHandler(state, setState, audioVideo)(...params);
      },
    );
  }

  getDevices = async (audioVideo) => {
    const { videoPreviewRef } = this.state;
    const {
      audioInputDevicesIds, audioOutputDeviceIds, videoInputDeviceIds,
    } = await getDeviceIds(audioVideo);

    audioVideo.chooseAudioInputDevice(audioInputDevicesIds[0]?.deviceId);
    audioVideo.chooseAudioOutputDevice(audioOutputDeviceIds[0]?.deviceId);
    if (videoInputDeviceIds[0]) {
      await audioVideo.chooseVideoInputDevice(videoInputDeviceIds[0].deviceId);
      await audioVideo.startVideoPreviewForVideoInput(videoPreviewRef?.current);
    }

    this.setState({
      videoInputDeviceIds,
      audioOutputDeviceIds,
      audioInputDevicesIds,
      videoInputDeviceSelected: videoInputDeviceIds[0]?.deviceId,
      audioOutputDeviceSelected: audioOutputDeviceIds[0]?.deviceId,
      audioInputDeviceSelected: audioInputDevicesIds[0]?.deviceId,
    });
  }

  startCall = async () => {
    const { audioVideo } = this.state;

    await audioVideo.startLocalVideoTile();
    audioVideo.start();
    this.showAllVideoTiles();
  }

  stopCall = async () => {
    const { audioVideo } = this.state;

    await audioVideo.stop();
    window.location.href = window.location.href.replace('video-calls', 'conversations');
  }

  eventDidReceive = (name) => {
    if (name === 'meetingEnded') this.stopCall();
  }

  setDeviceSelected = async (device, id) => {
    const { audioVideo } = this.state;
    const stateKey = toCamel(device);

    await audioVideo[`choose${stateKey}`](id);
    this.setState({ [stateKey]: id });
  }

  joinCall = () => {
    this.startCall();
    this.setState({ configuring: false });
    setTimeout(this.toggleSpeaker, 1000);
  }

  showAllVideoTiles = () => {
    const { audioVideo } = this.state;
    const videoTiles = audioVideo.getAllVideoTiles();

    if (videoTiles.length === 0) return;
    bindVideoTiles(audioVideo, videoTiles);
  }

  testSound = async () => {
    const {
      logger, audioOutputDeviceSelected, audioVideo, videoPreviewRef,
    } = this.state;
    audioVideo.startVideoPreviewForVideoInput(videoPreviewRef.current);

    const testSound = new TestSound(logger, audioOutputDeviceSelected);
    await testSound.init();
  }

  toggleAudio = () => {
    const { muted, audioVideo } = this.state;

    if (muted) audioVideo.realtimeUnmuteLocalAudio();
    else audioVideo.realtimeMuteLocalAudio();

    this.setState({ muted: !muted });
  }

  toggleSpeaker = () => {
    const { audioVideo, speakerOn } = this.state;

    if (speakerOn) {
      audioVideo.unbindAudioElement();
    } else {
      const meetingAudioElement = document.getElementById('meetingAudio');
      audioVideo.bindAudioElement(meetingAudioElement);
    }
  }

  toggleCamera = () => {
    const { audioVideo, showCamera, videoInputDeviceSelected } = this.state;

    audioVideo.stopLocalVideoTile();

    if (!showCamera) {
      audioVideo.chooseVideoInputDevice(videoInputDeviceSelected);
      audioVideo.startLocalVideoTile();
      audioVideo.start();
    }

    this.setState({ showCamera: !showCamera });
  }

  endCall = async () => {
    const { channelSid } = this.props;

    axios.delete(`/video-calls/${channelSid}`).then(() => this.stopCall());
  }

  videoTileWasRemoved(tileId) {
    const { tileOrganizer } = this.state;
    const tile = tileOrganizer.releaseTileIndex(tileId);
    const { videoContainer, nameLabel } = getUserTileElements(tile);

    videoContainer.removeAttribute('data-external-id');
    nameLabel.innerText = '';
  }

  videoTileDidUpdate(tileState) {
    const { audioVideo, tileOrganizer } = this.state;
    const { boundExternalUserId } = tileState;
    const tile = tileOrganizer.acquireTileIndex(tileState.tileId, boundExternalUserId);

    if (!tile) return;

    const { videoContainer, videoE, nameLabel } = getUserTileElements(tile);

    videoContainer.setAttribute('data-external-id', boundExternalUserId?.toLowerCase());
    nameLabel.innerText = userNameFromExternalUserId(boundExternalUserId);
    audioVideo.bindVideoElement(tileState.tileId, videoE);
  }

  remoteVideoSourcesDidChange(videoSources) {
    const { participants } = this.state;
    const newParticipants = handleVideoCamerasChanged(participants, videoSources);
    this.setState({ participants: newParticipants });
  }

  async initializeLifecycles(audioVideo, meetingSession) {
    audioVideo.addObserver(this);
    audioVideo.setDeviceLabelTrigger(deviceLabelTriggerHandler);
    meetingSession.contentShare.addContentShareObserver(this);
  }

  render() {
    const { userExternalName, channelSid } = this.props;
    const {
      videoInputDeviceIds,
      audioOutputDeviceIds,
      audioInputDevicesIds,
      configuring,
      videoPreviewRef,
      participants,
      muted,
      showCamera,
      speakerOn,
      full,
    } = this.state;

    if (full) {
      return (
        <VideoChatFull
          channelSid={channelSid}
          tryAgain={this.startMeeting}
        />
      );
    }

    return (
      <>
        { configuring && (
          <VideoChatConfig
            joinCall={this.joinCall}
            videoInputDeviceIds={videoInputDeviceIds}
            audioOutputDeviceIds={audioOutputDeviceIds}
            audioInputDevicesIds={audioInputDevicesIds}
            setDeviceSelected={this.setDeviceSelected}
            testSound={this.testSound}
            videoPreviewRef={videoPreviewRef}
            userExternalName={userExternalName}
            channelSid={channelSid}
          />

        ) }

        <VideoChatRoom
          userExternalName={userExternalName}
          configuring={configuring}
          stopCall={this.stopCall}
          endCall={this.endCall}
          participants={participants}
          videoInputDeviceIds={videoInputDeviceIds}
          audioOutputDeviceIds={audioOutputDeviceIds}
          audioInputDevicesIds={audioInputDevicesIds}
          setDeviceSelected={this.setDeviceSelected}
          toggleAudio={this.toggleAudio}
          toggleCamera={this.toggleCamera}
          toggleSpeaker={this.toggleSpeaker}
          micToggleState={muted}
          camToggleState={showCamera}
          speakerToggleState={speakerOn}
        />
      </>
    );
  }
}

VideoChatConversation.propTypes = {
  channelSid: PropTypes.string.isRequired,
  userExternalName: PropTypes.string.isRequired,
};

export default VideoChatConversation;
