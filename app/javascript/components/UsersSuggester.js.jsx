import React from 'react';
import PropTypes from 'prop-types';
import Qs from 'qs';
import axios from '../packs/axios_utils.js';
import defaultProfilePicture from '../../assets/images/cherapp-ownership-coborrowing-ico-user.svg';
import magnifierIcon from '../../assets/images/cherapp-ownership-coborrowing-magnifier.svg';

class PeopleInvolvedInHouse extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      suggestedUsers: [],
      inputValue: '',
      selectedUsers: [],
    };
  }

  handleError = (event) => {
    event.preventDefault();
    event.target.setAttribute('src', defaultProfilePicture);
  }

  handleKeyDown = (event) => {
    if (event.key === 'Enter') {
      event.stopPropagation();
      event.preventDefault();
    }
  }

  updateInput(value) {
    const { limit } = this.props;
    this.setState({
      inputValue: value,
    });
    if (value.length > 3) {
      this.findSimilarUsers(value);
    }
  }

  findSimilarUsers(userName) {
    const params = { user: { identifier: userName }};
    axios.get('/users', {
      params,
      paramsSerializer() { return Qs.stringify(params, { arrayFormat: 'brackets' }); },
    })
      .then((response) => {
        if (response.status === 200) {
          this.setState({
            suggestedUsers: response.data,
          });
        }
      });
  }

  addUserToList(newUser) {
    const { selectedUsers } = this.state;
    const userAlreadySelected = selectedUsers.filter((user) => newUser.id === user.id).length;
    if (userAlreadySelected) {
      this.setState({
        suggestedUsers: [],
        inputValue: '',
      });
    } else {
      this.setState((prevState) => ({
        selectedUsers: [...prevState.selectedUsers, newUser],
        suggestedUsers: [],
        inputValue: '',
      }));
    }
  }

  removeSelectedUser(userToRemove) {
    this.setState((prevState) => ({
      selectedUsers: prevState.selectedUsers.filter((user) => user.id !== userToRemove.id),
      suggestedUsers: [],
    }));
  }

  selectedUsers(){
    const { selectedUsers } = this.state;
    const { fieldName } = this.props;
    return selectedUsers.map((user) => (
      <div className="tag is-primary m-r-sm" key={user.id}>
        <input className="input" type="hidden" value={user.id} name={fieldName || 'users_ids[]'} />
        <span>{user.full_name}</span>
        <button onClick={() => { this.removeSelectedUser(user); }} className="is-close" type="button">X</button>
      </div>
    ))
  }
  render() {
    const { inputValue, suggestedUsers } = this.state;
    const { extraClass, position } = this.props;

    return (
      <>
        { position === 'top' ? this.selectedUsers() : null }

        <div className="field has-full-width">
          <p className="control has-icons-left">
            <input className={`input is-marginless ${extraClass}`} type="text"  placeholder="Search" value={inputValue} onChange={(event) => { this.updateInput(event.target.value); }} onKeyDown={(event) => { this.handleKeyDown(event); }} />
            <span className="icon is-small is-left">
              <img src={magnifierIcon} alt="Magnifier glass"/>
            </span>
          </p>
        </div>

        <div className="is-relative">
          <div className="options-container">
            { suggestedUsers.map((user) => (
              <div className="option is-clickable" key={user.id} onClick={() => { this.addUserToList(user); }}>
                <div className="user-image">
                  <img src={user.profile_image || defaultProfilePicture} alt="User profile" onError={(event) => { this.handleError(event); }} />
                </div>
                <span>{user.full_name}</span>
              </div>
            ))}
          </div>
        </div>

        { position === 'bottom' ? this.selectedUsers() : null }

      </>
    );
  }
}

PeopleInvolvedInHouse.propTypes = {
  fieldName: PropTypes.string,
  limit: PropTypes.number,
  extraClass: PropTypes.string,
  position: PropTypes.string,
};

PeopleInvolvedInHouse.defaultProps = {
  position: 'top'
};

export default PeopleInvolvedInHouse;
