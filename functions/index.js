const functions = require("firebase-functions");

// The Firebase Admin SDK to access Firestore.
const admin = require('firebase-admin');
admin.initializeApp();
const fetch = require("node-fetch");

exports.transfertServices = require('./TransfertServices');
exports.DataCheckServices = require('./DataCheckServices');

//Transferts
/*exports.transfertServices = transfertServices.getUsersAndTransaction;
exports.transfertServices = transfertServices.doTransaction;

//Check
exports.DataCheckServices = DataCheckServices.countUsers;
exports.DataCheckServices = DataCheckServices.check_data_transfert;
exports.DataCheckServices = DataCheckServices.check_mail_presence;*/
