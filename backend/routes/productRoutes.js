const express = require("express");

const router = express.Router();

const { protect } = require("../middleware/authMiddleware");
const adminMiddleware = require("../middleware/adminMiddleware");

const {
  addProduct,
  getAllProducts,
  getSingleProduct,
  updateProduct,
  deleteProduct,
} = require("../controllers/productController");

// Public routes
router.get("/", getAllProducts);
router.get("/:id", getSingleProduct);

//  Admin-only routes
router.post("/", protect, adminMiddleware, addProduct);

router.put("/:id", protect, adminMiddleware, updateProduct);

router.delete("/:id", protect, adminMiddleware, deleteProduct);

module.exports = router;