const { admin, db, storage } = require('/Login Register/src/config/firebase');

exports.register = async (req, res) => {
    const { fullName, email, password, pin } = req.body;
    const profilePicture = req.files['profilePicture'][0]; 
    const idCard = req.files['idCard'][0]; 

    try {
        // Validasi input
        if (!fullName || fullName.length < 3) {
            throw new Error('Nama lengkap harus diisi minimal 3 karakter.');
        }
        const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
        if (!emailRegex.test(email)) {
            throw new Error('Format email tidak valid.');
        }
        if (!password || password.length < 6) {
            throw new Error('Password harus diisi minimal 6 karakter.');
        }
        if (!pin || pin.length !== 6 || isNaN(pin)) {
            throw new Error('PIN harus berupa angka 6 digit.');
        }
        if (!profilePicture || !profilePicture.mimetype.startsWith('image/')) {
            throw new Error('File foto profil harus berupa gambar.');
        }
        if (profilePicture.size > 5 * 1024 * 1024) { 
            throw new Error('Ukuran file foto profil terlalu besar.');
        }
        if (!idCard || !idCard.mimetype.startsWith('image/')) {
            throw new Error('File KTP harus berupa gambar.');
        }

        // Buat user di Firebase Authentication
        const userRecord = await admin.auth().createUser({
            email,
            password,
            displayName: fullName,
        });

        // Upload foto profil ke Firebase Storage
        const profilePictureRef = storage.bucket('casptone-cc').file(`profilePictures/${userRecord.uid}`);
        await profilePictureRef.save(profilePicture.buffer);
        await profilePictureRef.makePublic();
        const profilePictureUrl = `https://storage.googleapis.com/${profilePictureRef.bucket.name}/${profilePictureRef.name}`;

        // Upload KTP ke Firebase Storage
        const idCardRef = storage.bucket('casptone-cc').file(`idCards/${userRecord.uid}`);
        await idCardRef.save(idCard.buffer);
        await idCardRef.makePublic();
        const idCardUrl = `https://storage.googleapis.com/${idCardRef.bucket.name}/${idCardRef.name}`;

        // Simpan data user ke Firestore
        await db.collection('users').doc(userRecord.uid).set({
            fullName,
            email,
            password,
            pin,
            profilePicture: profilePictureUrl,
            idCard: idCardUrl,
            isVerified: true 
        });

        res.status(201).send({ uid: userRecord.uid });
    } catch (error) {
        res.status(400).send({ error: error.message });
    }
};
