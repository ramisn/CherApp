import { Controller } from 'stimulus';

export default class extends Controller {
  static targets = ['flash']

  connect() {
    setTimeout(() => {
      this.handleHide();
    }, 3000);
  }

  handleHide(extraClass) {
    this.flashTarget.classList.add('hide');
    extraClass && this.flashTarget.classList.add(extraClass);
  }

  deleteFlash() {
    this.handleHide('fast');
  }
}
