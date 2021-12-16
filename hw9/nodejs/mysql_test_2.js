
var mysql = require('mysql');
const config = require('./config.json');

// create the connection
var con = mysql.createConnection(config);

// basic query example
var query = `SELECT COUNT(*) as total 
             FROM film_category JOIN film USING (film_id) 
             WHERE category_id = ? AND INSTR(title, ?)`;

var category = 2;
var keyword = 't';

// open the connection
con.connect(function(err) {
    if (err) throw err;
    console.log('>>> Connected to the database');
});

// run the query and log to output
con.query(query, [category, keyword], function(err, result, fields) {
    if (err) throw err;
    for (const r of result) {
        console.log(r['total']);
    }
});

// close the connection
con.end(function(err) {
    if (err) throw err;
    console.log('>>> Connection to the database closed');
});
