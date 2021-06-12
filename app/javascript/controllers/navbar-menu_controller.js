import { Controller } from 'stimulus';

export default class extends Controller {
  static targets = ['menuButton', 'menu']

  toggleMenu() {
    this.menuTarget.classList.toggle('is-hidden');
    this.menuTarget.classList.toggle('show');
  }
}
