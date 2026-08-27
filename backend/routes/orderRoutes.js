const express = require("express");

const router = express.Router();

const {
  placeOrder,
  getOrderHistory,
  getOrderDetails,
} = require("../controllers/orderController");

const { protect } = require("../middleware/authMiddleware");
console.log("protect:", typeof protect);
console.log("placeOrder:", typeof placeOrder);
// 🛒 Place Order
router.post("/", protect, placeOrder);

// 📋 Order History
router.get("/", protect, getOrderHistory);

// 🔍 Order Details
router.get("/:id", protect, getOrderDetails);

module.exports = router;