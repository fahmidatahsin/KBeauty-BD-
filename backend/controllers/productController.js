const Product = require("../models/Product");
const addProduct = async (req, res) => {
    const {
    name,
    brand,
    category,
    price,
    description,
    image,
    stock,
} = req.body;
const product = new Product({
    name,
    brand,
    category,
    price,
    description,
    image,
    stock,
});
await product.save();
res.status(201).json({
    message: "Product added successfully",
    product,
});
};
module.exports = {
    addProduct,
};