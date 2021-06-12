import { Controller } from 'stimulus';
import axios from '../packs/axios_utils.js';

export default class extends Controller {
  static targets = ['fundingValue']

  initialize() {
    this.userFunding = this.fundingValueTarget.getAttribute('data-funding');
  }

  updateFund(event) {
    const coBorrowers = event.target.value;
    const newFunding = this.userFunding * coBorrowers;
    this.fundingValueTarget.innerHTML = `$${newFunding.toLocaleString()}`;
    this.updateUserProfile(coBorrowers);
  }

  updateUserProfile(coBorrowers) {
    const userId = this.fundingValueTarget.getAttribute('data-user');
    axios.put(`/profile/${userId}`, { user: { co_borrowers: coBorrowers } });
  }
}
