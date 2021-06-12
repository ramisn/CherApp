import { Controller } from 'stimulus';
import defaultAxios from 'axios';
import { initMap } from '../packs/maps_utils';
import { DEFAULT_CITY_NAME, DEFAULT_ESTATE } from '../packs/property_utils.js';

// Used this way due to google library not being imported until map is initialized
const MAP_CONTROL_POSITION_LEFT_BOTTOM = 6;

export default class extends Controller {
  static targets = ['searchInput', 'geoLocationCity', 'changeLocationButton', 'errorMessage']

  connect() {
    this.setup();
  }

  async setup() {
    this.map = await initMap('locationMapContainer', { zoomControl: true, zoomControlOptions: { position: MAP_CONTROL_POSITION_LEFT_BOTTOM } });
    this.geocoder = new google.maps.Geocoder();
  }

  processLocationResponse = (results) => {
    if (!results.length) return DEFAULT_CITY_NAME;

    const stateComponent = results[0].address_components.find((component) => (
      component.types.includes('administrative_area_level_1')
    ));
    const state = stateComponent ? stateComponent.long_name : 'Not defined';
    if (state !== DEFAULT_ESTATE) return DEFAULT_CITY_NAME;

    const cityComponent = results[0].address_components.find((component) => (
      component.types.includes('locality')
    ));

    return cityComponent ? cityComponent.long_name : DEFAULT_CITY_NAME;
  }

  async updateFormLocation(position) {
    const google_key = document.body.getAttribute('google_places_key');
    const latlng = `${position.coords.latitude},${position.coords.longitude}`;
    const params = { latlng, key: google_key };
    const noTokenAxiosInstance = defaultAxios.create();
    delete noTokenAxiosInstance.defaults.headers.common['X-CSRF-Token'];
    const deafultLocation = await noTokenAxiosInstance.get('https://maps.googleapis.com/maps/api/geocode/json', { params })
    .then((response) => {
      if (response.status === 200) return this.processLocationResponse(response.data.results);

      return DEFAULT_CITY_NAME;
    });

    this.searchInputTarget.value = deafultLocation;

    if (this.hasGeoLocationCityTarget) this.geoLocationCityTarget.innerHTML = deafultLocation;
  }

  setCity() {
    const city = this.searchInputTarget.value;

    this.geocoder.geocode({ address: city }, (results, status) => {
      if (status === 'OK') {
        const [result] = results;

        if (result.formatted_address && result.formatted_address.includes('USA')) {
          this.map.setCenter(result.geometry.location);
          this.setInUsa();
        } else {
          this.setOutUSA();
        }
      }
    });
  }

  setOutUSA() {
    this.changeLocationButtonTarget.disabled = true;
    this.setErrorMessage('The location is outside USA');
  }

  setInUsa() {
    this.changeLocationButtonTarget.disabled = false;
    this.setErrorMessage();
  }

  setErrorMessage(message) {
    this.errorMessageTarget.innerText = message || '';
  }
}
