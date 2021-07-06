import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:yk_creation_booking/constants/colors.dart';
import 'package:yk_creation_booking/constants/constants.dart';
import 'package:yk_creation_booking/data/profile_model.dart';
import 'package:yk_creation_booking/pages/service_page.dart';

class EmailSignUpPage extends StatefulWidget {
  final String number;

  const EmailSignUpPage({Key? key, required this.number}) : super(key: key);

  @override
  _EmailSignUpPageState createState() => _EmailSignUpPageState();
}

class _EmailSignUpPageState extends State<EmailSignUpPage> {
  String _email = '', _name = '';

  void signUp() {
    if (_email.length == 0) {
      Fluttertoast.showToast(
          msg: 'Email is empty', toastLength: Toast.LENGTH_LONG);
      return;
    }
    if (_name.length == 0) {
      Fluttertoast.showToast(
          msg: 'Name is empty', toastLength: Toast.LENGTH_LONG);
      return;
    }
    if (!emailRegExp.hasMatch(_email)) {
      Fluttertoast.showToast(
          msg: 'Invalid Email Format', toastLength: Toast.LENGTH_LONG);
      return;
    }

    Profile profile = Profile();
    profile.email = _email;
    profile.name = _name;
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context) => ServicePage(
            number: widget.number,
            profile: profile,
          ),
          settings: RouteSettings(
            name: ServicePage.ID,
          ),
        ),
        (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
          child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height,
          maxWidth: MediaQuery.of(context).size.width,
        ),
        decoration: BoxDecoration(
          color: primaryColor,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 36, horizontal: 24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Sign Up',
                      style: TextStyle(
                          fontSize: 42.0,
                          color: Colors.white,
                          fontWeight: FontWeight.w800),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Text(
                      'YK Creation',
                      style: TextStyle(
                          fontSize: 24.0,
                          color: Colors.white,
                          fontWeight: FontWeight.w400),
                    )
                  ],
                ),
              ),
              flex: 2,
            ),
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(32),
                    topRight: Radius.circular(32),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      //mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        SizedBox(
                          height: 32,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8, horizontal: 16),
                          child: TextField(
                            keyboardType: TextInputType.emailAddress,
                            textInputAction: TextInputAction.next,
                            onChanged: (t) => _email = t,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide.none,
                              ),
                              filled: true,
                              fillColor: textFieldColor,
                              hintText: 'Email',
                              prefixIcon: Icon(
                                Icons.email,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8, horizontal: 16),
                          child: TextField(
                            onChanged: (t) => _name = t,
                            textInputAction: TextInputAction.done,
                            keyboardType: TextInputType.visiblePassword,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide.none,
                              ),
                              filled: true,
                              fillColor: textFieldColor,
                              hintText: 'Name',
                              prefixIcon: Icon(
                                Icons.person,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ),
                        ),
                        /*Align(
                              alignment: Alignment.centerRight,
                              child: TextButton(
                                onPressed: () {},
                                child: Text(
                                  'Forgot your password?',
                                  style: TextStyle(
                                    color: Colors.blue,
                                    */ /*decoration: TextDecoration.underline*/ /*
                                  ),
                                ),
                              ),
                            ),*/
                        SizedBox(
                          height: 32,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: ElevatedButton(
                            onPressed: signUp,
                            style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                    primaryColor), // <-- Button color
                                shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12.0),
                                  ),
                                )),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Text(
                                'Sign UP',
                                style: TextStyle(
                                    fontSize: 16, color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    /*Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: TextButton(
                              onPressed: signUp,
                              child: Text(
                                'Don\'t Have An Account? Register Now',
                                style: TextStyle(color: Colors.blue),
                              )),
                        ),*/
                  ],
                ),
              ),
              flex: 5,
            ),
          ],
        ),
      )),
    );
  }
}
