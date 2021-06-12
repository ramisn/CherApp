import React, { useState, useEffect } from 'react';
import ReactDOM from 'react-dom';
import PropTypes from 'prop-types';

const NavbarNotificationBadge = (props) => {
  const [showBadge, setShowBadge] = useState(false);
  const { unconsumedMessages, friendRequestsNumber, invitationsNumber } = props;
  const notificationBadgeContainer = document.getElementById('notificationBadgeContainer');
  const numberOfNotifications = friendRequestsNumber + unconsumedMessages + invitationsNumber;

  useEffect(() => {
    setTimeout(() => {
      setShowBadge(true);
    }, 3000);
  }, []);

  return (
    <>
      { numberOfNotifications ? ReactDOM.createPortal(
        <span className={`main-badge is-hidden-mobile ${ showBadge ? '' : 'is-loading' }`}>
          {showBadge ? numberOfNotifications : ''}
        </span>,
        notificationBadgeContainer,
      ) : null}
    </>
  );
};

NavbarNotificationBadge.propTypes = {
  unconsumedMessages: PropTypes.number,
  friendRequestsNumber: PropTypes.number,
  invitationsNumber: PropTypes.number,
};

export default NavbarNotificationBadge;
