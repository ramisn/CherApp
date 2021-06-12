import React from 'react';
import PropTypes from 'prop-types';
import ConciergeImage from '../../../assets/images/cherapp-ownership-coborrowing-concierge-chat.svg';

const ConciergeChatFloating = ({ openChat, showChat, newMessages }) => (
  <button
    className={`floating-concierge-chat-button ${showChat ? 'is-hidden' : ''}`}
    onClick={openChat}
    type="button"
  >
    <img src={ConciergeImage} alt="Open Concierge Chat" />
    { newMessages > 0 && (<span className="badge has-bounce">{newMessages}</span>)}
  </button>
);

ConciergeChatFloating.propTypes = {
  openChat: PropTypes.func.isRequired,
  showChat: PropTypes.bool,
  newMessages: PropTypes.number,
};

export default ConciergeChatFloating;
