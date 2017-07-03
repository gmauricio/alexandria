// routes/note_routes.js
var request=require('request');

module.exports = function(app, db) {
  app.post('/search', (req, res) => {
	const text = req.body.text;
	const server = "72.191.219.159";
	const url = "http://" + server + "/mobile?num=9999999&search=" + text +  "&sort=title&order=ascending";
	request.get(url,null,function(err_,res_,body){
	  if (err_) console.log(err_);
	  if(res_.statusCode === 200 ) res.json({ results: body });   ;
	});
  });
};