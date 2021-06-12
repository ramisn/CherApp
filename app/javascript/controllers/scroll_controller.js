import { Controller } from 'stimulus';

export default class extends Controller {
  static targets = ['trigger'];

  moveToItem() {
    const { targetId, scrollTop, behavior } = this.triggerTarget.dataset;
    const target = document.getElementById(targetId);
    target.scrollIntoView({ block: scrollTop, behavior });
  }
}
