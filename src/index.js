'use strict'


require('semantic-ui-css/semantic.min.css');

// Require index.html so it gets copied to dist
require('./index.html');

const Elm = require('./Main.elm')

// get a reference to the div where we will show our UI
const container = document.getElementById('container')

// start the elm app in the container
// and keep a reference for communicating with the app
const app = Elm.Main.embed(container, { apiHost: process.env.API_BASE_URL || 'http://localhost:8000' })