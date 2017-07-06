// server.js
const express = require('express');
const bodyParser = require('body-parser');

const app = express();

app.use(bodyParser.urlencoded({ extended: true }));
app.use(bodyParser.json())
app.use(express.static('public'))

require('./routes')(app, {});

const port = process.env.PORT || 8000;
app.listen(port, () => {
  console.log('We are live on ' + port);
})
