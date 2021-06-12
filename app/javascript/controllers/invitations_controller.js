import axios from '../packs/axios_utils.js';
import ShareItemController from './share-item_controller.js';

export default class extends ShareItemController {
  static targets = [
                    'emailInput', 'messageInput', 'errorsMessage',
                    'resultMessage', 'senderEmailInput', 'senderFirstName',
                    'senderLastName', 'linkMessage', 'phoneNumberInput',
                    'typeInput', 'userFirstNameInput', 'userLastNameInput', 'addressInput',
                    'userContactInput', 'recipientContactInput', 'userPhoneNumberInput', 'recipientFirstNameInput',
                    'recipientLastNameInput', 'recipientEmailInput', 'recipientPhoneNumberInput',
                    'userFullNameInputs', 'userSenderInput', 'recipientFullNameInputs', 'recipientSelectedId',
                    'sendMessage', 'signUpLink', 'sendMessageLink',
                  ];

  handleInviteEmail(event) {
    event.stopPropagation();
    event.preventDefault();
    const contact = this.recipientContactInputTarget.value;

    if (this.hasRecipientSelectedIdTarget) this.sendFriendsRequest();
    else this.sendEmailInvitation(contact);
  }

  sendFriendsRequest() {
    const recipientSelected = this.recipientSelectedIdTarget.value;

    const params = {
      friend_request: {
        requestee_id: recipientSelected,
      },
    };

    axios.post('/friend_requests', params)
      .then((response) => {
        if (response.status === 201) this.resetMessageTargets('Friend request sent');
      }).catch(({ response }) => {
        if (response) {
          this.showSendMessage(recipientSelected);
        }
      });
  }

  sendEmailInvitation(recipientEmail) {
    const body = this.messageBody();
    const recipientName = this.recipientFullName();
    const userName = this.userFullName();

    const params = {
      user: {
        body,
        recipient_name: recipientName,
        email: recipientEmail,
        user_name: userName,
      },
    };

    axios.post('/users/invitation', params)
      .then((response) => {
        if (response.status === 201) {
          this.resetMessageTargets('Email sent');
          this.cleanInputs();
        }
      }).catch(({ response }) => {
        if (response) {
          const { data } = response;

          this.setErrorsMessage(data.message || this.formatMessage(data.errors.email[0]));
        }
      });
  }

  messageBody = () => (this.hasMessageInputTarget ? this.messageInputTarget.value : '');

  resetMessageTargets(message) {
    this.recipientContactInputTarget.value = '';
    if (this.hasMessageInputTarget) this.messageInputTarget.value = '';
    this.errorsMessageTarget.innerText = '';
    this.resultMessageTarget.classList.remove('is-hidden');
    this.errorsMessageTarget.classList.add('is-hidden');
    this.resultMessageTarget.innerText = message;
    this.hideMessageLink();
  }

  setErrorsMessage(message) {
    this.errorsMessageTarget.classList.remove('is-hidden');
    this.errorsMessageTarget.innerText = message;
    this.hideMessageLink();
  }

  showSendMessage(userId) {
    const firstName = this.recipientFirstNameInputTarget.value;
    this.cleanInputs();
    this.resetMessageTargets('');

    this.sendMessageTarget.classList.remove('is-hidden');
    this.sendMessageTarget.setAttribute('data-user-id', userId);
    this.sendMessageTarget.innerText = `You are already friend of ${firstName}, click here to chat!`;
  }

  sendMessageToUser = (e) => {
    const { userId } = e.target.dataset;
    axios.get(`/users/${userId}`).then((res) => { window.location = `/conversations/${res.data.slug}`; });
  }

  cleanInputs() {
    this.recipientFirstNameInputTarget.value = '';
    this.recipientLastNameInputTarget.value = '';
  }

  cleanModal() {
    this.hideMessageLink();
    this.cleanInputs();
    this.resetMessageTargets('');
  }

  hideMessageLink = () => this.sendMessageTarget.classList.add('is-hidden');

  formatMessage = (message) => `${message.includes('email') ? '' : 'The contact'} ${message}, please try with a different one.`;
}
