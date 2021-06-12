import { Controller } from 'stimulus';

export default class extends Controller {
  static targets = ['propertyAddress', 'shareItemLink', 'propertyLink',
                    'modal', 'facebookLink', 'twitterLink', 'linkedInLink']

  connect() {
    this.baseUrl = this.propertyLinkTarget.value.replace('property_id', '')
    this.facebookBaseUrl = 'https://www.facebook.com/sharer/sharer.php?u=';
    this.twitterBaseUrl = 'https://twitter.com/share?url=';
    this.linkedInBaseUrl = 'https://www.linkedin.com/shareArticle?url=';
  }

  updatePropertyModalData(event) {
    event.stopPropagation();
    event.preventDefault();
    const target = event.target.nodeName == 'BUTTON' ? event.target : event.target.parentNode
    const { propertyId, propertyAddress } = target.dataset;
    this.propertyAddressTarget.value = propertyAddress;
    this.propertyLinkTarget.value = `${this.baseUrl}${propertyId}`;
    this.facebookLinkTarget.setAttribute('href',  `${this.facebookBaseUrl}${this.baseUrl}${propertyId}`);
    this.twitterLinkTarget.setAttribute('href',  `${this.twitterBaseUrl}${this.baseUrl}${propertyId}`);
    this.linkedInLinkTarget.setAttribute('href',  `${this.linkedInBaseUrl}${this.baseUrl}${propertyId}`);
    this.showModal();
  }

  showModal() {
    this.modalTarget.classList.add('is-active');
    document.getElementsByTagName('html')[0].classList.toggle('is-clipped');
  }
}
