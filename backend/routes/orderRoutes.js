const express = require("express");
const router = express.Router();

const {
  placeOrder,
  getOrderHistory,
  getOrderDetails,
} = require("../controllers/orderController");

const authMiddleware = require("../middleware/authMiddleware");

// 🛒 Place Order
router.post("/", authMiddleware, placeOrder);

// 📋 Order History
router.get("/", authMiddleware, getOrderHistory);

// 🔍 Order Details
router.get("/:id", authMiddleware, getOrderDetails);

module.exports = router;