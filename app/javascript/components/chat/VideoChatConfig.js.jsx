/* eslint-disable jsx-a11y/media-has-caption */

import React from 'react';
import PropTypes from 'prop-types';
import { userNameFromExternalUserId } from '../../packs/video_call_utils/index.js';

const VideoChatConfig = ({
  videoInputDeviceIds,
  audioOutputDeviceIds,
  audioInputDevicesIds,
  setDeviceSelected,
  joinCall,
  testSound,
  videoPreviewRef,
  userExternalName,
  channelSid,
}) => (
  <div className="is-gradient-blue" data-controller="viewheight">
    <div className="container has-regular-padding">
      <div className="box is-borderless is-paddingless has-full-height">
        <div className="container">
          <h2 className="m-t-md has-text-centered is-full-width">Select devices</h2>

          <div className="columns is-multiline is-marginless">
            <div className="column is-10 is-offset-1">
              <hr />

              <div className="columns is-marginless is-multiline has-regular-padding">
                <div className="column is-half is-fully-centered has-direction-column is-paddingless-mobile">
                  <div className="field has-full-width">
                    <label htmlFor="selectAudioInput" className="label">Microphone</label>
                    <div className="select is-fullwidth m-b-md">
                      <select
                        id="selectAudioInput"
                        name="audioInputDevice"
                        onChange={(e) => setDeviceSelected(e.target.name, e.target.value)}
                      >
                        {audioInputDevicesIds.map((device) => (
                          <option
                            key={device.deviceId}
                            value={device.deviceId}
                          >
                            {device.label}
                          </option>
                        ))}
                      </select>
                    </div>
                  </div>

                  <div className="field has-full-width">
                    <label htmlFor="selectCameraDevice" className="label">Camera</label>
                    <div className="select is-fullwidth m-b-md">
                      <select
                        id="selectCameraDevice"
                        name="videoInputDevice"
                        onChange={(e) => setDeviceSelected(e.target.name, e.target.value)}
                      >
                        {videoInputDeviceIds.map((device) => (
                          <option
                            key={device.deviceId}
                            value={device.deviceId}
                          >
                            {device.label}
                          </option>
                        ))}
                      </select>
                    </div>
                  </div>

                  <div className="field has-full-width">
                    <label htmlFor="selectAudioOutput" className="label">Speaker</label>
                    <div className="select is-fullwidth m-b-lg">
                      <select
                        id="selectAudioOutput"
                        name="audioOutputDevice"
                        onChange={(e) => setDeviceSelected(e.target.name, e.target.value)}
                      >
                        {audioOutputDeviceIds.map((device) => (
                          <option
                            key={device.deviceId}
                            value={device.deviceId}
                          >
                            {device.label}
                          </option>
                        ))}
                      </select>
                    </div>
                  </div>
                </div>

                <div className="column is-half is-paddingless-mobile">
                  <label className="label">Preview</label>
                  <video id="video-preview" className="m-b-md" ref={videoPreviewRef} />

                  <button className="button is-primary is-fullwidth is-outlined" onClick={testSound} type="button">
                    Test
                  </button>
                </div>

                <button className="button is-primary is-half is-offset-3 column m-t-md has-full-width-mobile" onClick={joinCall} type="button">
                  Join Call
                </button>
              </div>
            </div>

            <div className="is-fully-centered has-full-width column is-12 p-b-lg is-block has-text-centered">
              Ready to join meeting
              <hr className="is-hidden-tablet m-t-xs m-b-xs" />
              &nbsp;
              <b>{channelSid}</b>
              <hr className="is-hidden-tablet m-t-xs m-b-xs" />
              &nbsp; as &nbsp;
              <b>{userNameFromExternalUserId(userExternalName)}</b>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
);

VideoChatConfig.propTypes = {
  videoInputDeviceIds: PropTypes.arrayOf(String),
  audioOutputDeviceIds: PropTypes.arrayOf(String),
  audioInputDevicesIds: PropTypes.arrayOf(String),
  setDeviceSelected: PropTypes.func,
  joinCall: PropTypes.func,
  testSound: PropTypes.func,
  userExternalName: PropTypes.string,
  channelSid: PropTypes.string,
  videoPreviewRef: PropTypes.oneOfType(
    [PropTypes.func, PropTypes.shape({ current: PropTypes.instanceOf(Element) })],
  ),
};

export default VideoChatConfig;
