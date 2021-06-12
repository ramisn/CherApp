import React, { useState, useEffect, useRef } from 'react';
import PropTypes from 'prop-types';
import Qs from 'qs';
import axios from '../../packs/axios_utils.js';
import magnifierGlass from '../../../assets/images/cherapp-ownership-coborrowing-magnifier-white.svg';
import defaultProfilePicture from '../../../assets/images/cherapp-ownership-coborrowing-ico-user.svg';
import filterIcon from '../../../assets/images/cherapp-ownership-coborrowing-filter.svg';
import crossIcon from '../../../assets/images/cherapp-ownership-coborrowing-ellipse-cross.svg';
import userDefaultImage from '../../../assets/images/cherapp-ownership-coborrowing-ico-user.svg';
import USER_ROLES from '../../packs/user_roles.js';

const ChatGroupParticipants = ({
  selectedUsers, removeUserFromList, addUserToList, friends, createGroup,
  }) => {
  const [inputValue, setInputValue] = useState('');
  const [suggestedUsers, setSuggestedUsers] = useState([]);
  const suggesterInput = useRef(null);

  useEffect(() => {
    if (!suggesterInput) return;

    document.addEventListener('click', (event) => {
      if (suggesterInput.current) {
        const isClickOutside = !suggesterInput.current.contains(event.target);
        if (isClickOutside) setSuggestedUsers([]);
      }
    });
  }, [suggesterInput]);

  useEffect(() => {
    setSuggestedUsers([]);
  }, []);

  const userIdentifier = (user) => (user.full_name.trim() ? user.full_name : user.email);

  const friendItem = (friend) => (
    <li key={friend.id} className="list-item has-space-mobile">
      <div className="columns is-marginless is-mobile">
        <div className="column is-narrow is-paddingless item-image image">
          <img src={friend.profile_image || userDefaultImage} alt="User profile" className="is-rounded has-shadow" />
        </div>
        <div className="column is-paddingless has-overflow">
          <p className="main-title has-overflow-elipsed">{userIdentifier(friend)}</p>
          <span className="is-flex has-items-centered">
            <span className="has-overflow-elipsed">Santa Monica, CA</span>
          </span>
        </div>
        <div className="column is-narrow is-paddingless has-text-right m-l-md">
          <p>{USER_ROLES[friend.role]}</p>
          { selectedUsers.includes(friend)
          ? (<button type="button" className="button has-no-style has-text-primary" onClick={() => removeUserFromList(friend)}>- Remove</button>)
          : (<button type="button" className="button has-no-style has-text-primary" onClick={() => addUserToList(friend)}>+ Add to group</button>)}
        </div>
      </div>
    </li>
  );

  const fetchUsers = (identifier) => {
    const params = { user: { identifier, exclude_current: true } };
    axios.get('/users', {
      params,
      paramsSerializer() { return Qs.stringify(params, { arrayFormat: 'brackets' }); },
    })
    .then((response) => {
      if (response.status === 200) {
        setSuggestedUsers(response.data);
      }
    });
  };

  const updateInput = (searchValue) => {
    setInputValue(searchValue);
    if (searchValue.length > 4) {
      fetchUsers(searchValue);
    } else {
      setSuggestedUsers([]);
    }
  };

  const handleImageError = (event) => {
    event.preventDefault();
    event.target.setAttribute('src', defaultProfilePicture);
  };

  const userItem = (user) => (
    <button type="button" className="button has-no-style option is-clickable" key={user.id} href={`/conversations/${user.slug}`} onClick={() => { addUserToList(user); }}>
      <div className="user-image is-medium">
        <img
          src={user.profile_image || defaultProfilePicture}
          alt="User profile"
          onError={handleImageError}
        />
      </div>
      <span>{ `${user.first_name} ${user.last_name}` }</span>
    </button>
  );

  const searchInput = () => (
    <div className="field has-submit-beside is-primary">
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

  return (
    <>
      <div className="m-t-md">
        <div className="columns is-marginless is-multiline has-space-between is-flex">
          <div className="column is-12-mobile is-6-tablet is-5-desktop is-paddingless">
            {searchInput()}
          </div>
          <div className="column is-12-mobile is-narrow-tablet is-flex is-justified-end is-paddingless">
            <div className="is-flex has-items-centered m-l-sm">
              <span className="has-text-dark">Filtered by:&nbsp;</span>
              <span className="has-text-primary">Name(A-Z)</span>
              <img src={filterIcon} alt="Filter" className="m-l-md" />
            </div>
          </div>
        </div>
      </div>
      <ul className="chat-list-items m-b-md m-t-md">
        {selectedUsers.map((user) => (
          <li className="tag is-blue m-r-sm" key={user.id}>
            {user.email}
            <button type="button" className="is-close is-flex" onClick={() => removeUserFromList(user)}>
              <img alt="close" src={crossIcon} />
            </button>
          </li>
        ))}
      </ul>

      <ul className="chat-list-items">
        {friends.map((friend) => friendItem(friend))}
      </ul>
      <div className="column is-12 m-t-md">
        <div className="columns is-marginless is-fully-centered is-mobile">
          <div className="column is-6-mobile is-5-tablet is-5-desktop is-paddingless">
            <button type="button" className="button is-primary has-full-width" onClick={createGroup}>Create group</button>
          </div>
        </div>
      </div>
    </>
  );
};

ChatGroupParticipants.propTypes = {
  selectedUsers: PropTypes.arrayOf(PropTypes.shape({})),
  friends: PropTypes.arrayOf(PropTypes.shape({})),
  removeUserFromList: PropTypes.func.isRequired,
  addUserToList: PropTypes.func.isRequired,
  createGroup: PropTypes.func.isRequired,
};

export default ChatGroupParticipants;
