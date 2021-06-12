import React, { useEffect, useState } from 'react';
import PropTypes from 'prop-types';
import userDefaultImage from '../../../assets/images/cherapp-ownership-coborrowing-ico-user.svg';
import groupDefaultImage from '../../../assets/images/cherapp-ownership-coborrowing-testimonial-cher-rounded-logo.png';
import axios from '../../packs/axios_utils.js';
import { getHourDayOrDate } from '../../packs/time_utils.js';
import { getChannelImage, isChannelAGroup } from '../../packs/channel_utils.js';
import USER_ROLES from '../../packs/user_roles.js';

const ChatListItem = ({ channel }) => {
  const [lastMessage, setLastMessage] = useState(null);
  const [participants, setParticipants] = useState([]);
  const [channelImage, setChannelImage] = useState(userDefaultImage);
  const [channelName, setChannelName] = useState('Unknown user');
  const [previewMessage, setPreviewMessage] = useState('');
  const [channelType, setChannelType] = useState('');
  const [lastMessageTime, setLastMessageTime] = useState('');

  const getParticipants = async () => {
    const response = await axios.get(`/message_channels/${channel.sid}/participants`);
    const channelParticipants = response.data;
    setParticipants(channelParticipants);
  };

  const getLastMessage = () => {
    if (channel.status !== 'joined') return;

    channel.getMessages(1)
    .then((messagesPaginator) => {
      const channelLastMessage = messagesPaginator.items[0];
      setLastMessage(channelLastMessage);
    });
  };

  useEffect(() => {
    getParticipants();
    getLastMessage();
  }, []);

  const defineChanelName = () => {
    if (channel.friendlyName) {
      channel.conversationTitle = channel.friendlyName;
      return setChannelName(channel.friendlyName);
    }

    if (participants.length === 1) {
      const user = participants[0];
      const listItemName = user.full_name.trim() ? user.full_name : user.email;
      channel.conversationTitle = listItemName;
      setChannelName(listItemName);
    }
  };

  const defineChannelImage = async () => {
    if (isChannelAGroup(channel)) {
      const image = await getChannelImage(channel.sid);
      setChannelImage(image || groupDefaultImage);
    } else {
      const profileImage = participants[0]?.profile_image;
      profileImage && setChannelImage(profileImage)
    }
  };

  const defineChannelType = () => {
    let userType = 'Unknown user';
    const user = participants[0];
    if (user) {
      userType = USER_ROLES[user.role];
    }
    setChannelType(userType);
  };

  useEffect(() => {
    defineChannelImage();

    if (!participants.length) return;
    defineChanelName();
    defineChannelType();
  }, [participants]);

  useEffect(() => {
    if (lastMessage) {
      const time = new Date(lastMessage.dateUpdated);
      
      if (lastMessage.body === 'start_video_call') {
        setPreviewMessage('A Call has just started, Click here to join.');
      } else {
        setPreviewMessage(lastMessage.body);
      }
      setLastMessageTime(getHourDayOrDate(time));
    } else if (channel.status === 'joined') {
      setPreviewMessage('Say Hi!');
    } else if (channel.status === 'invited') {
      setPreviewMessage('Wants to chat with you!');
    }
  }, [lastMessage]);

  const hasNewMessages = () => {
    if (!lastMessage) return false;

    const hasPendingMessages = channel.lastConsumedMessageIndex < lastMessage.index;
    return hasPendingMessages ? <span className="badge">NEW</span> : null;
  };

  const handleImageError = (event) => {
    event.preventDefault();
    event.target.setAttribute('src', userDefaultImage);
  };

  const updateChannelData = () => {
    axios.put(`/message_channels/${channel.sid}`, { channel: { status: 'closed' } })
    .then((updateResponse) => {
      if (updateResponse.status === 200) {
        channel.join();
        window.location = `/conversations/${channel.sid}`;
      }
    });
  };

  const getChannelStatus = async () => {
    const response = await axios.get(`/message_channels/${channel.sid}`);
    const { status, data } = response;
    return status === 200 ? data.status : 'not found';
  };

  const handleClick = async (event) => {
    if (channel.status !== 'invited') return;

    event.preventDefault();
    event.stopPropagation();

    const channelStatus = await getChannelStatus();
    if (channelStatus === 'active') {
      updateChannelData();
    } else {
      alert('This channel is not available anymore');
      channel.decline();
      window.location = '/conversations';
    }
  };

  return (
    <>
      <li className="list-item">
        <a href={`/conversations/${channel.sid}`} className="columns is-marginless is-mobile" onClick={(e) => handleClick(e)}>
          <div className="column is-narrow is-paddingless item-image image">
            <img src={channelImage} alt="User profile" className="is-rounded has-shadow" onError={handleImageError} />
          </div>
          <div className="column is-paddingless has-overflow">
            <p className="main-title has-overflow-elipsed">{channelName}</p>
            <span className="is-flex has-items-centered">
              { hasNewMessages()}
              <span className="has-overflow-elipsed container-body">{previewMessage}</span>
            </span>
          </div>
          <div className="column is-narrow is-paddingless has-text-right m-l-md">
            <p>{channelType}</p>
            <span className="time">{lastMessageTime}</span>
          </div>
        </a>
      </li>
    </>
  );
};

ChatListItem.propTypes = {
  channel: PropTypes.shape({
    getMessages: PropTypes.func,
    join: PropTypes.func,
    decline: PropTypes.func,
    sid: PropTypes.string.isRequired,
    conversationTitle: PropTypes.string,
    status: PropTypes.string,
    lastConsumedMessageIndex: PropTypes.number,
    friendlyName: PropTypes.string,
  }),
};

export default ChatListItem;
