import React from 'react';
import PropTypes from 'prop-types';
import defaultImagePicture from '../../assets/images/cherapp-ownership-coborrowing-ico-user.svg';

function UserListItem(props) {
  const { user } = props;
  const { id, profile_image, first_name } = user;

  return (
    <a href={`/users/${user.id}`} key={id} className="option">
      <div className="user-image">
        <img src={profile_image || defaultImagePicture} alt="User profile" />
      </div>
      {first_name}
    </a>
  );
}

UserListItem.propTypes = {
  user: PropTypes.shape({
    id: PropTypes.number,
    image: PropTypes.string,
    first_name: PropTypes.string,
  }).isRequired,
};

export default UserListItem;
