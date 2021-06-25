import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthErrorCode {
  static String getErrorMessage(dynamic object) {
    String errorMessage = "An Unexpected error occurred.";
    if (object is FirebaseAuthException) {
      FirebaseAuthException error = object;
      print('error code is $error.code');
      switch (error.code) {
        case "invalid-email":
          errorMessage = "Your email address appears to be malformed.";
          break;
        case "wrong-password":
          errorMessage = "Your password is wrong.";
          break;
        case "user-not-found":
          errorMessage = "User with this email doesn't exist.";
          break;
        case "user-disabled":
          errorMessage = "User with this email has been disabled.";
          break;
        case "too-many-requests":
          errorMessage = "Too many requests. Try again later.";
          break;
        case "operation-not-allowed":
          errorMessage = "Signing in with Email and Password is not enabled.";
          break;
        case "email-already-in-use":
          errorMessage =
              "The email address is already in use by another account.";
          break;
        case "invalid-verification-code":
          errorMessage = 'Your OTP is wrong';
          break;
        case 'invalid-phone-number':
          errorMessage = 'The provided phone number is not valid.';
          break;
        default:
          errorMessage = error.message ?? errorMessage;
      }
    }
    return errorMessage;
  }
}
