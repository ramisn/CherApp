import { Controller } from 'stimulus';
import defaultAxios from 'axios';
import axios from '../packs/axios_utils.js';

import { initMap, buildMarker, fetchPeopleThatSearchTheSameCity } from '../packs/maps_utils.js';
import {
          sanitizedPropertyAddress,
          DEFAULT_CITY_NAME,
          DEFAULT_VENDOR,
          AVAILABLE_VENDORS,
          DEFAULT_ESTATE,
        } from '../packs/property_utils.js';
import {
          getShapeProperties,
          POLYGON_DEFAULT_OPTIONS,
          getPointString,
          capitalizeFirstLetter,
        } from '../packs/shape_utils.js';

export default class extends Controller {
  static targets = ['propertiesContainer', 'cityNameInput', 'lookMap',
                    'formSubmit', 'requestResponse', 'inputMinPrice',
                    'inputMaxPrice', 'rangePriceButton',
                    'rangeRoomButton', 'propertiesMinBeds',
                    'homeTypesButton', 'textInput', 'water',
                    'exteriorFeatures', 'moreFiltersButton', 'unactivePropertyStatusInput',
                    'searchAliasInput', 'savedSearches', 'saveSearchMessage', 'saveSearchContainer',
                    'nextBatchButton', 'numberOfResults', 'shapeDataInput', 'shapeNameInput',
                    'myShapesContainer', 'newShapeToolsContainer', 'searchPolygon', 'shapeModal',
                    'errorShapeMessage', 'selectShapeInput', 'userId', 'trackShareASale'
                   ]

  async connect() {
    await this.initializeMap();
    this.setupInputsListener();
    this.getLocation();
    this.initiateSearch();
    this.initiateDrawingTools();
    this.data.markers = [];
    this.data.activeInfoWindow = null;
    this.data.shape = null;
    this.data.defaultNextBatchLink = '';
    this.data.availableVendors = AVAILABLE_VENDORS.filter((vendor) => vendor !== DEFAULT_VENDOR);
    this.data.printedProperties = [];
    this.user_city_name = document.getElementById('user_city').value || DEFAULT_CITY_NAME;

    setTimeout(this.stopTracking(), 1500);
  }

  stopTracking() {
    if (this.trackShareASaleTarget.value) {
      const userId = this.userIdTarget.value;
      const params = {
        user: {
          track_share_a_sale: false
        },
      };
      axios.put(`/users/${userId}`, params);
    }
  }

  initiateDrawingTools() {
    this.data.drawingManagerDisplayed = true;
    this.data.drawingManager = new google.maps.drawing.DrawingManager({
      drawingMode: null,
      drawingControl: false,
      drawingControlOptions: {
        position: google.maps.ControlPosition.TOP_CENTER,
        drawingModes: [
          google.maps.drawing.OverlayType.CIRCLE,
          google.maps.drawing.OverlayType.POLYGON,
          google.maps.drawing.OverlayType.RECTANGLE,
        ],
      },
      circleOptions: {
        ...POLYGON_DEFAULT_OPTIONS,
      },
      polygonOptions: {
        ...POLYGON_DEFAULT_OPTIONS,
      },
      rectangleOptions: {
        ...POLYGON_DEFAULT_OPTIONS,
      },
    });

    this.data.drawingManager.setMap(this.data.map);

    google.maps.event.addListener(this.data.drawingManager, 'overlaycomplete', this.setCurrentShape.bind(this));
    google.maps.event.addListener(this.data.drawingManager, 'drawingmode_changed', this.removeMarkers.bind(this));
    google.maps.event.addListener(this.data.drawingManager, 'drawingmode_changed', () => {
      this.data.shape_id = null;
    });
  }

  toggleDrawingTools() {
    this.data.drawingManager.setOptions({
      drawingControl: !this.data.drawingManagerDisplayed,
    });

    this.data.drawingManagerDisplayed = !this.data.drawingManagerDisplayed;
  }

  setCurrentShape(e) {
    this.removeShape();
    this.data.shape = e.overlay;
    this.data.shape_type = e.type;

    this.setShapePropertiesOnInput();
    this.data.drawingManager.setOptions({ drawingMode: null });
    this.setShapeEvents();

    this.formSubmitTarget.click();
  }

