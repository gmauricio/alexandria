'use strict';

const search = require('./search');
module.exports = function(app, db) {
  search(app, db);
};
