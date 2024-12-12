const { admin, db } = require('/Login Register/src/config/firebase'); // Import konfigurasi Firebase

// Fungsi untuk menangani login dengan email dan password
exports.loginWithEmail = async (req, res) => {
  const { email, password } = req.body;

  try {
    const userDoc = await db.collection('users').where('email', '==', email).limit(1).get();

    if (userDoc.empty) {
      throw new Error('User tidak ditemukan.');
    }

    const userData = userDoc.docs[0].data();

    if (userData.password !== password) { 
      throw new Error('Password salah.');
    }

    const token = await admin.auth().createCustomToken(userDoc.docs[0].id);
    res.status(200).send({ token, uid: userDoc.docs[0].id });

  } catch (error) {
    res.status(400).send({ error: error.message });
  }
};


// Fungsi untuk menangani verifikasi PIN dan otorisasi akses ke dashboard
exports.verifyPIN = async (req, res) => {
  const { uid, pin } = req.body;

  try {
    if (!pin || pin.length !== 6 || isNaN(pin)) {
      throw new Error('PIN harus berupa angka 6 digit.');
    }

    // Dapatkan data user dari Firestore
    const userDoc = await db.collection('users').doc(uid).get();
    const userData = userDoc.data();

    // Verifikasi PIN
    if (userData.pin !== pin) {
      throw new Error('PIN yang Anda masukkan salah.');
    }
    res.status(200).send({ message: 'PIN verified, welcome to dashboard!' }); 

  } catch (error) {
    res.status(400).send({ error: error.message }); 
  }
};