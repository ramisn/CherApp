import { Controller } from 'stimulus';

export default class extends Controller {
  static targets = ['input']

  connect() {
    this.inputTargets.forEach((input) => {
      input.addEventListener('keydown', (event) => {
        if (['Backspace', 'ArrowLeft', 'ArrowRight'].includes(event.key)) {
          return;
        }
        const characterPresed = String.fromCharCode(event.keyCode);
        if (/\D/.test(characterPresed)) {
          event.preventDefault();
          event.stopPropagation();
        }
      });
    });
  }
}
