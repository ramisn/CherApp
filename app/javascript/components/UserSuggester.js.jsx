import React, { useState } from 'react';
import PropTypes from 'prop-types';
import FontAwesome from 'react-fontawesome';
import Qs from 'qs';
import axios from '../packs/axios_utils';
import defaultProfilePicture from '../../assets/images/cherapp-ownership-coborrowing-ico-user.svg';

const UserSuggester = ({ scopeName, controllerName, isPrimary }) => {
  const [inputValue, setInputValue] = useState('');
  const [selectedUser, setSelectedUser] = useState(null);
  const [suggestedUsers, setSuggestedUsers] = useState([]);
  const [showSuggestions, setShowSuggestions] = useState(false);

  const requestUsers = (user) => {
    const params = { user: { suggestion: user } };

    if (user.length >= 4) {
      axios.get('/users', {
        params,
        paramsSerializer() { return Qs.stringify(params, { arrayFormat: 'brackets' }); },
      })
      .then((response) => {
        if (response.status === 200) setSuggestedUsers(response.data);
      });
    }
  };

  const updateInput = (value) => {
    setInputValue(value);
    if (value.length > 3) {
      requestUsers(value);
    }
  };

  const setValuesToInputs = (user) => {
    const firstNameInputs = document.querySelectorAll(`#${scopeName}FirstNameInput`);
    firstNameInputs.forEach((input) => {
      input.value = user.first_name;
    });
    const lastNameInputs = document.querySelectorAll(`#${scopeName}LastNameInput`);
    lastNameInputs.forEach((input) => {
      input.value = user.last_name;
    });
  };

  const selectUser = (user, event) => {
    // Propagation affects click outside modals listener
    setSelectedUser(user);
    setSuggestedUsers([]);
    setInputValue('');
    setValuesToInputs(user);
    event.stopPropagation();
    event.nativeEvent.stopImmediatePropagation();
  };

  const handleImageError = (event) => {
    event.preventDefault();
    event.target.setAttribute('src', defaultProfilePicture);
  };

  const removeUser = (event) => {
    // Propagation affects click outside modals listener
    event.stopPropagation();
    event.nativeEvent.stopImmediatePropagation();
    setSelectedUser(null);
  };

  return (
    <div className="suggester-input">
      { selectedUser ? (
        <div className={`input ${isPrimary && 'is-primary'}`}>
          <input className="is-hidden" readOnly data-target={`${ controllerName || 'share-item'}.${scopeName}ContactInput`} value={selectedUser.email || selectedUser.phone_number} data-user-selected="true" />
          {!('is_subscribed' in selectedUser) && (
            <input className="is-hidden" readOnly data-target={`${ controllerName || 'share-item'}.${scopeName}SelectedId`} value={selectedUser.id} />
          )}
          <span className="selected-item">
            <span>{`${selectedUser.first_name} ${selectedUser.last_name}`}</span>
            <button onClick={(event) => removeUser(event)} type="button" id={`${scopeName}RemoveUserButton`}>x</button>
          </span>
        </div>
      ) : (
        <div className="field">
          <p className="control has-icons-left">
            <input
              name={`email[${scopeName}_contact]`}
              className={`input ${isPrimary ? 'is-primary' : 'is-secondary'} is-marginless`}
              type="text"
              onChange={(event) => { updateInput(event.target.value); }}
              onBlur={() => setTimeout(() => setShowSuggestions(false), 200)}
              onFocus={() => setShowSuggestions(true)}
              placeholder="Phone number or email"
              data-target={`${ controllerName || 'share-item' }.${scopeName}ContactInput`}
              data-action={`input->${ controllerName || 'share-item' }#askNames`}
              data-scope={scopeName}
              required="required"
            />
            <span className="icon is-small is-left">
              <FontAwesome name="search" />
            </span>
          </p>
        </div>
        )}
      <div className="is-relative">
        <div className="options-container">
          {showSuggestions && suggestedUsers.map((user) => (
            <div
              className="option is-clickable"
              key={user.id}
              onClick={(event) => selectUser(user, event)}
              data-action={`click->${ controllerName || 'share-item' }#askNames`}
              data-scope={scopeName}
              data-has-name={!!user.first_name}
            >
              <div className="user-image">
                <img
                  src={user.profile_image || defaultProfilePicture}
                  alt="User profile"
                  onError={handleImageError}
                />
              </div>
              <span>{ `${user.first_name} ${user.last_name}` }</span>
            </div>
          ))}
        </div>
      </div>
    </div>
  );
};

UserSuggester.defaultProps = {
  controllerName: '',
};

UserSuggester.propTypes = {
  scopeName: PropTypes.string,
  controllerName: PropTypes.string,
  isPrimary: PropTypes.bool,
};

export default UserSuggester;
