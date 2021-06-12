import React, { useState } from 'react';
import PropTypes from 'prop-types';
import defaultProfilePicture from '../../../assets/images/cherapp-ownership-coborrowing-ico-user.svg';
import flaggedPropertyIcon from '../../../assets/images/cherapp-ownership-coborrowing-ico-favorite.svg';
import ellipse from '../../../assets/images/cherapp-ownership-coborrowing-property_placeholder.svg';
import ellipseChecked from '../../../assets/images/cherapp-ownership-coborrowing-ellipse-checked.svg';
import { formatMoney, annualIncomeWithFriends } from '../../packs/home_utils.js';

const FlaggedPropertiesSelecter = ({ flaggedProperties, nextStep }) => {
  const [selectedProperty, setSelectedProperty] = useState(null);

  const handleImageError = (event) => {
    event.preventDefault();
    event.target.setAttribute('src', defaultProfilePicture);
  };

  const togglePropertyFlagg = () => {
    // TODO flag/unflag properties
  };

  return (
    <div className="columns is-multiline is-mobile is-marginless">
      <div className="column is-12">
        <h3 className="is-size-5">My flagged homes</h3>
      </div>
      { flaggedProperties.map((property) => (
        <div className="column is-6-mobile is-4-tablet is-3-widescreen is-one-fifth-fullhd property-card" key={property.listingId}>
          <button type="button" onClick={() => { setSelectedProperty(property); }} className="button has-no-style has-text-left is-relative">
            { selectedProperty === property
              ? <img alt="ellipse" src={ellipseChecked} className="is-absolute-right-up" />
              : <img alt="ellipse" src={ellipse} className="is-absolute-right-up" />}
            <img alt="Property" className="property-image" src={property.photos[0]} onError={handleImageError} />
            <div className="property-info">
              <h4 className="is-size-4 is-size-5-mobile">{formatMoney(property.listPrice)}</h4>
              <span className="is-size-7 m-r-xs">Est.</span>
              <span className="is-bold is-size-7">{ annualIncomeWithFriends(property.listPrice, 1) }</span>
              <span className="is-block is-size-7">monthly</span>
              <span className="is-bold is-block is-size-7">{property.address.full}</span>
              <span className="is-block is-size-7 m-t-sm">{property.address.city}</span>
              <span className="is-block is-size-7">{`${property.address.state} ${property.address.postalCode}`}</span>
            </div>
          </button>

          <button className="button is-secondary m-t-sm" type="button" onClick={togglePropertyFlagg}>
            <img src={flaggedPropertyIcon} alt="Flag" className="m-r-md" />
            Flagged
          </button>
        </div>
      ))}
      <div className="column is-12">
        <div className="columns is-marignless is-justified-center">
          <div className="column is-12-mobile is-8-tablet is-4-desktop is-fully-centered has-direction-column">
            <button type="button" onClick={() => { nextStep(selectedProperty); }} className="button is-primary m-b-md has-full-width">Next</button>
            <button type="button" onClick={() => nextStep(null)} className="button has-no-style has-text-primary is-bold has-full-width">Skip</button>
          </div>
        </div>
      </div>
    </div>
  );
};

FlaggedPropertiesSelecter.propTypes = {
  flaggedProperties: PropTypes.arrayOf(PropTypes.shape({})),
  nextStep: PropTypes.func.isRequired,
};

export default FlaggedPropertiesSelecter;
