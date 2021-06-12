import { Controller } from 'stimulus';
import axios from '../packs/axios_utils';

const userProfessionalRoles = {
                                estate_agent: 'Real State Agent',
                                loan_officer: 'Loan Officer',
                                escrow_officer: 'Escrow Officer',
                                general_contractor: 'General Contractor',
                                mortgage_broker: 'Mortgage Broker',
                                title_officer: 'Title Oficer',
                                other: 'other',
                              };
export default class extends Controller {
  static targets = [
                    'emailInput', 'passwordInput', 'passwordConfirmationInput',
                    'passwordErrorMessage', 'emailErrorMessage',
                    'passwordConfirmationErrorMessage', 'form',
                    ]

  handleSubmit(event) {
    event.stopPropagation();
    event.preventDefault();
    this.cleanInputs();
    const userEmail = this.emailInputTarget.value;
    const userPassword = this.passwordInputTarget.value;
    const userPasswordConfirmation = this.passwordConfirmationInputTarget.value;
    this.requestUserRegistration(userEmail, userPassword, userPasswordConfirmation);
  }

  cleanInputs() {
    this.passwordInputTarget.classList.remove('is-danger');
    this.passwordConfirmationInputTarget.classList.remove('is-danger');
    this.passwordInputTarget.classList.remove('is-danger');
    this.emailInputTarget.classList.remove('is-danger');
    this.passwordErrorMessageTarget.innerText = '';
    this.passwordConfirmationErrorMessageTarget.innerText = '';
    this.emailErrorMessageTarget.innerText = '';
  }

  requestUserRegistration(email, password, passwordConfirmation) {
    const params = {
      user: {
        email,
        password,
        password_confirmation: passwordConfirmation,
      },
    };
    axios.post('/users', params)
    .then((response) => {
      if (response.data.valid) {
        this.formTarget.submit();
      }
    })
    .catch((exception) => {
      const { errors } = exception.response.data;
      this.manageErrorMessages(errors);
    });
  }

  manageErrorMessages(errorMessages) {
    if (errorMessages.email) {
      this.emailInputTarget.classList.add('is-danger');
      this.emailErrorMessageTarget.innerText = errorMessages.email[0];
    }
    if (errorMessages.password) {
      this.passwordInputTarget.classList.add('is-danger');
      this.passwordErrorMessageTarget.innerText = errorMessages.password[0];
    }
    if (errorMessages.password_confirmation) {
      const message = errorMessages.password_confirmation[0];
      this.passwordConfirmationInputTarget.classList.add('is-danger');
      this.passwordConfirmationErrorMessageTarget.innerText = message;
    }
  }
}
