import { Controller } from 'stimulus';
import axios from '../packs/axios_utils.js';
import flaggedPropertiesOutline from '../../assets/images/cherapp-ownership-coborrowing-ico-favorite.svg';
import flaggedPropertiesWhite from '../../assets/images/cherapp-ownership-coborrowing-ico-favorite-white.svg';
import flaggedPropertiesPurple from '../../assets/images/cherapp-ownership-coborrowing-ico-favorite-active.svg';

export default class extends Controller {
  static targets = ['flagPropertyLink'];

  toggleflagProperty(e, startChat, cb) {
    const {
            propertyCity,
            propertyListingId,
            propertyFlagStatus,
            propertyPrice,
          } = this.flagPropertyLinkTarget.dataset;
    if (propertyFlagStatus === 'flagged' && !startChat) {
      this.unflagProperty(propertyListingId, cb);
    } else {
      this.flagProperty(propertyListingId, propertyCity, propertyPrice, cb);
    }
  }

  flagProperty(propertyId, propertyCity, propertyPrice, cb) {
    axios.post('/flagged_properties', { property_id: propertyId, city: propertyCity, price: propertyPrice })
    .then((response) => {
      if (cb) cb();

      this.toggleButtonClass('unflag', 'flag');
      this.toggleButtonStatus('flagged', response.data.property_id);
      this.toggleButtonMessage('flagged');
      this.toggleButtonStyle();
      this.toggleButtonIcon('flagged');
    }).catch((data) => {
      this.handleError(data.response);
    });
  }

  toggleButtonStyle() {
    const hasButtonStyle = !this.flagPropertyLinkTarget.classList.contains('has-no-style');
    if (hasButtonStyle) {
      this.flagPropertyLinkTarget.classList.toggle('is-primary');
      this.flagPropertyLinkTarget.classList.toggle('is-secondary');
    }
  }

  unflagProperty(propertyId, cb) {
    axios.delete(`/flagged_properties/${propertyId}`)
    .then(() => {
      this.toggleButtonClass('flag', 'unflag');
      this.toggleButtonStatus('unflagged', null);
      this.toggleButtonMessage('unflagged');
      this.toggleButtonStyle();
      this.toggleButtonIcon('unflagged');

      if (cb) cb();
    }).catch((data) => {
      this.handleError(data.response);
    });
  }

  toggleButtonClass(classToAdd, classToRemove) {
    this.flagPropertyLinkTarget.classList.add(classToAdd);
    this.flagPropertyLinkTarget.classList.remove(classToRemove);
  }

  toggleButtonStatus(status, propertyId) {
    this.flagPropertyLinkTarget.dataset.propertyId = propertyId;
    this.flagPropertyLinkTarget.dataset.propertyFlagStatus = status;
  }

  toggleButtonMessage(status) {
    if (!this.flagPropertyLinkTarget.children.length) { return; }
    const { isUserProfessional } = this.flagPropertyLinkTarget.dataset;

    let message = '';
    if (isUserProfessional) {
      message = status === 'flagged' ? 'Saved' : 'Save home';
    } else {
      message = status === 'flagged' ? 'Flagged' : 'Flag home';
    }
    this.flagPropertyLinkTarget.children[1].innerText = message;
  }

  handleError = (response) => {
    if (response.statusText && response.statusText === 'Unauthorized') {
      window.location = '/users/sign_in';
    }
  }

  toggleButtonIcon(status) {
    const hasButtonStyle = !this.flagPropertyLinkTarget.classList.contains('has-no-style');
    let newButtonIcon = null;
    if (status === 'flagged') {
      newButtonIcon = hasButtonStyle ? flaggedPropertiesOutline : flaggedPropertiesPurple;
    } else {
      newButtonIcon = hasButtonStyle ? flaggedPropertiesWhite : flaggedPropertiesOutline;
    }
    this.flagPropertyLinkTarget.children[0].src = newButtonIcon;
  }

  startChat(e) {
    const url = e.target.href;

    this.toggleflagProperty(e, true, () => {
      window.location.href = url;
    });

    return false;
  }
}
