import React, { useEffect, useState } from 'react';
import PropTypes from 'prop-types';
import defaultAxios from 'axios';
import axios from '../packs/axios_utils.js';
import { DEFAULT_CITY_NAME, DEFAULT_ESTATE, randomizeProperties } from '../packs/property_utils.js';
import SuggestedPropertyCard from './SuggesterPropertyCard';

const SuggestedProperties = ({ suggestedProperties }) => {
  const [properties, setProperties] = useState(suggestedProperties);
  const [location, setLocation] = useState(DEFAULT_CITY_NAME);

  const fetchProperties = () => {
    if (location) {
      const params = {
        'search[search_in]': location,
        'search[type][]': 'residential',
        'search[status][]': 'Active',
        'search[minprice]': 300000,
      };

      axios.get('/look-around.json', { params })
        .then((res) => {
          const randomProperties = randomizeProperties(res.data.properties, 8);
          setProperties(randomProperties);
        });
    }
  };

  const processLocationResponse = (results) => {
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
  };

  const defineLocation = async (position) => {
    const googleKey = document.body.getAttribute('google_places_key');
    const latlng = `${position.coords.latitude},${position.coords.longitude}`;
    const params = { latlng, key: googleKey };
    const noTokenAxiosInstance = defaultAxios.create();
    delete noTokenAxiosInstance.defaults.headers.common['X-CSRF-Token'];

    const city = await noTokenAxiosInstance.get('https://maps.googleapis.com/maps/api/geocode/json', { params })
      .then((response) => {
        if (response.status !== 200) return DEFAULT_CITY_NAME;

        return processLocationResponse(response.data.results);
      });

    if (city !== location) setLocation(city);
  };

  useEffect(() => {
    navigator.geolocation.getCurrentPosition(defineLocation);
  }, [navigator]);

  useEffect(() => {
    fetchProperties();
  }, [location]);

  return (
    <>
      <h3 className="is-size-2 is-marginless">
        Suggested homes in&nbsp;
        {location}
      </h3>
      <div className="columns is-marginless p-t-md p-b-md is-mobile is-x-scroll is-centered-desktop">
        { properties.map((p) => (<SuggestedPropertyCard key={p.listingId} property={p} />)) }
      </div>
    </>
  );
};

SuggestedProperties.propTypes = {
  suggestedProperties: PropTypes.arrayOf(PropTypes.shape({
    listingId: PropTypes.string,
    listPrice: PropTypes.number,
    photos: PropTypes.arrayOf(PropTypes.string),
  })),
};

export default SuggestedProperties;
