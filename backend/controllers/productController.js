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
const getAllProducts = async (req, res) => {
    const products = await Product.find();
res.status(200).json(products);
};
module.exports = {
    addProduct,
    getAllProducts,
};