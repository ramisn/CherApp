import { Controller } from 'stimulus';
import { initMap } from '../packs/maps_utils';

export default class extends Controller{
  static targets = ['directionsInput', 'estimationTime']

  async connect() {
    this.property = JSON.parse(this.data.get('property'))
    this.map = await initMap('singlePropertyMapContainer');
    this.coords = this.property['geo']
    this.setupMap();
    this.setupAutoCompleteInput();
    this.trendsMap = await initMap('salesTrentMap', { controlSize: 16 });
    this.trendsMap.setCenter(this.property.geo);
    this.trendsMap.setZoom(14);
  }

  setupAutoCompleteInput() {
    const autoCompleteOptions = {
      types: ['address'],
      componentRestrictions: { country: 'us' },
    };
    this.autocompleteInput = new google.maps
                                        .places
                                        .Autocomplete(this.directionsInputTarget, autoCompleteOptions);
    this.setAutocompleteInputListenners();
  }

  setAutocompleteInputListenners() {
    google.maps.event.addListener(this.autocompleteInput, 'place_changed', () => {
      const place = this.autocompleteInput.getPlace();
      // Edit the properties list returned from Google does not override data
      // then we need to override the input content when user select a city
      
      if (!place) {
        this.estimationTimeTarget.classList.remove('is-hidden', 'has-text-primary');
        this.estimationTimeTarget.classList.add('is-danger');
        this.estimationTimeTarget.innerText = 'Please introduce a destination';
        return;
      }

      if (place.geometry) {
        this.setDirections(place.geometry.location)
      }
      if (place.address_components) {
        const newPlace = this.directionsInputTarget.value;
        this.directionsInputTarget.value = newPlace.replace(/, .., USA/, '');
      }
    });
  }

  setupMap() {
    this.directionsService = new google.maps.DirectionsService();
    this.directionsDisplay = new google.maps.DirectionsRenderer();
    this.marker = new google.maps.Marker({ position: this.property.geo, map: this.map });
    this.map.setCenter(this.property.geo);
    this.map.setZoom(16);
    this.directionsDisplay.setMap(this.map);
  }

  setDirections(endPoint) {
    const start = new google.maps.LatLng(this.coords['lat'], this.coords['lng']);
    const typeInput = document.querySelector('input[name="travel_mode"]:checked');
    this.marker.setMap(null);
    const request = {
      origin: start,
      destination: endPoint,
      travelMode: typeInput.value
    };
    this.directionsService.route(request, (response, status) => {
      if (status == 'OK') {
        this.directionsDisplay.setDirections(response);
        const duration = response.routes[0].legs[0].duration.text
        this.estimationTimeTarget.classList.remove('is-hidden', 'is-danger');
        this.estimationTimeTarget.classList.add('has-text-primary');
        this.estimationTimeTarget.innerText = `Estimated time: ${duration}`;
      }
    });
  }

  triggerSuggesterInput() {
    google.maps.event.trigger(this.autocompleteInput, 'place_changed');
  }
}
