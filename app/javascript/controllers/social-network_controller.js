import { Controller } from 'stimulus';
import axios from '../packs/axios_utils.js';

export default class extends Controller {
  static targets = ['container', 'importSection']

  connect() {
    this.initializeSocialLibraries();
    const urlParams = new URLSearchParams(window.location.search);
    const tab = urlParams.get('tab');

    if (tab === 'agents') {
      this.toogleView({target: document.getElementById('displayAgentsButton')});
    }
  }

  initializeSocialLibraries = () => {
    gapi.load('client', this.buildGoogleClient);
    window.fbAsyncInit = () => {
      const appId = document.querySelector('body').getAttribute('facebook-app-id');
      FB.init({
        appId,
        autoLogAppEvents: true,
        xfbml: true,
        version: 'v2.7',
      });
    };
  }

  buildGoogleClient = () => {
    const clientId = document.querySelector('body').getAttribute('google-client-id');
    const apiKey = document.querySelector('body').getAttribute('google_key');
    gapi.client.init({
      apiKey,
      clientId,
      discoveryDocs: ['https://people.googleapis.com/$discovery/rest'],
      scope: 'profile email https://www.googleapis.com/auth/contacts.readonly',
    });
  }

  importFromGoogle = () => {
    const google = gapi.auth2.getAuthInstance();
    google.signIn()
    .then(async () => {
      const response = await gapi.client.people.people.get({
        resourceName: 'people/me/connections',
        'requestMask.includeField': 'person.names,person.emailAddresses',
      });
      if (response.result.connections) {
        const connections = Object.values(response.result.connections);
        const filteredConnectionsEmail = connections.reduce((connectionsEmail, connection) => (
          connection.emailAddresses
            ? [...connectionsEmail, connection.emailAddresses[0].value]
            : connectionsEmail
        ), []);
        this.requestConnections(filteredConnectionsEmail, 'google');
      }
    });
  }

  requestConnections = (data, socialMediaResource) => {
    axios.get('/users_importer/new', { params: { identifiers: data, social_network: socialMediaResource } })
    .then((response) => {
      if (response.status === 200) {
        const importedUsersContainer = document.getElementById('importedUsersContainer');
        if (importedUsersContainer) {
          this.importSectionTarget.classList.remove('is-hidden');
          importedUsersContainer.innerHTML = response.data.html;
        }
      }
    });
  }

  importFromFacebook = () => {
    FB.getLoginStatus((authResponse) => {
      if (authResponse.status === 'connected') {
        this.requestFacebokUsers();
      } else {
        FB.login((response) => {
          if (response.authResponse.status === 'connected') {
            this.requestFacebokUsers();
          }
        });
      }
    });
  }

  requestFacebokUsers = () => {
    FB.api('/me?fields=friends{id}', (response) => {
      const usersIds = response.friends.data.map((friend) => friend.id);
      this.requestConnections(usersIds, 'facebook');
    }, { scope: 'user_friends' });
  }

  toogleView(event) {
    const { targetContainerId } = event.target.dataset;
    const targetContainer = document.getElementById(targetContainerId);
    if (targetContainer) {
      this.containerTargets.forEach((container) => container.classList.add('is-hidden'));
      document.querySelectorAll('.navigational-button').forEach((button) => {
        button.classList.remove('is-active');
      });
      targetContainer.classList.remove('is-hidden');
      event.target.classList.add('is-active');
      this.importSectionTarget.classList.add('is-hidden');
    }
  }
}
