import { Controller } from 'stimulus';

export default class extends Controller {
  static targets = ['userName']

  toggleUserName() {
    this.userNameTarget.classList.toggle('is-hidden');
  }
}