  setShapeEvents() {
    google.maps.event.addListener(this.data.shape, 'dragend', this.setShapePropertiesOnInput.bind(this));
    google.maps.event.addListener(this.data.shape, 'set_at', this.setShapePropertiesOnInput.bind(this));

    if (this.data.shape_type === 'polygon') {
      this.data.shape.getPaths().forEach((path) => {
        google.maps.event.addListener(path, 'insert_at', this.setShapePropertiesOnInput.bind(this));
        google.maps.event.addListener(path, 'set_at', this.setShapePropertiesOnInput.bind(this));
        google.maps.event.addListener(path, 'remove_at', this.setShapePropertiesOnInput.bind(this));
      });
    } else if (this.data.shape_type === 'rectangle') {
      google.maps.event.addListener(this.data.shape, 'bounds_changed', this.setShapePropertiesOnInput.bind(this));
    } else {
      google.maps.event.addListener(this.data.shape, 'radius_changed', this.setShapePropertiesOnInput.bind(this));
      google.maps.event.addListener(this.data.shape, 'center_changed', this.setShapePropertiesOnInput.bind(this));
    }
  }

  cleanShape() {
    this.removeShape();
    this.removeMarkers();
    this.cleanShapePropertyInput();
  }

  drawUserShape(e) {
    const { shapeRadius, shapeType, shapeId } = e.target.options[e.target.selectedIndex].dataset;
    const shapeCoordinates = e.target.value;

    this.cleanShape();

    if (shapeId) {
      this.data.shape_id = shapeId;
      this[`draw${shapeType}Polygon`]({ shapeCoordinates: JSON.parse(shapeCoordinates), shapeRadius: parseFloat(shapeRadius) });
      this.setShapePropertiesOnInput();
      this.setShapeEvents();
    }

    this.formSubmitTarget.click();
  }

  drawRectanglePolygon({ shapeCoordinates }) {
    const bounds = {
      north: shapeCoordinates[1].lat,
      south: shapeCoordinates[0].lat,
      east: shapeCoordinates[3].lng,
      west: shapeCoordinates[2].lng,
    };

    this.data.shape_type = 'rectangle';
    this.data.shape = new google.maps.Rectangle({
      ...POLYGON_DEFAULT_OPTIONS,
      bounds,
    });

    this.data.shape.setMap(this.data.map);
  }

  drawCirclePolygon({ shapeCoordinates, shapeRadius }) {
    const [center] = shapeCoordinates;

    this.data.shape_type = 'circle';
    this.data.shape = new google.maps.Circle({
      ...POLYGON_DEFAULT_OPTIONS,
      center,
      radius: shapeRadius || 500,
    });

    this.data.shape.setMap(this.data.map);
  }

  drawPolygonPolygon({ shapeCoordinates }) {
    this.data.shape_type = 'polygon';
    this.data.shape = new google.maps.Polygon({
      paths: shapeCoordinates,
      ...POLYGON_DEFAULT_OPTIONS,
    });

    this.data.shape.setMap(this.data.map);
  }

  savePolygon() {
    if (!this.data.shape_type) {
      this.errorShapeMessageTarget.classList.remove('is-hidden');
      this.errorShapeMessageTarget.innerText = 'Shape drawn not valid.';

      return;
    }

    const shapeProperties = getShapeProperties(this.data.shape_type, this.data.shape);
    const shapeName = this.shapeNameInputTarget.value;

    const params = {
      shape_type: this.data.shape_type,
      ...shapeProperties,
    };

    if (shapeName) params.name = shapeName;

    if (this.data.shape_id) axios.put(`/shapes/${this.data.shape_id}`, { shape: params });
    else {
      axios.post('/shapes', { shape: params }).then(({ data }) => {
        this.data.shape_id = data.id;
        this.errorShapeMessageTarget.classList.add('is-hidden');
        this.toggleShapeModal();
        this.setShapeOnSelect(data);
      }).catch(() => {
        this.errorShapeMessageTarget.classList.remove('is-hidden');
        this.errorShapeMessageTarget.innerText = 'Enter a name for your shape';
      });
    }
  }

  deletePolygon() {
    if (this.data.shape_id) {
      axios.delete(`/shapes/${this.data.shape_id}`).then(() => {
        this.data.shape_id = null;
        this.removeFromSelect();
      });
    }

    this.cleanShape();
  }

