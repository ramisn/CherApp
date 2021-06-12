import { Controller } from 'stimulus';

export default class extends Controller {
  static targets = ['modal', 'modalContent']

  connect() {
    document.addEventListener('click', (event) => {
      const isClickInside = this.modalContentTarget.contains(event.target);
      const isModalActive = this.modalTarget.classList.contains('is-active');
      if (!isClickInside && isModalActive) {
        this.modalTarget.classList.toggle('is-active');
        document.getElementsByTagName('html')[0].classList.toggle('is-clipped');
      }
    });
  }

  toggleModal(event) {
    this.modalTarget.classList.toggle('is-active');
    document.getElementsByTagName('html')[0].classList.toggle('is-clipped');
    event.stopPropagation();
    event.preventDefault();
  }
}
