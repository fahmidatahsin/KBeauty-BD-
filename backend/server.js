require("dotenv").config();
console.log(process.env.JWT_SECRET);
const app = require("./app");
const connectDB = require("./config/db");

const PORT = process.env.PORT || 5000;

// Connect Database
connectDB();

app.listen(PORT, () => {
  console.log(`Server is running on port ${PORT}`);
});