import { Controller } from 'stimulus';

export default class extends Controller {
  static targets = ['container', 'modal']

  connect = () => {
    const contactProfessionalButtons = document.querySelectorAll('[data-action="contactProfessional"]');
    const contactInput = document.getElementById('contactProfessionalLink');
    if (contactInput) this.addTriggerListenner(contactInput);
    contactProfessionalButtons.forEach((button) => this.addTriggerListenner(button));
  }

  selectHome() {
    const containers = document.querySelectorAll('.property-preview');
    const { homeAddress } = this.containerTarget.dataset;
    document.getElementById('propertyAddressInput').value = homeAddress;
    containers.forEach((home) => home.classList.remove('is-selected'));
    this.containerTarget.classList.add('is-selected');
  }

  addTriggerListenner = (button) => {
    if (!button) return;

    button.addEventListener('click', (event) => {
      this.showModal(event);
    });
  }

  showModal = (event) => {
    event.preventDefault();
    event.stopPropagation();
    document.getElementsByTagName('html')[0].classList.add('is-clipped');
    document.getElementById('professionalContactModal').classList.add('is-active');
  }
}
