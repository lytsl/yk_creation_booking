import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yk_creation_booking/constants/colors.dart';
import 'package:yk_creation_booking/constants/firebase_auth_error.dart';
import 'package:yk_creation_booking/constants/text_styles.dart';
import 'package:yk_creation_booking/data/profile_model.dart';
import 'package:yk_creation_booking/data/salon_location_model.dart';
import 'package:yk_creation_booking/pages/email_signup_page.dart';
import 'package:yk_creation_booking/pages/service_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  //final AppointmentData appointmentData;

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final auth = FirebaseAuth.instance;

  String? number, uid;
  String? otpVerificationId;
  bool otpSent = false, hasSignedIn = false;
  final formKey = GlobalKey<FormState>();
  TextEditingController textEditingController = TextEditingController();

  // ..text = "123456";

  // ignore: close_sinks
  StreamController<ErrorAnimationType>? errorController;
  String otp = "";
  bool hasError = false;
  Color bgColor = Color(0xFFF7F7F7);
  Color logoBGColor = Color(0xffdedede);

  Timer? _timer;
  int _start = 60;

  //Color(0xFFf5f6f8)

  Future<void> navigateToServicePage() async {
    //final user = FirebaseAuth.instance.currentUser?.uid;
    print(uid);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('uid', uid!);
    prefs.setString('number', this.number!);

    bool isNewCustomer = await SalonLocationModel.isNewCustomer(number!);
    //isNewCustomer = true;
    if (isNewCustomer == true) {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => EmailSignUpPage(
                number: this.number!,
              )));
    } else {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
              builder: (_) => ServicePage(
                    number: this.number!,
                    profile: Profile(),
                  )),
          (route) => false);
    }
  }

  void startTimer() {
    _start = 60;
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_start == 0) {
          setState(() {
            timer.cancel();
          });
        } else {
          setState(() {
            _start--;
          });
        }
      },
    );
  }

  Future<void> getOTP() async {
    print('get OTP');
    if (number == null) {
      Fluttertoast.showToast(
          msg: 'Please enter mobile number', toastLength: Toast.LENGTH_LONG);
      return;
    }
    final String? message = validateMobile(number!);
    if (message != null) {
      Fluttertoast.showToast(msg: message, toastLength: Toast.LENGTH_LONG);
      return;
    }
    startTimer();
    setState(() {
      otpSent = true;
    });
    SalonLocationModel.getCustomerID(number!).then((value) async {
      if (value == null) return;
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('customerID', value);
    });
    try {
      await auth.verifyPhoneNumber(
        phoneNumber: number!,
        timeout: Duration(seconds: 60),
        verificationCompleted: (PhoneAuthCredential credential) async {
          print('verification completed');
          try {
            await auth.signInWithCredential(credential);
          } catch (e) {
            print('verification error ' + e.toString());
            snackBar(e.toString());
            //Fun.toast(e.toString());
            return;
          }
          setState(() {
            hasSignedIn = true;
          });
          print('signed in try await');
          snackBar('Signed In Successfully');
        },
        verificationFailed: (FirebaseAuthException e) {
          if (e.code == 'invalid-phone-number') {
            print('The provided phone number is not valid.');
            snackBar('The provided phone number is not valid.');
            return;
          }
          print('verification Failed ' + e.toString());
          snackBar(e.message);
          //Fun.toast(e.message??'Verification failed');
        },
        codeSent: (String verificationId, int? resendToken) async {
          print('code sent');
          //snackBar('Please check your phone for the verification code.');
          otpVerificationId = verificationId;
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          print("verification code: " + verificationId);
          //otpVerificationId = verificationId;
        },
      );
    } catch (e) {
      print('getOTP catch ' + e.toString());
      snackBar('Failed to verify phone number ' + e.toString());
    }
  }

  Future<void> verifyOTP() async {
    print('verifying OTP');
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: otpVerificationId!, smsCode: otp);
    try {
      await auth.signInWithCredential(credential).then((value) {
        uid = value.user?.uid;
        if (uid == null) {
          throw Exception('Could not sign in');
          return;
        }
        //setState(() {
        //hasSignedIn = true;
        //});
        navigateToServicePage();
      });
      print('signed in verifyOTP');
    } catch (e) {
      //Fun.toast('Verification Failed');
      snackBar(FirebaseAuthErrorCode.getErrorMessage(e));
      print('verify OTP ' + e.toString());
      return;
    }
  }

  String? validateMobile(String value) {
    String pattern = r'(^(?:[+0]9)?[0-9]{10,12}$)';
    RegExp regExp = new RegExp(pattern);
    if (value.length == 0) {
      return 'Please enter mobile number';
    } else if (!regExp.hasMatch(value)) {
      return 'Please enter valid mobile number';
    }
    return null;
  }

  snackBar(String? message) {
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message!),
        duration: Duration(seconds: 2),
      ),
    );
  }

  Size textSize(String text, TextStyle textStyle, BuildContext context) =>
      (TextPainter(
              text: TextSpan(text: text, style: textStyle),
              maxLines: 1,
              textScaleFactor: MediaQuery.of(context).textScaleFactor,
              textDirection: TextDirection.ltr)
            ..layout())
          .size;

  @override
  void initState() {
    errorController = StreamController<ErrorAnimationType>();
    super.initState();
  }

  @override
  void dispose() {
    errorController!.close();
    if (_timer != null) _timer!.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //resizeToAvoidBottomInset: false,
      backgroundColor: primaryColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height,
              maxWidth: MediaQuery.of(context).size.width,
            ),
            child: Column(
              children: [
                //logo
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Image.asset(
                    'assets/logo.png',
                    height: 120,
                    width: 120,
                    fit: BoxFit.cover,
                  ),
                ),
                //!hasSignedIn
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: bgColor,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(16),
                        topRight: Radius.circular(16),
                      ),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        SizedBox(
                          height: 16,
                        ),
                        //continue with phone
                        Text(
                          'Continue with Phone',
                          style: bold16,
                        ),
                        Image.asset(
                          'assets/otp_image.jpg',
                          height: 200,
                          width: 200,
                          fit: BoxFit.fill,
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        Card(
                          elevation: 4,
                          margin: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          child: TextField(
                              onChanged: (t) => this.number = t,
                              textInputAction: TextInputAction.done,
                              keyboardType: TextInputType.phone,
                              decoration: InputDecoration(
                                contentPadding:
                                    EdgeInsets.symmetric(vertical: 16),
                                //labelText: 'Mobile Number',
                                //contentPadding: const EdgeInsets.all(8.0),
                                suffixIcon: GestureDetector(
                                  onTap: () {
                                    FocusScope.of(context).unfocus();
                                    getOTP();
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.only(right: 8),
                                    child: Card(
                                      margin: EdgeInsets.zero,
                                      elevation: 2,
                                      color: Color(0xFFe1e1e1),
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(8))),
                                      child: Container(
                                        padding: EdgeInsets.all(8),
                                        child: Icon(
                                          Icons.arrow_forward,
                                          color: primaryColor,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                //isDense: true,
                                suffixIconConstraints:
                                    BoxConstraints(maxWidth: 48, maxHeight: 40),
                                border: InputBorder.none,
                                filled: true,
                                fillColor: Colors.white,
                                prefixIcon: Icon(
                                  Icons.phone,
                                  color: primaryColor,
                                ),
                                hintText: 'Enter your phone number',
                                focusColor: Colors.black,
                              )),
                        ),

                        otpSent
                            ? Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    SizedBox(
                                      height: 16,
                                    ),
                                    Visibility(
                                      visible: _start == 0 ? false : true,
                                      child: Align(
                                          alignment: Alignment.topCenter,
                                          child: Text(
                                            'Fetching OTP: 0:$_start secs',
                                            style: TextStyle(color: Colors.red),
                                          )),
                                    ),
                                    Form(
                                      key: formKey,
                                      child: Card(
                                        elevation: 0,
                                        color: Colors.transparent,
                                        margin: const EdgeInsets.symmetric(
                                            horizontal: 64, vertical: 0),
                                        child: TextField(
                                            textInputAction:
                                                TextInputAction.done,
                                            style: TextStyle(
                                              letterSpacing: 16.0,
                                            ),
                                            onChanged: (t) => this.otp = t,
                                            keyboardType: TextInputType.phone,
                                            textAlign: TextAlign.center,
                                            decoration: InputDecoration(
                                              contentPadding:
                                                  EdgeInsets.symmetric(
                                                      vertical: 16),
                                              hintText: 'OTP',
                                              //border:InputBorder.none,
                                              /*prefixIcon:
                                                        Icon(Icons.lock),*/
                                              focusColor: Colors.black,
                                              // suffix: Container(),
                                            )),
                                      ),
                                    ),
                                    /*Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 30.0),
                                            child: Text(
                                              hasError
                                                  ? "*Please fill up all the cells properly"
                                                  : "",
                                              style: TextStyle(
                                                  color: Colors.red,
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w400),
                                            ),
                                          ),*/
                                    SizedBox(
                                      height: 24,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16),
                                      child: ElevatedButton(
                                          onPressed: () {
                                            if (otp.length != 6) {
                                              snackBar('OTP length must be 6');
                                            } else {
                                              verifyOTP();
                                            }
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 16),
                                            child: Text(
                                              'SUBMIT',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16),
                                            ),
                                          ),
                                          style: ButtonStyle(
                                              backgroundColor:
                                                  MaterialStateProperty.all(
                                                      primaryColor), // <-- Button color
                                              /*overlayColor:
                                                  MaterialStateProperty
                                                      .resolveWith<Color?>(
                                                          (states) {
                                                if (states.contains(
                                                    MaterialState.pressed))
                                                  return Colors
                                                      .blue; // <-- Splash color
                                              }),*/
                                              shape: MaterialStateProperty.all<
                                                  RoundedRectangleBorder>(
                                                RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          12.0),
                                                ),
                                              ))),
                                    ),
                                    SizedBox(
                                      height: 16,
                                    ),
                                    (_start == 0)
                                        ? TextButton(
                                            onPressed: getOTP,
                                            child: Text(
                                              'RESEND CODE',
                                              style: TextStyle(
                                                  color: Colors.red,
                                                  decoration:
                                                      TextDecoration.underline),
                                            ))
                                        : Container(),
                                  ],
                                ),
                              )
                            : Container(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
