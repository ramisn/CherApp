import React from 'react';
import PropTypes from 'prop-types';

const UserAreas = (props) => {
  const {
    city, isEditing, selectedAreas, availableAreas, updateAreas, unselectItem,
  } = props;

  const userTags = (area) => (
    <li className="tag is-grey" key={area}>
      {area}
      {isEditing && (
        <button type="button" className="is-close" onClick={unselectItem} value={area}>X</button>
      )}
    </li>
  );

  return (
    <div className="field">
      <label htmlFor="areas" className="label is-marginless">My Areas</label>
      <ul>
        <li className="tag is-grey has-text-weight-bold is-primary">{city}</li>
        {selectedAreas.map((area) => userTags(area))}
      </ul>
      {isEditing && (
        <div className="control m-t-sm">
          <div className="select">
            <select name="areas" id="areas" onChange={updateAreas} defaultValue="prompt">
              <option value="prompt" disabled>Select your areas</option>
              { availableAreas.map((area) => <option value={area} key={area}>{area}</option>) }
            </select>
          </div>
        </div>
      )}
    </div>
  );
};

UserAreas.propTypes = {
  updateAreas: PropTypes.func.isRequired,
  isEditing: PropTypes.bool.isRequired,
  availableAreas: PropTypes.arrayOf(PropTypes.string),
  selectedAreas: PropTypes.arrayOf(PropTypes.string),
  unselectItem: PropTypes.func.isRequired,
};

export default UserAreas;
