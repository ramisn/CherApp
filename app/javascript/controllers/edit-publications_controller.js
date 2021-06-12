import { Controller } from 'stimulus';
import axios from '../packs/axios_utils.js';
import updateInpuntHeight from '../packs/input_utils.js';

export default class extends Controller {
  static targets = ['message', 'modalContent', 'modal'];

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

  setUpListeners() {
    this.messageTarget.addEventListener('keydown', () => {
      updateInpuntHeight(this.messageTarget);
    });
    this.messageTarget.addEventListener('paste', () => {
      updateInpuntHeight(this.messageTarget);
    });
  }

  triggerLastFileInput = (event) => {
    const inputsList = document.querySelectorAll('#imagesFieldsContainer input[type="file"]');
    const lastInput = inputsList[inputsList.length - 1];
    lastInput.click();
    event.preventDefault();
    event.stopPropagation();
  }

  attachImage = (event) => {
    const { files, id } = event.target;
    if (files[0]) {
      this.updateImagesContainer(files[0], id);
      const newInputId = Math.floor((Math.random()) * 0x10000);
      axios.get('/publications/new', { params: { input_id: newInputId } })
      .then((response) => {
        if (response.status === 200) {
          document.getElementById('imagesFieldsContainer').insertAdjacentHTML('beforeEnd', response.data);
        }
      });
    }
  }

  updateImagesContainer = (file, inputId) => {
    const reader = new FileReader();
    reader.addEventListener('load', () => {
      const image = this.buildImage(reader.result, inputId);
      document.getElementById('imagesContainer').insertAdjacentHTML('beforeEnd', image);
    }, false);
    reader.readAsDataURL(file);
  }

  buildImage = (src, inputId) => {
    const randomId = Math.floor((Math.random()) * 0x10000);
    return `<div class="image-container" id="imageContainer${randomId}" >`
    + `<img src="${src}" />`
    + `<button class="button is-delete" type="button" data-action="click->edit-publications#markItemForDestruction" data-image-id=${randomId} data-input-id="${inputId}">`
      + '<i class="fas fa-times" />'
    + '</button>'
    + '</div>';
  }

  markItemForDestruction = (event) => {
    const imageId = event.target.getAttribute('data-image-id');
    const inputId = event.target.getAttribute('data-input-id');
    const container = document.getElementById(`imageContainer${imageId}`);
    const deleteImageInput = document.getElementById(`deleteImageInput${imageId}`);


    if (inputId === 'firstImageInput') {
      document.getElementById('firstImageInput').value = '';
    } else if (inputId) {
      const fileInput = document.getElementById(inputId);
      fileInput.parentNode.removeChild(fileInput);
    } else {
      deleteImageInput.value = imageId;
    }
    //TODO CLICKING BUTTON X CLOSES MODAL
    container.parentNode.removeChild(container);
  }

  requestForm = (event) => {
    const publicationId = event.target.getAttribute('data-publication-id');
    axios.get(`/publications/${publicationId}/edit`)
    .then((response) => {
      if (response.status === 200) {
        document.getElementById('publicationEditModal').innerHTML = response.data;
        this.setUpListeners();
      }
    });
  }

  toggleModal = (event) => {
    this.modalTarget.classList.toggle('is-active');
    document.getElementsByTagName('html')[0].classList.toggle('is-clipped');
    event.stopPropagation();
  }
}
