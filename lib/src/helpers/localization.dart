import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class Localization extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        'en': {
          'raktadaan': 'Raktadaan',
          'signin': 'Sign In',
          'signup': 'Sign Up',
          'create_account': 'Create Account',
          'submit': 'Submit',
          'next': 'Next',
          'skip': 'Skip',
          'have_account_already': 'Already have an account?',
          'dont_have_account': 'Don\'t have an account?',
          'search': 'Search',
          'search_for_blood_donors': 'Search for Blood Donors',
          'search_for_donors': 'Search for Donors',
          'search_for_donors_n': 'Search for\nDonors',
          'search_for_blood_donors_n': 'Search for\nBlood Donors',
          'Call': 'Call',
          'Verified': 'Verified',
          'Not Verified': 'Not Verified',
          'select_language': 'Select Language',
          'Profile': 'Profile',
          'Events': 'Events',
          'Hospital Contact Details': 'Hospital Contact Details',
          'Logout': 'Logout',
          'Admin': 'Admin',
          'Settings': 'Settings',
          'Home': 'Home',
          'Blood Requests': 'Blood Requests',
          'Search donors': 'Search donors',
          'Notifications': 'Notifications',
          'Menu': 'Menu',
          'Location': 'Location',
          'No more items!': 'No more items',
          'Lalitpur': 'Lalitpur',
          'Kathmandu': 'Kathmandu',
          'Bhaktapur': 'Bhaktapur',
          'Pokhara': 'Pokhara',
          'Urgent': 'Urgent',
          'Search by location': 'Search by location',
          'Search by blood group': 'Search by blood group',
          'Blood required': 'Blood required',
          'Blood Group': 'Blood Group',
          'Did you know': 'Did you know',
          'New Blood Request:': 'New Blood Request:',
          'Is Urgent': 'Is Urgent',
          'Search Nearby Donors': 'Search Nearby Donors',
        },

        // nepali
        'ne': {
          'raktadaan': 'रक्तदान',
          'signin': 'साइन इन',
          'signup': 'साइन अप',
          'create_account': 'खाता बनाउनुहोस्',
          'submit': 'सबमिट गर्नुहोस्',
          'next': 'अर्को',
          'skip': 'छोड्नुहोस्',
          'have_account_already': 'पहिले नै खाता छ?',
          'dont_have_account': 'खाता छैन?',
          'search': 'खोज्नुहोस्',
          'search_for_blood_donors': 'रक्तदाताहरूको लागि खोज्नुहोस्',
          'search_for_blood_donors_n': 'रक्तदाताहरूको लागि\nखोज्नुहोस्',
          'search_for_donors_n': 'रक्तदाताहरूको लागि\nखोज्नुहोस्',
          'Call': 'कल',
          'Verified': 'सत्यापित',
          'Not Verified': 'सत्यापित छैन',
          'select_language': 'भाषा छनौट गर्नुहोस्',
          'Profile': 'प्रोफाइल',
          'Events': 'कार्यक्रमहरू',
          'Hospitals Contact Details': 'अस्पताल सम्पर्क विवरण',
          'Logout': 'लगआउट',
          'Admin': 'व्यवस्थापक',
          'Settings': 'सेटिङ्ग्स',
          'Home': 'गृहपृष्ठ',
          'Blood Requests': 'रक्त अनुरोधहरू',
          'Search donors': 'रक्तदाताहरू खोज्नुहोस्',
          'Notifications': 'सूचनाहरू',
          'Menu': 'मेनु',
          'Location': 'स्थान',
          'No more items!': 'अझै कुनै वस्तुहरू छैनन्',
          'Lalitpur': 'ललितपुर',
          'Kathmandu': 'काठमाडौं',
          'Bhaktapur': 'भक्तपुर',
          'Pokhara': 'पोखरा',
          'Urgent': 'अत्यावश्यक',
          'Search by location': 'स्थान द्वारा खोज्नुहोस्',
          'Search by blood group': 'रक्त समूह द्वारा खोज्नुहोस्',
          'Blood Required': 'रक्त आवश्यक',
          'Blood Group': 'रक्त समूह',
          'Did You Know': 'के तपाईंले थाहा पाए',
          'Nepali': 'नेपाली',
          'English': 'अंग्रेजी',
          'New Blood Request': 'नयाँ रक्त अनुरोध',
          'Is Urgent': 'अत्यावश्यक छ',
          'Search Nearby Donors': 'नजिकका दाताहरू खोज्नुहोस्',
          'Search Radius': 'खोज त्रिज्या',
          'km': 'किमी',
          'Update Profile': 'प्रोफाइल अपडेट गर्नुहोस्',
          'Select Your Location': 'तपाईंको स्थान छनौट गर्नुहोस्',
          'Select Location': 'स्थान छनौट गर्नुहोस्',
          'Get Current Location': 'हालको स्थान प्राप्त गर्नुहोस्',
        },
      };
}

String formatFirestoreTimestamp(Timestamp timestamp) {
  DateTime dateTime = timestamp.toDate();

  // Format the date
  String formattedDate = DateFormat('d MMM yyyy').format(dateTime);

  // Format the time
  String formattedTime = DateFormat('h:mm a').format(dateTime);

  // Combine date and time
  String formattedTimestamp = '$formattedDate $formattedTime';

  return formattedTimestamp;
}
