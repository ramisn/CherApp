import { Controller } from 'stimulus';
import { loadStripe } from '@stripe/stripe-js';
import axios from '../packs/axios_utils.js';

export default class extends Controller {
  static targets = ['submitButton', 'errorsContainer', 'buttonContinue', 'inputContainer', 'sucessMessage', 'formContainer']

  async initialize() {
    const stripePK = document.querySelector('body').getAttribute('stripe_key');
    this.stripe = await loadStripe(stripePK);
    this.setupElements();
  }

  setupElements = () => {
    const elements = this.stripe.elements({
      fonts: [{
        cssSrc: 'https://fonts.googleapis.com/css?family=Karla:400,400i,700,700i&display=swap',
      }],
    });
    const expiricyStyle = {
      style: {
        base: {
          color: 'rgb(84, 84, 84)',
          fontSize: '16px',
          fontWeight: '400',
          fontFamily: 'Karla',
          '::placeholder': {
            fontWeight: '100',
            fontSize: '16px',
            color: '#9CAFC8',
            fontStyle: 'italic',
          },
        },
      },
    };

    const cvcStyle = {
      style: {
        base: {
          color: 'rgb(84, 84, 84)',
          fontSize: '16px',
          fontWeight: '400',
          fontFamily: 'Karla',
          '::placeholder': {
            fontWeight: '100',
            fontSize: '16px',
            color: '#9CAFC8',
            fontStyle: 'italic',
          },
        },
      },
      placeholder: '',
    };

    const numberStyle = {
      style: {
        base: {
          color: 'rgb(84, 84, 84)',
          fontSize: '16px',
          fontWeight: '400',
          fontFamily: 'Karla',
          '::placeholder': {
            fontWeight: '400',
            fontSize: '16px',
            color: '#9CAFC8',
            fontStyle: 'italic',
          },
        },
      },
      placeholder: 'Type your card number',
    };

    this.cardNumber = elements.create('cardNumber', numberStyle);
    this.cardCvc = elements.create('cardCvc', cvcStyle);
    this.cardExpiry = elements.create('cardExpiry', expiricyStyle);
    this.cardNumber.mount('#card-number');
    this.cardCvc.mount('#card-cvc');
    this.cardExpiry.mount('#card-expiry');
  };

  handleSubmit(event) {
    event.preventDefault();
    this.changeLoadingState(true);
    const firstNameInput = document.getElementById('firstName');
    const lastNameInput = document.getElementById('lastName');
    const emailInput = document.getElementById('email');
    const name = `${firstNameInput.value} ${lastNameInput.value}`;

    // Refactor these conditionals into separated function
    if (firstNameInput.value.trim()) {
      if (firstNameInput.value) firstNameInput.classList.remove('is-danger');
    } else {
      if (!firstNameInput.value) firstNameInput.classList.add('is-danger');
      this.changeLoadingState(false);
      return;
    }

    if (lastNameInput.value.trim()) {
      if (lastNameInput.value) lastNameInput.classList.remove('is-danger');
    } else {
      if (!lastNameInput.value) lastNameInput.classList.add('is-danger');
      this.changeLoadingState(false);
      return;
    }

    if (emailInput) {
      if (emailInput.value.trim()) {
        if (emailInput.value) emailInput.classList.remove('is-danger');
      } else {
        if (!emailInput.value) emailInput.classList.add('is-danger');
        this.changeLoadingState(false);
        return;
      }
    }

    this.stripe.createPaymentMethod({
      type: 'card',
      card: this.cardNumber,
      billing_details: {
        name,
      },
    }).then(this.stripePaymentMethodHandler);
  }

  stripePaymentMethodHandler = (result) => {
    if (result.error) {
      this.showError(result.error.message);
    } else {
      const firstName = document.getElementById('firstName').value;
      const lastName = document.getElementById('lastName').value;
      const emailInput = document.getElementById('email');

      const coupon = document.getElementById('couponDiscountInput').value;
      const planType = this.submitButtonTarget.getAttribute('plan-type');

      const params = { payment_method_id: result.paymentMethod.id, plan_type: planType, coupon };
      if (emailInput) {
        params.email = emailInput.value;
        params.first_name = firstName;
        params.last_name = lastName;
      }

      axios.post('/customer/payments', params)
      .then((response) => {
        this.handleServerResponse(response.data);
      });
    }
  }

  handleServerResponse = (response) => {
    if (response.error) {
      this.showError(response.error);
    } else if (response.requires_action) {
      this.stripe.confirmCardPayment(response.payment_intent_client_secret)
      .then((result) => {
        this.handleStripeJsResult(result);
      });
    } else {
      this.orderComplete(response.payment_intent_id, response.message);
    }
  }

  handleStripeJsResult = (result) => {
    if (result.error) {
      this.showError(result.error);
    } else if (result.paymentIntent.status === 'succeeded') {
      this.orderComplete(result.paymentIntent.id, 'Payment succeeded');
    }
  }

  orderComplete = (paymentIntentId, message) => {
    this.buttonContinueTarget.setAttribute('href', `/customer/payments/${paymentIntentId}`);
    this.inputContainerTargets.forEach((container) => {
      container.classList.add('is-hidden');
    });
    this.submitButtonTarget.classList.add('is-hidden');
    this.buttonContinueTarget.classList.remove('is-hidden');
    this.sucessMessageTarget.innerHTML = message;
    this.formContainerTarget.classList.add('is-hidden');
  }

  showError = (errorMsgText) => {
    this.changeLoadingState(false);
    this.errorsContainerTarget.textContent = errorMsgText;
  };

  changeLoadingState = (isLoading) => {
    this.submitButtonTarget.disabled = isLoading;
  };
}
