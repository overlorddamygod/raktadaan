const express = require('express');
const admin = require('firebase-admin');
const serviceAccount = require('./service_account.json');

const app = express();
app.use(express.json());

// Initialize Firebase Admin SDK
admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
});

app.get('/', (req, res) => {
  res.status(200).json({ message: 'Hello World!' });
});

app.post('/bloodrequest', async (req, res) => {
  try {
    const { bloodGroup, contactNumber, isUrgent, location, userId } = req.body;
    // Add event to the 'events' collection in Firestore
    const eventRef = await admin.firestore().collection('user_blood_requests').add({
      bloodGroup,
      contactNumber,
      isUrgent,
      location,
      requestAt: admin.firestore.Timestamp.fromDate(new Date()),
      userId,
    });

    // Add notification to the 'notifications' collection in Firestore
    const notificationRef = await admin.firestore().collection('notifications').add({
        title: `Blood Required`,
        body: `Blood Group: ${bloodGroup}\nLocation: ${location}`,
      eventId: eventRef.id,
    });

    // Send FCM notification
    const payload = {
      notification: {
        title: `Blood Required`,
        body: `Blood Group: ${bloodGroup}\Location: ${location}`,
      },
      data: {
        // eventId: eventRef.id,
        notificationId: notificationRef.id,
      },
    };

    const topic = 'all_notification'; // You can use a specific topic or device token
    await admin.messaging().sendToTopic(topic, payload);

    res.status(200).json({ message: 'Blood Requested successfully!' });
  } catch (error) {
    console.error('Error:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

app.post('/events', async (req, res) => {
  try {
    const { title, description, image, date } = req.body;
    console.log(req.body)
    // Add event to the 'events' collection in Firestore
    const eventRef = await admin.firestore().collection('events').add({
      title,
      description,
      image,
    //   time: admin.firestore.Timestamp.fromDate(new Date(date)),
    });

    // Add notification to the 'notifications' collection in Firestore
    const notificationRef = await admin.firestore().collection('notifications').add({
        title: `New Event: ${title}`,
        body: `Description: ${description}`,
      eventId: eventRef.id,
    });

    // Send FCM notification
    const payload = {
      notification: {
        title: `New Event: ${title}`,
        body: `Description: ${description}`,
      },
      data: {
        eventId: eventRef.id,
        notificationId: notificationRef.id,
      },
    };

    const topic = 'all_notification'; // You can use a specific topic or device token
    await admin.messaging().sendToTopic(topic, payload);

    res.status(200).json({ message: 'Event created successfully!' });
  } catch (error) {
    console.error('Error:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

app.post('/makeAdmin', async (req, res) => {
  try {
    const { uid } = req.body;

    await admin.auth().setCustomUserClaims(uid, { admin: true });

    admin.firestore().collection('users').where("uid","==", uid).get().then((querySnapshot) => {
        querySnapshot.forEach((doc) => {
            doc.ref.update({
                admin: true
            })
        });
    }).catch((error) => {
        res.status(404).json({ error: 'User not found' });
        return;
    });

    res.status(200).json({ message: 'User is now an admin!' });
  } catch (error) {
    console.error('Error:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

// Start the Express server
const PORT = process.env.PORT || 8080;
app.listen(PORT, () => {
  console.log(`Server is running on port ${PORT}`);
});
