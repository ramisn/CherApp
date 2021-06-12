import { Controller } from 'stimulus';

export default class extends Controller {
  static targets = ['requestMessage', 'phoneNumber']

  connect() {
    this.phoneNumberTarget.addEventListener('keydown', (event) => {
      const keyPressed = event.key;
      if (!keyPressed.match(/\d|Backspace|ArrowLeft|ArrowRight/)) {
        event.preventDefault();
        event.stopPropagation();
      }
    });
  }

  processResponse(response) {
    const [data, _status, _xhr] = response.detail;
    this.requestMessageTarget.innerHTML = data;
  }
}
