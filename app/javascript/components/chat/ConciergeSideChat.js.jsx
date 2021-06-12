import React, { useState, useEffect } from 'react';
import PropTypes from 'prop-types';
import ConciergeChat from './ConciergeChat';
import axios from '../../packs/axios_utils.js';

const ConciergeSideChat = (props) => {
  const [chatClient, setChatClient] = useState(null);
  const [conciergeChannels, setConciergeChannels] = useState([]);
  const [hiddenChanels, setHiddenChannels] = useState({});

  const hideChannel = (sid) => setHiddenChannels({ ...hiddenChanels, [sid]: true });
  const showChannel = (sid) => setHiddenChannels({ ...hiddenChanels, [sid]: false });

  const setupTwilioClient = (token) => {
    Twilio.Chat.Client.create(token)
    .then((client) => {
      setChatClient(client);
    });
  };

  const processChannels = () => {
    chatClient.on('channelAdded', (channel) => {
      setConciergeChannels((prevGroupChannels) => (
        [channel, ...prevGroupChannels]
      ));

      hideChannel(channel.sid)
    });
  };

  useEffect(() => {
    axios.post('/chat_tokens')
    .then((response) => {
      if (response.status === 200) {
        setupTwilioClient(response.data);
      }
    });
  }, []);

  useEffect(() => {
    if (!chatClient) return;

    processChannels();
  }, [chatClient]);

  return (
    <div className="concierge-side-container">
      {conciergeChannels.map((c) => (
        <ConciergeChat
          isHidden={hiddenChanels[c.sid]}
          key={c.sid}
          channelSid={c.sid}
          concierge
          hideChannel={hideChannel}
          showChannel={showChannel}
          {...props}
        />
      ))}
    </div>
  )
}

ConciergeSideChat.propTypes = {
  userProfilePicture: PropTypes.string,
  userEmail: PropTypes.string,
  conciergeSlug: PropTypes.string,
};

export default ConciergeSideChat;
