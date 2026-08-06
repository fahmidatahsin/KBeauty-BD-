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
module.exports = {
    addCategory,
};