import { Controller } from 'stimulus';
import axios from '../packs/axios_utils.js';

const EMAILREGEX = /^\w+([\.-]?\w+)*@\w+([\.-]?\w+)*(\.\w{2,3})+$/;
const PHONEREGEX = /^[0-9]{10}/;

export default class extends Controller {
  static targets = [
                    'linkInput', 'emailInput', 'messageInput', 'errorMessage',
                    'successMessage', 'linkMessage', 'phoneNumberInput',
                    'typeInput', 'userFirstNameInput', 'userLastNameInput', 'addressInput',
                    'userContactInput', 'recipientContactInput', 'userPhoneNumberInput', 'recipientFirstNameInput',
                    'recipientLastNameInput', 'recipientEmailInput', 'recipientPhoneNumberInput',
                    'userFullNameInputs', 'userSenderInput', 'recipientFullNameInputs', 'propertyId'
                   ];

  copyLink() {
    this.linkInputTarget.select();
    document.execCommand('copy');
    this.linkInputTarget.setSelectionRange(0, 99999);
    this.linkMessageTarget.classList.remove('is-hidden');
  }

  handleSubmit(event) {
    event.stopPropagation();
    event.preventDefault();
    const contact = this.recipientContactInputTarget.value;

    if (this.isValidContact(contact)) {
      this.createProspects();
      if (this.isPhoneValid(contact)) {
        this.sendSMSRequest(contact);
      } else {
        this.sendEmailRequest(contact);
      }
    } else {
      this.setErrorMessage({ show: true, message: 'The contact is not valid, please try a different one.'});
    }
  }

  handleSubmitFull(event) {
    event.stopPropagation();
    event.preventDefault();
    const contact = this.recipientContactInputTarget.value;
    const isUserSelected = this.recipientContactInputTarget.dataset.userSelected;

    if (!isUserSelected) {
      this.handleSubmit(event);
      return;
    }

    if (this.isValidContact(contact)) {
      this.createProspects();
      this.sendFullNotification(contact);
    } else {
      this.setErrorMessage({ show: true, message: 'The contact is not valid, please try a different one.'});
    }
  }

  sendFullNotification(recipient) {
    const link = this.linkInputTarget.value;
    const type = this.typeInputTarget.value;
    const propertyId = this.propertyId(type);

    const params = {
      recipient,
      link,
      type,
      property_id: propertyId,
    };

    axios.post('/full_notifications', params)
    .then((response) => {
      if (response.status === 200) {
        const messageResponse = response.data.message;
        this.resetFormValues(messageResponse, type);
      }
    });
  }

  sendSMSRequest(recipient) {
    const message = this.messageInputTarget.value;
    const link = this.linkInputTarget.value;
    const type = this.typeInputTarget.value;
    const recipientName = this.recipientFullName();
    const userName = this.userFullName();
    const address = this.address(type);

    const params = {
                      message,
                      link,
                      type,
                      recipient,
                      recipient_name: recipientName,
                      user_name: userName,
                      address,
    };

    axios.post('/text_messages', params)
    .then((response) => {
      if (response.status === 200) {
        const messageResponse = response.data.message;
        this.resetFormValues(messageResponse, type);
      }
    });
  }

  sendEmailRequest(recipient) {
    const body = this.messageInputTarget.value;
    const link = this.linkInputTarget.value;
    const type = this.typeInputTarget.value;
    const recipientName = this.recipientFullName();
    const userName = this.userFullName();
    const address = this.address(type);

    const params = {
                    address,
                    body,
                    link,
                    recipient,
                    type,
                    recipient_name: recipientName,
                    user_name: userName,
    };

    axios.post('/email', params)
    .then((response) => {
      if (response.status === 200) {
        const { message } = response.data;
        this.resetFormValues(message, type);
      }
    });
  }

  propertyId(type) {
    return type === 'property' ? this.propertyIdTarget.value : null;
  }

  address(type) {
    return type === 'property' ? this.addressInputTarget.value : null;
  }

  userFullName() {
    return `${this.userFirstNameInputTarget.value} ${this.userLastNameInputTarget.value}`;
  }

  recipientFullName() {
    return `${this.recipientFirstNameInputTarget.value} ${this.recipientLastNameInputTarget.value}`;
  }

  createProspects() {
    const userContact = this.userContactInputTarget.value;
    const userFirstName = this.userFirstNameInputTarget.value;
    const userLastName = this.userLastNameInputTarget.value;

    const recipientContact = this.recipientContactInputTarget.value;
    const recipientFirstName = this.recipientFirstNameInputTarget.value;
    const recipientLastName = this.recipientLastNameInputTarget.value;

    const userProspect = {
      first_name: userFirstName,
      last_name: userLastName,
    };

    if (this.isEmailValid(userContact)) userProspect.email = userContact;
    if (this.isPhoneValid(userContact)) userProspect.phone_number = userContact;

    const recipientProspect = {
      first_name: recipientFirstName,
      last_name: recipientLastName,
    };
    if (this.isEmailValid(recipientContact)) recipientProspect.email = recipientContact;
    if (this.isPhoneValid(recipientContact)) recipientProspect.phone_number = recipientContact;

    if (this.isValidContact(userContact)) axios.post('/prospect', { prospect: userProspect, send_email: false });
    if (this.isValidContact(recipientContact)) axios.post('/prospect', { prospect: recipientProspect, send_email: false });
  }

  setUserName({ firstName, lastName }, input) {
    this[`${input}FirstNameInputTarget`].value = firstName || '';
    this[`${input}LastNameInputTarget`].value = lastName || '';
  }

  setContact(contact, input) {
    this[`${input}ContactInputTarget`].value = contact || '';
  }

  removeSuggestedUser = (input) => {
    const element = document.getElementById(`${input}RemoveUserButton`);

    if (element) element.click();
  }

  toggleNameInputs(disabled, input) {
    this[`${input}FirstNameInputTarget`].disabled = disabled;
    this[`${input}LastNameInputTarget`].disabled = disabled;
  }

  resetEmailInput(e) {
    const { email } = e.target.dataset;

    this[`${email}EmailInputTarget`].value = '';
  }

  resetPhoneNumberInput(e) {
    const { phoneTarget } = e.target.dataset;

    this[`${phoneTarget || 'recipientPhoneNumberInput'}Target`].value = '';
  }

  resetFormValues(message) {
    this.setUserName({}, 'recipient');
    this.setUserName({}, 'user');
    this.setContact(null, 'user');
    this.setContact(null, 'recipient');
    this.removeSuggestedUser('user');
    this.removeSuggestedUser('recipient');

    this.messageInputTarget.value = '';
    this.successMessageTarget.classList.remove('is-hidden');
    this.setErrorMessage({show: false});
    this.successMessageTarget.innerText = message;
    this.toggleNameInputs(false, 'recipient');
  }

  setErrorMessage = ({message, show}) => {
    this.errorMessageTarget.innerText = message || '';
    this.errorMessageTarget.classList[show ? 'remove' : 'add']('is-hidden');
  }

  isEmailValid = (email) => EMAILREGEX.test(email);

  isPhoneValid = (phone) => PHONEREGEX.test(phone);

  isValidContact = (contact) => this.isEmailValid(contact) || this.isPhoneValid(contact);

  askNames(e) {
    const { scope, hasName } = e.currentTarget.dataset;

    if (hasName) this[`${scope}FullNameInputsTarget`].classList.add('is-hidden');
    else this[`${scope}FullNameInputsTarget`].classList.remove('is-hidden');
  }
}
