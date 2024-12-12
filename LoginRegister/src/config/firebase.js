const admin = require('firebase-admin');
const serviceAccount = require('service_account');

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
  databaseURL: "Your_database_url",
  storageBucket: "Your_bucket_name" 
});

const db = admin.firestore();
const storage = admin.storage();

module.exports = { admin, db, storage };
