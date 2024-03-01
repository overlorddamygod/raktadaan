// import 'package:flutter/material.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:get/get.dart';
// import 'package:raktadaan/src/screens/sign_in.dart';

// void main() {
//   group('SignInWidgetValidationTest', () {
//     testWidgets('Empty email shows error', (WidgetTester tester) async {
//       await tester.pumpWidget(MaterialApp(
//         home: SignIn(),
//       ));

//       // Access the SignIn widget to get its state
//       final signInWidget =
//           tester.widget(find.byType(SignInState)) as SignInState;
//       final formKey = signInWidget.formKey;

//       // Enter an empty email
//       await tester.enterText(find.byKey(const Key('email_text_field')), '');

//       // Tap the sign-in button
//       await tester.tap(find.text('signin'.tr));
//       await tester.pump();

//       // Expect to find an error message
//       expect(formKey.currentState!.validate(), isFalse);
//       expect(find.text('Please enter email'), findsOneWidget);
//     });

//     // testWidgets('Invalid email shows error', (WidgetTester tester) async {
//     //   await tester.pumpWidget(MaterialApp(
//     //     home: SignIn(),
//     //   ));

//     //   // Enter an invalid email
//     //   await tester.enterText(
//     //       find.byKey(const Key('email_text_field')), 'invalidemail');

//     //   // Tap the sign-in button
//     //   await tester.tap(find.text('signin'.tr));
//     //   await tester.pump();

//     //   // Expect to find an error message
//     //   expect(find.text('Please enter valid email'), findsOneWidget);
//     // });

//     // testWidgets('Empty password shows error', (WidgetTester tester) async {
//     //   await tester.pumpWidget(MaterialApp(
//     //     home: SignIn(),
//     //   ));

//     //   // Enter an empty password
//     //   await tester.enterText(find.byKey(const Key('password_text_field')), '');

//     //   // Tap the sign-in button
//     //   await tester.tap(find.text('signin'.tr));
//     //   await tester.pump();

//     //   // Expect to find an error message
//     //   expect(find.text('Please enter password'), findsOneWidget);
//     // });
//   });
// }
