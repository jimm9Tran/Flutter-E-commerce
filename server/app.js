const express = require('express');
const bodyParser = require('body-parser');
const cors = require('cors');
const morgan = require('morgan');
const mongoose = require('mongoose');
require('dotenv/config');
const authJwt = require('./middlewares/jwt');
const errorHandler = require('./middlewares/error_handler');
const authorizePostRequests = require('./middlewares/authorization');

const app = express();
const API = process.env.API_URL;


app.use(bodyParser.json());
app.use(morgan('tiny'));
app.use(cors());
app.options('*', cors());
app.use(authorizePostRequests)
app.use(authJwt());
app.use(errorHandler);

const authRouter = require('./routes/auth');
const usersRouter = require('./routes/users');
const adminRouter = require('./routes/admin');
const categoriesRouter = require('./routes/categories');
const productsRouter = require('./routes/products');
const checkoutRouter = require('./routes/checkout');


app.use(`${API}/`, authRouter);
app.use(`${API}/users`, usersRouter);
app.use(`${API}/admin`, adminRouter);
app.use(`${API}/categories`, categoriesRouter);
app.use(`${API}/products`, productsRouter);
app.use('/public', express.static(__dirname + '/public'));

const hostname = process.env.HOSTNAME;
const port = process.env.PORT;

require('./helpers/cron_job');

mongoose
    .connect(process.env.MONGODB_CONNECTION)
    .then(() => {
        console.log("Connected to Database");
    })
    .catch((error) => {
        console.error(error);
    });

// Start the server
app.listen(port, hostname, () => {
    console.log(`Server running at http://${hostname}:${port}`);
});