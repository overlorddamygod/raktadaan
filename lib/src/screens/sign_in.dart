import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:raktadaan/src/constants/app_themes.dart';
import 'package:raktadaan/src/screens/home_screen.dart';
import 'package:raktadaan/src/screens/sign_up.dart';

import '../widgets/widgets.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  static const routeName = '/signin';

  @override
  State<SignIn> createState() => _SignInState();
}

class SignInFormData {
  String email = '';
  String password = '';
}

class _SignInState extends State<SignIn> {
  final _formKey = GlobalKey<FormState>();

  final formData = SignInFormData();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('signin'.tr),
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
                        'signin'.tr,
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
                        },
                        onSaved: (newValue) {
                          formData.email = newValue!;
                        },
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      PasswordInput(
                        labelText: 'Password',
                        onSaved: (newValue) {
                          formData.password = newValue!;
                        },
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 15),
                        child: RButton(
                          onPressed: () {
                            signIn(setLoading);
                          },
                          buttonTitle: 'signin'.tr,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('dont_have_account'.tr),
                          TextButton(
                            onPressed: () {
                              Get.to(() => const SignUp());
                            },
                            child: Text(
                              "signup".tr,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                              onPressed: () {
                                // signInWithGoogle();
                              },
                              icon: const Icon(Icons.add))
                        ],
                      )
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

  signIn(setLoading) async {
    setLoading(true);
    if (!_formKey.currentState!.validate()) {
      setLoading(false);
      Get.showSnackbar(const GetSnackBar(
        title: "Enter valid data",
        message: "Input Validation failed",
      ));
      return;
    }
    _formKey.currentState!.save();
    try {
      // Code to be executed after the delay
      final _ = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: formData.email,
        password: formData.password,
      );

      Get.showSnackbar(const GetSnackBar(
        title: "Signed in successfully",
        message: " ",
        duration: Duration(seconds: 2),
      ));

      Get.offAll(const HomeScreen());
    } catch (e) {
      // print(e.toString());
      Get.showSnackbar(GetSnackBar(
        title: "Sign In failed",
        message: e.toString(),
        duration: const Duration(seconds: 2),
      ));
    } finally {
      setLoading(false);
    }
  }
}
