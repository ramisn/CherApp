import { Controller } from 'stimulus';

const mixpanel = require('mixpanel-browser');

export default class extends Controller {
  static targets = ['link']

  connect() {
    const mixpanelToken = document.body.getAttribute('data-mixpanel-token');
    if (!mixpanelToken) return;

    mixpanel.init(mixpanelToken, { cross_subdomain_cookie: false });
    this.identifyUser();
    this.trackpageView();
    this.clearTracking();
    this.setupLinkTracker();
  }

  setupLinkTracker() {
    this.linkTargets.forEach((link) => {
      mixpanel.track_links(link, link.dataset.linkMessage);
    });
  }

  trackpageView = () => {
    const pageInput = document.getElementById('currentPageInput');
    if (!pageInput) return;

    mixpanel.track(`See ${pageInput.value}`);
  }

  identifyUser = () => {
    const userEmailInput = document.getElementById('currentUserEmailInput');
    if (!userEmailInput) return;

    mixpanel.identify(userEmailInput.value);
  }

  clearTracking = () => {
    const userSignedOut = document.getElementById('userSignedOut');
    if (userSignedOut) {
      mixpanel.reset();
    }
  }

  trackEvent = (event) => {
    const { eventName } = event.target.dataset;
    mixpanel.track(eventName);
  }
}
