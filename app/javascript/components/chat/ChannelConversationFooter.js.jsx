import React, { useState } from 'react';
import PropTypes from 'prop-types';
import planeIcon from '../../../assets/images/cherapp-ownership-coborrowing-plane.svg';
import clipIcon from '../../../assets/images/cherapp-ownership-coborrowing-clip.svg';
import axios from '../../packs/axios_utils'

const ChannelConversationFooter = ({ 
  concierge, conversationChannel, updateLastReadMessage, participants
}) => {
  const [inputContent, setInputContent] = useState('');

  const sendMessage = () => {
    if (inputContent.length) {
      conversationChannel.sendMessage(inputContent)
      .then(() => {
        updateLastReadMessage();
        sendNotification();
      });
      setInputContent('');
    }
  };

  const sendNotification = () => {
    participants.forEach((participant) => {
      const params = {
        link: smsMessageLink(),
        recipient: participant.email,
        type: 'new_chat_message',
      };

      if (params.link) axios.post('/full_notifications', params);
    });
  };

  const updateInputContent = (content) => {
    setInputContent(content);
    conversationChannel.typing();
  };

  const triggerFileUpload = () => {
    document.getElementById('conversationFileInput').click();
  };

  const smsMessageLink = () => {
    const element = document.getElementById(`${concierge ? 'concierge_' : ''}sms_message_link`);

    if (element) return element.value;
  };

  const sendMediaMessage = (file) => {
    const formData = new FormData();
    formData.append('file', file, file.name);
    conversationChannel.sendMessage(formData);
  };

  const enterListenner = (event) => {
    if (event.key !== 'Enter') return;

    event.preventDefault();
    event.stopPropagation();
    sendMessage();
  };

  return (
    <div className="messages-footer">
      <textarea
        className="input is-primary"
        value={inputContent}
        placeholder="Type your message"
        onChange={(event) => updateInputContent(event.target.value)}
        onKeyPress={(event) => enterListenner(event)}
      />
      <button id="" type="button" className="secondary-button" onClick={triggerFileUpload}>
        <img src={clipIcon} alt="Attach file" />
      </button>
      <input
        id="conversationFileInput"
        className="is-hidden"
        type="file"
        onChange={(event) => sendMediaMessage(event.target.files[0])}
      />
      <button type="button" className="success-button" onClick={sendMessage}>
        <img src={planeIcon} alt="Send message" />
      </button>
    </div>
  );
};

ChannelConversationFooter.propTypes = {
  conversationChannel: PropTypes.shape({
    typing: PropTypes.func.isRequired,
    sendMessage: PropTypes.func.isRequired,
  }),
  updateLastReadMessage: PropTypes.func.isRequired,
  concierge: PropTypes.bool
};

export default ChannelConversationFooter;
