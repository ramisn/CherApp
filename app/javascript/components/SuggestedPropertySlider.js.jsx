import React from 'react';
import PropTypes from 'prop-types';
import { numToCurrency } from '../packs/property_utils.js';
import friends1 from '../../assets/images/cherapp-ownership-coborrowing-friends-1.svg';
import friends1Active from '../../assets/images/cherapp-ownership-coborrowing-friends-1-active.svg';
import friends2 from '../../assets/images/cherapp-ownership-coborrowing-friends-2.svg';
import friends2Active from '../../assets/images/cherapp-ownership-coborrowing-friends-2-active.svg';
import friends3 from '../../assets/images/cherapp-ownership-coborrowing-friends-3.svg';
import friends3Active from '../../assets/images/cherapp-ownership-coborrowing-friends-3-active.svg';
import friends4 from '../../assets/images/cherapp-ownership-coborrowing-friends-4.svg';
import friends4Active from '../../assets/images/cherapp-ownership-coborrowing-friends-4-active.svg';

const SuggestedPropertySlider = ({ listPrice }) => (
  <div className="column has-full-width">
    <h3 className="is-bold is-marginless has-text-left is-size-3">
      {numToCurrency(listPrice)}
    </h3>
    <div className="is-hidden-mobile">
      <input type="hidden" name="home_price" value={listPrice} data-target="home-price-slider.defaultPriceList" />
      <span>Est.</span>
      <span className="is-bold m-l-sm m-r-sm" data-target="home-price-slider.amountWithCher" />
      <span>monthly</span>
      <input
        type="range"
        className="custom-slider-primary is-fullwidth"
        data-target="home-price-slider.numberOfFriends"
        data-action="input->home-price-slider#updateMonthlyMortgage input->home-price-slider#updateSliderStyle input->home-price-slider#updateSelectedIcon"
        max={4}
        min={1}
        defaultValue={4}
        step={1}
      />
      <div className="columns is-flex has-space-between coborrowing-slider m-t-sm">
        <div>
          <img src={friends1} alt="friends 1" className="is-clickable" id="friendsIcon1" data-target="home-price-slider.personIcon" data-action="click->home-price-slider#updateSlider" data-slider-value={1} />
          <img
            src={friends1Active}
            className="is-hidden"
            id="soliidFriendsIcon1"
            data-target="home-price-slider.solidPersonIcon"
            alt="friends 1"
          />
        </div>
        <div>
          <img src={friends2} alt="friends 2" className="is-clickable" id="friendsIcon2" data-target="home-price-slider.personIcon" data-action="click->home-price-slider#updateSlider" data-slider-value={2} />
          <img
            src={friends2Active}
            className="is-hidden"
            id="soliidFriendsIcon2"
            data-target="home-price-slider.solidPersonIcon"
            alt="friends 2"
          />
        </div>
        <div>
          <img src={friends3} alt="friends 3" className="is-clickable" id="friendsIcon3" data-target="home-price-slider.personIcon" data-action="click->home-price-slider#updateSlider" data-slider-value={3} />
          <img
            src={friends3Active}
            className="is-hidden"
            id="soliidFriendsIcon3"
            data-target="home-price-slider.solidPersonIcon"
            alt="friends 3"
          />
        </div>
        <div>
          <img src={friends4} alt="friends 4" className="is-clickable" id="friendsIcon4" data-target="home-price-slider.personIcon" data-action="click->home-price-slider#updateSlider" data-slider-value={4} />
          <img
            src={friends4Active}
            className="is-hidden"
            id="soliidFriendsIcon4"
            data-target="home-price-slider.solidPersonIcon"
            alt="friends 4"
          />
        </div>
      </div>
    </div>
  </div>
);

SuggestedPropertySlider.propTypes = {
  listPrice: PropTypes.number,
};

export default SuggestedPropertySlider;