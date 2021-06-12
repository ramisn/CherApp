import { Controller } from 'stimulus';

export default class extends Controller {
  static targets = ['socialLink', 'formLink']

  updatePropertyUrl(event) {
    const propertyUrl = event.target.dataset.url;
    this.formLinkTarget.value = propertyUrl;
    this.socialLinkTargets.forEach((link) => {
      const genericShareLink = link.getAttribute('href');
      const propertyShareLink = genericShareLink.replace('propertyUrl', propertyUrl);
      link.setAttribute('href', propertyShareLink);
    });
  }
}
