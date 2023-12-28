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
          'call': 'Call',
          'verified': 'Verified',
          'not_verified': 'Not Verified',
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
          'call': 'कल',
          'verified': 'सत्यापित',
          'not_verified': 'सत्यापित छैन',
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