  setShapePropertiesOnInput() {
    const shapeProperties = getShapeProperties(this.data.shape_type, this.data.shape);

    this.shapeDataInputTarget.value = getPointString(shapeProperties);
    this.cityNameInputTarget.required = false;
  }

  setShapeOnSelect(shapeData) {
    const option = new Option(shapeData.name, JSON.stringify(shapeData.coordinates), true, true);

    if (shapeData.shape_type === 'circle') option.value = JSON.stringify(shapeData.center);
    option.dataset.shapeType = capitalizeFirstLetter(shapeData.shape_type);
    option.dataset.shapeRadius = shapeData.radius;
    option.dataset.shapeId = shapeData.id;

    this.selectShapeInputTarget.options.add(option);
    this.updateSavedShapesCount();
  }

  updateSavedShapesCount() {
    this.selectShapeInputTarget.options[0].text = `Saved Shapes ${this.selectShapeInputTarget.options.length - 1}`;
  }

  removeFromSelect() {
    this.selectShapeInputTarget.options.remove(this.selectShapeInputTarget.selectedIndex);
    this.updateSavedShapesCount();
  }

  cleanShapePropertyInput() {
    this.shapeDataInputTarget.value = '';
    this.cityNameInputTarget.required = true;
  }

  setDrawingMode(e) {
    const { drawingMode } = e.currentTarget.dataset;
    const googleDrawingMode = google.maps.drawing.OverlayType[drawingMode.toUpperCase()];

    this.data.drawingManager.setDrawingMode(googleDrawingMode);
  }

  searchPolygon() {
    this.formSubmitTarget.click();
  }

  changeMapView(e) {
    this.data.map.setMapTypeId(e.target.value);
  }

  removeShape() {
    if (this.data.shape) {
      this.data.shape.setMap(null);
      this.data.shape = null;
    }
  }

  toggleDrawingActions() {
    this.myShapesContainerTarget.classList.toggle('is-hidden');
    this.newShapeToolsContainerTarget.classList.toggle('is-hidden');
  }

  toggleShapeModal() {
    this.shapeModalTarget.classList.toggle('is-hidden');
    this.errorShapeMessageTarget.innerText = '';
    this.errorShapeMessageTarget.classList.add('is-hidden');
  }

  initiateSearch() {
    if (this.cityNameInputTarget.value) {
      const clickEvent = new Event('click');
      this.formSubmitTarget.click();
      this.formSubmitTarget.dispatchEvent(clickEvent);
      this.mapOnLoading();
    }
  }

  getLocation() {
    if (navigator.geolocation) {
      navigator.geolocation.getCurrentPosition(this.updateFormLocation.bind(this));
    } else {
      this.cityNameInputTarget.value = this.user_city_name;
      this.formSubmitTarget.click();
    }
  }

  async updateFormLocation(position) {
    const googleKey = document.body.getAttribute('google_places_key');
    const latlng = `${position.coords.latitude},${position.coords.longitude}`;
    const params = { latlng, key: googleKey };
    const noTokenAxiosInstance = defaultAxios.create();
    delete noTokenAxiosInstance.defaults.headers.common['X-CSRF-Token'];
    const deafultLocation = await noTokenAxiosInstance.get('https://maps.googleapis.com/maps/api/geocode/json', { params })
    .then((response) => {
      if (response.status !== 200) return DEFAULT_CITY_NAME;

      return this.processLocationResponse(response.data.results);
    });
    this.cityNameInputTarget.value = deafultLocation;
    this.formSubmitTarget.click();
  }

  processLocationResponse = (results) => {
    if (!results.length) return this.user_city_name;

    const stateComponent = results[0].address_components.find((component) => (
      component.types.includes('administrative_area_level_1')
    ));
    const state = stateComponent ? stateComponent.long_name : 'Not defined';
    if (state !== DEFAULT_ESTATE) return this.user_city_name;

    const cityComponent = results[0].address_components.find((component) => (
      component.types.includes('locality')
    ));
    return cityComponent ? cityComponent.long_name : this.user_city_name;
  }

