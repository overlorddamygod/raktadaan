const admin = require('firebase-admin');
const serviceAccount = require('./service_account.json');
const {faker} = require('@faker-js/faker');
const geofire = require('geofire-common');

let locations = {
    "Lalitpur": [[27.671205,85.333007], [27.666095,85.330766]],
    // "Lalitpur": [[27.682079, 85.315048],[27.661001, 85.328704]],
    // "Kathmandu": [[27.713904, 85.317032],[27.726101, 85.340206],[27.715250, 85.304774]],
    // "Bhaktapur": [[27.676046, 85.383544],[27.676683, 85.388751],[27.684236, 85.375283]],
    // "Pokhara": [[28.228790, 83.948375],[28.187341, 83.952839],[28.194301, 84.001590]]
}
// map locations lalitpur map and iclude geohash
locations = Object.keys(locations).reduce((arr, city) => {
    locations[city].forEach((location) => {
        arr.push({
            city,
            geohash: geofire.geohashForLocation(location),
            geopoint: new admin.firestore.GeoPoint(location[0], location[1])
        })
    })
    return arr;
}, [])

console.log(locations)
return;


// const users = ["Prachanda Oli", "Nishan Rana Magar", "Saman Shakya", "Pratik Dhakal", "Priyanka Bhandari", "Shriya Shrestha", "Mibija Singh", "Aathiti Shakya", "Pritam Shrestha", "Gulshan Mahaseth", "Anish Maharjan"]
const users = ["Ram Dahal", "Shyam Upreti"]

// Initialize Firebase Admin SDK
admin.initializeApp({
    credential: admin.credential.cert(serviceAccount),
});

function getRandomFromArray(arr) {
    const randomIndex = Math.floor(Math.random() * arr.length)
    return arr[randomIndex]
}

function getRandomLocation() {
    return getRandomFromArray(locations)
}

const bloodGroups = ["A+", "A-", "B+", "B-", "AB+", "AB-", "O+", "O-"]

// function to get Random bloog group
function getRandomBloodGroup() {
    return getRandomFromArray(bloodGroups);
}

// function to get Random bloog group
function getRandomCity() {
    const city = Object.keys(locations);
    // const city = ["Kathmandu", "Lalitpur", "Bhaktapur", "Pokhara"]
    const randomIndex = Math.floor(Math.random() * city.length)
    return city[randomIndex]
}

function getRandomPhoneNumber() {
    return '98' + Math.floor(Math.random() * 100000000)
}

// Firebase Authentication
async function createFirebaseUser(name) {
    const nameSplit = name.split(" ")
    const firstName = nameSplit[0]
    let lastName = nameSplit[1]
    let middleName = null

    if (nameSplit.length == 3) {
        middleName = nameSplit[1]
        lastName = nameSplit[2]
    }

    const email = firstName.toLowerCase() + '@gmail.com'

    const firebaseUserProperties = {
        email,
        password: `${firstName.toLowerCase()}123`, // Set a temporary password
        displayName: name,
        photoURL: faker.image.avatar(),
    };

    try {
        const userRecord = await admin.auth().createUser(firebaseUserProperties);
        console.log('Firebase Authentication User Created:', userRecord.uid);
        const randomLocation = getRandomLocation();
        const userDocProperties = {
            bloodGroup: getRandomBloodGroup(),
            donor: (Math.random() > 0.25) ? true : false,
            email: email,
            firstName,
            lastName,
            middleName,
            city: randomLocation.city,
            mobileNumber: getRandomPhoneNumber(),
            position: {
                geohash: randomLocation.geohash,
                geopoint: randomLocation.geopoint
            },
            uid: userRecord.uid,
        };
        console.log(userDocProperties)

        if (Math.random() > 0.4) {
            userDocProperties.citizenshipNo = faker.random.alphaNumeric(8),
                userDocProperties.verified = true;
        }

        await admin.firestore().collection('users').doc(userRecord.uid).set(userDocProperties);
    } catch (error) {
        console.error('Error creating Firebase Authentication User:', error);
        return null;
    }
}


async function populateUsers() {
    for (let i=0; i<users.length; i++) {
        await createFirebaseUser(users[i])
    }
}

populateUsers();
