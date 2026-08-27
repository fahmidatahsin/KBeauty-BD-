const express = require("express");

const router = express.Router();

const {
  getAllUsers,
  deleteUser,
  getAllProducts,
  deleteProduct,
  getAllOrders,
  updateOrderStatus,
} = require("../controllers/adminController");

const { protect } = require("../middleware/authMiddleware");

const adminMiddleware = require("../middleware/adminMiddleware");

router.get("/users", protect, adminMiddleware, getAllUsers);
router.delete("/users/:id", protect, adminMiddleware, deleteUser);

router.get("/products", protect, adminMiddleware, getAllProducts);
router.delete("/products/:id", protect, adminMiddleware, deleteProduct);

router.get("/orders", protect, adminMiddleware, getAllOrders);

router.put(
  "/orders/:id",
  protect,
  adminMiddleware,
  updateOrderStatus
);

module.exports = router;