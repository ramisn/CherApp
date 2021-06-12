import { Controller } from 'stimulus';

export default class extends Controller {
  setPreviews = (event) => {
    const imageContainer = document.getElementById('houseImagesContainer');
    imageContainer.innerHTML = '';
    const { files } = event.target;
    if (files) {
      [].forEach.call(files, this.buildImages);
    }
  }

  buildImages = (file) => {
    const imageContainer = document.getElementById('houseImagesContainer');
    const reader = new FileReader();
    reader.addEventListener('load', () => {
      const image = `<img src="${reader.result}" class="image is-96x96 has-regular-margin"/>`;
      imageContainer.insertAdjacentHTML('beforeEnd', image);
    });
    reader.readAsDataURL(file);
  }
}
