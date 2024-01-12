import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:raktadaan/src/constants/app_themes.dart';
import 'package:raktadaan/src/widgets/widgets.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  TextEditingController emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reset Password'.tr),
      ),
      body: FullPageLoading(
        builder: (setLoading) => Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 50, bottom: 20),
                    child: Center(
                      child: Text(
                        'Reset Password'.tr,
                        style: const TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: AppThemes.primaryColor,
                        ),
                      ),
                    ),
                  ),
                  Form(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    key: _formKey,
                    child: Column(children: [
                      TextFormField(
                          controller: emailController,
                          // validator: ,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(11),
                            ),
                            labelText: 'Email',
                            prefixIcon: const Icon(Icons.email),
                            prefixIconColor: AppThemes.primaryColor,
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter email';
                            } else if (!EmailValidator.validate(value)) {
                              return 'Please enter valid email';
                            }
                            return null;
                          }),
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 15),
                        child: RButton(
                          onPressed: () {
                            submit(setLoading);
                          },
                          buttonTitle: 'Submit'.tr,
                        ),
                      ),
                    ]),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  submit(setLoading) async {
    setLoading(true);

    if (!_formKey.currentState!.validate()) {
      setLoading(false);
      Get.showSnackbar(const GetSnackBar(
        title: "Enter valid data",
        message: "Input Validation failed",
        duration: Duration(seconds: 1),
      ));
      return;
    }

    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: emailController.text);

      Get.showSnackbar(const GetSnackBar(
        title: "Success",
        message: 'Password reset link sent to your email',
        duration: Duration(seconds: 1),
      ));
      Get.back(); // Close dialog
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        Get.showSnackbar(const GetSnackBar(
          title: "Error",
          message: "No user found for that email.",
          duration: Duration(seconds: 1),
        ));
      }
    } finally {
      setLoading(false);
    }
  }
}
