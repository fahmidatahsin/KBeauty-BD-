const express = require("express");
const router = express.Router();

const {
  addToCart,
  updateCart,
  removeFromCart,
  getCart,
} = require("../controllers/cartController");

const { protect } = require("../middleware/authMiddleware");

router.post("/", protect, addToCart);
router.put("/:productId", protect, updateCart);
router.delete("/:productId", protect, removeFromCart);
router.get("/", protect, getCart);

module.exports = router;