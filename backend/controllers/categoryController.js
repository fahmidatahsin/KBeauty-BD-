const Category = require("../models/Category");
const addCategory = async (req, res) => {
const { name } = req.body;
const existingCategory = await Category.findOne({ name });
if (existingCategory) {
    return res.status(400).json({
        message: "Category already exists",
    });
}
const category = new Category({
    name,
});
await category.save();
res.status(201).json({
    message: "Category added successfully",
    category,
});
};
const getAllCategories = async (req, res) => {
const categories = await Category.find();
res.status(200).json(categories);
};
const getSingleCategory = async (req, res) => {
const { id } = req.params;
const category = await Category.findById(id);
if (!category) {
    return res.status(404).json({
        message: "Category not found",
    });
}
res.status(200).json(category);
};
const updateCategory = async (req, res) => {
const { id } = req.params;
const { name } = req.body;
const category = await Category.findById(id);
if (!category) {
    return res.status(404).json({
        message: "Category not found",
    });
}
category.name = name;
await category.save();
res.status(200).json({
    message: "Category updated successfully",
    category,
});
};
const deleteCategory = async (req, res) => {
const { id } = req.params;
const category = await Category.findById(id);
if (!category) {
    return res.status(404).json({
        message: "Category not found",
    });
}
await category.deleteOne();
res.status(200).json({
    message: "Category deleted successfully",
});
};    
module.exports = {
    addCategory,
    getAllCategories,
    getSingleCategory,
    updateCategory,
    deleteCategory,
};