const express = require("express");
const router = express.Router();

const {
    addProduct,
    getAllProducts,
    getSingleProduct,
} = require("../controllers/productController");
router.get("/", getAllProducts);
router.post("/", addProduct);
router.get("/:id", getSingleProduct);
module.exports = router;