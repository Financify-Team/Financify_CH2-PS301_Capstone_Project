const express = require('express');
const multer = require('multer');
const { register } = require('/Login Register/src/controllers/userController'); 

const router = express.Router();
const upload = multer();

router.post('/register', 
    upload.fields([
        { name: 'profilePicture', maxCount: 1 },
        { name: 'idCard', maxCount: 1 }
    ]), 
    register 
);

module.exports = router;
