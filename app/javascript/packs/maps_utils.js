import { Loader } from 'google-maps';
import defaultPropertyImage from '../../assets/images/cherapp-ownership-coborrowing-property_placeholder.png';
import icon from '../../assets/images/cherapp-ownership-coborrowing-marker.png';
import iconActive from '../../assets/images/cherapp-ownership-coborrowing-marker-selected.png';
import axios from './axios_utils.js';

document.addEventListener('turbolinks:load', () => {
  const googleKey = document.querySelector('body').getAttribute('google_key');
  window.loader = new Loader(googleKey, { libraries: ['places'] });
});

let activeInfoWindow;
let activeMarker;
let focusedPropertyCard;

function stringToHtml(string) {
  const container = document.createElement('div');
  container.innerHTML = string;
  return container.firstChild;
}

function focusOnProperty(propertyId) {
  if (focusedPropertyCard) {
    focusedPropertyCard.classList.remove('has-focus');
  }
  const propertyCard = document.getElementById(`property${propertyId}`);
  const propertiesWrap = document.querySelector('.properties-wrapper');
  propertiesWrap.scroll({ top: propertyCard.offsetTop, behavior: 'smooth'});
  propertyCard.classList.add('has-focus');
  focusedPropertyCard = propertyCard;
}

function getMissingProperty(propertyId) {
  setTimeout(() => {
    const popUp = document.getElementById(`propertyPopUp${propertyId}`);
    if (popUp) {
      popUp.classList.add('is-loading');
    }
  }, 100);
  axios.get(`/properties/${propertyId}`)
  .then((response) => {
    if (response.status === 200) {
      const container = document.getElementById('propertiesCardsContainer');
      const propertyCard = response.data.html;
      container.insertAdjacentElement('beforeend', stringToHtml(propertyCard));
      focusOnProperty(propertyId);
    }
    const popUp = document.getElementById(`propertyPopUp${propertyId}`);
    popUp.classList.remove('is-loading');
  });
}

function initMap(anchor, mapSettings={}) {
  const mapElement = document.getElementById(anchor);
  return new Promise( async (resolve, reject) => {
    if (mapElement) {
      if(!window.google) {
        const googleKey = document.querySelector('body').getAttribute('google_key');
        window.loader = new Loader(googleKey, { libraries: ['places', 'drawing'] });
        window.google = await loader.load();
      }
      const map = new google.maps.Map(mapElement, {
                            center: { lat: 34.017720, lng: -118.429996 },
                            disableDefaultUI: true,
                            zoomControl: true,
                            zoomControlOptions: {
                                position: google.maps.ControlPosition.LEFT_TOP,
                            },
                            mapTypeId: google.maps.MapTypeId.ROADMAP,
                            zoom: 12,
                            controlSize: 28,
                            ...mapSettings,
                            });
      resolve(map);
      return;
    }
    reject(`Undefined element ${anchor}`);
  });
}

function propertyImage(property) {
  const propertyImages = property.photos;
  let image = defaultPropertyImage;
  if (propertyImages && propertyImages[0]) {
    image = propertyImages[0].replace('http://', 'https://');
  }
  return image;
}

const infoContainer = (property, isProppertyFlagged) => {
    const price = Intl.NumberFormat('en-US', { maximumFractionDigits: 1 }).format(parseInt(property.listPrice, 10));
    return `<div data-property-id="${property.listingId}" class='property-popup' data-controller="watched-property">`
      + '<div class="watch-property__form">'
      + `<a href='' data-action='watched-property#toggleflagProperty'
          data-target='watched-property.flagPropertyLink'
          data-property-listing-id='${property.listingId}'
          data-property-city='${property.address.city}'
          data-property-price='${property.listPrice}'
          data-property-flag-status='${isProppertyFlagged ? 'flagged' : 'unflagged'}'
          class='${isProppertyFlagged ? 'unflag' : 'flag'}'>
        </a>`
      + '</div>'
      + '<div class="cobuyers__form">'
      + `<a href= '/chat-groups/new?property_id=${property.listingId}'
          data-action='watched-property#startChat'
          ${
            isProppertyFlagged ? '' : `
              data-property-listing-id='${property.listingId}'
              data-property-city='${property.address.city}'
              data-property-price='${property.listPrice}'
              data-property-flag-status='unflagged'
            `
          }
          class='user-cobuyers'> </a>`
      + '</div>'
      + `<img loading='lazy' src=${propertyImage(property)} class='property-image' onError="this.onerror=null;this.src='${defaultPropertyImage}'; this.nextSibling.classList.add('no-image');"/>`
      + `<a href="/properties/${property.listingId}" target="_blank">`
      + `<div class="property-info" id="propertyPopUp${property.listingId}">`
      + `<span>$${price}</span>`
      + '</div>'
      + '</a>'
      + `<div class="engaged-people" data-property-id=${property.listingId}></div>`
      + '</div>';
};

function fetchPeopleThatSearchTheSameCity(city, propertyId) {
  const watchedPropertiesContainer = document.querySelector('.logged-user-wrapper');
  if (watchedPropertiesContainer) {
    axios.get(`/homebuyers?city=${city}&property_id=${propertyId}`, { headers: { Accept: 'html/text' } })
    .then((response) => {
      watchedPropertiesContainer.innerHTML = response.data;
    });
  }
}

function buildMarkerListenner(map, marker, property, infoWindow) {
  google.maps.event.addListener(infoWindow, 'closeclick', () => {
    marker.setIcon(icon);
  });
  marker.addListener('click', () => {
    map.panTo(marker.getPosition());
    if (activeMarker) {
      activeMarker.setIcon(icon);
    }
    activeMarker = marker;
    marker.setIcon(iconActive);
    if (activeInfoWindow) {
      activeInfoWindow.close();
    }
    infoWindow.open(map, marker);
    activeInfoWindow = infoWindow;

    const propertyCard = document.getElementById(`property${property.listingId}`);
    if (propertyCard) {
      if (focusedPropertyCard) {
        focusedPropertyCard.classList.remove('has-focus');
      }
      const propertiesWrap = document.querySelector('.properties-wrapper');
      propertiesWrap.scroll({ top: propertyCard.offsetTop, behavior: 'smooth'});
      propertyCard.classList.add('has-focus');
      focusedPropertyCard = propertyCard;
    } else if (document.getElementById('propertiesCardsContainer')) {
      getMissingProperty(property.listingId);
    }

    const searchInput = document.getElementById('searchFor');
    if (searchInput) {
      fetchPeopleThatSearchTheSameCity(searchInput.value, property.listingId);
    }
  });
}

function buildMarker(properties, flaggedPropertiesIds, map, fitBounds = true) {
  const bounds = new google.maps.LatLngBounds();
  const markers = properties.map((property) => {
    // Some properties does not includes location
    if (!property.geo.lat || !property.geo.lng) return null;

    const isProppertyFlagged = flaggedPropertiesIds.includes(property.listingId);
    const propertyData = infoContainer(property, isProppertyFlagged);
    const infoWindow = new google.maps.InfoWindow({
      content: propertyData,
    });
    const marker = new google.maps.Marker({
      position: property.geo, map, icon, data: property,
    });
    buildMarkerListenner(map, marker, property, infoWindow);
    bounds.extend(marker.position);
    return marker;
  });

  const filteredMarkers = markers.filter((marker) => marker);

  if (fitBounds && filteredMarkers.length) {
    map.fitBounds(bounds);
    map.panToBounds(bounds);
  }
  return filteredMarkers;
}

export { initMap, buildMarker, fetchPeopleThatSearchTheSameCity };
