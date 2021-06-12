import { Controller } from 'stimulus';

export default class extends Controller {
  static targets = ['dateInput']

  connect = () => {
    this.setupListenners();
  }

  setupListenners() {
    this.dateInputTarget.addEventListener('keyup', (event) => {
      if (this.doesInputNeedBacklash(event.key)) {
        this.dateInputTarget.value = `${this.dateInputTarget.value}/`;
      }
    });
    this.dateInputTarget.addEventListener('keydown', (event) => {
      if (!this.isKeyValid(event)) {
        event.preventDefault();
        event.stopPropagation();
      }
    });
  }

  isKeyValid = (event) => {
    if (['Backspace', 'ArrowLeft', 'ArrowRight'].includes(event.key)) return true;

    const characterPresed = String.fromCharCode(event.keyCode);
    return !/\D/.test(characterPresed);
  }

  doesInputNeedBacklash = (key) => this.dateInputTarget.value.length === 2 && key !== 'Backspace';
}
