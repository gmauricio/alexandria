const request = require('request');
const utf8 = require('utf8');
const Parser = require('../lib/parser')

module.exports = function(app, db) {
	app.use(function(req, res, next) {
		res.header("Access-Control-Allow-Origin", "*");
		res.header("Access-Control-Allow-Headers", "Origin, X-Requested-With, Content-Type, Accept");
		next();
	})

  app.post('/search', (req, res) => {
		const text = req.body.text;
		const host = "72.191.219.159";
		const url = "http://" + host + "/mobile?num=9999999&search=" + utf8.encode(text) +  "&sort=title&order=ascending";
		request.get(url,null, (err, response, html) => {
			const parser = Parser(host, html);
			if (err) {
				console.log(err);
				res.status(500).json({ message: err.message })
			}
			if (response.statusCode === 200 ) {
				res.json(parser.getResults())
			} else {
				console.log('status', response.statusCode);
				res.status(500).json({ message: 'Unknown error' })
			}
		});
  });
};