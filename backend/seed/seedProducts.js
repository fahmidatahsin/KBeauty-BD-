require("dotenv").config();
const mongoose = require("mongoose");

const Product = require("../models/Product");
const Category = require("../models/Category");

const products = [
  {
    name: "SKIN1004 Madagascar Centella Tone Brightening Cleansing Gel Foam 125ml",
    price: 1450,
    category: "Cleanser",
    brand: "SKIN1004",
    image:
      "assets/images/SKIN1004 Madagascar Centella Tone Brightening Cleansing Gel Foam 125ml.jpeg",
    rating: 5,
  },
  {
    name: "Bonajour Ginger Aqua Relief Pad 60 Pads",
    price: 1700,
    category: "Pads",
    brand: "BONAJOUR",
    image: "assets/images/GinerReliefPad.jpg",
    rating: 5,
  },
  {
    name: "AXIS-Y Heartleaf My Type Calming Cream 60ml",
    price: 1650,
    category: "Moisturizer",
    brand: "AXIS-Y",
    image:
      "assets/images/AXIS-Y Heartleaf My Type Calming Cream 60ml.jpeg",
    rating: 5,
  },
  {
    name: "SKIN1004 Madagascar Centella Soothing Cream 75ml",
    price: 1850,
    category: "Moisturizer",
    brand: "SKIN1004",
    image:
      "assets/images/SKIN1004-Centella Soothing Cream 75ml.jpeg",
    rating: 5,
  },
  {
    name: "SKIN1004 Madagascar Centella Probio-Cica Enrich Cream 50ml",
    price: 2250,
    category: "Moisturizer",
    brand: "SKIN1004",
    image:
      "assets/images/SKIN1004-Probio-Cica Enrich Cream 50ml.jpeg",
    rating: 5,
  },
  {
    name: "Bonajour Jeju Milk Soft Foaming Cleanser 160ml",
    price: 1700,
    category: "Cleanser",
    brand: "BONAJOUR",
    image: "assets/images/boanjourFoamingCleanser.webp",
    rating: 5,
  },
  {
    name: "Dear, KLAIRS Gentle Black Fresh Cleansing Oil 150ml",
    price: 2100,
    category: "Cleanser",
    brand: "KLAIRS",
    image: "assets/images/KLAIRS Cleansing Oil 150ml.jpeg",
    rating: 5,
  },
  {
    name: "Bonajour Ginger Aqua Relief Sun Cream 40ml",
    price: 1700,
    category: "Sun Care",
    brand: "BONAJOUR",
    image: "assets/images/bonajourGingercream.png",
    rating: 5,
  },
  {
    name: "AXIS-Y Cera-Heart My Type Duo Cream 60ml",
    price: 2200,
    category: "Moisturizer",
    brand: "AXIS-Y",
    image: "assets/images/AXIS-Y Duo Cream 60ml.jpeg",
    rating: 5,
  },
  {
    name: "Bonajour Ginger Aqua Relief Foam Cleanser",
    price: 0,
    category: "Cleanser",
    brand: "BONAJOUR",
    image:
      "assets/images/Bonajour Ginger Aqua Relief Foam Cleanser.jpg",
    rating: 4,
    stock: 0,
  },
  {
    name: "SKIN1004 Madagascar Centella Hyalu-Cica Moisture Cream 75ml",
    price: 2200,
    category: "Moisturizer",
    brand: "SKIN1004",
    image:
      "assets/images/SKIN1004 Hyalu-Cica Moisture Cream.jpeg",
    rating: 5,
  },
  {
    name: "SKIN1004 Madagascar Centella Hyalu-Cica Water-Fit Sun Serum 50ml",
    price: 1850,
    category: "Sun Care",
    brand: "SKIN1004",
    image:
      "assets/images/SKIN1004 Water-Fit Sun Serum.jpeg",
    rating: 5,
  },
  {
    name: "AXIS-Y Daily Purifying Treatment Toner 200ml",
    price: 1650,
    category: "Toner",
    brand: "AXIS-Y",
    image:
      "assets/images/AXIS-Y Daily Purifying Toner.jpeg",
    rating: 5,
  },
  {
    name: "Dear KLAIRS Gentle Black Facial Cleanser 20mL",
    price: 600,
    category: "Cleanser",
    brand: "KLAIRS",
    image:
      "assets/images/KLAIRSGentleBlackFacialCleanser20mL.webp",
    rating: 5,
  },
  {
    name: "AXIS-Y Dark Spot Correcting Glow Toner 120ml",
    price: 1850,
    category: "Toner",
    brand: "AXIS-Y",
    image:
      "assets/images/AXIS-Y Correcting Glow Toner.jpeg",
    rating: 5,
  },
  {
    name: "Dear, KLAIRS Fundamental Water Gel Cream 50ml",
    price: 2200,
    category: "Moisturizer",
    brand: "KLAIRS",
    image:
      "assets/images/KLAIRS Water Gel Cream.jpeg",
    rating: 5,
  },
  {
    name: "SKIN1004 Madagascar Centella Probio-Cica Intensive Ampoule 50ml",
    price: 2250,
    category: "Serum",
    brand: "SKIN1004",
    image:
      "assets/images/SKIN1004 Probio-Cica Intensive Ampoule.jpeg",
    rating: 5,
  },
  {
    name: "Dear, KLAIRS All-day Airy Sunscreen SPF50+ PA++++ 50ml",
    price: 2000,
    category: "Sun Care",
    brand: "KLAIRS",
    image: "assets/images/KLAIRS Sunscreen.jpeg",
    rating: 5,
  },
  {
    name: "Beauty of Joseon Calming Serum Green Tea + Panthenol 30ml",
    price: 1650,
    category: "Serum",
    brand: "BEAUTY OF JOSEON",
    image:
      "assets/images/Beauty of Joseon Calming Serum Green Tea + Panthenol.jpeg",
    rating: 5,
  },
  {
    name: "Beauty of Joseon Light On Serum Centella + Vita C 30ml",
    price: 1650,
    category: "Serum",
    brand: "BEAUTY OF JOSEON",
    image:
      "assets/images/Beauty of Joseon Serum Centella + Vita C.jpeg",
    rating: 5,
  },
  {
    name: "Dear, KLAIRS Rich Moist Soothing Serum 80ml",
    price: 2100,
    category: "Serum",
    brand: "KLAIRS",
    image: "assets/images/KLAIRS Serum.jpeg",
    rating: 5,
  },
  {
    name: "Dear, KLAIRS Midnight Blue Youth Activating Drop 20ml",
    price: 2500,
    category: "Serum",
    brand: "KLAIRS",
    image: "assets/images/KLAIRS Serum Drop.jpeg",
    rating: 5,
  },
  {
    name: "SKIN1004 Madagascar Centella Hyalu-Cica Blue Serum 50ml",
    price: 1950,
    category: "Serum",
    brand: "SKIN1004",
    image: "assets/images/SKIN1004 Blue Serum.jpeg",
    rating: 5,
  },
  {
    name: "Beauty of Joseon Glow Serum: Propolis + Niacinamide 30ml",
    price: 1850,
    category: "Serum",
    brand: "BEAUTY OF JOSEON",
    image:
      "assets/images/Beauty of Joseon Glow Serum_Propolis_Niacinamide 30ml.png",
    rating: 5,
  },
  {
    name: "SKIN1004 Madagascar Centella Watergel Sheet Ampoule Mask 25ml",
    price: 450,
    category: "Mask",
    brand: "SKIN1004",
    image:
      "assets/images/SKIN1004 Watergel Sheet Ampoule Mask.jpeg",
    rating: 5,
  },
  {
    name: "SKIN1004 Madagascar Centella Hyalu-Cica Hydrating Mask 23ml",
    price: 450,
    category: "Mask",
    brand: "SKIN1004",
    image:
      "assets/images/SKIN1004 Hydrating Mask.jpeg",
    rating: 5,
  },
  {
    name: "Dear, KLAIRS Rich Moist Soothing Tencel Sheet Mask 25ml",
    price: 450,
    category: "Mask",
    brand: "KLAIRS",
    image: "assets/images/KLAIRS Tencel Sheet Mask.jpeg",
    rating: 5,
  },
  {
    name: "Beauty of Joseon Relief Sun Rice + Probiotics SPF50+ PA++++ 50ml",
    price: 1650,
    category: "Sun Care",
    brand: "BEAUTY OF JOSEON",
    image:
      "assets/images/Beauty of Joseon Relief Sun Rice + Probiotics SPF50+ PA++++ 50ml.jpeg",
    rating: 5,
  },
  {
    name: "Beauty of Joseon Relief Sun Aqua-Fresh Rice + B5 SPF50+ PA++++ 50ml",
    price: 1650,
    category: "Sun Care",
    brand: "BEAUTY OF JOSEON",
    image:
      "assets/images/Beauty of Joseon Relief Sun Aqua-Fresh.jpeg",
    rating: 5,
  },
  {
    name: "Beauty of Joseon Ginseng Moist Sun Serum SPF50+ PA++++ 50ml",
    price: 1750,
    category: "Sun Care",
    brand: "BEAUTY OF JOSEON",
    image:
      "assets/images/Beauty of Joseon Ginseng Moist Sun Serum.jpeg",
    rating: 5,
  },
  {
    name: "Beauty of Joseon Dynasty Cream 50ml",
    price: 1850,
    category: "Moisturizer",
    brand: "BEAUTY OF JOSEON",
    image:
      "assets/images/Beauty of Joseon Dynasty Cream.jpeg",
    rating: 5,
  },
  {
    name: "Beauty of Joseon Red Bean Cream 50ml",
    price: 1750,
    category: "Moisturizer",
    brand: "BEAUTY OF JOSEON",
    image:
      "assets/images/Beauty of Joseon Red Bean Cream.jpeg",
    rating: 5,
  },
  {
    name: "SKIN1004 Madagascar Centella Hyalu-Cica Brightening Toner 210ml",
    price: 1750,
    category: "Toner",
    brand: "SKIN1004",
    image:
      "assets/images/SKIN1004 Hyalu-Cica Brightening Toner.jpeg",
    rating: 5,
  },
  {
    name: "SKIN1004 Madagascar Centella Tone Brightening Boosting Toner 210ml",
    price: 1950,
    category: "Toner",
    brand: "SKIN1004",
    image:
      "assets/images/SKIN1004 Boosting Toner.jpeg",
    rating: 5,
  },
  {
    name: "AXIS-Y Mugwort Pore Clarifying Wash Off Pack 100ml",
    price: 1800,
    category: "Mask",
    brand: "AXIS-Y",
    image:
      "assets/images/AXIS-Y Mugwort Pore Clarifying Wash Off Pack 100ml.jpeg",
    rating: 5,
  },
  {
    name: "Beauty of Joseon Red Bean Refreshing Pore Mask 140ml",
    price: 1650,
    category: "Mask",
    brand: "BEAUTY OF JOSEON",
    image:
      "assets/images/Beauty of Joseon Red Bean Refreshing Pore Mask.jpeg",
    rating: 5,
  },
  {
    name: "Beauty of Joseon Ground Rice and Honey Glow Mask 150ml",
    price: 1650,
    category: "Mask",
    brand: "BEAUTY OF JOSEON",
    image:
      "assets/images/Beauty of Joseon Ground Rice and Honey Glow Mask 150ml.jpeg",
    rating: 5,
  },
  {
    name: "AXIS-Y New Skin Resolution Gel Mask 100ml",
    price: 1850,
    category: "Mask",
    brand: "AXIS-Y",
    image:
      "assets/images/AXIS-Y New Skin Resolution Gel Mask 100ml.jpeg",
    rating: 5,
  },
  {
    name: "KLAIRS Midnight Blue Calming Cream 30ml",
    price: 1750,
    category: "Moisturizer",
    brand: "KLAIRS",
    image: "assets/images/KLAIRSmidnightcream.jpg",
    rating: 5,
  },
  {
    name: "SKIN1004 Madagascar Centella Quick Calming Pad 70 Pads",
    price: 2100,
    category: "Pads",
    brand: "SKIN1004",
    image:
      "assets/images/SKIN1004 Quick Calming Pad.jpeg",
    rating: 5,
  },
  {
    name: "KLAIRS Freshly Juiced Vitamin Drop 35ml",
    price: 2000,
    category: "Serum",
    brand: "KLAIRS",
    image:
      "assets/images/KLAIRS Freshly Juiced Vitamin Drop 35ml.jpg",
    rating: 5,
  },
  {
    name: "KLAIRS Rich Moist Soothing Cream 80ml",
    price: 2100,
    category: "Moisturizer",
    brand: "KLAIRS",
    image:
      "assets/images/KLAIRS_Rich-Moist-Soothing-Cream-4.jpg",
    rating: 5,
  },
  {
    name: "KLAIRS Freshly Juiced Vitamin E Mask 15ml",
    price: 950,
    category: "Mask",
    brand: "KLAIRS",
    image:
      "assets/images/KLAIRS Freshly Juiced Vitamin E Mask 15ml.jpg",
    rating: 5,
  },
  {
    name: "AXIS-Y Quinoa One-Step Balanced Gel Cleanser 180ml",
    price: 1650,
    category: "Cleanser",
    brand: "AXIS-Y",
    image:
      "assets/images/AXIS-Y Quinoa One-Step Balanced Gel Cleanser 180ml.webp",
    rating: 5,
  },
  {
    name: "SKIN1004 Madagascar Centella Ampoule 100ml",
    price: 2150,
    category: "Serum",
    brand: "SKIN1004",
    image:
      "assets/images/SKIN1004 Madagascar Centella Ampoule 100m.jpg",
    rating: 5,
  },
  {
    name: "SKIN1004 Madagascar Centella Toning Toner 210ml",
    price: 2100,
    category: "Toner",
    brand: "SKIN1004",
    image:
      "assets/images/SKIN1004-Madagascar-Centella-Toning-Toner-210-ml.jpg",
    rating: 5,
  },
  {
    name: "AXIS-Y Dark Spot Correcting Glow Serum 50ml",
    price: 1850,
    category: "Serum",
    brand: "AXIS-Y",
    image:
      "assets/images/AXIS-Y Dark Spot Correcting Glow Serum 50ml.jpg",
    rating: 5,
  },
  {
    name: "SKIN1004 Madagascar Centella Light Cleansing Oil 30ml",
    price: 700,
    category: "Cleanser",
    brand: "SKIN1004",
    image:
      "assets/images/SKIN1004 Madagascar Centella Light Cleansing Oil 30ml(mini).png",
    rating: 5,
  },
  {
    name: "AXIS-Y Artichoke Intensive Skin Barrier Ampoule 30ml",
    price: 1950,
    category: "Serum",
    brand: "AXIS-Y",
    image:
      "assets/images/AXIS-Y Artichoke Intensive Skin Barrier Ampoule 30ml.jpg",
    rating: 5,
  },
  {
    name: "AXIS-Y Sunday Morning Refreshing Cleansing Foam 120ml",
    price: 1450,
    category: "Cleanser",
    brand: "AXIS-Y",
    image:
      "assets/images/AXIS-Y Sunday Morning Refreshing Cleansing Foam 120ml.jpeg",
    rating: 5,
  },
  {
    name: "Skin1004 Madagascar Centella Ampoule Foam 20ml (Mini)",
    price: 1450,
    category: "Cleanser",
    brand: "Skin1004",
    image:
      "assets/images/Skin1004-Madagascar-Centella-Ampoule-Foam-20ml(mini).webp",
    rating: 5,
  },
  {
    name: "AXIS-Y Complete No-Stress Physical Sunscreen SPF50+ PA++++ 50ml",
    price: 1850,
    category: "Sun Care",
    brand: "AXIS-Y",
    image:
      "assets/images/AXIS-Y Complete No-Stress Physical Sunscreen 50ml.webp",
    rating: 5,
  },
  {
    name: "SKIN1004 Hyalu-Cica Water-Fit Sun Serum SPF50+ PA++++",
    price: 2050,
    category: "Sun Care",
    brand: "SKIN1004",
    image:
      "assets/images/SKIN1004-Madagascar-Centella-Hyalu-Cica-Water-Fit-Sun-Serum-50ml.webp",
    rating: 5,
  },
  {
    name: "SKIN1004 Madagascar Centella Light Cleansing Oil 200ml",
    price: 2250,
    category: "Cleanser",
    brand: "SKIN1004",
    image:
      "assets/images/SKIN1004 Madagascar Centella Light Cleansing Oil 200ml.jpeg",
    rating: 5,
  },
];

