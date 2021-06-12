import { initMap, buildMarker } from './maps_utils.js';
import axios from './axios_utils.js';

async function requestProperties() {
  const customerMap = document.getElementById('customerDashboardMap');
  const url = customerMap ? '/network_watched_properties' : '/flagged_properties';
  let response = {};
  try {
    response = await axios.get(url, {});
  } catch (exception) {
    return { data: [] };
  }
  return response;
}

const setMarkers = (map) => {
  requestProperties()
  .then((response) => {
    const flaggedPropertiesIds = response.data.map((property) => property.listingId);
    buildMarker(response.data, flaggedPropertiesIds, map);
  });
};

const getLocation = async () => {
  const map = await initMap('mapContainer');
  setMarkers(map);
};


document.addEventListener('turbolinks:load', () => {
  if (document.getElementById('mapContainer')) {
    getLocation();
  }
});
