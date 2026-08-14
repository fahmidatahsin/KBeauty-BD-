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

const authMiddleware = require("../middleware/authMiddleware");
const adminMiddleware = require("../middleware/adminMiddleware");

// =========================
// 👥 MANAGE USERS
// =========================

router.get("/users", authMiddleware, adminMiddleware, getAllUsers);

router.delete("/users/:id", authMiddleware, adminMiddleware, deleteUser);


// =========================
// 📦 MANAGE PRODUCTS
// =========================

router.get("/products", authMiddleware, adminMiddleware, getAllProducts);

router.delete("/products/:id", authMiddleware, adminMiddleware, deleteProduct);


// =========================
// 🛒 MANAGE ORDERS
// =========================

router.get("/orders", authMiddleware, adminMiddleware, getAllOrders);

router.put(
  "/orders/:id",
  authMiddleware,
  adminMiddleware,
  updateOrderStatus
);

module.exports = router;