import { Controller } from 'stimulus';

export default class extends Controller {

  connect = () => {
    this.data.currentStep = this.data.get('active');
  }

  nextItem(event) {
    const currentStepContainer = document.getElementById(this.data.currentStep);
    const nextItemContainer = document.getElementById(event.target.dataset.nextItem);
    currentStepContainer.classList.add('is-hidden');
    nextItemContainer.classList.remove('is-hidden');
    this.data.currentStep = event.target.dataset.nextItem;
  }

  previousItem(event) {
    const currentStepContainer = document.getElementById(this.data.currentStep);
    const previousItemContainer = document.getElementById(event.target.dataset.previousItem);
    currentStepContainer.classList.add('is-hidden');
    previousItemContainer.classList.remove('is-hidden');
    this.data.currentStep = event.target.dataset.previousItem;
  }
}
