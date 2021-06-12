import React from 'react';
import Qs from 'qs';
import PropTypes from 'prop-types';
import axios from '../packs/axios_utils.js';
import USER_ROLES from '../packs/user_roles.js';
import searchIcon from '../../assets/images/cherapp-ownership-coborrowing-ico-share-white.svg';
import defaultProfilePicture from '../../assets/images/cherapp-ownership-coborrowing-ico-user.svg';

class UserSugesterModal extends React.Component {
  constructor(props) {
    super(props);
    const { users, isChecked } = this.props;
    this.state = {
      inputContent: '',
      users,
      isChecked,
      usersSharedWith: [],
    };
  }

  toggleChange = () => {
    this.setState((prevState) => (
    { isChecked: !prevState.isChecked }));
    const { isChecked } = this.state;
    const checkBoxValue = isChecked ? '1' : '0';
    const { userNotificationPreferences, userId } = this.props;
    const newObjPreferences = { ...userNotificationPreferences };
    newObjPreferences.share_house_modal_in_app = checkBoxValue;

    const params = {
                    notification_settings: {
                      preferences: newObjPreferences,
                    },
    };
    axios.patch(`/notification_settings/${userId}`, params);
  }

  updateInputContent = (event) => {
    const inputContent = event.target.value;
    this.setState({ inputContent }, () => {
      this.requestAllUsers();
    });
  }

  requestAllUsers = async () => {
    const { inputContent } = this.state;
    const params = {
      user: {
        identifier: inputContent,
      },
    };
    if (inputContent.length > 3) {
      axios.get('/users', {
        params,
        paramsSerializer() { return Qs.stringify(params, { arrayFormat: 'brackets' }); },
      })
      .then((response) => {
        if (response.status === 200) {
          this.setState({ users: response.data });
        }
      });
    } else {
      this.setState({ users: [] });
    }
  }

  handleImageError = (event) => {
    event.preventDefault();
    event.target.setAttribute('src', defaultProfilePicture);
  };

  sendEmailRequest = (recipient, e) => {
    const recipientId = recipient.id;
    const type = 'property';
    const recipientEmail = recipient.email;
    const recipientName = `${recipient.first_name} ${recipient.last_name}`;
    const { userName, propertyAddress, propertyUrl } = this.props;

    const params = {
                    address: propertyAddress,
                    link: propertyUrl,
                    recipient: recipientEmail,
                    type,
                    recipient_name: recipientName,
                    user_name: userName,
    };

    axios.post('/email', params);

    e.target.disabled = true;
    this.setState((prevState) => (
      { usersSharedWith: [...prevState.usersSharedWith, recipientId] }
    ));
  }

  isContainerDisabledClass(user) {
    const { usersSharedWith } = this.state;
    return usersSharedWith.includes(user.id) ? 'is-disabled' : '';
  }

  render() {
    const { inputContent, users, isChecked } = this.state;

    return (
      <div className="suggester-input">
        <div id="suggesterInputContainer" className="control has-icons-right m-b-md">
          <input
            value={inputContent}
            type="text"
            name="user[identifier]"
            className="input has-border-blue"
            placeholder="Search friends"
            required="required"
            autoComplete="off"
            onChange={this.updateInputContent}
          />
        </div>
        { users.map((user) => (
          <div key={user.id} className={`card-container is-paddingless is-relative ${this.isContainerDisabledClass(user)}`}>
            <div className="panel-top-section is-paddingless">
              <div className="is-flex is-aligned-center">
                <img
                  src={user.profile_image || defaultProfilePicture}
                  alt="User profile"
                  className="profile-image is-marginless"
                  onError={this.handleImageError}
                />
                <div className="panel-text-content friend-name ">
                  <span className="is-primary">{`${user.first_name} ${user.last_name}`}</span>
                  <span className="has-text-weight-normal">{USER_ROLES[user.role]}</span>
                </div>
                <div className="is-absolute to-left-3 to-top-1-half">{user.city}</div>
              </div>
            </div>
            <button
              id={`share${user.id}`}
              className="button has-full-width is-primary m-t-md m-b-lg"
              type="button"
              onClick={(e) => { this.sendEmailRequest(user, e); }}
            >
              <img src={searchIcon} className="is-is-16x16 m-r-sm" alt="user" />
              <span>Share</span>
            </button>
          </div>
        ))}

        <label className="checkbox-container is-relative">
          Don&apos;t show me this again
          <input type="checkbox" checked={isChecked} onChange={this.toggleChange} />
          <span className="checkmark" />
        </label>
      </div>
    );
  }
}

UserSugesterModal.propTypes = {
  users: PropTypes.arrayOf(PropTypes.shape({})),
  userId: PropTypes.string.isRequired,
  isChecked: PropTypes.bool,
  propertyUrl: PropTypes.string.isRequired,
  propertyAddress: PropTypes.string.isRequired,
  userName: PropTypes.string.isRequired,
  userNotificationPreferences: PropTypes.shape({}),
};

export default UserSugesterModal;
