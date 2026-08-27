const express = require("express");

const router = express.Router();

const { protect } = require("../middleware/authMiddleware");
const adminMiddleware = require("../middleware/adminMiddleware");

const {
  addCategory,
  getAllCategories,
  getSingleCategory,
  updateCategory,
  deleteCategory,
} = require("../controllers/categoryController");

// 👥 Public routes
router.get("/", getAllCategories);

router.get("/:id", getSingleCategory);

// 🔐 Admin-only routes
router.post("/", protect, adminMiddleware, addCategory);

router.put("/:id", protect, adminMiddleware, updateCategory);

router.delete("/:id", protect, adminMiddleware, deleteCategory);

module.exports = router;