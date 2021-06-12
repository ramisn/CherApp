/* eslint-disable jsx-a11y/media-has-caption */
/* eslint-disable react/forbid-prop-types */

import React from 'react';
import PropTypes from 'prop-types';
import VideoChatParticipants from './VideoChatParticipants';
import { VideoChatInsideConfig, VideoChatExitActions } from './VideoChatActions';

const VideoChatTile = ({ id }) => (
  <div id={`videoTile${id}`} className="is-main-body video-tile-video is-main-body has-full-width">
    <label id={`videoTile${id}Label`} className="has-text-white is-bold is-absolute is-fully-centered has-full-width is-above-container to-bottom m-b-sm" />
    <video id={`video-${id}`} className="has-full-width" />
  </div>
);

VideoChatTile.propTypes = {
  id: PropTypes.number,
};

const VideoChatRoom = ({
  userExternalName,
  configuring,
  stopCall,
  endCall,
  participants,
  toggleAudio,
  videoInputDeviceIds,
  audioOutputDeviceIds,
  audioInputDevicesIds,
  setDeviceSelected,
  micToggleState,
  camToggleState,
  toggleCamera,
  toggleSpeaker,
  speakerToggleState,
}) => (
  <div className={`is-relative ${configuring ? 'is-hidden' : ''}`}>
    <div className="is-absolute is-above-container">
      <VideoChatInsideConfig
        toggleMic={toggleAudio}
        toggleCamera={toggleCamera}
        setDeviceSelected={setDeviceSelected}
        videoInputDeviceIds={videoInputDeviceIds}
        audioOutputDeviceIds={audioOutputDeviceIds}
        audioInputDevicesIds={audioInputDevicesIds}
        micToggleState={micToggleState}
        camToggleState={camToggleState}
        toggleSpeaker={toggleSpeaker}
        speakerToggleState={speakerToggleState}
      />
    </div>

    <div className="columns is-marginless">
      <div className="video-tiles-container">
        <div id="videoTile1" className="video-tile-video is-video-active is-main-body has-full-width">
          <label id={`videoTile1Label`} className="has-text-white is-bold is-absolute is-fully-centered has-full-width is-above-container to-bottom m-b-sm" />
          <video id="video-1" className="has-full-width" />
        </div>

        <VideoChatTile id={2} />
        <VideoChatTile id={3} />
        <VideoChatTile id={4} />
        <VideoChatTile id={5} />
        <VideoChatExitActions
          stopCall={stopCall}
          endCall={endCall}
        />
      </div>

      <VideoChatParticipants
        participants={participants}
        userExternalName={userExternalName}
        cameraState={camToggleState}
      />
      <audio id="meetingAudio" autoPlay />
    </div>
  </div>
);

VideoChatRoom.propTypes = {
  stopCall: PropTypes.func.isRequired,
  toggleAudio: PropTypes.func.isRequired,
  userExternalName: PropTypes.string,
  configuring: PropTypes.bool,
  endCall: PropTypes.func,
  participants: PropTypes.object,
  videoInputDeviceIds: PropTypes.arrayOf(PropTypes.object),
  audioOutputDeviceIds: PropTypes.arrayOf(PropTypes.object),
  audioInputDevicesIds: PropTypes.arrayOf(PropTypes.object),
  setDeviceSelected: PropTypes.func,
  micToggleState: PropTypes.bool,
  camToggleState: PropTypes.bool,
  toggleCamera: PropTypes.func,
  toggleSpeaker: PropTypes.func,
  speakerToggleState: PropTypes.bool,
};

export default VideoChatRoom;
