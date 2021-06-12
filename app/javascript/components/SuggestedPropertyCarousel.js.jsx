import React from 'react';
import PropTypes from 'prop-types';
import defaultImage from '../../assets/images/cherapp-ownership-coborrowing-property_placeholder.png';

const SuggestedPropertyCarousel = ({ photos, listingId }) => {
  if (!photos) {
    return (
      <a href={`/properties/${listingId}`}>
        <img
          src={defaultImage}
          alt="home"
          className="property-image"
          loading="lazy"
        />
      </a>
    );
  }

  return (
    <div
      className={`carousel has-no-pagination ${photos.length > 1 ? '' : 'has-no-arrows'}`}
      data-target="carousel.imageContainer"
    >
      {photos.map((image, index) => (
        <div
          key={`item${listingId}-${index + 1}`}
          className={`item${listingId}-${index + 1}`}
          data-target="carousel.images"
        >
          <a href={`/properties/${listingId}`}>
            <img
              src={image}
              alt="home"
              className="property-image"
              data-controller="property-default-image"
              data-action="error->property-default-image#setDefaultPropertyImage"
              loading="lazy"
            />
          </a>
        </div>
      ))}
    </div>
  );
};

SuggestedPropertyCarousel.propTypes = {
  photos: PropTypes.arrayOf(PropTypes.string),
  listingId: PropTypes.string,
};

export default SuggestedPropertyCarousel;