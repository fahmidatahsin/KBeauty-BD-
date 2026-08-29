const express = require("express");

const router = express.Router();

const {
  getDashboardStats,
  getAllUsers,
  deleteUser,
  getAllProducts,
  deleteProduct,
  getAllOrders,
  updateOrderStatus,
} = require("../controllers/adminController");
const { protect } = require("../middleware/authMiddleware");

const adminMiddleware = require("../middleware/adminMiddleware");
const { updateProduct } = require("../controllers/productController");

router.get(
  "/dashboard",
  protect,
  adminMiddleware,
  getDashboardStats
);
router.get("/users", protect, adminMiddleware, getAllUsers);
router.delete("/users/:id", protect, adminMiddleware, deleteUser);

router.get("/products", protect, adminMiddleware, getAllProducts);
router.put("/products/:id", protect, adminMiddleware, updateProduct);
router.delete("/products/:id", protect, adminMiddleware, deleteProduct);

router.get("/orders", protect, adminMiddleware, getAllOrders);

router.put(
  "/orders/:id",
  protect,
  adminMiddleware,
  updateOrderStatus
);

module.exports = router;