import { Controller } from 'stimulus';

export default class extends Controller {
  connect = () => {
    window.addEventListener('resize', () => {
      this.updateVhVar();
    });
    this.updateVhVar();
  }

  updateVhVar = () => {
    const vh = window.innerHeight * 0.01;
    document.documentElement.style.setProperty('--vh', `${vh}px`);
  }
}
