import { Controller } from 'stimulus';
import updateInpuntHeight from '../packs/input_utils.js';

export default class extends Controller {
  static targets = ['messageInput', 'form'];

  connect() {
    this.messageInputTarget.addEventListener('keydown', (event) => {
      updateInpuntHeight(this.messageInputTarget);
      if (event.key === 'Enter' && this.messageInputTarget.value.length) {
        event.preventDefault();
        event.stopPropagation();
        this.formTarget.submit();
        this.messageInputTarget.setAttribute('disabled', 'diasbled');
      }
    });
    this.messageInputTarget.addEventListener('paste', () => {
      updateInpuntHeight(this.messageInputTarget);
    });
  }
}
