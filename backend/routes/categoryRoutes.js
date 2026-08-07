const express = require("express");
const router = express.Router();

const {
    addCategory,
    getAllCategories,
    getSingleCategory,
    updateCategory,
    deleteCategory,
} = require("../controllers/categoryController");
router.get("/", getAllCategories);
router.post("/", addCategory);
router.get("/:id", getSingleCategory);
router.put("/:id", updateCategory);
router.delete("/:id", deleteCategory);
module.exports = router;