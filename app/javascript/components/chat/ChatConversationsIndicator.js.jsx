import React, { useEffect, useState } from 'react';
import axios from '../../packs/axios_utils.js';
import messageIcon from '../../../assets/images/cherapp-ownership-coborrowing-ico-message.svg';

const ChatConversationsIndicator = () => {
  const [pendingConversations, setPendingConversations] = useState(0);
  const [chatClient, setChatClient] = useState(null);

  const setupTwilioClient = (token) => {
    window.Twilio.Chat.Client.create(token)
    .then((client) => {
      setChatClient(client);
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

  const listConversation = async (userChannel) => {
    const { lastMessage } = userChannel;
    if (lastMessage && userChannel.lastConsumedMessageIndex < lastMessage.index) {
      setPendingConversations((prevPendingConversations) => (prevPendingConversations + 1));
    }
  };

  const processChannelPaginator = (channelPaginator) => {
    channelPaginator.items.forEach((channel) => {
      chatClient.getChannelBySid(channel.sid)
      .then((userChannel) => {
        listConversation(userChannel);
      });
    });

    if (channelPaginator.state.nextToken) {
      channelPaginator.nextPage()
      .then((paginator) => {
        processChannelPaginator(paginator);
      });
    }
  };

  const processChannels = () => {
    chatClient.getUserChannelDescriptors()
    .then((paginator) => {
      processChannelPaginator(paginator);
    });
  };

  useEffect(() => {
    if (!chatClient) return;

    processChannels();
  }, [chatClient]);

  return (
    <a href="/conversations" className="chat-button">
      <img src={messageIcon} alt="Messages" />
      {pendingConversations > 0 && (
        <span className="badge">{pendingConversations > 10 ? '+10' : pendingConversations}</span>
      )}
    </a>
  );
};

export default ChatConversationsIndicator;