  setupInputsListener() {
    // For some reason hiting Enter inside input make two requests
    this.cityNameInputTarget.addEventListener('keydown', (event) => {
      if (event.key !== 'Enter') return;

      event.preventDefault();
      event.stopPropagation();
      this.formSubmitTarget.click();
    });
    this.cityNameInputTarget.addEventListener('focus', () => {
      this.cityNameInputTarget.value = '';
    });
    this.textInputTargets.forEach((input) => {
      input.addEventListener('change', () => {
        this.moreFiltersButtonTarget.classList.add('is-completed');
      });
    });
    this.waterTarget.addEventListener('change', () => {
      this.moreFiltersButtonTarget.classList.add('is-completed');
    });
  }

  async initializeMap() {
    this.data.map = await initMap('lookAroundMap');
    const featureProperties = JSON.parse(this.data.get('feature-properties'));
    const featurePropertiesIds = JSON.parse(this.data.get('flagged-feature-properties'));
  }

  mapOnLoading() {
    this.lookMapTarget.classList.add('loading');
  }

  processPropertiesResponse(response) {
    this.mapOnLoading();
    const [data, _status, xhr] = response.detail;
    const lookingFor = this.cityNameInputTarget.value;
    const { properties, notice } = data;
    if (xhr.status === 200 && properties.length) {
      this.populatePropertiesContainer(data.html);
      this.removeMarkers();
      const flaggedPropertiesIds = data.flagged_properties_ids;
      this.data.markers = buildMarker(properties, flaggedPropertiesIds, this.data.map);
      fetchPeopleThatSearchTheSameCity(lookingFor, properties[0].listingId);
      this.defineDefaultNextBatchLink();
    }
    this.requestResponseTarget.innerHTML = notice;
    this.lookMapTarget.classList.remove('loading');
  }

  appendPrintedProperties(properties) {
    properties.forEach((property) => {
      const propertyAddress = sanitizedPropertyAddress(property);
      const alreadyPrinted = this.data.printedProperties.includes(propertyAddress);
      if (alreadyPrinted) {
        document.getElementById(`property${property.listingId}`).classList.add('is-hidden');
      } else {
        this.data.printedProperties.push(propertyAddress);
      }
    });
  }

  removeMarkers() {
    this.data.markers.forEach((marker) => {
      marker.setMap(null);
    });
    this.data.markers = [];
  }

  populatePropertiesContainer(propertiesContainerHtml) {
    this.propertiesContainerTarget.innerHTML = propertiesContainerHtml;
    setTimeout(() => ReactRailsUJS.mountComponents(), 1000);
  }

  fetchWatchedProperties = (propertyId) => {
    setTimeout(() => {
      const watchedPropertyContainer = document.querySelector(`[data-property-id="${propertyId}"].engaged-people`);
      if (watchedPropertyContainer) {
        axios.get(`/engaged_people?property_id=${propertyId}`)
        .then((response) => {
          watchedPropertyContainer.innerHTML = response.data;
        });
      }
    }, 500);
  }

  updateMinBeds(event) {
    const clickedValue = event.target.value;
    const minBeds = clickedValue.replace('null', 'Any');
    const { minBaths } = this.propertiesMinBedsTarget.dataset;
    this.propertiesMinBedsTarget.setAttribute('data-min-beds', minBeds);
    this.updateBedBathsButton(minBeds, minBaths);
  }

  updateMinBaths(event) {
    const clickedValue = event.target.value;
    const minBaths = clickedValue.replace('null', 'Any');
    const { minBeds } = this.propertiesMinBedsTarget.dataset;
    this.propertiesMinBedsTarget.setAttribute('data-min-baths', minBaths);
    this.updateBedBathsButton(minBeds, minBaths);
  }

  updateBedBathsButton(minBeds, minBaths) {
    const buttonRangeText = `${minBeds}+ BD, ${minBaths}+ BA`;
    this.rangeRoomButtonTarget.innerText = buttonRangeText.replaceAll('Any+', 'Any');
    this.rangeRoomButtonTarget.classList.add('is-completed');
  }

  updatePriceRange() {
    const selectedMaxPriceIndex = this.inputMaxPriceTarget.selectedIndex;
    const maxPrice = this.inputMaxPriceTarget.options[selectedMaxPriceIndex].text;
    const selectedMinPriceIndex = this.inputMinPriceTarget.selectedIndex;
    const minPrice = this.inputMinPriceTarget.options[selectedMinPriceIndex].text;
    this.rangePriceButtonTarget.innerText = `${minPrice} - ${maxPrice}`;
  }

