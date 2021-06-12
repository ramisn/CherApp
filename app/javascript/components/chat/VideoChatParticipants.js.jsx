/* eslint-disable react/jsx-props-no-spreading */
/* eslint-disable react/forbid-prop-types */

import React, { useEffect } from 'react';
import PropTypes from 'prop-types';
import TalkingIcon from '../../../assets/images/cherapp-ownership-coborrowing-talking-ico.svg';
import MicOn from '../../../assets/images/cherapp-ownership-checkout-mic-on.svg';
import MicOff from '../../../assets/images/cherapp-ownership-checkout-mic-off.svg';
import CameraOn from '../../../assets/images/cherapp-ownership-checkout-cam-on.svg';
import CameraOff from '../../../assets/images/cherapp-ownership-checkout-cam-off.svg';

const cameraIconState = (
  userExternalName, userName, cameraState, camera,
) => (userExternalName === userName.toLowerCase() ? cameraState : camera);

const Participant = ({
  userExternalName, attendeeId, volume, muted, userName, cameraState, camera,
}) => (
  <div className="columns is-marginless is-paddingless is-mobile" key={attendeeId}>
    <div className="column is-paddingless is-1 is-fully-centered">
      {volume > 20 ? <img alt="Talking icon" src={TalkingIcon} /> : null }
    </div>
    <div className="column is-paddingless has-margin-y-auto has-overflow-elipsed is-3-widescreen is-6-tablet is-6-desktop">{userName}</div>
    <div className="column p-sm is-fully-centered is-narrow is-1-desktop is-2">
      <img alt="Microphone status" src={muted ? MicOff : MicOn} />
    </div>
    <div className="column p-sm is-fully-centered is-narrow is-1-desktop is-2">
      <img
        alt="Camera status"
        src={
          cameraIconState(userExternalName, userName, cameraState, camera) ? CameraOn : CameraOff
        }
      />
    </div>
  </div>
);

Participant.propTypes = {
  userExternalName: PropTypes.string,
  attendeeId: PropTypes.string,
  volume: PropTypes.number,
  muted: PropTypes.bool,
  userName: PropTypes.string,
  cameraState: PropTypes.bool,
  camera: PropTypes.bool,
};

const VideoChatParticipants = ({ participants, userExternalName, cameraState }) => {
  useEffect(() => {
    let someoneTalking = false;

    Object.keys(participants).forEach((attendeeId) => {
      const participant = participants[attendeeId];
      const selector = `[data-external-id="${participant.externalUserId}"]`;
      const videoContainer = document.querySelector(selector);

      if (!videoContainer) return;

      if (participant.active) {
        videoContainer.classList.add('is-video-active');
        someoneTalking = true;
      } else {
        videoContainer.classList.remove('is-video-active');
      }
    });

    if (!someoneTalking) {
      const videoContainer = document.getElementById('videoTile1');
      videoContainer?.classList.add('is-video-active');
    }
  });

  return (
    <div className="column is-4 is-5-widescreen is-white p-r-sm-mobile p-l-sm-mobile p-r-lg p-l-lg is-hidden-mobile">
      <p className="is-size-4 is-bold m-t-sm ">
        Participants
      </p>
      {Object.keys(participants).map((attendeeId) => {
        const participant = participants[attendeeId];
        return (
          <Participant
            key={attendeeId}
            userExternalName={userExternalName}
            cameraState={cameraState}
            attendeeId={attendeeId}
            {...participant}
          />
        );
      })}
    </div>
  );
};

VideoChatParticipants.propTypes = {
  participants: PropTypes.object,
  userExternalName: PropTypes.string,
  cameraState: PropTypes.bool,
};

export default VideoChatParticipants;
