import { Controller } from 'stimulus';
import axios from '../packs/axios_utils.js';

export default class extends Controller {
  static targets = ['modalImage', 'container', 'modalContent', 'modal'];

  connect() {
    this.modalImageTarget.addEventListener('load', () => {
      this.containerTarget.classList.remove('is-loading');
      this.modalImageTarget.classList.remove('is-hidden');
    });
    document.addEventListener('click', (event) => {
      const isClickInside = this.modalContentTarget.contains(event.target);
      const isModalActive = this.modalTarget.classList.contains('is-active');
      if (!isClickInside && isModalActive) {
        this.modalTarget.classList.toggle('is-active');
        document.getElementsByTagName('html')[0].classList.toggle('is-clipped');
      }
    });
    this.imagesList = [];
  }

  updateModalImage(event) {
    this.nextImage = event.target.getAttribute('data-next-image');
    this.previousImage = event.target.getAttribute('data-previous-image');
    this.publicationId = event.target.getAttribute('data-publication-id');
    this.currentImage = event.target.getAttribute('data-image-id');
    this.requestImageSrc(this.currentImage);
  }

  nextItem() {
    if (this.nextImage) {
      this.previousImage = this.currentImage;
      this.currentImage = this.nextImage;
      this.nextImage = document.getElementById(`image_${this.currentImage}`).getAttribute('data-next-image');
      this.requestImageSrc(this.currentImage);
    }
  }

  previousItem() {
    if (this.previousImage) {
      this.nextImage = this.currentImage;
      this.currentImage = this.previousImage;
      this.previousImage = document.getElementById(`image_${this.previousImage}`).getAttribute('data-previous-image');
      this.requestImageSrc(this.currentImage);
    }
  }

  requestImageSrc(imageId) {
    this.modalImageTarget.classList.add('is-hidden');
    this.containerTarget.classList.add('is-loading');
    axios.get(`/publications/${this.publicationId}/images/${imageId}`)
    .then((response) => {
      if (response.status === 200) {
        const imageSrc = response.data.image_url;
        this.modalImageTarget.setAttribute('src', imageSrc);
      }
    });
  }

  toggleModal = (event) => {
    this.modalTarget.classList.toggle('is-active');
    document.getElementsByTagName('html')[0].classList.toggle('is-clipped');
    event.stopPropagation();
  }
}
