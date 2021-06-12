import { Controller } from 'stimulus';

export default class extends Controller {
  static targets = ['cliqueContainer']

  hide(e) {
    e.preventDefault();
    this.cliqueContainerTarget.classList.add('is-hidden');
  }
}
