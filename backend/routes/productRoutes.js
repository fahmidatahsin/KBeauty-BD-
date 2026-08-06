const express = require("express");
const router = express.Router();

const {
    addProduct,
    getAllProducts,
    getSingleProduct,
    updateProduct,
} = require("../controllers/productController");
router.get("/", getAllProducts);
router.post("/", addProduct);
router.get("/:id", getSingleProduct);
router.put("/:id", updateProduct);
module.exports = router;