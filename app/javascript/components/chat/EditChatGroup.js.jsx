import React, { useEffect, useState, useRef } from 'react';
import PropTypes from 'prop-types';
import Qs from 'qs';
import axios from '../../packs/axios_utils.js';
import leaveIcon from '../../../assets/images/cherapp-ownership-coborrowing-leave.svg';
import editIcon from '../../../assets/images/cherapp-ownership-coborrowing-edit.svg';
import defaultProfilePicture from '../../../assets/images/cherapp-ownership-coborrowing-ico-user.svg';
import magnifierGlass from '../../../assets/images/cherapp-ownership-coborrowing-magnifier-white.svg';
import USER_ROLES from '../../packs/user_roles.js';

const EditChatGroup = ({ channelSid, userPermissions, userEmail }) => {
  const [chatClient, setChatClient] = useState(null);
  const [convesationChannel, setConversationChannel] = useState(null);
  const [participants, setParticipants] = useState([]);
  const [groupName, setGroupName] = useState('');
  const [isInputEditable, setIsInputEditable] = useState(false);
  const [inputValue, setInputValue] = useState('');
  const [suggestedUsers, setSuggestedUsers] = useState([]);
  const [usersToRemove, setUsersToRemove] = useState([]);
  const [usersToAdd, setUsersToAdd] = useState([]);
  const chatNameInput = useRef(null);
  const suggesterInput = useRef(null);

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

  const getParticipants = async () => {
    const response = await axios.get(`/message_channels/${channelSid}/participants`);
    const channelParticipants = response.data;
    setParticipants(channelParticipants);
  };

  const leaveGroup = () => {
    const userAccepted = confirm('Are you sure you want to leave the group?');

    // Leave a group is not the same as remove a member.
    // When leaving,all member info persisis(inlcuding messages)
    if (userAccepted) {
      convesationChannel.leave()
      .then(() => {
        axios.delete(`/message_channels/${channelSid}/participants/${userEmail}`, { parmas: { email: userEmail } })
        .then((response) => {
          window.location = '/conversations';
        });
      });
    }
  };

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
  }, [chatClient]);

  useEffect(() => {
    if (!convesationChannel) return;

    setGroupName(convesationChannel.friendlyName);
  }, [convesationChannel]);

  useEffect(() => {
    if (!isInputEditable) return;

    chatNameInput.current.focus();
  }, [isInputEditable]);

  const userIdentifier = (user) => (user.full_name.trim() ? user.full_name : user.email);

  const canUserInvite = () => userPermissions.includes('addMember');

  // Ideally admin should be able to leave as well, but a new admin need to be defined first
  const canUserLeaveGroup = () => userPermissions.includes('leaveChannel') && !canUserInvite();

  // TODO: Move to a utils files
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

  const deleteFromGroup = (friend) => {
    setUsersToRemove((prevUsersToRemove) => [...prevUsersToRemove, friend.email]);
    setParticipants((prevParticipants) => {
      const filteredParticipants = prevParticipants.filter((user) => user.email !== friend.email);
      return filteredParticipants;
    });
  };

  const isUserAMember = (user) => (
    participants.filter((member) => (member.email === user.email).length)
  );

  const willMemberBeDeleted = (member) => (
    usersToRemove.filter((user) => (user.email === member.email).length)
  );

  const addToGroup = (friend) => {
    setSuggestedUsers([]);

    if (isUserAMember(friend) && willMemberBeDeleted(friend)) {
      setUsersToRemove((prevUsers) => prevUsers.filter((email) => (email !== friend.email)));
      setParticipants((prevParticipants) => [...prevParticipants, friend]);
    }

    if (participants.filter((user) => (user.email === friend.email).length)) return;

    setUsersToAdd((prevUsersToRemove) => [...prevUsersToRemove, friend.email]);
    setParticipants((prevParticipants) => [...prevParticipants, friend]);
  };

  const saveChanges = () => {
    axios.put(`/chat-groups/${channelSid}`,
            {
              group: {
                        users_to_remove: usersToRemove,
                        users_to_add: usersToAdd,
                        name: groupName,
                      },
            })
    .then((response) => {
      if (response.status === 200) {
        window.location = `/chat-groups/${channelSid}`;
      }
    });
  };

  // TODO: move to a utils file
  const userItem = (user) => (
    <button type="button" className="option button has-no-style" key={user.id} onClick={() => { addToGroup(user); }}>
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

  const friendItem = (friend) => (
    <li key={friend.id} className="list-item has-space-mobile">
      <div className="columns is-marginless is-mobile">
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
          {canUserInvite() && (
            <button className="button has-no-style has-text-primary" type="button" onClick={() => { deleteFromGroup(friend); }}>
              Delete from group
            </button>
          )}
        </div>
      </div>
    </li>
  );

  const searchInput = () => (
    <div className="field has-submit-beside is-primary">
      <div className="is-marginless has-full-width-mobile">
        <input
          type="text"
          value={inputValue}
          ref={suggesterInput}
          placeholder="Add name, email, mobile"
          className="input is-marginless"
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
    <div className="conversation-container">
      <div className="columns is-marginless is-mobile is-multilline has-direction-column">
        <div className="column is-12">
          <div className="has-full-width is-flex has-space-between">
            <a className="is-bold" href={`/chat-groups/${channelSid}`}>{'< Back'}</a>
            {canUserLeaveGroup() && (
              <button type="button" className="button has-no-style has-text-primary is-flex is-bold" onClick={leaveGroup}>
                <img src={leaveIcon} alt="Leave" className="m-r-md" />
                Leave
              </button>
            )}
          </div>
        </div>
        <div className="column is-12">
          <div className="is-flex m-b-sm">
            <input
              ref={chatNameInput}
              value={groupName}
              onChange={(e) => { setGroupName(e.target.value); }}
              className={`input is-bold is-marginless is-editable has-width-auto ${isInputEditable ? '' : 'is-disabled'}`}
            />
            {canUserInvite() && (
              <button className="button has-no-style" type="button" onClick={() => { setIsInputEditable(!isInputEditable); }}>
                <img alt="edit" className="m-l-md" src={editIcon} />
              </button>
            )}
          </div>
          <hr className="is-marginless" />
        </div>
        <div className="column is-12">
          {canUserInvite() && searchInput()}
          <div className="chat-list-items">
            {participants.map((user) => friendItem(user))}
          </div>
        </div>
        {canUserInvite() && (
          <div className="column is-12">
            <div className="columns is-marginless is-fully-centered">
              <div className="column is-12-mobile is-6-tablet is-5-desktop is-3-widescreen is-fully-centered is-paddingless">
                <button type="button" className="button is-primary has-full-width" onClick={saveChanges}>
                  Save
                </button>
              </div>
            </div>
          </div>
        )}
      </div>
    </div>
  );
};

EditChatGroup.propTypes = {
  channelSid: PropTypes.string.isRequired,
  userPermissions: PropTypes.arrayOf(PropTypes.string).isRequired,
  userEmail: PropTypes.string.isRequired
};

export default EditChatGroup;
