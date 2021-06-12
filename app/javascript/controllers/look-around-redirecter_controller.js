import { Controller } from 'stimulus';

export default class extends Controller{
  static targets = ['input']

  redirectUser() {
    const address = this.inputTarget.value;
    window.location = `/look-around?address=${address}`
  }
}
