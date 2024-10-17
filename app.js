const express = require("express");
const routes = require("./routes/routes");

const app = express();

app.set('view engine', 'ejs');

app.use("/" , routes);

const PORT = 3000;

app.listen(PORT , console.log("Server Created at port 3000"));
