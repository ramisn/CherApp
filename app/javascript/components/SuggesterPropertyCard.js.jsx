import React from 'react';
import PropTypes from 'prop-types';
import SuggestedPropertyCarousel from './SuggestedPropertyCarousel';
import SuggestedPropertySlider from './SuggestedPropertySlider';

const SuggestedPropertyCard = ({ property }) => (
  <div
    className="column is-4-tablet is-3-desktop is-2-fullhd is-10-mobile"
    id={`property${property.listingId}`}
    data-controller="watched-property home-price-slider"
  >
    <div className="is-marginless is-white">
      <div data-controller="carousel">
        <SuggestedPropertyCarousel photos={property.photos} listingId={property.listingId} />
      </div>
      <div className="is-flex has-space-between has-direction-column has-full-heighh">
        <div className="columns is-marginless is-mobile has-space-between is-multiline">
          <SuggestedPropertySlider listPrice={property.listPrice} />
        </div>
      </div>
    </div>
  </div>
);

SuggestedPropertyCard.propTypes = {
  property: PropTypes.shape({
    listingId: PropTypes.string,
    listPrice: PropTypes.number,
    photos: PropTypes.arrayOf(PropTypes.string),
  }),
};

export default SuggestedPropertyCard;