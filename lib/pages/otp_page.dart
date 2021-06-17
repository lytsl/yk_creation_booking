import 'dart:async';

import 'package:date_format/date_format.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:yk_creation_booking/constants/text_styles.dart';
import 'package:yk_creation_booking/data/appointment_data.dart';
import 'package:yk_creation_booking/util/gender.dart';
import 'package:yk_creation_booking/widgets/card_with_side.dart';
import 'package:yk_creation_booking/widgets/circular_button.dart';

class OTPPage extends StatefulWidget {
  const OTPPage({Key? key, required this.appointmentData}) : super(key: key);

  final AppointmentData appointmentData;

  @override
  _OTPPageState createState() => _OTPPageState();
}

class _OTPPageState extends State<OTPPage> {
  final auth = FirebaseAuth.instance;

  String? number;
  String? otpVerificationId;
  bool otpSent = false, hasSignedIn = false;
  final formKey = GlobalKey<FormState>();
  TextEditingController textEditingController = TextEditingController();

  // ..text = "123456";

  // ignore: close_sinks
  StreamController<ErrorAnimationType>? errorController;
  String otp = "";
  bool hasError = false;

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
    setState(() {
      otpSent = true;
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
          }
          setState(() {
            hasSignedIn = true;
          });
          print('signed in');
          snackBar('Signed In Successfully');
        },
        verificationFailed: (FirebaseAuthException e) {
          if (e.code == 'invalid-phone-number') {
            print('The provided phone number is not valid.');
            snackBar('The provided phone number is not valid.');
            return;
          }
          print(e.toString());
          snackBar(e.message);
        },
        codeSent: (String verificationId, int? resendToken) async {
          print('code sent');
          snackBar('Please check your phone for the verification code.');
          otpVerificationId = verificationId;
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          print("verification code: " + verificationId);
          //otpVerificationId = verificationId;
        },
      );
    } catch (e) {
      print(e.toString());
      snackBar('Failed to verify phone number ' + e.toString());
    }
  }

  Future<void> verifyOTP() async {
    print('verifying OTP');
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: otpVerificationId!, smsCode: otp);
    try {
      await auth
          .signInWithCredential(credential)
          .then((value) => print(value.user));
    } catch (e) {
      print(e);
      return;
    }
    setState(() {
      hasSignedIn = true;
    });
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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.blue.shade200,
      appBar: AppBar(
        backgroundColor: Colors.blueAccent.shade100,
        title: Text(
          'Verification',
          style: bold16,
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            //logo
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Icon(
                Icons.account_circle,
                size: 50,
              ),
            ),
            !hasSignedIn
                ? Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(32),
                          topRight: Radius.circular(32),
                        ),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          //continue with phone
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Icon(
                              Icons.account_circle,
                              size: 100,
                            ),
                          ),

                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextField(
                                onChanged: (t) => this.number = t,
                                textInputAction: TextInputAction.done,
                                keyboardType: TextInputType.phone,
                                decoration: InputDecoration(
                                  labelText: 'Mobile Number',
                                  //hintText: '',
                                  suffix: GestureDetector(
                                    onTap: () => getOTP(),
                                    child: Text(
                                      'Get OTP',
                                      style: bold16,
                                    ),
                                  ),
                                  border: OutlineInputBorder(),
                                  prefixIcon: Icon(Icons.phone),
                                )),
                          ),

                          otpSent
                              ? Expanded(
                                  child: Column(
                                    children: [
                                      SizedBox(
                                        height: 32,
                                      ),
                                      Form(
                                        key: formKey,
                                        child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 8.0, horizontal: 30),
                                            child: PinCodeTextField(
                                              appContext: context,
                                              pastedTextStyle: TextStyle(
                                                color: Colors.green.shade600,
                                                fontWeight: FontWeight.bold,
                                              ),
                                              length: 6,
                                              obscureText: true,
                                              obscuringCharacter: '*',
                                              /*obscuringWidget: ,*/
                                              blinkWhenObscuring: true,
                                              animationType: AnimationType.fade,
                                              pinTheme: PinTheme(
                                                shape: PinCodeFieldShape.box,
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                                fieldHeight: 50,
                                                fieldWidth: 40,
                                                activeFillColor: hasError
                                                    ? Colors.blue.shade100
                                                    : Colors.white,
                                              ),
                                              cursorColor: Colors.black,
                                              animationDuration:
                                                  Duration(milliseconds: 300),
                                              enableActiveFill: true,
                                              errorAnimationController:
                                                  errorController,
                                              controller: textEditingController,
                                              keyboardType:
                                                  TextInputType.number,
                                              boxShadows: [
                                                BoxShadow(
                                                  offset: Offset(0, 1),
                                                  color: Colors.black12,
                                                  blurRadius: 10,
                                                )
                                              ],
                                              onCompleted: (v) {
                                                print("Completed");
                                              },
                                              onChanged: (value) {
                                                print(value);
                                                setState(() {
                                                  otp = value;
                                                });
                                              },
                                              beforeTextPaste: (text) {
                                                print(
                                                    "Allowing to paste $text");
                                                return true;
                                              },
                                            )),
                                      ),
                                      Padding(
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
                                      ),
                                      SizedBox(
                                        height: 16,
                                      ),
                                      CircularButton(
                                          text: 'Verify',
                                          onButtonTap: () async {
                                            formKey.currentState!.validate();
                                            if (otp.length != 6) {
                                              errorController!.add(
                                                  ErrorAnimationType
                                                      .shake); // Triggering error shake animation
                                              setState(() {
                                                hasError = true;
                                              });
                                            } else {
                                              setState(
                                                () {
                                                  hasError = false;
                                                },
                                              );
                                              verifyOTP();
                                            }
                                          }),
                                    ],
                                  ),
                                )
                              : Container(),
                        ],
                      ),
                    ),
                  )
                : Expanded(
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(16.0),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(32),
                              topRight: Radius.circular(32),
                            ),
                          ),
                          child: CardWithSide(
                            height:
                                (5 * textSize('text', bold14, context).height +
                                    4 * 4 +
                                    8 * 6),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Appointment Details', style: bold14),
                                  SizedBox(
                                    height: 4,
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        'Booked with: ',
                                        style: bold14,
                                      ),
                                      Text(
                                        widget.appointmentData.person!,
                                        style: black14,
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 4,
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        'Date: ',
                                        style: bold14,
                                      ),
                                      Text(
                                        '${formatDate(widget.appointmentData.date!, [
                                                  D,
                                                  ' ',
                                                  dd,
                                                  '/',
                                                  mm,
                                                  '/',
                                                  yy
                                                ])} ' +
                                            widget.appointmentData.time!,
                                        style: black14,
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 4,
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        'Bookings for: ',
                                        style: bold14,
                                      ),
                                      Text(
                                        '${(widget.appointmentData.gender == Gender.male) ? 'Male' : 'Female'}',
                                        style: black14,
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 4,
                                  ),
                                  ElevatedButton(
                                    style: ButtonStyle(
                                        shape: MaterialStateProperty.all<
                                                RoundedRectangleBorder>(
                                            RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8.0),
                                      //side: BorderSide(color: Colors.red)
                                    ))),
                                    onPressed: () {},
                                    child: Text(
                                      'Booking Details',
                                      style: TextStyle(
                                          fontSize: 14, color: Colors.white),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
