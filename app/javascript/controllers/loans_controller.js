import { Controller } from 'stimulus';
import axios from '../packs/axios_utils.js';
import { formatMoney } from '../packs/home_utils.js';

export default class extends Controller {
  static targets = [
                    'addressInput', 'propertyImage', 'propertyCard',
                    'propertyPrice', 'propertyAddress', 'propertyAddress2',
                    'inputContainer', 'addressNextStepButton', 'priceSlider',
                    'propertyIdInput', 'lookArroundLink', 'foundHomeNextButton',
                    'propertyPriceInput', 'propertyLink', 'propertyTypeInput',
                    'propertyZipcodeInput', 'propertyCountyInput', 'propertyStreetInput',
                    'propertyCityInput', 'propertyStateInput'
                    ]

  connect() {
    this.addressInputTarget.addEventListener('keydown', (event) => {
      this.cleanSelection();
      if (event.key === 'Enter') {
        event.stopPropagation();
        event.preventDefault();
        this.searchProperty();
      }
    });
    this.propertyPriceInputTarget.addEventListener('change', () => {
      this.updateSlider(this.propertyPriceInputTarget.value);
    });
  }

  updateSlider(propertyPrice) {
    // home-price-slider listen to event and update animation
    const changeEvent = new Event('input', { bubbles: true, cancelable: false });
    this.priceSliderTarget.value = this.getSliderPrice(propertyPrice);
    this.priceSliderTarget.dispatchEvent(changeEvent);
  }

  updateIcon = (event) => {
    const { disableImage, enableImage } = event.target.dataset;
    JSON.parse(disableImage).forEach((image) => {
      document.getElementById(image).classList.add('is-hidden');
    });
    JSON.parse(enableImage).forEach((image) => {
      document.getElementById(image).classList.remove('is-hidden');
    });
  }

  toggleModal = (event) => {
    const inviteFriendModal = document.getElementById('addFriendModal');
    event.stopPropagation();
    inviteFriendModal.classList.toggle('is-active');
    document.getElementsByTagName('html')[0].classList.toggle('is-clipped');
  }

  searchProperty() {
    this.inputContainerTarget.classList.add('is-loading');
    const address = this.sanitizedAddress();
    axios.get(`/properties/${address}`, { params: { address } })
    .then((response) => {
      if (response.status === 200) {
        const propertyData = response.data.property_data;
        this.updatePropertyCard(propertyData);
        this.removeLoader();
      }
    })
    .catch((event) => {
      this.cleanSelection();
    });
  }

  removeLoader() {
    this.propertyCardTarget.classList.remove('is-hidden');
    this.inputContainerTarget.classList.remove('is-loading');
  }

  cleanSelection() {
    this.inputContainerTarget.classList.remove('is-loading');
    this.propertyCardTarget.classList.add('is-hidden');
    this.propertyPriceInputTarget.value = null;
    this.propertyTypeInputTarget.value = null;
    this.propertyZipcodeInputTarget.value = null;
    this.propertyCountyInputTarget.value = null;
    this.propertyStreetInputTarget.value = null;
    this.propertyCityInputTarget.value = null;
    this.propertyStateInputTarget.value = null;
    const selectedFlaggedProperty = document.querySelector('.property-preview.is-selected')
    if (selectedFlaggedProperty) {
      selectedFlaggedProperty.classList.remove('is-selected');
    }
  }

  updatePropertyCard(propertyData) {
    const propertyPicture = propertyData.photos[0];
    this.propertyIdInputTarget.value = propertyData.listingId;
    this.propertyImageTarget.setAttribute('src', propertyPicture.replace('http', 'https'));
    this.propertyAddressTarget.innerText = propertyData.address.full;
    this.propertyAddress2Target.innerText = `${propertyData.address.city}, ${propertyData.address.state}`;
    this.propertyPriceTarget.innerText = formatMoney(propertyData.listPrice);
    this.propertyZipcodeInputTarget.value = propertyData.address.postalCode;
    this.propertyTypeInputTarget.value = propertyData.type;
    this.propertyCountyInputTarget.value = propertyData.address.county;
    this.propertyStreetInputTarget.value = propertyData.address.full;
    this.propertyCityInputTarget.value = propertyData.address.city;
    this.propertyStateInputTarget.value = propertyData.address.state;

    this.updateSlider(propertyData.listPrice)
    const propertyLink = this.propertyLinkTarget.getAttribute('href')
    this.propertyLinkTarget.setAttribute('href', propertyLink.replace('property_id', propertyData.listingId));

    const selectedFlaggedProperty = document.querySelector('.property-preview.is-selected')
    if (selectedFlaggedProperty) {
      selectedFlaggedProperty.classList.remove('is-selected');
    }
  }

  updatelookAroundLink(event) {
    if (event.target.value === 'true') {
      this.lookArroundLinkTarget.classList.add('is-hidden');
      this.foundHomeNextButtonTarget.classList.remove('is-hidden');
    } else {
      this.lookArroundLinkTarget.classList.remove('is-hidden');
      this.foundHomeNextButtonTarget.classList.add('is-hidden');
    }
  }

  getSliderPrice = (propertyPrice) => ((30 * propertyPrice) / 3000000);

  sanitizedAddress() {
    return this.addressInputTarget.value.split(',')[0];
  };
}
