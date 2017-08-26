'use strict';

const express = require('express');

let app = express();



app.get('/',(req, res) => {
	
	res.json({message: 'Hello World.'});
});

app.listen(3000, () => {
	console.log('app listening to port 3000');
});
