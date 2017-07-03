const request = require('request');

module.exports = function(app, db) {
	app.use(function(req, res, next) {
		res.header("Access-Control-Allow-Origin", "*");
		res.header("Access-Control-Allow-Headers", "Origin, X-Requested-With, Content-Type, Accept");
		next();
	})

  app.post('/search', (req, res) => {
		const text = req.body.text;
		const host = "72.191.219.159";
		const url = "http://" + host + "/mobile?num=9999999&search=" + text +  "&sort=title&order=ascending";
		request.get(url,null, (err, response, html) => {
			if (err) console.log(err);
			if (response.statusCode === 200 ) res.json([ { host, html } ]);
		});
  });
};