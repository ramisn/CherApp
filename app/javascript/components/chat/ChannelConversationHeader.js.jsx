import React, { useEffect, useState } from 'react';
import PropTypes from 'prop-types';
import { getChannelImage, isChannelAGroup } from '../../packs/channel_utils';
import closeIcon from '../../../assets/images/cherapp-ownership-coborrowing-x.svg';
import userDefaultImage from '../../../assets/images/cherapp-ownership-coborrowing-ico-user.svg';
import groupDefaultImage from '../../../assets/images/cherapp-ownership-coborrowing-testimonial-cher-rounded-logo.png';
import settingsIcon from '../../../assets/images/cherapp-ownership-coborrowing-ico-settings.svg';
import CameraIcon from '../../../assets/images/cherapp-ownership-blue-cam-on.svg';
import conciergePicture from '../../../assets/images/cherapp-ownership-coborrowing-concierge-photo.png';

const ChannelConversationHeader = ({ hideChannel, signedIn, concierge, onClose, conversationChannel, participants, isConciergeContact }) => {
  const [channelName, setChannelName] = useState('');
  const [channelImage, setChannelImage] = useState(userDefaultImage);

  const notifyStartVideoCall = () => {
    const message =  'start_video_call';
    conversationChannel.sendMessage(message);
  }

  const getChanelName = () => {
    if (conversationChannel.friendlyName) {
      return conversationChannel.friendlyName;
    }

    // Default channel name
    let hederTitle = !signedIn || !isConciergeContact ? 'Cher Concierge' : 'Unknown user';
    if (participants.length && !concierge) {
      // The person who the user is chatting with
      const user = participants[0];
      hederTitle = user.full_name.trim() ? user.full_name : user.email;
    }
    return hederTitle;
  };

  const getChatImage = async () => {
    let channelImage = '';

    if (isChannelAGroup(conversationChannel)) {
      channelImage = await getChannelImage(conversationChannel.sid) || groupDefaultImage;
    } else if (concierge && !isConciergeContact) {
      channelImage = conciergePicture;
    } else {
      channelImage = participants[0]?.profile_image;
    }

    setChannelImage(channelImage);
  };

  useEffect(() => {
    if (!conversationChannel) return;

    setChannelName(getChanelName());
    getChatImage();
  }, [conversationChannel]);

  const conciergeCloseChat = () => {
    onClose();
    hideChannel(conversationChannel.sid);
  };

  return (
    <div className="conversation-header">
      <div className="is-fully-centered">
        <figure className="image m-r-md">
          <img
            src={channelImage || userDefaultImage}
            alt="User profile"
            className="is-rounded has-shadow"
          />
        </figure>
        <h2>{channelName}</h2>
      </div>
      <div className="is-flex">
        { conversationChannel && (
          <a href={`/video-calls/${conversationChannel?.sid}`} className="link has-no-style is-fully-centered m-r-md" onClick={notifyStartVideoCall}>
            <img src={CameraIcon} alt="Start video chat" />
          </a>
        )}
        {isChannelAGroup() && (
        <a href={`/chat-groups/${conversationChannel.sid}/edit`} className="link has-no-style is-fully-centered  m-r-md">
          <img src={settingsIcon} alt="Settings" />
        </a>
        )}

        { concierge ? (
          <button onClick={conciergeCloseChat} type="button" className="link has-no-style is-fully-centered">
            <img src={closeIcon} alt="Close chat" />
          </button>
        ) : (
          <a href="/conversations" className="link has-no-style is-fully-centered">
            <img src={closeIcon} alt="Close chat" />
          </a>
        )}

      </div>
    </div>
  );
};

ChannelConversationHeader.propTypes = {
  conversationChannel: PropTypes.shape({
    sid: PropTypes.string,
    friendlyName: PropTypes.string,
    createdBy: PropTypes.string,
    attributes: PropTypes.shape({
      purpose: PropTypes.string,
    }).isRequired,
  }),
  participants: PropTypes.arrayOf(PropTypes.shape({
    profile_image: PropTypes.string.isRequired,
    full_name: PropTypes.string.isRequired,
    email: PropTypes.string.isRequired,
  })),
  userEmail: PropTypes.string.isRequired,
  userProfilePicture: PropTypes.string,
  signedIn: PropTypes.bool,
  isConciergeContact: PropTypes.bool,
  hideChannel: PropTypes.func,
};

export default ChannelConversationHeader;
