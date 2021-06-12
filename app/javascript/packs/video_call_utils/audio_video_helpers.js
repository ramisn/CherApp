/* eslint-disable no-restricted-syntax */
/* eslint-disable guard-for-in */

import {
  ConsoleLogger,
  LogLevel,
  DefaultDeviceController,
  DefaultMeetingSession,
  MeetingSessionConfiguration,
  DefaultActiveSpeakerPolicy,
} from 'amazon-chime-sdk-js';

import { parseMeetingParams, userNameFromExternalUserId } from './index.js';

export const createSessionConfigObject = ({ meeting, attendee }) => (
  new MeetingSessionConfiguration({
    Meeting: parseMeetingParams(meeting),
  }, {
    Attendee: parseMeetingParams(attendee),
  })
);

export const generateConstants = (videoCallConfiguration) => {
  const logger = new ConsoleLogger('SDK', LogLevel.ERROR);
  const deviceController = new DefaultDeviceController(logger);
  const meetingSession = new DefaultMeetingSession(
    videoCallConfiguration, logger, deviceController,
  );

  return { logger, deviceController, meetingSession };
};

export const getDeviceIds = async (audioVideo) => ({
  audioOutputDeviceIds: await audioVideo.listAudioOutputDevices(),
  audioInputDevicesIds: await audioVideo.listAudioInputDevices(),
  videoInputDeviceIds: await audioVideo.listVideoInputDevices(),
});

// Handles participant's real time events such as volume, muted, active user.
export const realtimeAttendeeHandler = (
  state, setState, audioVideo,
) => (attendeeId, present, externalUserId) => {
  const { participants } = state();
  const newParticipants = { ...participants };

  if (!present) {
    delete newParticipants[attendeeId];
    setState({ participants: newParticipants });
    return;
  }

  if (!newParticipants[attendeeId]) {
    newParticipants[attendeeId] = {
      externalUserId: externalUserId.toLowerCase(),
      userName: userNameFromExternalUserId(externalUserId),
      attendeeId,
      camera: true,
    };

    setState({ participants: newParticipants });
  }

  audioVideo.realtimeSubscribeToVolumeIndicator(
    attendeeId,
    async (_attendeeId, volume, muted) => {
      const { participants: realTimeParticipants } = state();
      const newRealTimeParticipants = { ...realTimeParticipants };

      if (!newRealTimeParticipants[attendeeId]) {
        return;
      }
      if (volume !== null) {
        newRealTimeParticipants[attendeeId].volume = Math.round(volume * 100);
      }
      if (muted !== null) {
        newRealTimeParticipants[attendeeId].muted = muted;
      }
      setState({ participants: newRealTimeParticipants });
    },
  );

  const activeSpeakerHandler = (attendeeIds) => {
    const { participants: realTimeParticipants } = state();
    const newRealTimeParticipants = { ...realTimeParticipants };

    if (!attendeeIds.length) return;

    for (const aId in newRealTimeParticipants) {
      newRealTimeParticipants[aId].active = false;
    }

    for (const aId of attendeeIds) {
      if (newRealTimeParticipants[aId]) {
        newRealTimeParticipants[aId].active = true;
        break;
      }
    }

    setState({ participants: newRealTimeParticipants });
  };

  audioVideo.subscribeToActiveSpeakerDetector(
    new DefaultActiveSpeakerPolicy(),
    activeSpeakerHandler,
    (scores) => {
      const { participants: scoreParticipants } = state();
      const newScopeParticipants = { ...scoreParticipants };

      for (const id in scores) {
        if (newScopeParticipants[id]) {
          newScopeParticipants[id].score = scores[id];
        }
      }
      setState({ participants: newScopeParticipants });
    },
    0,
  );
};

// Sets video tile to video element
export const bindVideoTiles = (audioVideo, videoTiles) => {
  videoTiles.forEach((videoTile) => {
    const videoElement = document.getElementById(`video-${videoTile.tileState.tileId}`);
    audioVideo.bindVideoElement(videoTile.tileState.tileId, videoElement);
  });
};

// Gets all the elements related to a user based on the externalTileId
export const getUserTileElements = ({ externalTileId }) => ({
  videoContainer: document.getElementById(`videoTile${externalTileId}`),
  videoE: document.getElementById(`video-${externalTileId}`),
  nameLabel: document.getElementById(`videoTile${externalTileId}Label`),
});

export const deviceLabelTriggerHandler = async () => {
  const stream = await navigator.mediaDevices.getUserMedia({ audio: true, video: true });

  return stream;
};

export const handleVideoCamerasChanged = (participants, videoSources) => {
  const newParticipants = { ...participants };
  const availableCameras = videoSources.map((vs) => vs.attendee.attendeeId);

  // Sets whether participant has camera on or off
  Object.keys(participants).forEach((attendeeId) => {
    if (availableCameras.includes(attendeeId)) newParticipants[attendeeId].camera = true;
    else newParticipants[attendeeId].camera = false;
  });

  return newParticipants;
};
