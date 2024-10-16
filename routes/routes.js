const express = require('express');
const homeController = require("../controller/HomeController")

const app = express();

app.use("/" , homeController.index);

module.exports = app;