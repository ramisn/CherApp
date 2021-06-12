import { Controller } from 'stimulus';

export default class extends Controller {
  static targets = ['fadeContainer']

  toggleVisibility() {
    this.fadeContainerTarget.classList.toggle('is-hidden');
  }
}

