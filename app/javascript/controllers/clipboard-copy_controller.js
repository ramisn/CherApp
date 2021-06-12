import { Controller } from 'stimulus';

export default class extends Controller {
  static targets = ['input', 'trigger']

  copyLink() {
    this.triggerTarget.innerHTML = 'Link copied!';
    this.inputTarget.select();
    document.execCommand('copy');
    this.inputTarget.setSelectionRange(0, 99999);
  }
}
