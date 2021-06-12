import React from 'react';
import { render } from '@testing-library/react';
import UserInvitation from 'components/UserInvitation.js';

const sendFriendRequest = jest.fn();

const setup = () => (
  render(
    <UserInvitation
      sendFriendRequest={sendFriendRequest}
      email="miguel.urbina@michelada.io"
    />,
  )
);

describe('UserInvitation', () => {
  it('should display invitation button', () => {
    const { getByText } = setup();

    expect(getByText('Invite miguel.urbina@michelada.io')).toBeTruthy();
  });
});
