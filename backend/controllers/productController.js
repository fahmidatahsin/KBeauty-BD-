const Product = require("../models/Product");
const Category = require("../models/Category");

// ===============================
// ADD PRODUCT
// ===============================
const addProduct = async (req, res) => {
    try {
        const {
            name,
            brand,
            category,
            price,
            description,
            image,
            stock,
        } = req.body;

        // Check category
        const existingCategory = await Category.findById(category);

        if (!existingCategory) {
            return res.status(404).json({
                message: "Category not found",
            });
        }

        // Create product
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
    } catch (error) {
        res.status(500).json({
            message: error.message,
        });
    }
};


// ===============================
// GET ALL PRODUCTS
// ===============================
const getAllProducts = async (req, res) => {
    try {
        const keyword = req.query.keyword;
        const category = req.query.category;
        const minPrice = req.query.minPrice;
        const maxPrice = req.query.maxPrice;
        const sort = req.query.sort;

        const page = Number(req.query.page) || 1;
        const limit = Number(req.query.limit) || 10;
        const skip = (page - 1) * limit;

        // Search query
        const searchQuery = keyword
            ? {
                  name: {
                      $regex: keyword,
                      $options: "i",
                  },
              }
            : {};

        // Category filter
        if (category) {
            searchQuery.category = category;
        }

        // Price filter
        if (minPrice || maxPrice) {
            searchQuery.price = {};

            if (minPrice) {
                searchQuery.price.$gte = Number(minPrice);
            }

            if (maxPrice) {
                searchQuery.price.$lte = Number(maxPrice);
            }
        }

        // Product query
        let query = Product.find(searchQuery)
            .populate("category")
            .skip(skip)
            .limit(limit);

        // Sorting
        if (sort === "price_asc") {
            query = query.sort({ price: 1 });
        } else if (sort === "price_desc") {
            query = query.sort({ price: -1 });
        } else if (sort === "newest") {
            query = query.sort({ createdAt: -1 });
        } else if (sort === "oldest") {
            query = query.sort({ createdAt: 1 });
        }

        // Total products
        const totalProducts = await Product.countDocuments(searchQuery);

        // Get products
        const products = await query;

        res.status(200).json({
            products,
            currentPage: page,
            totalPages: Math.ceil(totalProducts / limit),
            totalProducts,
        });
    } catch (error) {
        res.status(500).json({
            message: error.message,
        });
    }
};


// ===============================
// GET SINGLE PRODUCT
// ===============================
const getSingleProduct = async (req, res) => {
    try {
        const { id } = req.params;

        const product = await Product.findById(id)
            .populate("category");

        if (!product) {
            return res.status(404).json({
                message: "Product not found",
            });
        }

        res.status(200).json(product);
    } catch (error) {
        res.status(500).json({
            message: error.message,
        });
    }
};


// ===============================
// UPDATE PRODUCT
// ===============================
const updateProduct = async (req, res) => {
    try {
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

        // Check category
        if (category) {
            const existingCategory = await Category.findById(category);

            if (!existingCategory) {
                return res.status(404).json({
                    message: "Category not found",
                });
            }

            product.category = category;
        }

        product.name = name;
        product.brand = brand;
        product.price = price;
        product.description = description;
        product.image = image;
        product.stock = stock;

        await product.save();

        res.status(200).json({
            message: "Product updated successfully",
            product,
        });
    } catch (error) {
        res.status(500).json({
            message: error.message,
        });
    }
};


// ===============================
// DELETE PRODUCT
// ===============================
const deleteProduct = async (req, res) => {
    try {
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
    } catch (error) {
        res.status(500).json({
            message: error.message,
        });
    }
};


// ===============================
// EXPORT
// ===============================
module.exports = {
    addProduct,
    getAllProducts,
    getSingleProduct,
    updateProduct,
    deleteProduct,
};