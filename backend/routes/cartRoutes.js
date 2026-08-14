const express = require("express");
const router = express.Router();

const {
  addToCart,
  updateCart,
  removeFromCart,
  getCart,
} = require("../controllers/cartController");

const authMiddleware = require("../middleware/authMiddleware");

router.post("/", authMiddleware, addToCart);
router.put("/:productId", authMiddleware, updateCart);
router.delete("/:productId", authMiddleware, removeFromCart);
router.get("/", authMiddleware, getCart);

module.exports = router;