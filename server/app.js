const express = require("express");
require("dotenv").config();

const app = express();
const port = process.env.PORT;
const hostname = process.env.HOST;

app.listen(port, () => {
    console.log(`Server running on port: ${port}`);
});