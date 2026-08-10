const jwt = require("jsonwebtoken");

const authMiddleware = (req, res, next) => {
    console.log(req.headers.authorization);
  const authHeader = req.headers.authorization;

  // token check
  if (!authHeader) {
    return res.status(401).json({ message: "No token provided" });
  }

  const token = authHeader.split(" ")[1];

  try {
    const decoded = jwt.verify(token, process.env.JWT_SECRET);
    req.user = decoded; // এখানে user save হচ্ছে
    next();
  } catch (error) {
    return res.status(401).json({ message: "Invalid token" });
  }
};

module.exports = authMiddleware;