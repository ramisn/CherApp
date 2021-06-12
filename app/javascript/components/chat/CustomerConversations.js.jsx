import React, { useEffect, useState } from 'react';
import ChatListItem from './ChatListItem';
import axios from '../../packs/axios_utils.js';
import cellPhoneImage from '../../../assets/images/cherapp-ownership-coborrowing-recent_messages_empty.svg';

const CustomerConversations = () => {
  const [chatClient, setChatClient] = useState(null);
  const [isClientReady, setIsClientReady] = useState(null);
  const [messageChannels, setMessageChannels] = useState([]);

  const setupTwilioClient = (token) => {
    Twilio.Chat.Client.create(token)
    .then((client) => {
      setChatClient(client);
      setIsClientReady(true);
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

  const processChannels = () => {
    chatClient.getUserChannelDescriptors()
    .then((paginator) => {
      processChannelPaginator(paginator);
    });
  };

  useEffect(() => {
    if (!isClientReady) return;

    processChannels();
  }, [isClientReady]);

  const listConversation = (userChannel) => {
    setMessageChannels((prevMessageChannels) => (
      [...prevMessageChannels, userChannel]
    ));
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

  const sortChannelsByDate = (channels) => (
    channels.sort((a, b) => {
      const dateA = new Date(b.lastMessage ? b.lastMessage.timestamp : b.dateUpdated);
      const dateB = new Date(a.lastMessage ? a.lastMessage.timestamp : a.dateCreated);
      return dateA - dateB;
    })
  );

  useEffect(() => {
    const sortedChannels = sortChannelsByDate(messageChannels);
    setMessageChannels(sortedChannels);
  }, [messageChannels]);

  return (
    <>
      {messageChannels.length ? (
        <ul className="chat-list-items">
          {messageChannels.slice(0, 3).map((channel) => (
            <ChatListItem
              channel={channel}
              key={channel.sid}
            />
          ))}
        </ul>
      ) : (
        <div className="has-text-centered m-t-lg">
          <img src={cellPhoneImage} alt="Cellphone" className="m-b-md" />
          <span className="has-text-weight-bold is-lighter-blue is-block">
            You haven’t added any contact
          </span>
          <span className="is-lighter-blue is-block">
            The contacts added to your list will appear here
          </span>
        </div>
      )}
    </>
  );
};

export default CustomerConversations;
