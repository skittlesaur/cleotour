const functions = require('firebase-functions');
const admin = require('firebase-admin');

admin.initializeApp();

exports.myFunction = functions.firestore
  .document('Posts/{message}')
  .onCreate((snapshot, context) => {
    console.log(snapshot.data);
    const topic = 'Posts'; 
    const notification = {
      topic: topic,
      notification: {
        title: 'New Post!',
        body: `${snapshot.data().posterUserName} made a new post`,
        imageUrl: snapshot.data().imageUrl,
      },
    };

    return admin.messaging().send(notification);
});

