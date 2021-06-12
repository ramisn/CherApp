import { Controller } from 'stimulus';

export default class extends Controller {
  static targets = ['password', 'passwordConfirmation']

  seePassword() {
    if (this.passwordTarget.type === 'password') {
      this.passwordTarget.type = 'text';
    } else {
      this.passwordTarget.type = 'password';
    }
  }

  seePasswordConfirmation() {
    if (this.passwordConfirmationTarget.type === 'password') {
      this.passwordConfirmationTarget.type = 'text';
    } else {
      this.passwordConfirmationTarget.type = 'password';
    }
  }
}
