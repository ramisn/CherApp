import { Controller } from 'stimulus';
import bulmaCollapsible from '@creativebulma/bulma-collapsible/src/js/index.js';

export default class extends Controller {
  static targets = ['messageContainer', 'container', 'arrow']

  connect = () => {
    this.bulmaContainer = new bulmaCollapsible(this.containerTarget);

    this.bulmaContainer.on('after:collapse', () => {
      if (this.hasMessageContainerTarget) {
        const newMessage = this.data.get('collapsed-message');
        if (this.messageContainerTargets) {
          this.messageContainerTargets.forEach((e) => { e.innerText = newMessage || 'Show more'; });
        } else {
          this.messageContainerTarget.innerText = newMessage || 'Show more';
        }
      }
    });
    this.bulmaContainer.on('after:expand', () => {
      if (this.hasMessageContainerTarget) {
        const newMessage = this.data.get('expanded-message');
        if (this.messageContainerTargets) {
          this.messageContainerTargets.forEach((e) => { e.innerText = newMessage || 'Show less'; });
        } else {
          this.messageContainerTarget.innerText = newMessage || 'Show less';
        }
      }
    });

    if (this.data.get('is-active')) setTimeout(() => this.toogleCollapsible(), 500);
  }

  toogleCollapsible() {
    if (this.containerTarget.classList.contains('is-active')) {
      this.bulmaContainer.collapse();
    } else {
      this.bulmaContainer.expand();
    }

    if (this.hasArrowTarget) {
      if (this.arrowTargets) {
        this.arrowTargets.forEach((e) => e.classList.toggle('is-down'));
      } else {
        this.arrowTarget.classList.toggle('is-down');
      }
    }
  }

  toggleStep(e) {
    e.preventDefault();
    e.stopImmediatePropagation();

    if (this.containerTarget.classList.contains('is-active')) {
      document.location = e.target.getAttribute('href');
    } else {
      this.bulmaContainer.expand();
    }
  }
}
