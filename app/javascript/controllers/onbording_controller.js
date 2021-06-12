import defaultAxios from 'axios';
import { Controller } from 'stimulus';
import { initMap } from '../packs/maps_utils.js';
import axios from '../packs/axios_utils.js';
import { DEFAULT_ESTATE } from '../packs/property_utils.js';

const DEFAULT_CITY_NAME = 'Santa Monica';
const LEFT_BOTTOM = 6;

export default class extends Controller {
  static targets = [
                      'onbording', 'searchInput', 'userId', 'geoLocationCity',
                      'userCity', 'changeLocationButton', 'errorMessage', 'startButton',
                    ]

  myCity = ''

  citySelected = null;

  async connect() {
    this.map = await initMap('locationMapContainer', { zoomControl: true, zoomControlOptions: { position: LEFT_BOTTOM } });
    this.geocoder = new google.maps.Geocoder();
    this.getLocation();
  }

  getLocation() {
    if (navigator.geolocation) {
      navigator.geolocation.getCurrentPosition(
        this.updateFormLocation.bind(this), this.handleNoLocation
      );
    } else {
      this.handleNoLocation();
    }
  }

  handleNoLocation = () => {
    this.startButtonTarget.disabled = true;
  }

  processLocationResponse = (results) => {
    if (!results.length) return DEFAULT_CITY_NAME;

    const stateComponent = results[0].address_components.find((component) => (
      component.types.includes('administrative_area_level_1')
    ));
    const state = stateComponent ? stateComponent.long_name : 'Not defined';
    if (state === DEFAULT_ESTATE) this.myCity = DEFAULT_ESTATE;
    if (state !== DEFAULT_ESTATE) return DEFAULT_CITY_NAME;

    const cityComponent = results[0].address_components.find((component) => (
      component.types.includes('locality')
    ));

    return cityComponent ? cityComponent.long_name : DEFAULT_CITY_NAME;
  }

  async updateFormLocation(position) {
    const googleKey = document.body.getAttribute('google_places_key');
    const latlng = `${position.coords.latitude},${position.coords.longitude}`;
    const params = { latlng, key: googleKey };
    const noTokenAxiosInstance = defaultAxios.create();
    delete noTokenAxiosInstance.defaults.headers.common['X-CSRF-Token'];
    const defaultLocation = await noTokenAxiosInstance.get('https://maps.googleapis.com/maps/api/geocode/json', { params })
      .then((response) => (
        (response.status === 200) && this.processLocationResponse(response.data.results)
      ));

    this.searchInputTarget.value = defaultLocation;
    this.geoLocationCityTarget.innerHTML = defaultLocation;
  }

  setCity(cb) {
    this.getCity((results) => {
      const [result] = results;
      const inUsa = result.formatted_address && (result.formatted_address.includes('EE. UU.') || result.formatted_address.includes('USA'));
      this.citySelected = result;

      if (inUsa) {
        this.map.setCenter(result.geometry.location);
        this.setInUsa();
      } else {
        this.setOutUSA();
      }

      if (typeof cb === 'function') cb();
    }, () => this.setinvalidLocation());
  }

  setOutUSA() {
    this.changeLocationButtonTarget.disabled = true;
    this.startButtonTarget.disabled = true;
    this.setErrorMessage('The location is outside USA');
  }

  setinvalidLocation() {
    this.changeLocationButtonTarget.disabled = true;
    this.startButtonTarget.disabled = true;
    this.setErrorMessage('Invalid location');
  }

  setInUsa() {
    this.changeLocationButtonTarget.disabled = false;
    this.startButtonTarget.disabled = false;
    this.setErrorMessage('');
  }

  setErrorMessage(message) {
    this.errorMessageTarget.innerText = message || '';
  }

  saveUserCity() {
    this.setCity(() => {
      const searchValue = this.getCityName();
      const trackShareASale = this.myCity === DEFAULT_ESTATE || searchValue.includes(DEFAULT_ESTATE);
      const city = searchValue || DEFAULT_CITY_NAME;
      const userId = this.userIdTarget.value;

      const params = {
        user: {
          city,
          skip_onbording: true,
          track_share_a_sale: trackShareASale,
        },
      };

      axios.put(`/users/${userId}`, params).then(() => {
        window.location.href = '/look-around';
      });
    });

  }

  getCity = (success, fail) => {
    const input = this.searchInputTarget.value;

    this.geocoder.geocode({ address: input }, (results, status) => {
      if (status === 'OK') {
        success(results);
      } else if (fail) {
        fail();
      }
    });
  }

  getCityName = () => {
    const city = this.citySelected.address_components.find((obj) => obj.types[0] === 'locality');
    return city.long_name;
  }
}
