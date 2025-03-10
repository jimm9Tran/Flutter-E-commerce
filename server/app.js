const express =  require('express');
const bodyParser = require('body-parser');
const cors = require('cors');
const morgan = require('morgan');
const mongoose = require('mongoose');
require('dotenv/config');

const app = express();
const API = process.env.API_URL;

app.use(bodyParser.json());
app.use(morgan('tiny'));
app.use(cors());
app.options('*', cors());

const authRouter = require('./routes/auth');

app.use(`${API}/`, authRouter);

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