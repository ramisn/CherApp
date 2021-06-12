import React, { useState } from 'react';
import PropTypes from 'prop-types';
import axios from '../../packs/axios_utils.js';
import ConciergeChatFloating from './ConciergeChatFloating';
import ConciergeChatPopUp from './ConciergeChatPopUp';

const ConciergeChat = ({
 conciergeSlug, userProfilePicture, userEmail, channelSid, signedIn, concierge, hideChannel, showChannel, isHidden
}) => {
  const [showModal, setShowModal] = useState(false);
  const [channelData, setChannelData] = useState({ sid: channelSid, userIdentifier: null });
  const [newMessages, setNewMessages] = useState(0);

  const initializeConciergeChat = () => {
    if (!channelData.sid && !channelSid) {
      axios({
        method: userEmail ? 'get' : 'post',
        url: userEmail ? `/conversations/${conciergeSlug}` : '/concierge_conversations'
      })
        .then(({ data }) => {
          setChannelData({
            sid: data.table.channel.sid,
            userIdentifier: data.table.user_concierge_id 
          });
          setShowModal(true);
          setNewMessages(0);
        });
    } else {
      setShowModal(true);
      setNewMessages(0);
    }
  };

  const hideChat = () => {
    setShowModal(false);
    setNewMessages(0);
  };

  const handleNewMessage = () => {
    setNewMessages(newMessages + 1);
    if (showChannel) showChannel(channelSid);
  };

  return (
    <>
      {!isHidden && (
        <ConciergeChatFloating
          openChat={initializeConciergeChat}
          showChat={showModal}
          newMessages={newMessages}
        />
      )}

      {(channelData.sid || channelSid) && (
        <div className={`concierge-chat-container ${showModal && !isHidden ? '' : 'is-hidden'}`}>
          <ConciergeChatPopUp
            hideChat={hideChat}
            channelSid={channelData.sid || channelSid}
            userProfilePicture={userProfilePicture}
            userEmail={userEmail || channelData.userIdentifier}
            hideChannel={hideChannel}
            showChat={showModal}
            handleNewMessage={handleNewMessage}
            signedIn={signedIn}
            isConciergeContact={concierge}
          />
        </div>
      )}
    </>
  );
};

ConciergeChat.propTypes = {
  userProfilePicture: PropTypes.string,
  userEmail: PropTypes.string,
  conciergeSlug: PropTypes.string,
  signedIn: PropTypes.bool,
  concierge: PropTypes.bool,
  channelSid: PropTypes.string,
  hideChannel: PropTypes.func,
  showChannel: PropTypes.func,
};

export default ConciergeChat;
