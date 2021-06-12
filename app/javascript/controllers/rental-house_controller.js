import { Controller } from 'stimulus';
import bulmaCollapsible from '@creativebulma/bulma-collapsible/src/js/index.js';

export default class extends Controller {
  static targets = ['petsContainer']

  connect() {
    this.bulmaContainer = new bulmaCollapsible(this.petsContainerTarget);
  }

  togglePetsOptions() {
    if (this.petsContainerTarget.classList.contains('is-active')) {
      this.bulmaContainer.collapse();
    } else {
      this.bulmaContainer.expand();
    }
  }
}
