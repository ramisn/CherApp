import { Controller } from 'stimulus';

export default class extends Controller {
  static targets = ['form'];

  connect = () => {
    window.captchaCallback = this.handleCaptcahCompleted;
  }

  handleSubmit = (event) => {
    const environment = document.querySelector('body').getAttribute('data-environment');
    if (!this.successCode && environment !== 'test') {
      event.preventDefault();
      event.stopPropagation();
    }
  }

  handleCaptcahCompleted = (response) => {
    this.successCode = response;
  }
}
