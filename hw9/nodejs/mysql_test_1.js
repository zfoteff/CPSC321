
var mysql = require('mysql');
const config = require('./config.json');

// create the connection
var con = mysql.createConnection(config);

// basic query example
var query = 'SELECT * FROM category ORDER BY name';

// open the connection
con.connect(function(err) {
    if (err) throw err;
    console.log('>>> Connected to the database');
});

// run the query and log to output
con.query(query, function(err, result, fields) {
    if (err) throw err;
    for (const r of result) {
        console.log(r['name']);
    }
});

// close the connection
con.end(function(err) {
    if (err) throw err;
    console.log('>>> Connection to the database closed');
});
