const express =  require('express');
const bodyParser = require('body-parser');
const cors = require('cors');
const morgan = require('morgan');
const mongoose = require('mongoose');
require('dotenv/config');

const app = express();
const API = process.env.API_URL;
const authJwt = require('./middlewares/jwt');
const errorHandler = require('./middlewares/error_handler');

app.use(bodyParser.json());
app.use(morgan('tiny'));
app.use(cors());
app.options('*', cors());
app.use(authJwt);
app.use(errorHandler);

const authRouter = require('./routes/auth');
const usersRouter = require('./routes/users');
const adminRouter = require('./routes/admin');

app.use(`${API}/`, authRouter);
app.use(`${API}/users`, usersRouter);
app.use(`${API}/admin`, adminRouter);

const hostname = process.env.HOSTNAME;
const port = process.env.PORT;

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