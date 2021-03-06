const request = require('request-promise');
const utf8 = require('utf8');
const Parser = require('../lib/parser');

const hosts = [
	"72.191.219.159",
	"23.94.123.28:8080",
	"24.28.154.227:8080",
	"211.181.142.155",
	"24.60.64.82:8080",
	"24.60.64.82:8080",
	"24.117.20.91",
	"24.117.20.91",
	"24.14.243.46:8080",
	"24.183.188.250:8081",
	"41.86.178.42:8080",
	"50.66.185.122:8000",
	"50.88.7.19",
	"50.170.111.245:8080",
	"50.186.64.134",
	"52.43.215.155",
	"52.64.177.67",
	"69.69.164.139:8888",
	"70.70.158.63",
	"71.90.204.102",
	"73.164.30.34:8080",
	"74.129.250.46:8888",
	"75.19.8.28:8080",
	"96.51.188.58:8080",
	"98.214.170.70",
	"98.232.181.142:8787",
	"104.50.8.212:8080",
	"107.170.128.62:8080",
	"108.63.56.243:9080",
	"118.208.243.87/category/allbooks",
	"119.236.134.86",
	"137.74.112.209",
	"217.35.162.117/",
	"173.48.114.20:8000",
	"173.94.108.253",
	"ebooks.wsd.net:8080",
	"184.100.235.173:8080",
	"198.199.7.10",
	"traviata.dyndns.org:2208",
	"203.160.127.78:8080"
]

const search = async (host, text) => {
	const uri = "http://" + host + "/mobile?num=9999999&search=" + utf8.encode(text) +  "&sort=title&order=ascending";
	const options = {
		uri,
		resolveWithFullResponse: true
	}
	try {
		const response = await request.get(options);
		if (response.statusCode === 200) {
			const parser = Parser(host, response.body);
			return parser.getResults();
		}
		console.log(`Not OK response searching for ${text} on ${host}. Status Code: ${response.statusCode}`);
		return [];
	} catch (error) {
		console.log(`Error searching for ${text} on ${host}`);
		return [];
	}
}

const searchEverywhere = async (text) => {
	const allResults = await Promise.all(hosts.map(host => search(host, text)));
	return allResults.reduce((results, hostResults) => results.concat(hostResults), [])
}

module.exports = function(app, db) {
	app.use(function(req, res, next) {
		res.header("Access-Control-Allow-Origin", "*");
		res.header("Access-Control-Allow-Headers", "Origin, X-Requested-With, Content-Type, Accept");
		next();
	})

	app.post('/search', async (req, res) => {
		const text = req.body.text;
		try {
			const results = await searchEverywhere(text)
			console.log('got results!!!', results);
			res.json(results)
		} catch (error) {
			console.log(error);
			res.status(500).json({ message: err.message })
		}
	});
};