  completeHomeTypes(event) {
   if (event.target.value) {
     this.homeTypesButtonTarget.classList.add('is-completed');
   }
  }

  updateHomeTypes(event) {
    const isRentType = event.target.checked;
    if (isRentType) {
      this.inputMinPriceTarget.selectedIndex = '0';
    } else {
      this.inputMinPriceTarget.selectedIndex = '3';
    }
    this.updatePriceRange();
  }

  resetMoreFilters(event) {
    event.stopPropagation();
    event.preventDefault();
    this.textInputTargets.forEach((input) => { input.value = null; });
    this.waterTarget.checked = false;
    this.moreFiltersButtonTarget.classList.remove('is-completed');
  }

  updateExteriorFeatures(event) {
    this.exteriorFeaturesTarget.value = event.target.value;
  }

  toggleHoverContainer = () => {
    const hoverContainers = document.querySelectorAll('.hover-container');
    hoverContainers.forEach((container) => {
      container.classList.add('is-hidden');
      setTimeout(() => {
        container.classList.remove('is-hidden');
      }, 1000);
    });
  }

  updateMaxPrice() {
    const { selectedIndex } = this.inputMinPriceTarget;
    const selectedMinPrice = this.inputMinPriceTarget.options[selectedIndex].value;
    if (selectedMinPrice) {
      Array.from(this.inputMaxPriceTarget.options).forEach((currentOption) => {
        const isOptionValueOk = Number(currentOption.value) > Number(selectedMinPrice);
        if (currentOption.value && isOptionValueOk) {
          currentOption.classList.remove('is-hidden');
        } else if (currentOption.value) {
          currentOption.classList.add('is-hidden');
        }
      });
    } else {
      this.displayInputAllOptions(this.inputMaxPriceTarget);
    }
    this.updatePriceRange();
  }

  updateMinPrice() {
    const { selectedIndex } = this.inputMaxPriceTarget;
    const selectedMaxPrice = this.inputMaxPriceTarget.options[selectedIndex].value;
    if (selectedMaxPrice) {
      Array.from(this.inputMinPriceTarget.options).forEach((currentOption) => {
        const isOptionValueOk = Number(currentOption.value) < Number(selectedMaxPrice);
        if (currentOption.value && isOptionValueOk) {
          currentOption.classList.remove('is-hidden');
        } else if (currentOption.value) {
          currentOption.classList.add('is-hidden');
        }
      });
    } else {
      this.displayInputAllOptions(this.inputMinPriceTarget);
    }
    this.updatePriceRange();
  }

  displayInputAllOptions = (input) => {
    Array.from(input).forEach((option) => {
      option.classList.remove('is-hidden');
    });
  }

  updatePropertiesStatus(event) {
    const unavtiveStatusCheck = event.target.checked;
    this.unactivePropertyStatusInputTargets.forEach((input) => {
      input.checked = unavtiveStatusCheck;
    });
  }

  saveSearch() {
    const alias = this.searchAliasInputTarget.value;
    if (!alias.length) {
      this.searchAliasInputTarget.classList.add('is-danger');
      return;
    }

    const propertySearchModal = document.getElementById('propertySearchModal');
    const params = this.buildSearchParams();
    axios.post('/property_searches', params)
    .then((response) => {
      if (response.status === 201) {
        this.searchAliasInputTarget.classList.remove('is-danger');
        propertySearchModal.classList.remove('is-active');
        document.getElementsByTagName('html')[0].classList.toggle('is-clipped');
        this.saveSearchContainerTarget.innerHTML = response.data;
      }
    })
    .catch((error) => {
      const { errors } = error.response.data;
      const errorMessage = errors[Object.keys(errors)[0]];
      this.saveSearchMessageTarget.innerText = errorMessage;
    });
  }

