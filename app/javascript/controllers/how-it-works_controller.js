import { Controller } from 'stimulus';

export default class extends Controller {
  static targets = ['reasonImage', 'reasonButton', 'reasonDescription', 'processButton', 'processImage', 'whyDescription'];

  togglePart(e) {
    const { reasonNumber } = e.target.dataset;

    this.hideTargets(this.reasonImageTargets);
    this.showTargets(this.reasonImageTargets, reasonNumber);

    this.hideTargets(this.reasonDescriptionTargets);
    this.showTargets(this.reasonDescriptionTargets, reasonNumber);
    this.outlineButtons();
    e.currentTarget.classList.remove('is-outlined');
  }

  toggleProcess(e) {
    e.preventDefault();
    const { stepNumber } = e.currentTarget.dataset;

    this.hideTargets(this.processImageTargets);
    this.showTargets(this.processImageTargets, stepNumber);
    this.deactivateButtons();
    e.currentTarget.classList.add('is-active');
  }

  toggleWhy(e) {
    e.preventDefault();
    const { whyNumber } = e.currentTarget.dataset;

    this.hideTargets(this.whyDescriptionTargets);
    this.showTargets(this.whyDescriptionTargets, whyNumber);
    this.deactivateButtons();
    e.currentTarget.classList.add('is-active');
  }

  hideTargets = (targets) => targets.forEach((e) => e.classList.add('is-hidden'));

  showTargets = (targets, number) => targets[number - 1].classList.remove('is-hidden');

  outlineButtons = () => this.reasonButtonTargets.forEach((e) => e.classList.add('is-outlined'));

  deactivateButtons = () => this.processButtonTargets.forEach((e) => e.classList.remove('is-active'));
}
