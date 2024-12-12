const admin = require('firebase-admin');
const serviceAccount = require('/Login Register/src/config/capstone--c242-ps301-firebase-adminsdk-h9m78-e84cf25a7c.json');

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
  databaseURL: "https://capstone--c242-ps301.firebaseio.com",
  storageBucket: "casptone-cc" 
});

const db = admin.firestore();
const storage = admin.storage();

module.exports = { admin, db, storage };