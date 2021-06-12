import { Controller } from 'stimulus';
import { Loader } from 'google-maps';

export default class extends Controller{
  static targets = ['placeContainer', 'placeImage', 'placePhoneNumber', 'placeReviews']

  connect() {
    this.isElementComplex = this.data.get('is-element-complex')
    const google_key = document.body.getAttribute('google_key');
    this.loader = window.loader || new Loader(google_key, { libraries: ['places'] });
    this.loader.load()
    .then((google) => {
      this.getPlacesData(google);
    })
  }

  getPlacesData(google) {
    const service = new google.maps.places.PlacesService(this.placeContainerTarget);
    const placeId = this.data.get('place-id');
    const request = {
      placeId,
      fields: ['user_ratings_total', 'formatted_phone_number', 'photos']
    };
    service.getDetails(request, (placeDetails) => { this.updateCardData(placeDetails) });
  }

  updateCardData(placeDetails) {
    this.placePhoneNumberTarget.innerText = placeDetails.formatted_phone_number;
    if(this.isElementComplex){
      const rating = placeDetails.user_ratings_total ? `(${placeDetails.user_ratings_total})` : '';
      const firstPhotoUrl = placeDetails.photos[0].getUrl({maxHeight: 400});
      this.placeImageTarget.setAttribute('src', firstPhotoUrl);
      this.placeImageTarget.parentNode.classList.remove('is-loading');
      this.placeReviewsTarget.innerText = rating;
    }
  }
}
