import { Controller } from 'stimulus';

export default class extends Controller {
  static targets = ['twitterUrl', 'facebookUrl', 'linkedInUrl', 'shareLink', 'modalContent', 'modal'];

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

  toggleModal = (event) => {
    this.modalTarget.classList.toggle('is-active');
    document.getElementsByTagName('html')[0].classList.toggle('is-clipped');
    event.stopPropagation();
  }

  updateModalLinks(event) {
    const { publicationUrl } = event.target.dataset;
    this.twitterUrlTarget.setAttribute('href', `https://twitter.com/share?url=${publicationUrl}`);
    this.facebookUrlTarget.setAttribute('href', `https://www.facebook.com/sharer/sharer.php?u=${publicationUrl}`);
    this.linkedInUrlTarget.setAttribute('href', `https://www.linkedin.com/shareArticle?url=${publicationUrl}`);
    this.shareLinkTarget.value = publicationUrl;
  }
}
