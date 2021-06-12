import { Controller } from 'stimulus';
import axios from '../packs/axios_utils';

export default class extends Controller {
  static targets = ['input']

  connect() {
    this.requestPlacesAround(this.inputTarget.dataset.type);
  }

  requestPlacesAround(placeType) {
    const propertyLat = document.getElementById('propertyLat').value;
    const propertyLng = document.getElementById('propertyLng').value;

    axios.get('/places-around', { params: { type: placeType, latitude: propertyLat, longitude: propertyLng } })
    .then((response) => {
      if (response.status === 200) {
        const placeText = this.inputTarget.textContent;
        if (response.data === 0) {
          this.inputTarget.parentNode.removeChild(this.inputTarget);
        } else {
          const numberOfPlaces = response.data === 20 ? '20+' : response.data;
          this.inputTarget.textContent = placeText.replace('0', numberOfPlaces);
        }
      }
    });
  }
}
