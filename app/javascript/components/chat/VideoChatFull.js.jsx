import React from 'react';
import PropTypes from 'prop-types';
import VideoChallFullImage from '../../../assets/images/cherapp-ownership-checkout-video-call-full.svg';

const VideoChatFull = ({ channelSid, tryAgain }) => ( 
  <div className="is-gradient-blue" data-controller="viewheight">
    <div className="container has-regular-padding m-t-lg m-b-lg is-paddingless-mobile is-marginless-mobile">
      <div className="box is-borderless is-paddingless has-full-height">
        <div className="container">
          <div className="columns is-multiline is-marginless">
            <div className="p-t-md has-full-width has-text-centered">
              <h2 className="is-inline">
                Sorry, meeting
              </h2>
              <h2 className="is-inline has-text-primary is-hidden-mobile">&nbsp;{ channelSid.substring(0, 4) }...&nbsp;</h2>
              <h2 className="is-inline">is full</h2>
            </div>

            <div className="column is-10 is-offset-1">
              <hr />

              <div className="is-flex has-direction-column is-marginless is-fully-centered has-regular-padding is-paddingless-mobile">
                <img src={VideoChallFullImage} alt="Video Call Full Image" className="m-b-md"/>

                <p className="is-marginless has-text-centered"> This call has reached maximum capacity.</p>
                <p className="has-text-centered">Talk to the admin or try again</p>

                <button className="column is-half-tablet is-full-mobile button is-primary is-full-width" onClick={tryAgain} type="button">
                  Try again
                </button>

                <a
                  className="link is-link is-bold m-t-md"
                  href={window.location.href.replace('video-calls', 'conversations')}
                >
                  Go back
                </a>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
);

React.propTypes = {
  channelSid: PropTypes.string,
  tryAgain: PropTypes.func
}

export default VideoChatFull;
