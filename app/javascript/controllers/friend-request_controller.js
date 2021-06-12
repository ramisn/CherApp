import { Controller } from 'stimulus';
import axios from '../packs/axios_utils.js';

export default class extends Controller {
    static targets = ['buttonAction']

    sendRequest() {
      const { userId } = this.buttonActionTarget.dataset;
      this.buttonActionTarget.disabled = true;
      axios.post('/friend_requests', { friend_request: { requestee_id: userId, status: 'pending' } })
      .then((response) => {
        if (response.status === 201) {
          this.buttonActionTarget.innerText = 'Pending';
        }
      });
    }
}
