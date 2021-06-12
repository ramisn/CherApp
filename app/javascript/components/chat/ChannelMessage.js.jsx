import React, { useEffect, useState } from 'react';
import PropTypes from 'prop-types';
import downloadIcon from '../../../assets/images/cherapp-ownership-coborrowing-ico-download.svg';
import defaultImage from '../../../assets/images/cherapp-ownership-coborrowing-property_placeholder.png';
import defaultProfilePicture from '../../../assets/images/cherapp-ownership-coborrowing-ico-user.svg';
import conciergePicture from '../../../assets/images/cherapp-ownership-coborrowing-concierge-photo.png';

const ChannelMessage = ({
  message, userEmail, scrollMessagesContainer,
  conversationChannel, participants, userProfilePicture,
}) => {
  const [isMediaReady, setIsMediaReady] = useState(false);
  const [mediaURL, setMediaURL] = useState(defaultImage);

  const isUserAuthorOfMessage = () => (message.author === userEmail);

  const isImage = () => (message.media.contentType.includes('image'));

  const fileTypeMessage = () => {
    if (!mediaURL) return <div className="loading" />;

    return (
      <div className="message-body">
        <a href={mediaURL} target="_blank" download={message.media.filename} className="download-link message0body" rel="noopener noreferrer">
          {message.media.filename}
          <img src={downloadIcon} className="icon" alt="Download file" />
        </a>
      </div>
    );
  };

  const imageTypeMessage = () => (
    <div className="message-body is-paddingless">
      <img src={mediaURL} className={isMediaReady ? 'image' : 'image is-loading'} alt="Sent message" />
    </div>
  );

  useEffect(() => {
    if (message.type === 'text') return;

    message.media.getContentUrl()
    .then((twilioMediaURL) => {
      setIsMediaReady(true);
      setMediaURL(twilioMediaURL);
    });
  }, []);

  useEffect(() => {
    // Scroll after image is fully loaded
    scrollMessagesContainer();
  }, [isMediaReady]);

  const mediaMessage = () => {
    let item = null;
    if (isImage()) {
      item = imageTypeMessage();
    } else {
      item = fileTypeMessage();
    }
    return item;
  };

  const isChannelAGroup = () => conversationChannel.attributes.purpose === 'chat_group';

  const autorProfilePicture = () => {
    let image = defaultProfilePicture;

    if (message.author === userEmail) {
      image = userProfilePicture;
    } else if (participants.length) {
      const author = participants.filter((user) => user.email === message.author)[0];
      if (author && author.profile_image) image = author.profile_image;
    } else {
      image = conciergePicture;
    }

    return (
      <figure className="image"><img alt="User profile" src={image} className="is-rounded has-shadow" /></figure>
    );
  };

  const textMessage = () => {
    if (message.body === 'start_video_call') {
      return (
        <p className="message-body">
          A Call has just started,
          <a href={`/video-calls/${conversationChannel?.sid}`}> Click here to join</a>
        </p>
      );
    }

    return (
      <p className="message-body">{message.body}</p>
    );
  };

  return (
    <div className={`message ${isUserAuthorOfMessage(message) ? 'is-author' : '' }`}>
      { isChannelAGroup()
      ? autorProfilePicture()
      : null }
      { message.type === 'text' ? textMessage() : mediaMessage()}
    </div>
  );
};

ChannelMessage.propTypes = {
  message: PropTypes.shape({
    type: PropTypes.string.isRequired,
    author: PropTypes.string.isRequired,
    body: PropTypes.string,
    media: PropTypes.shape({
      type: PropTypes.string.isRequired,
      contentType: PropTypes.string.isRequired,
      filename: PropTypes.string.isRequired,
      getContentUrl: PropTypes.func,
    }),
  }),
  userEmail: PropTypes.string.isRequired,
  userProfilePicture: PropTypes.string,
  scrollMessagesContainer: PropTypes.func,
  conversationChannel: PropTypes.shape({
    sid: PropTypes.string,
    attributes: PropTypes.shape({
      purpose: PropTypes.string,
    }),
  }),
  participants: PropTypes.arrayOf(PropTypes.shape({})),
};

export default ChannelMessage;
