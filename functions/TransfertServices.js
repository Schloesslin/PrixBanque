const functions = require("firebase-functions");

// The Firebase Admin SDK to access Firestore.
const admin = require('firebase-admin');
const fetch = require("node-fetch");

exports.getUsersAndTransaction = functions.https.onCall( async (data,context) => {
    var value = data.value;
    var emitter = data.emitter;
    var receiver_email= data.receiver_email;
    var receiver;
    var emitter_balance;
    var receiver_balance;

    /*await callCloudFunction("getBalanceValue",{"uid":emitter}).then( data => {
        functions.logger.log("DATA",data);
    });*/
    await admin.auth().getUserByEmail(receiver_email).then((userRecord) => {
     // See the UserRecord reference doc for the contents of userRecord.
     functions.logger.log("UID "+userRecord.uid);
     receiver =  userRecord.uid;
    });

     await admin.database().ref('/Customers/'+emitter+'/Main account').once('value').then(snapshot => {
         return snapshot.forEach(function(data) {
             if(data.key == "Balance") {
                 emitter_balance = data.val();
                 functions.logger.log("Balance "+data.val());
                 }
             });
         });
     await admin.database().ref('/Customers/'+receiver+'/Main account').once('value').then(snapshot => {
         return snapshot.forEach(function(data) {
             if(data.key == "Balance") {
                 receiver_balance = data.val();
                 functions.logger.log("Balance "+data.val());
                 }
             });
        });
    functions.logger.log("Emitter balance"+emitter_balance," Receiver balance :"+receiver_balance);

    callCloudFunction('transfertServices-doTransaction', {"value" : value, "emitter": emitter, "receiver": receiver, "emitter_balance":emitter_balance, "receiver_balance":receiver_balance});
  });

exports.doTransaction = functions.https.onCall( async (data, context) => {
  // We get the input data
  var value = data.value;
  var receiver = data.receiver;
  var emitter = data.emitter;
  var emitter_balance = data.emitter_balance;
  var receiver_balance = data.receiver_balance;
  // We record the current hour
  const timeStamp = new Date().getTime();
  // var currentAccount = admin.database.ref('/Customers').ref(data.emitter).ref().ref('Balance');
  const customersDatabase = admin.database().ref("/Customers/");
  functions.logger.log("Emitter balance"+emitter_balance);
  functions.logger.log("emitter : "+emitter);
  functions.logger.log("Valeur"+value);
  functions.logger.log("Receiver"+receiver);
  var updates = {};
  updates[emitter+"/Main account/Balance"] = emitter_balance - value;
  updates[receiver+"/Main account/Balance"] = +receiver_balance + +value;
  customersDatabase.update(updates);
  //customersDatabase.child(receiver+"/Main account/").update({'Balance': receiver_balance + value});
  var tradesCollection = admin.firestore().collection("Trades");
  tradesCollection
        .doc(emitter)
        .collection("trades")
        .doc(timeStamp.toString())
        .set(
          {
            date: timeStamp.toString(),
            value: -value,
            uid_receiver: receiver,
            uid_emitter: emitter,
          },
          { merge: true }
        );

  tradesCollection
        .doc(receiver)
        .collection("trades")
        .doc(timeStamp.toString())
        .set(
          {
            date: timeStamp.toString(),
            value: +value,
            uid_receiver: receiver,
            uid_emitter: emitter,
          },
          { merge: true }
          );
});

const callCloudFunction = async (functionName, data) => {
    let url = 'https://us-central1-prixbanque-e70aa.cloudfunctions.net/'+functionName;
    await fetch(url, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json',
        },
        body: JSON.stringify({ data }),
    }).then(response => { return response.json().then((data) => {functions.logger.log("cloud "+JSON.stringify(data));
                                                                 return data;})
})
}