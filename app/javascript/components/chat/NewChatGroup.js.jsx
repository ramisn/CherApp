import React, { useEffect, useState, useRef } from 'react';
import PropTypes from 'prop-types';
import axios from '../../packs/axios_utils.js';
import FlaggedPropertiesSelecter from './FlaggedPropertiesSelecter';
import ChatGroupParticipants from './ChatGroupParticipants';
import editIcon from '../../../assets/images/cherapp-ownership-coborrowing-edit.svg';

const NewChatGroup = ({ friends, flaggedProperties, userName, userEmail }) => {
  const [selectedUsers, setSelectedUsers] = useState([]);
  const [groupName, setGroupName] = useState(`${userName}'s group`);
  const [groupImage, setGroupImage] = useState(null);
  const [propertyStepFinished, setPropertyStepFinished] = useState(false);
  const [isInputEditable, setIsInputEditable] = useState(false);
  const chatNameInput = useRef(null);

  const addUserToList = (user) => {
    if (selectedUsers.filter((selectedUser) => (selectedUser.email === user.email)).length) return;

    setSelectedUsers((prevSelectedUsers) => [...prevSelectedUsers, user]);
  };

  const removeUserFromList = (user) => {
    setSelectedUsers((prevSelectedUsers) => {
      return prevSelectedUsers.filter((selectedUser) => selectedUser.email !== user.email);
    });
  };

  const nextStep = (selectedProperty) => {
    if (selectedProperty) {
      const propertyAddress = selectedProperty.address.full;
      setGroupName(propertyAddress);
      setGroupImage(selectedProperty.photos[0]);
    }

    setPropertyStepFinished(true);
  };

  const createGroup = () => {
    if (groupName.length && selectedUsers.length) {
      const participants = selectedUsers.map((user) => user.email);

      axios.post('/chat-groups', { group: { participants, name: groupName, image_url: groupImage } })
      .then((response) => {
        if (response.status === 201) {
          window.location.href = `/chat-groups/${response.data.sid}`;
        }
      });
    } else {
      chatNameInput.current.classList.add('is-danger');
    }
  };

  useEffect(() => {
    if (!isInputEditable) return;

    chatNameInput.current.focus();
  }, [isInputEditable]);

  useEffect(() => {
    const qParams = new URLSearchParams(window.location.search);
    const propertySelected = qParams.get('property_id');

    if (propertySelected) {
      const property = flaggedProperties.find((p) => p.listingId === propertySelected)
      nextStep(property);
    }
  }, [])

  return (
    <div className="columns is-multiline is-marginless">
      <div className="column is-12-mobile is-12-tablet chat-header">
        {propertyStepFinished
        ? (
          <div className="is-flex">
            <input
              ref={chatNameInput}
              className={`input is-bold is-marginless is-editable ${isInputEditable ? '' : 'is-disabled'}`}
              value={groupName}
              onChange={(e) => { setGroupName(e.target.value); }}
            />
            <button className="button has-no-style" type="button" onClick={() => { setIsInputEditable(!isInputEditable); }}>
              <img alt="edit" className="m-l-md" src={editIcon} />
            </button>
          </div>
        )
        : <h1 className="is-size-4">New group</h1>}
      </div>
      <div className="column is-12-mobile is-12-tablet">
        <div className="columns is-marginless is-mobile">
          <div className="column is-6 is-flex is-justified-center">
            <button
              type="button"
              className={`button has-no-style ${propertyStepFinished ? 'has-text-primary is-bold' : ''}`}
              onClick={() => { setPropertyStepFinished(false); }}
            >
              Homes
            </button>
          </div>
          <div className="column is-6 has-text-centered">
            <span className={propertyStepFinished ? '' : 'has-text-primary is-bold'}>Friends</span>
          </div>
        </div>
        <hr className="is-marginless" />
        {/* TODO: Add empty state when no flagged properties */}
        { propertyStepFinished
        ? (
          <ChatGroupParticipants
            addUserToList={addUserToList}
            removeUserFromList={removeUserFromList}
            selectedUsers={selectedUsers}
            friends={friends}
            createGroup={createGroup}
          />
          )
        : <FlaggedPropertiesSelecter flaggedProperties={flaggedProperties} nextStep={nextStep} />}
      </div>
    </div>
  );
};

NewChatGroup.propTypes = {
  friends: PropTypes.arrayOf(PropTypes.shape),
  flaggedProperties: PropTypes.arrayOf(PropTypes.shape({})).isRequired,
  userName: PropTypes.string,
};

export default NewChatGroup;
