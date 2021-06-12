import { Controller } from 'stimulus';

export default class extends Controller {
  static targets = ['roadStepsContainer', 'howToSellContainer', 'roadStepsButton', 'howToSellButton', 'buyTitleMobile',
                    'sellTitleMobile', 'roadStepsButtonMobile', 'howToSellButtonMobile'];

  showRoadStepsContainer() {
    this.showRoadsContainerSteps();
    this.roadStepsButtonTarget.classList.add('has-text-main-body');
    this.roadStepsButtonTarget.classList.remove('has-text-coborrower-blue');
    this.howToSellButtonTarget.classList.add('has-text-coborrower-blue');
    this.howToSellButtonTarget.classList.remove('has-text-main-body');
  }

  showHowToSellContainer() {
    this.showHowToSellContainerSteps();
    this.howToSellButtonTarget.classList.add('has-text-main-body');
    this.howToSellButtonTarget.classList.remove('has-text-coborrower-blue');
    this.roadStepsButtonTarget.classList.add('has-text-coborrower-blue');
    this.roadStepsButtonTarget.classList.remove('has-text-main-body');
  }

  showHowToSellContainerMobile() {
    this.showHowToSellContainer();
    this.buyTitleMobileTarget.classList.add('is-hidden');
    this.sellTitleMobileTarget.classList.remove('is-hidden');
    this.roadStepsButtonMobileTarget.classList.add('is-hidden');
    this.howToSellButtonMobileTarget.classList.remove('is-hidden');
    document.getElementById('listHomeDescription').classList.remove('is-hidden');
  }

  showRoadStepsContainerMobile() {
    this.showRoadsContainerSteps();
    this.buyTitleMobileTarget.classList.remove('is-hidden');
    this.sellTitleMobileTarget.classList.add('is-hidden');
    this.roadStepsButtonMobileTarget.classList.remove('is-hidden');
    this.howToSellButtonMobileTarget.classList.add('is-hidden');
    document.getElementById('dreamHomeDescription').classList.remove('is-hidden');
  }

  showRoadsContainerSteps() {
    this.howToSellContainerTarget.classList.add('is-hidden');
    this.roadStepsContainerTarget.classList.remove('is-hidden');
  }

  showHowToSellContainerSteps() {
    this.roadStepsContainerTarget.classList.add('is-hidden');
    this.howToSellContainerTarget.classList.remove('is-hidden');
  }

  showMobileDescription(e) {
    const { descriptionId } = e.target.dataset;
    console.log(descriptionId);
    if (descriptionId) {
      this.hideAllMobileDescriptions();
      document.getElementById(descriptionId).classList.remove('is-hidden');
    }
  }

  hideAllMobileDescriptions = () => {
    Array.from(document.getElementsByClassName('mobile-description')).forEach((element) => {
      element.classList.add('is-hidden');
    });
  }
}
