import 'package:get/get.dart';

class Localization extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        'en': {
          'signin': 'Sign In',
          'signup': 'Sign Up',
          'create_account': 'Create Account',
          'submit': 'Submit',
          'next': 'Next',
          'skip': 'Skip',
          'have_account_already': 'Already have an account?',
          'dont_have_account': 'Don\'t have an account?',
        },

        // nepali
        'ne': {
          'signin': 'साइन इन',
          'signup': 'साइन अप',
          'create_account': 'खाता बनाउनुहोस्',
          'submit': 'सबमिट गर्नुहोस्',
          'next': 'अर्को',
          'skip': 'छोड्नुहोस्',
          'have_account_already': 'पहिले नै खाता छ?',
          'dont_have_account': 'खाता छैन?',
        },
      };
}
