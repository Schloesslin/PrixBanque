const functions = require("firebase-functions");

// The Firebase Admin SDK to access Firestore.
const admin = require('firebase-admin');

//This function count and update the number of users in DB
exports.countUsers = functions.database.ref('/Customers').onWrite((change, context) => {
    const data = change.after.val();
    const count = Object.keys(data).length;
    return change.after.ref.child('_count').set(count-1);
});