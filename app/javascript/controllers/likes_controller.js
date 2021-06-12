import { Controller } from 'stimulus';
import axios from '../packs/axios_utils.js';

export default class extends Controller {
  static targets = ['likeButton', 'buttonContent']

  connect() {
    this.likesNumber = parseInt(this.likeButtonTarget.dataset.likesNumber, 10);
    this.likeId = this.likeButtonTarget.dataset.likeId;
    this.isLikedByUser = this.likeButtonTarget.dataset.isLikedByUser;
    this.publicationId = this.likeButtonTarget.dataset.publicationId;
    this.dataType = this.likeButtonTarget.dataset.type;
  }

  updateLike() {
    this.likeButtonTarget.classList.add('is-disbaled');
    if (this.isLikedByUser) {
      axios.delete(`/${this.dataType}/${this.publicationId}/likes/${this.likeId}`)
      .then((response) => {
        if (response.status === 200) {
          this.updateButtonStatus('is-tag-primary', 'is-tag-secondary', -1, false, this.likeId);
        }
      });
    } else {
      axios.post(`/${this.dataType}/${this.publicationId}/likes`)
      .then((response) => {
        if (response.status === 200) {
          const { like } = response.data;
          this.updateButtonStatus('is-tag-secondary', 'is-tag-primary', 1, true, like.id);
        }
      });
    }
  }

  updateButtonStatus(oldClass, newClass, likesDiference, likedByUser, likeId) {
    this.likesNumber += likesDiference;
    this.buttonContentTarget.innerText = this.likesNumber;
    this.likeButtonTarget.classList.remove(oldClass);
    this.likeButtonTarget.classList.add(newClass);
    this.likeButtonTarget.classList.remove('is-disbaled');
    this.isLikedByUser = likedByUser;
    this.likeId = likeId;
    if (this.likesNumber) {
      this.buttonContentTarget.innerText = this.likesNumber;
    } else {
      this.buttonContentTarget.innerText = 'Like';
    }
  }
}
