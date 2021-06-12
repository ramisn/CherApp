import { Controller } from 'stimulus';
import updateInpuntHeight from '../packs/input_utils.js';

export default class extends Controller {
  static targets = ['message', 'fileName']

  connect() {
    this.messageTarget.addEventListener('keydown', () => {
      updateInpuntHeight(this.messageTarget);
    });
    this.messageTarget.addEventListener('paste', () => {
      updateInpuntHeight(this.messageTarget);
    });
  }

  updateFileTag = (event) => {
    const fileInput = event.target;
    if (fileInput.files.length) {
      this.fileNameTarget.textContent = fileInput.files[0].name;
    }
  }
}
