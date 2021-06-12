import React from 'react';
import PropTypes from 'prop-types';
import axios from '../../packs/axios_utils.js';
import UserAreas from './UserAreas';
import AddressInformation from './AddressInformation';
import editIcon from '../../../assets/images/cherapp-ownership-coborrowing-edit.svg';

class ProfessionalInformation extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      address1: props.address1,
      address2: props.address2,
      state: props.state,
      zipcode: props.zipcode,
      city: props.city,
      companyName: props.companyName,
      isEditing: false,
      numberLicense: props.numberLicense,
      states: props.states,
      description: props.description,
      selectedAreas: props.selectedAreas,
      availableAreas: props.availableAreas.map((area) => area.name),
    };
    this.nameInput = React.createRef();
    this.descriptionInput = React.createRef();
  }

  componentDidMount() {
    const { availableAreas, selectedAreas } = this.state;
    const descriptionInput = this.descriptionInput.current;
    descriptionInput.style.cssText = `height: ${descriptionInput.scrollHeight}px`;
    const filteredAreas = availableAreas.filter((area) => !selectedAreas.includes(area));
    this.setState({ availableAreas: filteredAreas });
  }

  updateDescription = () => {
    const description = this.descriptionInput.current.value;
    this.setState({ description });
    const descriptionInput = this.descriptionInput.current;
    descriptionInput.style.cssText = 'height: auto; padding: 0';
    descriptionInput.style.cssText = `height: ${descriptionInput.scrollHeight}px`;
  }

  updateProfile = async () => {
    const { userId } = this.props;
    const {
      companyName, address1, address2, city, state, zipcode, description, selectedAreas,
    } = this.state;

    await axios.put(`/profile/${userId}`, {
      user: {
        company_name: companyName,
        address1,
        address2,
        city,
        state,
        zipcode,
        description,
        areas: selectedAreas,
      },
    });

    this.setState({ isEditing: false });
  }

  makeEditable = () => {
    this.setState({ isEditing: true });
    this.nameInput.current.focus();
  }

  updateField = (event) => {
    const fieldValue = event.target.value;
    const fieldName = event.target.name;

    this.setState({ [fieldName]: fieldValue });
  }

  updateAreas = (event) => {
    const selectedArea = event.target.value;
    const { availableAreas, selectedAreas } = this.state;
    event.target.selectedIndex = 0;
    if (selectedAreas.length > 9) { return; }

    const currentAreas = availableAreas.filter((area) => area !== selectedArea);
    this.setState({
      availableAreas: currentAreas,
      selectedAreas: [...selectedAreas, selectedArea],
    });
  }

  unselectItem = (event) => {
    const unselectedArea = event.target.getAttribute('value');
    const { selectedAreas } = this.state;
    selectedAreas.splice(selectedAreas.indexOf(unselectedArea), 1);
    this.setState((prevState) => ({
      availableAreas: [...prevState.availableAreas, unselectedArea].sort(),
      selectedAreas,
    }));
  }

  render() {
    const {
      isEditing, companyName, address1, address2, city, state,
      zipcode, numberLicense, states,
      description, areas, availableAreas, selectedAreas,
    } = this.state;

    return (
      <div className="is-family-secondary">
        <div className="is-flex has-space-between">
          <h3 className="has-text-primary is-family-secondary is-size-5 is-hidden-mobile">
            My Info
          </h3>
          { !isEditing && (
            <img src={editIcon} alt="Edit" className="icon is-clickable is-pulled-right" onClick={this.makeEditable} id="editProfessionalButton"/>
          )}
        </div>

        <div className="field m-t-sm">
          <label className="label is-marginless" htmlFor="companyName">Brokerage</label>
          <div className="control">
            <input
              ref={this.nameInput}
              className={`input is-editable is-marginless is-primary ${isEditing ? '' : 'is-disabled'}`}
              name="companyName"
              id="companyName"
              placeholder="Company's name"
              value={companyName || ''}
              onChange={this.updateField}
            />
          </div>
        </div>

        <div className="field">
          <label className="label is-marginless" htmlFor="address1">Address</label>
          <div className="control">
            <AddressInformation
              address1={address1}
              address2={address2}
              states={states}
              zipcode={zipcode}
              state={state}
              updateField={this.updateField}
              isEditing={isEditing}
            />
          </div>
        </div>

        { numberLicense && (
          <div className="field">
            <label className="label is-marginless" htmlFor="numberLicense">License Number</label>
            <div className="control">
              <input
                className="input is-editable is-marginless is-disabled"
                name="numberLicense"
                id="numberLicense"
                placeholder="Your license's number"
                value={numberLicense || ''}
                readOnly
              />
            </div>
          </div>
        )}

        <div className="field">
          <div className="control">
            <label className="label is-marginless" htmlFor="description">My Bio</label>
            <textarea
              ref={this.descriptionInput}
              className={`input is-primary is-editable is-marginless ${isEditing ? '' : 'is-disabled'}`}
              value={description || ''}
              name="description"
              id="description"
              placeholder="Describe yourself as professional"
              onChange={this.updateDescription}
              maxLength={500}
            />
          </div>
        </div>

        <UserAreas
          city={city}
          areas={areas}
          isEditing={isEditing}
          updateAreas={this.updateAreas}
          unselectItem={this.unselectItem}
          availableAreas={availableAreas}
          selectedAreas={selectedAreas}
        />

        <div className="has-text-right">
          { isEditing && (
          <button id="saveProffessionalData" type="button" className="button is-primary has-full-width" onClick={this.updateProfile}>
            Save
          </button>
          )}
        </div>
      </div>
    );
  }
}

ProfessionalInformation.propTypes = {
  userId: PropTypes.number.isRequired,
  address1: PropTypes.string,
  address2: PropTypes.string,
  city: PropTypes.string,
  state: PropTypes.string,
  zipcode: PropTypes.string,
  companyName: PropTypes.string,
  numberLicense: PropTypes.string,
  states: PropTypes.arrayOf(PropTypes.string).isRequired,
  description: PropTypes.string,
  selectedAreas: PropTypes.arrayOf(PropTypes.string),
  availableAreas: PropTypes.arrayOf(PropTypes.shape({
    id: PropTypes.number,
    name: PropTypes.string,
  })),
};

export default ProfessionalInformation;
