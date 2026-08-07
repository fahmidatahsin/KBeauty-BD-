const Product = require("../models/Product");
const Category = require("../models/Category");
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
const existingCategory = await Category.findById(category);

if (!existingCategory) {
    return res.status(404).json({
        message: "Category not found",
    });
}
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
    const keyword = req.query.keyword;
    const category = req.query.category;
    const minPrice = req.query.minPrice;
    const maxPrice = req.query.maxPrice;
    const sort = req.query.sort;
    const searchQuery = keyword
    ? {
        name: {
            $regex: keyword,
            $options: "i",
        },
    }
    : {};
    if (category) {
    searchQuery.category = category;
}
if (minPrice || maxPrice) {
    searchQuery.price = {};

    if (minPrice) {
        searchQuery.price.$gte = Number(minPrice);
    }

    if (maxPrice) {
        searchQuery.price.$lte = Number(maxPrice);
    }
}

    let query = Product.find(searchQuery).populate("category");
    if (sort === "price_asc") {
    query = query.sort({ price: 1 });
} else if (sort === "price_desc") {
    query = query.sort({ price: -1 });
} else if (sort === "newest") {
    query = query.sort({ createdAt: -1 });
} else if (sort === "oldest") {
    query = query.sort({ createdAt: 1 });
}
const products = await query;
res.status(200).json(products);
};
const getSingleProduct = async (req, res) => {
const { id } = req.params;
const product = await Product.findById(id).populate("category");
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