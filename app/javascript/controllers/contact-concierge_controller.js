import { Controller } from 'stimulus';

export default class extends Controller {
  static targets = ['infoTag']

  handleResponse() {
    this.infoTagTarget.innerText = 'Email sent. A Concierge agent will contact you soon.';
    this.infoTagTarget.classList.remove('is-hidden');
  }

  handleError() {
    this.infoTagTarget.innerText = 'Error sendind the email.';
    this.infoTagTarget.classList.remove('is-hidden', 'is-success');
    this.infoTagTarget.classList.add('is-warning');
  }
}
