const functions = require("firebase-functions");

// The Firebase Admin SDK to access Firestore.
const admin = require('firebase-admin');
const fetch = require("node-fetch");
//This function count and update the number of users in DB
exports.countUsers = functions.database.ref('/Customers').onWrite((change, context) => {
    const data = change.after.val();
    const count = Object.keys(data).length;
    return change.after.ref.child('_count').set(count-1);
});

exports.check_data_transfert = functions.https.onCall((data,context) => {
var value = data.value;

return admin.database().ref('/Customers/'+data.emitter+'/Main account').once('value').then(snapshot => {
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

exports.check_mail_presence = functions.https.onCall((data,context) => {
    var db = admin.firestore();
    var usersReference = db.collection("Users");
    var email = data.receiver_email;
    //Get them
    return usersReference.get().then((querySnapshot) => {
        //querySnapshot is "iteratable" itself
        var result = false;
        querySnapshot.forEach((userDoc) => {
            //userDoc contains all metadata of Firestore object, such as reference and id
            if( email == userDoc.data().mail) {
                    result = true;
                }
            });
            return result;
        });
});