  buildSearchParams() {
    const alias = this.searchAliasInputTarget.value;
    const searchIn = this.cityNameInputTarget.value;
    const minprice = this.inputMinPriceTarget.value;
    const maxprice = this.inputMaxPriceTarget.value;
    const minbeds = document.querySelector('input[name="search[minbeds]"]:checked').value;
    const minbaths = document.querySelector('input[name="search[minbaths]"]:checked').value;
    const typeInputs = Array.from(document.querySelectorAll('input[name="search[type][]"]:checked'));
    const minarea = document.querySelector('input[name="search[minarea]"]').value;
    const maxarea = document.querySelector('input[name="search[maxarea]"]').value;
    const minyear = document.querySelector('input[name="search[minyear]"]').value;
    const maxyear = document.querySelector('input[name="search[maxyear]"]').value;
    const minacres = document.querySelector('input[name="search[minacres]"]').value;
    const maxacres = document.querySelector('input[name="search[maxacres]"]').value;
    const water = document.querySelector('input[name="search[water]"][type="checkbox"]').checked;
    const maxdom = document.querySelector('input[name="search[maxdom]"]').value;
    const features = document.querySelector('input[name="search[features]"]').value;
    const searchType = document.querySelector('select[name="search[search_type]"]').value;
    const statusSelect = document.querySelector('select[name="search[status][]"]');
    const exteriorFeatures = features;
    const types = typeInputs.map((input) => input.value);
    let statuses = '';
    if (statusSelect) {
      statuses = statusSelect.value.split();
    } else {
      const statusInputs = Array.from(document.querySelectorAll('input[name="search[status][]"]:checked'));
      statuses = statusInputs.map((input) => input.value);
    }

    return {
      alias,
      search_in: searchIn,
      search_type: searchType,
      minprice,
      maxprice,
      minbeds,
      minbaths,
      types,
      statuses,
      minarea,
      maxarea,
      minyear,
      maxyear,
      minacres,
      maxacres,
      water,
      maxdom,
      features,
      exteriorFeatures,
    };
  }

  updateSearch() {
    const savedSearchId = this.savedSearchesTarget.value;
    axios.get(`/property_searches/${savedSearchId}`)
    .then((response) => {
      if (response.status === 200) {
        const search = response.data;
        document.querySelector('input[name="search[search_in]"]').value = search.search_in;
        document.querySelector('select[name="search[minprice]"]').value = search.minprice;
        document.querySelector('select[name="search[maxprice]"]').value = search.maxprice;
        document.querySelector(`input[name="search[minbeds]"][value="${search.minbeds}"]`).checked = true;
        document.querySelector(`input[name="search[minbaths]"][value="${search.minbaths}"]`).checked = true;
        const typeInputs = Array.from(document.querySelectorAll('input[name="search[type][]"]'));
        typeInputs.forEach((input) => {
          input.checked = false;
        });
        search.types.forEach((type) => {
          document.querySelector(`input[name="search[type][]"][value="${type}"]`).checked = true;
        });
        const statusInputs = Array.from(document.querySelectorAll('input[name="search[status][]"]'));
        statusInputs.forEach((input) => {
          input.checked = false;
        });
        const statusSelect = document.querySelector('select[name="search[status][]"]');
        if (statusSelect) {
          statusSelect.value = search.statuses[0];
        } else {
          search.statuses.forEach((status) => {
            document.querySelector(`input[name="search[status][]"][value="${status}"]`).checked = true;
          });
        }
        document.querySelector('input[name="search[minarea]"]').value = search.minarea;
        document.querySelector('input[name="search[minacres]"]').value = search.minacres;
        document.querySelector('input[name="search[maxacres]"]').value = search.maxacres;
        document.querySelector('input[name="search[maxarea]"]').value = search.maxarea;
        document.querySelector('input[name="search[minyear]"]').value = search.minyear;
        document.querySelector('input[name="search[maxyear]"]').value = search.maxyear;
        document.querySelector('input[name="search[water]"]').checked = search.water;
        document.querySelector('input.is-checkradio[name="search[water]"]').checked = search.water;
        document.querySelector('input[name="search[maxdom]"]').value = search.maxdom;
        document.querySelector('input[name="search[features]"]').value = search.features;
        document.querySelector('input[name="search[exteriorFeatures]"]').value = search.exteriorFeatures;
        document.getElementById('searchPropertySubmitButton').click();
      }
    });
  }