const getDescription = (category, brand) => {
  const descriptions = {
    Cleanser: `${brand} Korean skincare cleanser for gentle and effective daily cleansing.`,
    Moisturizer: `${brand} moisturizer designed to hydrate and support a healthy skin barrier.`,
    "Sun Care": `${brand} sun care product designed to help protect the skin from UV exposure.`,
    Serum: `${brand} skincare serum formulated to support a healthy and radiant complexion.`,
    Toner: `${brand} toner designed to refresh and prepare the skin for the next skincare steps.`,
    Mask: `${brand} skincare mask designed to provide targeted care and nourishment.`,
    Pads: `${brand} skincare pads designed for convenient and refreshing daily skincare.`,
  };

  return (
    descriptions[category] ||
    `${brand} premium Korean skincare product.`
  );
};

const seedProducts = async () => {
  try {
    await mongoose.connect(process.env.MONGODB_URI);

    console.log("MongoDB connected successfully.");

    const categories = await Category.find();

    const categoryMap = {};

    categories.forEach((category) => {
      categoryMap[category.name] = category._id;
    });

    console.log(
      "Available categories:",
      Object.keys(categoryMap)
    );

    const productsToInsert = products.map((product) => {
      const categoryId = categoryMap[product.category];

      if (!categoryId) {
        throw new Error(
          `Category not found: ${product.category}`
        );
      }

      return {
        name: product.name,
        brand: product.brand,
        category: categoryId,
        price: product.price,
        description: getDescription(
          product.category,
          product.brand
        ),
        image: product.image,
        stock:
          product.stock !== undefined
            ? product.stock
            : 10,
        rating: product.rating,
        numReviews: 0,
      };
    });

    await Product.insertMany(productsToInsert);

    console.log(
      `Successfully inserted ${productsToInsert.length} products.`
    );

    await mongoose.connection.close();

    console.log("MongoDB connection closed.");
  } catch (error) {
    console.error("Seeding failed:", error.message);

    await mongoose.connection.close();

    process.exit(1);
  }
};

seedProducts();