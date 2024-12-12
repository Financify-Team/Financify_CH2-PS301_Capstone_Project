const express = require('express');
const bodyParser = require('body-parser');
const multer = require('multer');
const cors = require('cors');
require('dotenv').config();

// Import controller functions
const authController = require('./controllers/authController'); 
const userController = require('./controllers/userController');

const app = express();
const upload = multer(); 

// Middleware
app.use(cors());
app.use(bodyParser.json());
app.use(express.json()); 

// Routes
app.post('/register', upload.fields([
    { name: 'profilePicture', maxCount: 1 },
    { name: 'idCard', maxCount: 1 }
]), authController.register); 
app.post('/login', userController.loginWithEmail);
app.post('/verify-pin', userController.verifyPIN); 

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => console.log(`Server running on port ${PORT}`));
