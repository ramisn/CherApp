import React, { useState } from 'react';
import PropTypes from 'prop-types';
import EndCall from '../../../assets/images/cherapp-ownership-end-call.svg';
import ExitCall from '../../../assets/images/cherapp-ownership-exit-call.svg';
import MicOn from '../../../assets/images/cherapp-ownership-blue-mic-on.svg';
import MicOff from '../../../assets/images/cherapp-ownership-blue-mic-off.svg';
import CameraOff from '../../../assets/images/cherapp-ownership-blue-cam-on.svg';
import CameraOn from '../../../assets/images/cherapp-ownership-blue-cam-off.svg';
import AudioOn from '../../../assets/images/cherapp-ownership-blue-audio-on.svg';
import AudioOff from '../../../assets/images/cherapp-ownership-blue-audio-off.svg';

const icons = {
  micOn: MicOn,
  micOff: MicOff,
  cameraOn: CameraOn,
  cameraOff: CameraOff,
  speakerOn: AudioOn,
  speakerOff: AudioOff,
};

const DeviceConfig = ({
  modalDisplayed,
  showModal,
  hideModal,
  deviceName,
  iconName,
  devices,
  toggle,
  toggleState,
  setDeviceSelected,
  label,
}) => {
  const icon = icons[`${iconName}${ toggleState ? 'Off' : 'On' }`];

  if (modalDisplayed === deviceName) {
    return (
      <div className="video-chat-device-config" onMouseLeave={hideModal}>
        <span className="icon m-l-sm m-r-sm m-b-sm">
          <img alt={icon} src={icon} />
        </span>
        <span><i className="fas fa-chevron-down has-text-primary" /></span>
        <label className="m-l-sm label is-bold is-inline">{label}</label>

        {
          devices.map((device) => (
            <div
              className="video-chat-device-config-option"
              key={device.deviceId}
              onClick={() => { setDeviceSelected(deviceName, device.deviceId) }}
            >
              {device.label}
            </div>
          ))
        }
      </div>
    );
  }

  if (!modalDisplayed) {
    return (
      <div className="is-inline">
        <button
          type="button"
          className="video-chat-toggle-device button icon"
          onClick={toggle}
        >
          <img alt={deviceName} src={icon} />
        </button>
        <button
          type="button"
          className="video-chat-select-device button icon"
          onClick={() => showModal(deviceName)}
        >
          <i className="fas fa-chevron-down has-text-primary" />
        </button>
      </div>
    );
  }

  return null;
};

DeviceConfig.propTypes = {
  modalDisplayed: PropTypes.string,
  showModal: PropTypes.func,
  hideModal: PropTypes.func,
  deviceName: PropTypes.string,
  iconName: PropTypes.string,
  devices: PropTypes.arrayOf(PropTypes.object),
  toggle: PropTypes.func,
  toggleState: PropTypes.bool,
  setDeviceSelected: PropTypes.func,
  label: PropTypes.string,
};

export const VideoChatInsideConfig = ({
  videoInputDeviceIds,
  audioOutputDeviceIds,
  audioInputDevicesIds,
  setDeviceSelected,
  toggleMic,
  toggleCamera,
  micToggleState,
  camToggleState,
  toggleSpeaker,
  speakerToggleState,
}) => {
  const [displayedModal, setDisplayedModal] = useState('');

  const hideModal = () => setDisplayedModal('');
  const showModal = (deviceName) => setDisplayedModal(deviceName);

  return (
    <div className="is-relative">
      <DeviceConfig
        modalDisplayed={displayedModal}
        showModal={showModal}
        hideModal={hideModal}
        deviceName="audioInputDevice"
        iconName="mic"
        devices={audioInputDevicesIds}
        toggle={toggleMic}
        toggleState={micToggleState}
        setDeviceSelected={setDeviceSelected}
        label="Select your microphone"
      />

      <DeviceConfig
        modalDisplayed={displayedModal}
        showModal={showModal}
        hideModal={hideModal}
        deviceName="videoInputDevice"
        iconName="camera"
        devices={videoInputDeviceIds}
        toggle={toggleCamera}
        toggleState={camToggleState}
        setDeviceSelected={setDeviceSelected}
        label="Select your camera"
      />

      <DeviceConfig
        modalDisplayed={displayedModal}
        showModal={showModal}
        hideModal={hideModal}
        deviceName="audioOutputDevice"
        iconName="speaker"
        devices={audioOutputDeviceIds}
        toggle={toggleSpeaker}
        toggleState={speakerToggleState}
        setDeviceSelected={setDeviceSelected}
        label="Select your speaker"
      />
    </div>
  );
};

VideoChatInsideConfig.propTypes = {
  videoInputDeviceIds: PropTypes.arrayOf(PropTypes.object),
  audioOutputDeviceIds: PropTypes.arrayOf(PropTypes.object),
  audioInputDevicesIds: PropTypes.arrayOf(PropTypes.object),
  setDeviceSelected: PropTypes.func,
  toggleMic: PropTypes.func,
  toggleCamera: PropTypes.func,
  toggleSpeaker: PropTypes.func,
  micToggleState: PropTypes.bool,
  camToggleState: PropTypes.bool,
  speakerToggleState: PropTypes.bool,
};

export const VideoChatExitActions = ({ stopCall, endCall }) => (
  <div className="video-actions">
    <button className="button is-square-icon is-circle-icon m-r-md" onClick={endCall} type="button">
      <img alt="end-call" src={EndCall} />
    </button>
    <button className="button is-square-icon is-circle-icon" onClick={stopCall} type="button">
      <img alt="exit-call" src={ExitCall} />
    </button>
  </div>
);

VideoChatExitActions.propTypes = {
  stopCall: PropTypes.func.isRequired,
  endCall: PropTypes.func.isRequired,
};
