import { Controller } from 'stimulus';

export default class extends Controller {
  static targets = ['switch', 'minPrice', 'maxPrice', 'priceTitle', 'monthlyTitle', 'helperMinPrice', 'helperMaxPrice']

  isShowingFullPrice = true

  toggle(e) {
    e.preventDefault();
    e.stopPropagation();

    if (this.isShowingFullPrice) {
      this.priceTitleTarget.classList.add('is-lighter-blue', 'has-text-weight-normal');
      this.monthlyTitleTarget.classList.remove('is-lighter-blue', 'has-text-weight-normal');
    } else {
      this.priceTitleTarget.classList.remove('is-lighter-blue', 'has-text-weight-normal');
      this.monthlyTitleTarget.classList.add('is-lighter-blue', 'has-text-weight-normal');
    }

    this.isShowingFullPrice = !this.isShowingFullPrice;
    this.handleChangeToRental();
    this.exchangeOptions();
  }

  handleChangeToRental() {
    const rentalStatusElement = document.getElementById('search_rental_status');
    const activeStatusElement = document.getElementById('search_active_status');

    if (rentalStatusElement) rentalStatusElement.checked = !this.isShowingFullPrice;
    if (activeStatusElement) activeStatusElement.checked = this.isShowingFullPrice;
  }

  exchangeOptions() {
    const minPrices = this.minPriceTarget.innerHTML;
    const maxPrices = this.maxPriceTarget.innerHTML;

    this.minPriceTarget.innerHTML = this.helperMinPriceTarget.innerHTML;
    this.maxPriceTarget.innerHTML = this.helperMaxPriceTarget.innerHTML;

    this.helperMinPriceTarget.innerHTML = minPrices;
    this.helperMaxPriceTarget.innerHTML = maxPrices;
  }
}
