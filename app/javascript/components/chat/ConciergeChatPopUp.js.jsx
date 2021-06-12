import React from 'react';
import PropTypes from 'prop-types';
import ChannelConversation from './ChannelConversation';

const ConciergeChatPopUP = ({
  channelSid, userProfilePicture, userEmail, hideChat, showChat, handleNewMessage,
  signedIn, isConciergeContact, hideChannel,
}) => (
  <div className={`concierge-chat-popup ${showChat ? '' : 'is-hidden'}`}>
    <ChannelConversation
      channelSid={channelSid}
      userProfilePicture={userProfilePicture}
      userEmail={userEmail}
      onClose={hideChat}
      handleNewMessage={handleNewMessage}
      signedIn={signedIn}
      concierge
      isConciergeContact={isConciergeContact}
      hideChannel={hideChannel}
    />
  </div>
);

ConciergeChatPopUP.propTypes = {
  hideChat: PropTypes.func.isRequired,
  channelSid: PropTypes.string.isRequired,
  userEmail: PropTypes.string,
  userProfilePicture: PropTypes.string,
  showChat: PropTypes.bool,
  handleNewMessage: PropTypes.func,
  signedIn: PropTypes.bool,
  isConciergeContact: PropTypes.bool,
  hideChannel: PropTypes.func,
};

export default ConciergeChatPopUP;
