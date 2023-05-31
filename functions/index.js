const functions = require('firebase-functions');
const admin = require('firebase-admin');

admin.initializeApp();

exports.myFunction = functions.firestore
  .document('Posts/{message}')
  .onCreate((snapshot, context) => {
    console.log(snapshot.data)
    return admin.messaging().send( {
        notification: {
          title: 'New Post !',
          body: `${snapshot.data().posterUserName} made a new post`,
          imageUrl:snapshot.data.imageUrl,
          clickAction: 'FLUTTER_NOTIFICATION_CLICK',
        },
      },
    )

}
    );