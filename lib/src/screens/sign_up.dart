import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geoflutterfire2/geoflutterfire2.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import '../constants/app_themes.dart';
import '../widgets/widgets.dart';
import 'sign_in.dart';

class RTitle extends StatelessWidget {
  final String tile;
  final String subtitle;
  const RTitle({super.key, required this.tile, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            tile,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            subtitle,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 15,
              fontWeight: FontWeight.w300,
            ),
          ),
        ],
      ),
    );
  }
}

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  static const routeName = '/signup';

  @override
  State<SignUp> createState() => _SignUpState();
}

class RegisterFormData {
  String uid = '';
  String email = '';
  String password = '';
  String confirmPassword = '';
  String firstName = '';
  String middleName = '';
  String lastName = '';
  String mobileNumber = '';
  String city = 'Lalitpur';
  dynamic position;
  String bloodGroup = '';
  String citizenshipNo = '';
}

class _SignUpState extends State<SignUp> {
  bool isLoading = false;

  final List<GlobalKey<FormState>> _formKeys = [
    GlobalKey<FormState>(),
    GlobalKey<FormState>(),
    GlobalKey<FormState>(),
  ];

  final RegisterFormData formData = RegisterFormData();

  int _currentStep = 0;

  Future<void> getCurrentLocation() async {
    LocationPermission permission =
        await GeolocatorPlatform.instance.checkPermission();
    if (permission == LocationPermission.denied) {}

    permission = await GeolocatorPlatform.instance.requestPermission();
    try {
      Position position =
          await GeolocatorPlatform.instance.getCurrentPosition();
      double latitude = position.latitude;
      double longitude = position.longitude;
      print('Latitude: $latitude, Longitude: $longitude');

      formData.position =
          GeoFlutterFire().point(latitude: latitude, longitude: longitude).data;

      setState(() {});
    } catch (e) {
      print('Error getting location: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Register"),
        shadowColor: Colors.transparent,
      ),
      body: Stack(
        children: [
          Stepper(
            type: StepperType.horizontal,
            elevation: 0,
            physics: const ScrollPhysics(),
            currentStep: _currentStep,
            controlsBuilder: (BuildContext context, ControlsDetails controls) {
              return const SizedBox.shrink();
            },
            steps: [
              Step(
                label: const Text(
                  'Account\nInformation',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 10,
                  ),
                ),
                title: const SizedBox.shrink(),
                content: Form(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  key: _formKeys[0],
                  child: Column(children: [
                    const RTitle(
                      tile: "Create your account",
                      subtitle:
                          "Please enter your information to create account",
                    ),
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
                      onChanged: (newValue) {
                        formData.password = newValue!;
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    PasswordInput(
                      labelText: 'Confirm Password',
                      validator: (value) {
                        if (value != formData.password) {
                          return 'Password does not match';
                        }
                        return null;
                      },
                      onSaved: (newValue) {
                        formData.confirmPassword = newValue!;
                      },
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 15),
                      child: RButton(
                        onPressed: () {
                          createAccount();
                        },
                        buttonTitle: 'create_account'.tr,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('have_account_already'.tr),
                        TextButton(
                          onPressed: () {
                            Get.to(const SignIn());
                          },
                          child: Text(
                            "signin".tr,
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
                isActive: _currentStep == 0,
                state:
                    _currentStep >= 1 ? StepState.complete : StepState.disabled,
              ),
              Step(
                label: const Text(
                  'Personal\nInformation',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 10,
                  ),
                ),
                title: const SizedBox.shrink(),
                content: Form(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  key: _formKeys[1],
                  child: Column(children: [
                    const RTitle(
                      tile: "Personal Information",
                      subtitle:
                          "Only provide information that is true and correct",
                    ),
                    TextInput(
                      labelText: 'First Name',
                      onSaved: (newValue) {
                        formData.firstName = newValue!;
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextInput(
                      labelText: 'Middle Name',
                      isRequired: false,
                      onSaved: (newValue) {
                        formData.middleName = newValue!;
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextInput(
                      labelText: 'Last Name',
                      onSaved: (newValue) {
                        formData.lastName = newValue!;
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextInput(
                      labelText: 'Contact No.',
                      onSaved: (newValue) {
                        formData.mobileNumber = newValue!;
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    CityFormSelect(
                      initialValue: formData.city,
                      onSaved: (newValue) {
                        formData.city = newValue!;
                      },
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    RIconButton(
                        text: "Give Current Location",
                        icon: const Icon(Icons.share_location),
                        color: formData.position == null
                            ? Colors.blue
                            : Colors.green,
                        onPressed: () async {
                          await getCurrentLocation();
                        }),
                    const SizedBox(
                      height: 12,
                    ),
                    BloodTypeFormSelect(
                      onSaved: (newValue) {
                        formData.bloodGroup = newValue!;
                      },
                    ),
                    const SizedBox(height: 11),
                    RButton(
                      onPressed: () {
                        next();
                      },
                      buttonTitle: 'next'.tr,
                    ),
                  ]),
                ),
                isActive: _currentStep == 1,
                state:
                    _currentStep >= 2 ? StepState.complete : StepState.disabled,
              ),
              Step(
                label: const Text(
                  'Verification',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 10,
                  ),
                ),
                title: const SizedBox.shrink(),
                content: Form(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  key: _formKeys[2],
                  child: Column(children: [
                    const RTitle(
                      tile: "Verify your identity",
                      subtitle: "Are you you?",
                    ),
                    TextInput(
                      isRequired: false,
                      labelText: "Citizenship No.",
                      onSaved: (newValue) {
                        formData.citizenshipNo = newValue!;
                      },
                    ),
                    Container(
                      height: 50,
                      margin: const EdgeInsets.symmetric(vertical: 15),
                      child: Row(
                        children: [
                          MediumButton(
                            backgroundColor: Colors.grey,
                            onPressed: () {
                              submitPersonalInfo(skip: true);
                            },
                            buttonTitle: 'skip'.tr,
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          MediumButton(
                            onPressed: () {
                              submitPersonalInfo();
                            },
                            buttonTitle: 'Submit'.tr,
                          ),
                        ],
                      ),
                    )
                  ]),
                ),
                isActive: _currentStep == 2,
                state:
                    _currentStep >= 3 ? StepState.complete : StepState.disabled,
              ),
            ],
          ),
          if (isLoading)
            Positioned.fill(
              child: Container(
                color: Colors.black
                    .withOpacity(0.7), // Background color with opacity
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            ),
        ],
      ),
    );
  }

  continued() {
    setState(() {
      _currentStep += 1;
    });
    // if (_formKeys[_currentStep].currentState!.validate()) {
    //   for (var element in _formKeys) {
    //     element.currentState!.save();
    //   }

    //   if (_currentStep < 2) {
    //     setState(() {
    //       _currentStep += 1;
    //     });
    //   } else {
    //     register();
    //     print(formData.email);
    //     print(formData.bloodGroup);
    //   }
    // } else {
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     const SnackBar(content: Text('Enter valid data')),
    //   );
    // }
  }

  cancel() {
    _currentStep > 0 ? setState(() => _currentStep -= 1) : null;
  }

  register() {}

  signInWithGoogle() async {
    // var u =
    //     await FirebaseAuth.instance.signInWithProvider(GoogleAuthProvider());
  }

  setLoading(bool value) {
    setState(() {
      isLoading = value;
    });
  }

  createAccount() async {
    setLoading(true);
    if (!_formKeys[0].currentState!.validate()) {
      setLoading(false);
      Get.showSnackbar(const GetSnackBar(
        title: "Enter valid data",
        message: "Input Validation failed",
      ));
      return;
    }
    _formKeys[0].currentState!.save();
    try {
      final user = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: formData.email,
        password: formData.password,
      );

      formData.uid = user.user!.uid;

      Get.showSnackbar(const GetSnackBar(
        title: "Account created successfully",
        message: "Fill personal information",
        duration: Duration(seconds: 2),
      ));
      setState(() {
        _currentStep = 1;
      });
    } catch (e) {
      // print(e.toString());
      Get.showSnackbar(GetSnackBar(
        title: "Account creation failed",
        message: e.toString(),
        duration: const Duration(seconds: 2),
      ));
    } finally {
      setLoading(false);
    }
  }

  next() {
    if (!_formKeys[1].currentState!.validate()) {
      Get.showSnackbar(const GetSnackBar(
        title: "Enter valid data",
        message: "Input Validation failed",
      ));

      return;
    }
    _formKeys[1].currentState!.save();
    setState(() {
      _currentStep = 2;
    });
  }

  submitPersonalInfo({bool skip = false}) async {
    setLoading(true);
    if (!skip && !_formKeys[2].currentState!.validate()) {
      setLoading(false);

      Get.showSnackbar(const GetSnackBar(
        title: "Enter valid data",
        message: "Input Validation failed",
        duration: Duration(seconds: 2),
      ));
      return;
    }
    _formKeys[2].currentState!.save();

    try {
      // query firebase firestore
      var user = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: formData.email)
          .get();

      if (user.docs.isNotEmpty) {
        Get.showSnackbar(const GetSnackBar(
          title: "Account creation failed",
          message: "Account already exists",
          duration: Duration(seconds: 2),
        ));
        return;
      }

      var userData = {
        'uid': formData.uid,
        'email': formData.email,
        'firstName': formData.firstName,
        'middleName': formData.middleName,
        'lastName': formData.lastName,
        'mobileNumber': formData.mobileNumber,
        'bloodGroup': formData.bloodGroup,
        'city': formData.city,
        'position': formData.position,
        'verified': false,
        'donor': true
      };

      if (!skip) {
        userData['citizenshipNo'] = formData.citizenshipNo;
      }

      // add user to firebase firestore

      await FirebaseFirestore.instance.collection('users').add(userData);

      // Get.
      Get.showSnackbar(const GetSnackBar(
        title: "Successfully submitted personal informations",
        message: "You can now login",
        duration: Duration(seconds: 2),
      ));
      Get.offAllNamed('/');
    } catch (e) {
      // print(e.toString());
      Get.showSnackbar(GetSnackBar(
        title: "Failed to submit personal information",
        message: e.toString(),
        duration: const Duration(seconds: 2),
      ));
    } finally {
      setLoading(false);
    }
  }
}
