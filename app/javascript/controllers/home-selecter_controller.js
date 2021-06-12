import { Controller } from 'stimulus';
import axios from '../packs/axios_utils.js';

export default class extends Controller {
  static targets = ['container', 'propertyPrice', 'contactButton']

  initialize = () => {
    const contactProfessionalButtons = document.querySelectorAll('[data-action="contactProfessional"]');
    contactProfessionalButtons.forEach((button) => {
      button.addEventListener('click', (event) => {
        event.stopPropagation();
        document.getElementsByTagName('html')[0].classList.add('is-clipped');
        document.getElementById('professionalContactModal').classList.add('is-active');
      });
    });
  }

  selectHome() {
    const containers = document.querySelectorAll('.property-preview');
    const { homeAddress, homeArea } = this.containerTarget.dataset;

    const propertyAddressInput = document.getElementById('propertyAddressInput');
    const propertyAreaInput = document.getElementById('propertyAreaInput');

    if (propertyAddressInput) propertyAddressInput.value = homeAddress;
    if (propertyAreaInput) propertyAreaInput.value = homeArea;

    containers.forEach((home) => home.classList.remove('is-selected'));
    this.containerTarget.classList.add('is-selected');
    const propertyPriceInput = document.getElementById('propertyPriceInput');
    if (propertyPriceInput) {
      // loans_controller listen to input event and update slider based on property price
      const changeEvent = new Event('change', { bubbles: true, cancelable: false });
      const {
              propertyPrice, propertyType,
              propertyCounty, propertyStreet,
              propertyState, propertyCity,
              propertyZipcode,
            } = this.containerTarget.dataset;

      document.getElementById('propertyStreetInput').value = propertyStreet;
      document.getElementById('propertyZipcodeInput').value = propertyZipcode;
      document.getElementById('propertyCountyInput').value = propertyCounty;
      document.getElementById('propertyTypeInput').value = propertyType;
      document.getElementById('propertyCityInput').value = propertyCity;
      document.getElementById('propertyStateInput').value = propertyState;

      propertyPriceInput.value = propertyPrice;
      propertyPriceInput.dispatchEvent(changeEvent);
    }
  }

  requestProfessionalContant() {
    const address = document.getElementById('propertyAddressInput').value;
    const area = document.getElementById('propertyAreaInput').value;
    const name = document.getElementById('userName').value;
    const phoneNumber = document.getElementById('userPhoneNumber').value;
    const phoneNumberInfo = document.getElementById('userPhoneNumberLabel');

    phoneNumberInfo.classList.add('is-hidden');

    if (!phoneNumber) {
      phoneNumberInfo.classList.remove('is-hidden');
      phoneNumberInfo.innerText = 'Provide a phone number please';
      return;
    }

    this.contactButtonTarget.disabled = true;
    this.contactButtonTarget.classList.add('is-loading');

    axios.post('/professional_contact', { professional_contact: { address, name, area, phone_number: phoneNumber } })
    .then((response) => {
      if (response.status === 200) {
        this.contactButtonTarget.classList.disabled = false;
        this.contactButtonTarget.innerText = 'Waiting for a professional';
        this.contactButtonTarget.classList.remove('is-loading');
      }
    });
  }
}
