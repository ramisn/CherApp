import { Controller } from 'stimulus';

const EMAILREGEX = /^(([^<>()\[\]\.,;:\s@\"]+(\.[^<>()\[\]\.,;:\s@\"]+)*)|(\".+\"))@(([^<>()[\]\.,;:\s@\"]+\.)+[^<>()[\]\.,;:\s@\"]{2,})$/i;

export default class extends Controller{
  static targets = ['input', 'modal']

  connect() {
    this.inputTarget.addEventListener('keydown', (event) => {
      if (event.key === 'Enter') {
        event.preventDefault();
        event.stopPropagation();
      }
    });
  }

  validateEmail(event) {
    if (this.isEmailValid()) {
      event.preventDefault();
      event.stopPropagation();
      this.inputTarget.classList.remove('is-danger');
      this.modalTarget.classList.toggle('is-active');
      document.getElementsByTagName('html')[0].classList.toggle('is-clipped');
    } else {
      this.inputTarget.classList.add('is-danger');
    }
  }

  isEmailValid() {
    const email = this.inputTarget.value;
    return EMAILREGEX.test(email)
  }
}
