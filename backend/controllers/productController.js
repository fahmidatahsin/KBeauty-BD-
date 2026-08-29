const Product = require("../models/Product");
const Category = require("../models/Category");
const Brand = require("../models/Brand");

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

    // Check brand
    const existingBrand = await Brand.findById(brand);

    if (!existingBrand) {
      return res.status(404).json({
        message: "Brand not found",
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
    const {
      keyword,
      category,
      minPrice,
      maxPrice,
      sort,
    } = req.query;

    const page = Number(req.query.page) || 1;
    const limit = req.query.limit
      ? Number(req.query.limit)
      : null;

    const skip = limit
      ? (page - 1) * limit
      : 0;

    // Search query
    const searchQuery = {};

    if (keyword) {
      searchQuery.name = {
        $regex: keyword,
        $options: "i",
      };
    }

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

    // Build query
    let query = Product.find(searchQuery)
      .populate("category")
      .populate("brand")
      .skip(skip);

    if (limit) {
      query = query.limit(limit);
    }

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
    const totalProducts = await Product.countDocuments(
      searchQuery
    );

    // Get products
    const products = await query;

    res.status(200).json({
      products,
      currentPage: page,
      totalPages: limit
        ? Math.ceil(totalProducts / limit)
        : 1,
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
      .populate("category")
      .populate("brand");

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

    // Check and update category
    if (category) {
      const existingCategory = await Category.findById(category);

      if (!existingCategory) {
        return res.status(404).json({
          message: "Category not found",
        });
      }

      product.category = category;
    }

    // Check and update brand
    if (brand) {
      const existingBrand = await Brand.findById(brand);

      if (!existingBrand) {
        return res.status(404).json({
          message: "Brand not found",
        });
      }

      product.brand = brand;
    }

    // Only change fields provided by the dashboard
    if (name !== undefined) {
      product.name = name;
    }

    if (price !== undefined) {
      product.price = price;
    }

    if (description !== undefined) {
      product.description = description;
    }

    if (image !== undefined) {
      product.image = image;
    }

    if (stock !== undefined) {
      const stockNumber = Number(stock);

      if (!Number.isInteger(stockNumber) || stockNumber < 0) {
        return res.status(400).json({
          message: "Stock must be a non-negative whole number",
        });
      }

      product.stock = stockNumber;
    }

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