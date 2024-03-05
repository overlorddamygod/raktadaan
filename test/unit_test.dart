import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:raktadaan/src/screens/sign_in.dart';

class SignUpFormData {
  String email = '';
  String password = '';
  String confirmPassword = '';
}

void main() {
  group('SignUpValidationTest', () {
    final formState = SignUpFormData();
    final key = GlobalKey<FormState>();
    testWidgets('User Registration with invalid inputs',
        (WidgetTester tester) async {
      await tester.pumpWidget(builder(key, formState));

      const email = "user@gmail";
      const password = "t";
      const confirmPassword = "t";

      await tester.enterText(find.byKey(const Key("email")), email);
      await tester.enterText(find.byKey(const Key("password")), password);
      await tester.enterText(
          find.byKey(const Key("confirm_password")), confirmPassword);

      expect(key.currentState!.validate(), isFalse);
    });
    testWidgets('User Registration with valid inputs',
        (WidgetTester tester) async {
      await tester.pumpWidget(builder(key, formState));

      const email = "user@gmail.com";
      const password = "Testuser1";
      const confirmPassword = "Testuser1";

      await tester.enterText(find.byKey(const Key("email")), email);
      await tester.enterText(find.byKey(const Key("password")), password);
      await tester.enterText(
          find.byKey(const Key("confirm_password")), confirmPassword);

      expect(key.currentState!.validate(), isTrue);
    });
  });
}

Widget emailBuilder(GlobalKey<FormState> key, SignInFormData formData) {
  return MaterialApp(
    home: MediaQuery(
      data: const MediaQueryData(),
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: Center(
          child: Material(
            child: Form(
              key: key,
              child: TextFormField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter email';
                  } else if (!EmailValidator.validate(value)) {
                    return 'Please enter valid email';
                  }
                  return null;
                },
                onSaved: (String? value) {
                  formData.email = value!;
                },
              ),
            ),
          ),
        ),
      ),
    ),
  );
}

Widget builder(GlobalKey<FormState> key, SignUpFormData formData) {
  return MaterialApp(
    home: MediaQuery(
      data: const MediaQueryData(),
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: Center(
          child: Material(
            child: Form(
              key: key,
              child: Column(
                children: [
                  TextFormField(
                    key: const Key("email"),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter email';
                      } else if (!EmailValidator.validate(value)) {
                        return 'Please enter valid email';
                      }
                      return null;
                    },
                    onSaved: (String? value) {
                      formData.email = value!;
                    },
                  ),
                  TextFormField(
                    key: const Key("password"),
                    onSaved: (newValue) {
                      formData.password = newValue!;
                    },
                    onChanged: (newValue) {
                      formData.password = newValue!;
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter some text';
                      }

                      if (value.length < 6) {
                        return 'Password must be at least 6 characters long';
                      }

                      return null;
                    },
                  ),
                  TextFormField(
                    key: const Key("confirm_password"),
                    onSaved: (newValue) {
                      formData.password = newValue!;
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter some text';
                      }

                      if (value.length < 6) {
                        return 'Password must be at least 6 characters long';
                      }
                      if (value != formData.password) {
                        return 'Password does not match';
                      }

                      return null;
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    ),
  );
}
