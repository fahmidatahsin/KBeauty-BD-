const express = require("express");
const router = express.Router();
const { protect } = require("../middleware/authMiddleware");
const {
    addProduct,
    getAllProducts,
    getSingleProduct,
    updateProduct,
    deleteProduct,
} = require("../controllers/productController");
router.get("/", getAllProducts);
router.post("/", protect, addProduct);
router.get("/:id", getSingleProduct);
router.put("/:id", updateProduct);
router.delete("/:id", deleteProduct);
module.exports = router;