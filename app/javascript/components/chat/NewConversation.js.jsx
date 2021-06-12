import React, { useEffect, useState, useRef } from 'react';
import PropTypes from 'prop-types';
import Qs from 'qs';
import axios from '../../../javascript/packs/axios_utils.js';
import magnifierGlass from '../../../assets/images/cherapp-ownership-coborrowing-magnifier-white.svg';
import defaultProfilePicture from '../../../assets/images/cherapp-ownership-coborrowing-ico-user.svg';
import USER_ROLES from '../../packs/user_roles.js';

const NewConversation = ({ friends }) => {
  const [inputValue, setInputValue] = useState('');
  const [suggestedUsers, setSuggestedUsers] = useState([]);
  const [visibleInvitationLink, setVisibleInvitationLink] = useState(false);
  const suggesterInput = useRef(null);

  useEffect(() => {
    setSuggestedUsers([]);
  }, []);

  useEffect(() => {
    if (!suggesterInput) return;

    document.addEventListener('click', (event) => {
      const isClickOutside = !suggesterInput.current.contains(event.target);
      if (isClickOutside) setSuggestedUsers([]);
    });
  }, [suggesterInput]);

  const fetchUsers = (identifier) => {
    const params = { user: { identifier, exclude_current: true } };
    axios.get('/users', {
      params,
      paramsSerializer() { return Qs.stringify(params, { arrayFormat: 'brackets' }); },
    })
    .then((response) => {
      if (response.status === 200) {
        setSuggestedUsers(response.data);
        if (response.data.length) {
          setVisibleInvitationLink(false);
        } else {
          setVisibleInvitationLink(true);
        }
      }
    });
  };

  const toggleFriendRequestModal = () => {
    document.getElementsByTagName('html')[0].classList.toggle('is-clipped');
    document.getElementById('addFriendModal').classList.add('is-active');
    setVisibleInvitationLink(false);
  };

  const updateInput = (searchValue) => {
    setInputValue(searchValue);
    if (searchValue.length > 4) {
      fetchUsers(searchValue);
    } else {
      setSuggestedUsers([]);
      setVisibleInvitationLink(false);
    }
  };

  const handleImageError = (event) => {
    event.preventDefault();
    event.target.setAttribute('src', defaultProfilePicture);
  };

  const userItem = (user) => (
    <a className="option is-clickable" key={user.id} href={`/conversations/${user.slug}`}>
      <div className="user-image is-medium">
        <img
          src={user.profile_image || defaultProfilePicture}
          alt="User profile"
          onError={handleImageError}
        />
      </div>
      <span>{ `${user.first_name} ${user.last_name}` }</span>
    </a>
  );

  const searchInput = () => (
    <div className="field has-submit-beside is-primary">
      <span className="is-fully-centered m-r-md">
        To:
      </span>
      <div className="has-full-width">
        <input
          value={inputValue}
          type="text"
          ref={suggesterInput}
          placeholder="Add name, email, mobile"
          className="input is-primary has-submit-beside"
          onChange={(event) => { updateInput(event.target.value); }}
        />
        <div className="suggester-input is-relative">
          <span className="options-container">
            {suggestedUsers.map((user) => userItem(user))}
            {visibleInvitationLink && (
              <div className="has-regular-padding">
                <span className="is-family-secondary is-block">We couldn't find any user.</span>
                <div className="is-fully-centerd has-full-width m-t-sm">
                  <button type="button" onClick={toggleFriendRequestModal} className="link is-paddingless">
                    Invite friend
                  </button>
                </div>
              </div>
            )}
          </span>
        </div>
      </div>
      <div className="control">
        <button className="button" type="button">
          <img src={magnifierGlass} alt="Magnifier glass" />
        </button>
      </div>
    </div>
  );

  const userIdentifier = (user) => (user.full_name.trim() ? user.full_name : user.email);

  const friendItem = (friend) => (
    <li key={friend.id} className="list-item has-space-mobile">
      <a href={`/conversations/${friend.slug}`} className="columns is-marginless is-mobile">
        <div className="column is-narrow is-paddingless item-image image">
          <img src={friend.profile_image} alt="User profile" className="is-rounded has-shadow" />
        </div>
        <div className="column is-paddingless has-overflow">
          <p className="main-title has-overflow-elipsed">{userIdentifier(friend)}</p>
          <span className="is-flex has-items-centered">
            <span className="has-overflow-elipsed">Santa Monica, CA</span>
          </span>
        </div>
        <div className="column is-narrow is-paddingless has-text-right m-l-md">
          <p>{USER_ROLES[friend.role]}</p>
        </div>
      </a>
    </li>
  );

  return (
    <div className="columns is-multiline is-marginless">
      <div className="column is-12-mobile is-12-tablet chat-header">
        <h1 className="is-size-4">New message</h1>
      </div>
      <div className="column is-12-mobile is-7-tablet is-5-widescreen m-t-md">{searchInput()}</div>
      <div className="column is-12-mobile is-12-tablet">
        <ul className="chat-list-items">
          {friends.map((friend) => (
            friendItem(friend)
          ))}
        </ul>
      </div>
    </div>
  );
};

NewConversation.propTypes = {
  friends: PropTypes.arrayOf(PropTypes.shape({})),
};

export default NewConversation;
