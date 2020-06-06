const functions = require('firebase-functions')
const admin = require('firebase-admin')

admin.initializeApp()

exports.myFunction = functions.firestore
  .document('chats/{message}')
  .onCreate((snapshot, context) => {
    admin.messaging().sendToTopic('chats', {
      notification: {
        title: snapshot.data().firstName,
        body: snapshot.data().text,
        clickAction: 'FLUTTER_NOTIFICATION_CLICK'
      }
    })
  })
