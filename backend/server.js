const path = require("path");
const express = require("express");

require("dotenv").config({
  path: path.join(__dirname, ".env"),
});

const app = require("./app");
const connectDB = require("./config/db");

// ============================================================
// SERVE UPLOADED PRODUCT IMAGES
// ============================================================

app.use(
  "/assets/images",
  express.static(path.join(__dirname, "uploads"))
);

// ============================================================
// PORT
// ============================================================

const PORT = process.env.PORT || 5000;

// ============================================================
// CONNECT DATABASE
// ============================================================

connectDB();

// ============================================================
// START SERVER
// ============================================================

app.listen(PORT, () => {
  console.log(`Server is running on port ${PORT}`);
});