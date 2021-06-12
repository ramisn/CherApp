import { Controller } from 'stimulus';
import { default as background } from '../animations/background.json';
import { default as fullHouse } from '../animations/full.json';
import {
         formatMoney,
         annualIncomeWithFriends,
       } from '../packs/home_utils.js';

const houseSegments = [0, 30, 60, 90, 120];

export default class extends Controller {
  static targets = ['homePrice', 'animationSlider', 'amountWithoutCher',
                    'amountWithCher', 'numberOfFriends', 'defaultPriceList',
                    'fullAnimation', 'background', 'solidPersonIcon', 'personIcon'];

  connect = () => {
    if (this.hasFullAnimationTarget) {
      this.animator = bodymovin.loadAnimation({
          container: this.fullAnimationTarget,
          loop: false,
          renderer: 'svg',
          autoplay: false,
          animationData: fullHouse,
      });
      this.animation = bodymovin.loadAnimation({
        container: this.backgroundTarget,
        loop: true,
        renderer: 'svg',
        autoplay: true,
        animationData: background,
      });
      this.animator.playSegments([0, 30], true);
    }
    this.previousSegment = 0;
    this.homePrice = this.hasDefaultPriceListTarget ? this.defaultPriceListTarget.value : 200000;
    this.activeIconId = 4;
    if (this.homePriceIsInput()) {
      this.updateAnimation();
    } else if (this.hasDefaultPriceListTarget) {
      this.updateMonthlyMortgage();
    }
  }

  disconnect() {
    this.animation?.destroy();
    this.animator?.destroy();
  }

  updateAnimation() {
    const selectedValue = this.animationSliderTarget.value;
    const homePrice = Math.round(parseFloat(selectedValue) * 100000);
    const currentStep = this.determineCurrentStep(selectedValue);
    const currentSegment = houseSegments[currentStep];
    if (this.hasHomePriceTarget && this.homePriceIsInput()) {
      this.homePriceTarget.value = formatMoney(homePrice);
    } else if (this.hasHomePriceTarget) {
      this.homePriceTarget.innerHTML = formatMoney(homePrice);
    }
    if (this.animator) this.animator.playSegments([this.previousSegment, currentSegment], true);
    this.previousSegment = currentSegment;
    this.homePrice = homePrice;
    this.updateMonthlyMortgage();
    this.updateSliderStyle();
  }

  updateMonthlyMortgage() {
    const numberOfFriends = this.numberOfFriendsTarget.value;
    if (this.hasAmountWithoutCherTarget) {
      this.amountWithoutCherTarget.innerHTML = annualIncomeWithFriends(this.homePrice, 1);
    }
    this.amountWithCherTarget.innerHTML = annualIncomeWithFriends(this.homePrice, numberOfFriends);
    this.updateFriendsSliderStyle();
  }

  updateSelectedIcon() {
    this.solidPersonIconTargets.forEach((icon) => {
      icon.classList.add('is-hidden');
    });
    const numberOfFriends = this.numberOfFriendsTarget.value;
    const solidIcon = this.solidPersonIconTargets[numberOfFriends - 1];
    let regularIcon = this.personIconTargets[numberOfFriends - 1];
    regularIcon.classList.add('is-hidden');
    solidIcon.classList.remove('is-hidden');
    if (this.activeIconId) {
      regularIcon = this.personIconTargets[this.activeIconId - 1];
      regularIcon.classList.remove('is-hidden');
      this.activeIconId = numberOfFriends;
    }
  }

  updateSlider(event) {
    const sliderValue = event.target.getAttribute('data-slider-value');
    this.numberOfFriendsTarget.value = sliderValue;
    this.updateSelectedIcon();
    this.updateMonthlyMortgage();
  }

  determineCurrentStep = (selectedValue) => {
    let currentStep = 0;
    if (selectedValue < 5) {
      currentStep = 1;
    } else if (selectedValue < 10) {
      currentStep = 2;
    } else if (selectedValue < 15) {
      currentStep = 3;
    } else {
      currentStep = 4;
    }
    return currentStep;
  }

  homePriceIsInput() {
    return this.hasHomePriceTarget && this.homePriceTarget instanceof HTMLInputElement;
  }

  updateFriendsSliderStyle() {
    const { value } = this.numberOfFriendsTarget;
    const percentage = (value - 1) * 33;
    const color = `background: linear-gradient(90deg, #1600ff ${percentage}%, #eee ${percentage}%);`;

    this.numberOfFriendsTarget.style.cssText = color;
  }

  updateSliderStyle() {
    const { value } = this.animationSliderTarget;
    const percentage = (value - 2) * 3.57;
    const color = `background: linear-gradient(90deg, #1600ff ${percentage}%, #eee ${percentage}%);`;

    this.animationSliderTarget.style.cssText = color;
  }
}
