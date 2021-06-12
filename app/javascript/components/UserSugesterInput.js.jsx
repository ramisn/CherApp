import React from 'react';
import Qs from 'qs';
import FontAwesome from 'react-fontawesome';
import PropTypes from 'prop-types';
import axios from '../packs/axios_utils.js';
import UserInvitation from './UserInvitation';
import UserListItem from './UserListItem';
import backgroundImg from '../../assets/images/cherapp-ownership-coborrowing-ico-credit.svg';
import personalityImg from '../../assets/images/cherapp-ownership-coborrowing-ico-personality.svg';
import identificationImg from '../../assets/images/cherapp-ownership-coborrowing-ico-identification.svg';

class UserSugesterInput extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      inputContent: '',
      inviteUser: false,
      users: [],
    };
    this.setupClickListener();
  }

  setupClickListener() {
    document.addEventListener('click', (event) => {
      const suggesterContainer = document.getElementById('suggesterInputContainer');
      const isClickInside = suggesterContainer.contains(event.target);
      if (!isClickInside) {
        this.setState({ users: [] });
      }
    });
  }

  updateInputContent = (event) => {
    const inputContent = event.target.value;
    this.setState({ inputContent }, () => {
      this.requestUsers();
    });
  }

  requestUsers = async () => {
    const { inputContent } = this.state;
    const { isUserProfessional } = this.props;
    let params = {};
    if (isUserProfessional) {
      const professionalRoleInputs = Array.from(document.querySelectorAll('input[name="user[professional_role][]"]:checked'));
      const professionalRoles = professionalRoleInputs.map((input) => input.value);
      params = {
        user: {
          identifier: inputContent,
          professional_role: professionalRoles,
        },
      };
    } else {
      const verified = document.getElementById('suggesterInputValidId').checked;
      const personalityTest = document.getElementById('suggesterPersonalityTest').checked;
      const backgroundCheck = document.getElementById('suggesterBackgroundCheck').checked;
      params = {
         user: {
                identifier: inputContent,
                personality_test: personalityTest || null,
                background_check: backgroundCheck || null,
                verified: verified || null,
         },
      };
    }

    if (inputContent.length > 3) {
      axios.get('/users', {
        params,
        paramsSerializer() { return Qs.stringify(params, { arrayFormat: 'brackets' }); },
      })
      .then((response) => {
        if (response.status === 200) {
          this.handleResponse(response.data);
        }
      });
    } else {
      this.setState({ users: [] });
    }
  }

  inputContentIsEmail = () => {
    const { inputContent } = this.state;
    return /^\w+([.-]?\w+)*@\w+([.-]?\w+)*(\.\w{2,3})+$/.test(inputContent);
  }

  sendFriendRequest = async (email) => {
    const response = await axios.post('/invite', { email });
    if (response.status === 200) {
      this.setState({ inviteUser: false, inputContent: '' });
    }
  }

  handleResponse(users) {
    if (users.length) {
      this.setState({ users, inviteUser: false });
    } else {
      this.setState({ inviteUser: this.inputContentIsEmail(), users: [] });
    }
  }

  render() {
    const { inputContent, users, inviteUser } = this.state;
    const { isUserProfessional } = this.props;

    return (
      <div className="suggester-input">
        <form action="/social_networks" method="get">
          <div className="field">
            <div id="suggesterInputContainer" className="control has-icons-right">
              <input
                value={inputContent}
                type="text"
                name="user[identifier]"
                className="input has-icon is-search is-marginless"
                placeholder="input phone, email or name "
                required="required"
                autoComplete="off"
                onChange={this.updateInputContent}
              />
              <span className="icon is-small is-right">
                <FontAwesome name="search" />
              </span>
              <div className="is-relative">
                <div className="options-container">
                  { users.map((user) => <UserListItem user={user} key={user.id} />)}
                  { inviteUser
                  && (
                  <UserInvitation email={inputContent} sendFriendRequest={this.sendFriendRequest} />
                  )}
                </div>
              </div>
            </div>
          </div>
          <hr />
          <h5 className="is-size-5 is-bold m-b-md">Only Show People with:</h5>

          {isUserProfessional ? (
            <div>
              <div className="columns is-flex m-l-sm m-t-md">
                <div className="column is-paddingless">
                  <div className="field">
                    <input type="checkbox" className="is-checkradio" id="suggesterRealStateAgent" name="user[professional_role][]" value="estate_agent" />
                    <label htmlFor="suggesterRealStateAgent">
                      Real State Agent
                    </label>
                  </div>
                </div>
              </div>
              <div className="columns is-flex m-l-sm m-t-md">
                <div className="column is-paddingless">
                  <div className="field">
                    <input type="checkbox" className="is-checkradio" id="suggesterContractors" name="user[professional_role][]" value="general_contractor" />
                    <label htmlFor="suggesterContractors">
                      Contractors
                    </label>
                  </div>
                </div>
              </div>
              <div className="columns is-flex m-l-sm m-t-md">
                <div className="column is-paddingless">
                  <div className="field">
                    <input type="checkbox" className="is-checkradio" id="suggesterEscrowOfficer" name="user[professional_role][]" value="escrow_officer" />
                    <label htmlFor="suggesterEscrowOfficer">
                      Escrow Officer
                    </label>
                  </div>
                </div>
              </div>
              <div className="columns is-flex m-l-sm m-t-md">
                <div className="column is-paddingless">
                  <div className="field">
                    <input type="checkbox" className="is-checkradio" id="suggesterLoanOfficer" name="user[professional_role][]" value="loan_officer" />
                    <label htmlFor="suggesterLoanOfficer">
                      Loan Officer
                    </label>
                  </div>
                </div>
              </div>
              <div className="columns is-flex m-l-sm m-t-md">
                <div className="column is-paddingless">
                  <div className="field">
                    <input type="checkbox" className="is-checkradio" id="suggesterTitleOfficer" name="user[professional_role][]" value="title_officer" />
                    <label htmlFor="suggesterTitleOfficer">
                      Title Officer
                    </label>
                  </div>
                </div>
              </div>
              <div className="columns is-flex m-l-sm m-t-md">
                <div className="column is-paddingless">
                  <div className="field">
                    <input type="checkbox" className="is-checkradio" id="suggesterOther" name="user[professional_role][]" value="other" />
                    <label htmlFor="suggesterOther">
                      Other
                    </label>
                  </div>
                </div>
              </div>
            </div>
          ) : (
            <div>
              <div className="columns is-flex m-l-sm m-t-md">
                <div className="column is-paddingless">
                  <div className="field">
                    <input type="checkbox" className="is-checkradio" id="suggesterInputValidId" name="user[verified]" />
                    <label htmlFor="suggesterInputValidId">
                      Validated I.D
                    </label>
                  </div>
                </div>
                <div className="column-is-narrow is-paddingless">
                  <img src={identificationImg} alt="Identity" className="image is-24x24"/>
                </div>
              </div>
              <div className="columns is-flex m-l-sm m-t-md">
                <div className="column is-paddingless">
                  <div className="field">
                    <input type="checkbox" className="is-checkradio" id="suggesterPersonalityTest" name="user[personality_test]" />
                    <label htmlFor="suggesterPersonalityTest">
                      Personality Test
                    </label>
                  </div>
                </div>
                <div className="column-is-narrow is-paddingless">
                  <img src={personalityImg} alt="Test" className="image is-24x24"/>
                </div>
              </div>
              <div className="columns is-flex m-l-sm m-t-md">
                <div className="column is-paddingless">
                  <div className="field">
                    <input type="checkbox" className="is-checkradio" id="suggesterBackgroundCheck" name="user[background_check]" />
                    <label htmlFor="suggesterBackgroundCheck">
                      Background Check
                    </label>
                  </div>
                </div>
                <div className="column-is-narrow is-paddingless">
                  <img src={backgroundImg} alt="Card" className="image is-24x24"/>
                </div>
              </div>
            </div>
          )}
        </form>
      </div>
    );
  }
}
UserSugesterInput.propTypes = {
  isUserProfessional: PropTypes.bool.isRequired,
};

export default UserSugesterInput;
