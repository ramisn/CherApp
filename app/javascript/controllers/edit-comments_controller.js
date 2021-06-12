import { Controller } from 'stimulus';
import axios from '../packs/axios_utils.js';

export default class extends Controller {
  static targets = ['modal', 'formContainer']

  requestForm = (event) => {
    const { postEditForm } = event.target.dataset;
    axios.get(postEditForm)
    .then((response) => {
      if (response.status === 200) {
        this.formContainerTarget.innerHTML = response.data;
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
