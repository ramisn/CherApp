import { Controller } from 'stimulus';
import { Loader } from 'google-maps';

export default class extends Controller {
  static targets = ['searchInput']

  connect() {
    const googleKey = document.body.getAttribute('google_key');
    this.loader = window.loader || new Loader(googleKey, { libraries: ['places'] });
    this.buildAutoCompleteInput();
  }

  buildAutoCompleteInput = async () => {
    const { type } = this.searchInputTarget.dataset;
    const autoCompleteOptions = {
      types: type ? [type] : [],
      componentRestrictions: { country: 'us' },
    };
    const google = await this.initGoogle();
    const autocompleteInput = new google.maps
                                        .places
                                        .Autocomplete(this.searchInputTarget, autoCompleteOptions);
    this.setAutocompleteInputListenners(autocompleteInput);
  }

  setAutocompleteInputListenners(autocompleteInput) {
    const { type } = this.searchInputTarget.dataset;
    document.addEventListener('DOMNodeInserted', (event) => {
      const { target } = event;
      if (target.classList && target.classList.contains('pac-item')) {
        // Since is not posible to request only cities name, we must replace the respose
        // to populate the list only with what we need
        target.innerHTML = target.innerHTML.replace(/.., USA<\/span>$/, '</span>');
      }
    });
    google.maps.event.addListener(autocompleteInput, 'place_changed', () => {
      const keyDownEvent = new KeyboardEvent('keydown', { key: 'Enter' });
      this.searchInputTarget.dispatchEvent(keyDownEvent);
      const place = autocompleteInput.getPlace();
      const submitInput = document.getElementById('searchPropertySubmitButton');
      if (submitInput) {
        submitInput.click();
      }
      // Edit the properties list returned from Google does not override data
      // then we need to override the input content when user select a city
      if (type === 'address' && place.formatted_address) {
        const newPlace = this.searchInputTarget.value;
        this.searchInputTarget.value = newPlace.replace(/, USA/, '');
      } else if (place.address_components) {
          const newPlace = this.searchInputTarget.value;
        this.searchInputTarget.value = newPlace.replace(/, .., USA/, '');
      }
    });
  }

  initGoogle = async () => window.google || this.loader.load();
}
