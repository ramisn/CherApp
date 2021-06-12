import { Controller } from 'stimulus';
import axios from '../packs/axios_utils.js';

export default class extends Controller {
  static targets = [
    'couponInput', 'paymentValue', 'hiddenCouponValue',
    'label', 'succesMessage', 'inputWrapper', 'notifier',
    'errorMessage',
  ]

  applyCoupon() {
    const couponId = this.couponInputTarget.value;
    if (!couponId.length) return;

    axios.get(`/customer/coupons/${couponId}`)
    .then((response) => {
      if (response.status === 200) {
        this.removeErrorMessage();
        this.couponInputTarget.classList.remove('is-danger');
        this.couponInputTarget.classList.add('is-success');
        this.couponInputTarget.disabled = true;
        if (response.data.amount_off) {
          this.updatePaymentValue(response.data.amount_off, response.data.id);
        }
      }
    })
    .catch(() => {
      this.showErrorMessage();
    });
  }

  updatePaymentValue = (amountOff, id) => {
    const discountAmount = (amountOff / 100);
    const currentValue = document.getElementById('paymentValueInput').value;
    const newPrice = currentValue - discountAmount;
    document.getElementById('paymentValueText').innerText = `$${newPrice}`;

    this.labelTarget.innerText = 'Congratulations!';
    this.succesMessageTarget.classList.remove('is-hidden');
    this.inputWrapperTarget.classList.add('is-hidden');
    document.getElementById('couponDiscountInput').value = id;
  }

  showErrorMessage = () => {
    this.errorMessageTarget.classList.remove('is-hidden');
    this.notifierTarget.classList.add('is-hidden');
    this.inputWrapperTarget.classList.add('is-danger');
  }

  removeErrorMessage = () => {
    this.errorMessageTarget.classList.add('is-hidden');
    this.notifierTarget.classList.remove('is-hidden');
    this.inputWrapperTarget.classList.remove('is-danger');
  }
}
