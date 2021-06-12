import { Controller } from 'stimulus';
import axios from '../packs/axios_utils.js';

export default class extends Controller {
  static targets = ['uploaderButton', 'image', 'imageContainer']

  connect() {
    this.imageTarget.addEventListener('load', () => {
      this.imageContainerTarget.classList.remove('is-loading');
      this.imageTarget.classList.remove('is-hidden');
    });
    this.userId = this.uploaderButtonTarget.dataset.userId;
  }

  triggerInput() {
    this.uploaderButtonTarget.click();
  }

  updateImage() {
    const image = this.uploaderButtonTarget.files[0];
    const imageSize = image.size / 1024;
    if (imageSize > 10240) {
      alert("Only images less than 10MB are permited");
    } else {
      const formData = new FormData();
      this.imageContainerTarget.classList.add('is-loading');
      this.imageTarget.classList.add('is-hidden');
      formData.append('user[image_stored]', image);
      axios.patch(`/profile/${this.userId}`, formData, { headers: { 'Content-Type': image.type } })
      .then((response) => {
        if (response.status === 200) {
          const profileImage = response.data.profile_image;
          this.imageTarget.setAttribute('src', profileImage);
        }
      });
    }
  }
}
