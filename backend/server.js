const path = require("path");

require("dotenv").config({
  path: path.join(__dirname, ".env"),
});

const app = require("./app");
const connectDB = require("./config/db");

const PORT = process.env.PORT || 5000;

// Connect Database
connectDB();

app.listen(PORT, () => {
  console.log(`Server is running on port ${PORT}`);
});