  getNextPropertiesBatch() {
    this.nextBatchButtonTarget.classList.add('is-loading');
    this.mapOnLoading();
    const nextBatchLink = this.nextBatchButtonTarget.getAttribute('data-next-batch-url');
    axios.get('/properties/', { params: { link: nextBatchLink } })
    .then((response) => {
      if (response.status === 200) {
        const container = document.getElementById('searchedPropertiesContainer');
        const flaggedPropertiesIds = response.data.flagged_properties_ids;
        const propertiesContainer = response.data.html;
        const { properties } = response.data;
        if (properties.length) {
          container.insertAdjacentElement('beforeend', this.stringToHtml(propertiesContainer));
          this.data.markers.push(...buildMarker(properties, flaggedPropertiesIds, this.data.map));
          this.appendPrintedProperties(properties);
          setTimeout(() => ReactRailsUJS.mountComponents(), 1000);
        }
        this.updateResultsMessage(properties.length);
        // we need to wait for container to be rendered
        const that = this;
        setTimeout(() => { that.updateNextBatchButton(); }, 2000);
      }
      this.nextBatchButtonTarget.classList.remove('is-loading');
      this.nextBatchButtonTarget.remove();
      this.lookMapTarget.classList.remove('loading');
    });
  }

  updateNextBatchButton() {
    const defaultNextBatchLink = document.getElementById('nextBatchLinkButton').dataset.nextBatchUrl;
    if (defaultNextBatchLink) return;

    if (this.data.availableVendors.length) {
      const emptyLink = this.sanitizedNextLink();
      const nextVendor = this.data.availableVendors.shift();
      const nextBatchLink = emptyLink.concat(`&vendor=${nextVendor}`);
      this.nextBatchButtonTarget.setAttribute('data-next-batch-url', nextBatchLink);
    } else {
      // hide button when no more vendors available
      this.nextBatchButtonTarget.classList.add('is-hidden');
    }
  }

  // udate base link to use next vendor
  sanitizedNextLink = () => this.data.defaultNextBatchLink.replace(/&vendor=[a-z]+/, '').replace(/offset=[0-9]*&/, '');

  defineDefaultNextBatchLink() {
    const defaultNextBatchLink = this.nextBatchButtonTarget.dataset.nextBatchUrl;
    this.data.defaultNextBatchLink = defaultNextBatchLink;
  }

  stringToHtml = (string) => {
    const container = document.createElement('div');
    container.innerHTML = string;
    return container;
  }

  updateResultsMessage(newProperties) {
    const { currentResults } = this.numberOfResultsTarget.dataset;
    const accumulatedResults = Number.parseInt(currentResults, 10) + newProperties;
    const currentMessageText = this.numberOfResultsTarget.textContent;
    const newMessage = currentMessageText.replace(currentResults, accumulatedResults);
    this.numberOfResultsTarget.textContent = newMessage;
    this.numberOfResultsTarget.dataset.currentResults = accumulatedResults;
  }

  verifyMultifamilyHomeType() {
    const residential = document.getElementById('search_residential_type').checked;
    const condominum = document.getElementById('search_condominium_type').checked;
    const mobile = document.getElementById('search_mobile_type').checked;
    const multy = document.getElementById('search_multifamily_type').checked;
    const fractional = document.getElementById('search_fractional_type').checked;

    if (multy && !residential && !condominum && !mobile && !fractional) {
      document.getElementById('search_min_baths_any').checked = true;
      document.getElementById('search_min_beds_any').checked = true;
      this.toogleBedBathsInputs(true);
    } else {
      this.toogleBedBathsInputs(false);
    }
  }

  toogleBedBathsInputs = (isDisabled) => {
    const bedInputs = document.querySelectorAll('input[name="search[minbeds]"]');
    bedInputs.forEach((input) => {
      input.disabled = isDisabled;
    });
    const bathInputs = document.querySelectorAll('input[name="search[minbaths]"]');
    bathInputs.forEach((input) => {
      input.disabled = isDisabled;
    });
    if (isDisabled) {
      const changeEvent = new Event('click');
      bedInputs[0].dispatchEvent(changeEvent);
      bathInputs[0].dispatchEvent(changeEvent);
    }
  }

  findMyArea(e) {
    this.cityNameInputTarget.value = e.currentTarget.value
    this.formSubmitTarget.click();
  }
}
