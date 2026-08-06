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
const getSingleProduct = async (req, res) => {
const { id } = req.params;
const product = await Product.findById(id);
if (!product) {
    return res.status(404).json({
        message: "Product not found",
    });
}
res.status(200).json(product);
};
const updateProduct = async (req, res) => {
const { id } = req.params;
const {
    name,
    brand,
    category,
    price,
    description,
    image,
    stock,
} = req.body;
const product = await Product.findById(id);
if (!product) {
    return res.status(404).json({
        message: "Product not found",
    });
}
product.name = name;
product.brand = brand;
product.category = category;
product.price = price;
product.description = description;
product.image = image;
product.stock = stock;
await product.save();
res.status(200).json({
    message: "Product updated successfully",
    product,
});
};
const deleteProduct = async (req, res) => {
const { id } = req.params;
const product = await Product.findById(id);
if (!product) {
    return res.status(404).json({
        message: "Product not found",
    });
}
await product.deleteOne();
res.status(200).json({
    message: "Product deleted successfully",
});
};
module.exports = {
    addProduct,
    getAllProducts,
    getSingleProduct,
    updateProduct,
    deleteProduct,
};