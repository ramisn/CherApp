import React from 'react';
import PropTypes from 'prop-types';

function UserInvitation(props) {
  const { email, sendFriendRequest } = props;

  return (
    <button type="button" className="option link is-coral" onClick={() => sendFriendRequest(email)}>
      {`Invite ${email}`}
    </button>
  );
}

UserInvitation.propTypes = {
  email: PropTypes.string.isRequired,
  sendFriendRequest: PropTypes.func.isRequired,
};

export default UserInvitation;
