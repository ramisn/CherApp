import React from 'react';
import PropTypes from 'prop-types';

const AddressInformation = (props) => {
  const {
    address1,
    address2,
    states,
    zipcode,
    city,
    state,
    updateField,
    isEditing,
  } = props;

  const address3 = `${city || 'City'}, ${state || 'state'}`;

  const customInput = (name, value, placeholder, extraPropps) => (
    <input
      className="input is-editable is-primary"
      name={name}
      id={name}
      placeholder={placeholder}
      value={value || ''}
      onChange={updateField}
      {...extraPropps}
    />
  );

  return (
    <>
      { isEditing ? (
        <>
          {customInput('address1', address1, 'Address 1')}
          {customInput('address2', address2, 'Address 2')}
          {customInput('city', city, 'City')}
          <div className="field">
            <div className="control is-expanded is-marginless">
              <div className="select">
                <select defaultValue={state} className="is-marginless" name="state" onChange={updateField}>
                  { states.map((americaState) => (
                    <option key={americaState} value={americaState}>{americaState}</option>
                  ))}
                </select>
              </div>
            </div>
          </div>
          {customInput('zipcode', zipcode, 'Zipcode', { maxLength: 5 })}
        </>
      ) : (
        <>
          <span className="is-block">{address1 || 'Address 1'}</span>
          { address2 && <span className="is-block">{address2}</span>}
          <span className="is-block">{address3}</span>
          <span className="is-block">{zipcode}</span>
        </>
      )}
    </>
  );
};

AddressInformation.propTypes = {
  address1: PropTypes.string,
  address2: PropTypes.string,
  states: PropTypes.arrayOf(PropTypes.string),
  zipcode: PropTypes.string,
  city: PropTypes.string,
  state: PropTypes.string,
  isEditing: PropTypes.bool,
  updateField: PropTypes.func,
};

export default AddressInformation;
