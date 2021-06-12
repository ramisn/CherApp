import React, { useEffect, useState } from 'react';
import PropTypes from 'prop-types';
import axios from '../../packs/axios_utils.js';
import ChannelMessage from './ChannelMessage';
import ChannelConversationFooter from './ChannelConversationFooter';
import ChannelConversationHeader from './ChannelConversationHeader';

const ChannelConversation = ({
  channelSid, userEmail, userProfilePicture, concierge, onClose, handleNewMessage,
  signedIn, isConciergeContact, hideChannel,
}) => {
  const [chatClient, setChatClient] = useState(null);
  const [conversationChannel, setConversationChannel] = useState(null);
  const [messages, setMessages] = useState([]);
  const [isUserTyping, setIsUserTyping] = useState(false);
  const [pendingConversations, setPendingConversations] = useState(false);
  const [participants, setParticipants] = useState([]);
  const conversationContainer = React.createRef();

  const setupTwilioClient = (token) => {
    window.Twilio.Chat.Client.create(token)
    .then((client) => {
      setChatClient(client);
    });
  };

  const setupChannel = () => {
    chatClient.getChannelBySid(channelSid)
    .then((channel) => {
      setConversationChannel(channel);
    });
  };

  const scrollMessagesContainer = () => {
    if (conversationContainer.current) {
      conversationContainer.current.scrollTop = conversationContainer.current.scrollHeight;
    }

    if (conversationChannel) {
      const lastMessage = messages[messages.length - 1];
      if (lastMessage) {
        const hasPendingMessages = conversationChannel.lastConsumedMessageIndex < lastMessage.index;
        if (hasPendingMessages) handleNewMessage();
      }
    }
  };

  const updateLastReadMessage = () => {
    conversationChannel.getMessagesCount()
    .then((index) => {
      conversationChannel.updateLastConsumedMessageIndex(index);
    });
  };

  const setUpChannelListenners = () => {
    conversationChannel.on('messageAdded', (message) => {
      setMessages((prevMessages) => ([...prevMessages, message]));
      if (handleNewMessage) handleNewMessage();
    });
    conversationChannel.on('typingStarted', () => {
      setIsUserTyping(true);
    });
    conversationChannel.on('typingEnded', () => {
      setIsUserTyping(false);
    });
  };

  const listConversation = (userChannel) => {
    const { lastMessage, lastConsumedMessageIndex } = userChannel;

    if (lastMessage && lastConsumedMessageIndex < lastMessage.index) {
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

  const getParticipants = async () => {
    const response = await axios.get(`/message_channels/${channelSid}/participants`);
    const channelParticipants = response.data;
    setParticipants(channelParticipants);
  };

  useEffect(() => {
    if (!pendingConversations) return;

    const indicator = document.getElementById('pendingMessagesIndicator');
    if (indicator) {
      indicator.classList.remove('is-hidden');
      indicator.innerText = pendingConversations;
    }
  }, [pendingConversations]);

  useEffect(() => {
    scrollMessagesContainer();
  }, [messages]);

  useEffect(() => {
    if (!conversationChannel) return;

    // Mark all messages as read after accessing to conversation
    if (!concierge) updateLastReadMessage();
    conversationChannel.getMessages(30)
    .then((messagePaginator) => {
      messagePaginator.items.forEach((message) => {
        setMessages((prevMessages) => ([...prevMessages, message]));
      });
    });
    setUpChannelListenners();
  }, [conversationChannel]);

  useEffect(() => {
    scrollMessagesContainer();
  }, [isUserTyping]);

  useEffect(() => {
    getParticipants();
    axios.post('/chat_tokens')
    .then((response) => {
      if (response.status === 200) {
        setupTwilioClient(response.data);
      }
    });
  }, []);

  useEffect(() => {
    if (!chatClient) return;

    setupChannel();
    processChannels();
  }, [chatClient]);

  const conciergeStarterConversation = () => (
    <ChannelMessage
      conversationChannel={conversationChannel}
      message={{
        type: 'text',
        author: '',
        body: 'Welcome to Cher! How can I help you today?',
        attributes: {},
      }}
      userEmail={userEmail}
      userProfilePicture={userProfilePicture}
      scrollMessagesContainer={scrollMessagesContainer}
      participants={participants}
    />
  );

  return (
    <div className={`conversation-container ${ concierge ? 'has-full-height' : '' }`}>
      <ChannelConversationHeader
        hideChannel={hideChannel}
        userEmail={userEmail}
        userProfilePicture={userProfilePicture}
        conversationChannel={conversationChannel}
        participants={participants}
        concierge={concierge}
        onClose={onClose}
        signedIn={signedIn}
        isConciergeContact={isConciergeContact}
      />
      <div className="messages-container" ref={conversationContainer}>
        <>
          {concierge && conversationChannel && conciergeStarterConversation()}

          { messages.map((message) => (
            <ChannelMessage
              conversationChannel={conversationChannel}
              message={message}
              userEmail={userEmail}
              userProfilePicture={userProfilePicture}
              key={message.sid}
              scrollMessagesContainer={scrollMessagesContainer}
              participants={participants}
            />
          )) }
          { isUserTyping && (
            <div className="message is-secondary"><p className="message-body">Typing...</p></div>
          )}
        </>
      </div>
      <div className="divider" />
      <ChannelConversationFooter
        conversationChannel={conversationChannel}
        updateLastReadMessage={updateLastReadMessage}
        participants={participants}
        concierge={concierge}
      />
    </div>
  );
};

ChannelConversation.propTypes = {
  channelSid: PropTypes.string.isRequired,
  userEmail: PropTypes.string.isRequired,
  userProfilePicture: PropTypes.string,
  concierge: PropTypes.bool,
  onClose: PropTypes.func,
  handleNewMessage: PropTypes.func,
  signedIn: PropTypes.bool,
  isConciergeContact: PropTypes.bool,
  hideChannel: PropTypes.func,
};

export default ChannelConversation;
