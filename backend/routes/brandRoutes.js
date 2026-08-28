const express = require("express");

const router = express.Router();


const { protect } = require("../middleware/authMiddleware");
const adminMiddleware = require("../middleware/adminMiddleware");

const {
  createBrand,
  getBrands,
  getBrand,
  updateBrand,
  deleteBrand,
} = require("../controllers/brandController");

// Public routes
router.get("/", getBrands);
router.get("/:id", getBrand);

// Admin-only routes
router.post("/", protect, adminMiddleware, createBrand);
router.put("/:id", protect, adminMiddleware, updateBrand);
router.delete("/:id", protect, adminMiddleware, deleteBrand);

module.exports = router;