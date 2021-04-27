const functions = require("firebase-functions");

// The Firebase Admin SDK to access Firestore.
const admin = require("firebase-admin");

//This function count and update the number of users in DB
exports.countUsers = functions.database
  .ref("/Customers")
  .onWrite((change, context) => {
    const data = change.after.val();
    const count = Object.keys(data).length;
    return change.after.ref.child("_count").set(count - 1);
  });

exports.doTransaction = functions.https.onCall((data, context) => {
  // We get the input data
  var value = data.value;
  var receiver = data.receiver;
  var emitter = data.emitter;
  // We record the current hour
  const timeStamp = new Date().getTime();
  // var currentAccount = admin.database.ref('/Customers').ref(data.emitter).ref().ref('Balance');
  const customersDatabase = admin.database.ref("Customers/");
  var transmitterAccount = customersDatabase
    .child(emitter)
    .child("/Main account")
    .get();
  var receiverAccount = customersDatabase
    .child(receiver)
    .child("/Main account")
    .get();

  var tradesCollection = admin.firestore().collection("Trades");
  // We update the account value of the operation transmitter
  return customersDatabase
    .ref(emitter + "/Main account")
    .child("Balance")
    .update(transmitterAccount.child("Balance").val() - value)
    .then(() => {
      //then we we save the operation in both accounts database
      tradesCollection
        .doc(emitter)
        .collection("trades")
        .doc(timeStamp.toString())
        .set(
          {
            date: timeStamp.toString(),
            value: -value,
            uid_receiver: receiverAccountNumber.child("Account number"),
            uid_emitter: currentAccountNumber.child("Account number"),
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
            value: value,
            uid_receiver: receiverAccountNumber.child("Account number"),
            uid_emitter: currentAccountNumber.child("Account number"),
          },
          { merge: true }
        );
      //and we update the account value of the receiver user
      customersDatabase
        .ref(emitter + "/Main account")
        .child("Balance")
        .update(receiverAccount.child("Balance").val() - value);
    });
});
