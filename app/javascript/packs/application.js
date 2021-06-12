// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

require('@rails/ujs').start();
require('turbolinks').start();
require('trix/dist/trix');
require('channels');
require('./landingPage');
require('./navbar');
require('./vouched');
require('./maps');
require('./sign_up_pop_up');
require('./google_analytics');
// Uncomment to copy all static images under ../images to the output folder and reference
// them with the image_pack_tag helper in views (e.g <%= image_pack_tag 'rails.png' %>)
// or the `imagePath` JavaScript helper below.
//
// const images = require.context('../../assets/images', true);
// const imagePath = (name) => images(`cherapp-ownership-coborrowing-${name}`, true);

import 'controllers';

require('trix');
require('@rails/actiontext');
// Support component names relative to this directory:
var componentRequireContext = require.context('components', true);
var ReactRailsUJS = require('react_ujs');
ReactRailsUJS.useContext(componentRequireContext);
