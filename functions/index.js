const functions = require("firebase-functions");

// The Firebase Admin SDK to access Firestore.
const admin = require('firebase-admin');
admin.initializeApp();
//This function count and update the number of users in DB
exports.countUsers = functions.database.ref('/Customers').onWrite((change, context) => {
    const data = change.after.val();
    const count = Object.keys(data).length;
    return change.after.ref.child('_count').set(count-1);
});

exports.check_data_transfert = functions.https.onCall((data,context) => {
var value = data.value;

return admin.database().ref('/Customers/'+data.uid+'/Main account').once('value').then(snapshot => {
        return snapshot.forEach(function(data) {
        if(data.key == "Balance") {
        var result;
            //check
            functions.logger.log("Balance "+data.val());
            if(value <= data.val()) {
                functions.logger.log("ok");
                result = true;
            } else {
                functions.logger.log("Not ok");
                result = false;
            }
        return result;
        }
        });
    });
});