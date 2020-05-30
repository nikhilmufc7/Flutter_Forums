import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:google_sign_in/google_sign_in.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final GoogleSignIn googleSignIn = GoogleSignIn();

String errorMessage;

String name;
String email;

String userId;

String userImage;

Future<String> signIn(String email, String password) async {
  FirebaseUser user;
  try {
    AuthResult result = await _auth.signInWithEmailAndPassword(
        email: email, password: password);
    user = result.user;
    name = user.displayName;
    email = user.email;
    userId = user.uid;
  } catch (error) {
    switch (error.code) {
      case "ERROR_INVALID_EMAIL":
        errorMessage = "Your email address appears to be malformed.";
        break;
      case "ERROR_WRONG_PASSWORD":
        errorMessage = "Your password is wrong.";

        break;
      case "ERROR_USER_NOT_FOUND":
        errorMessage = "User with this email doesn't exist.";
        break;
      case "ERROR_USER_DISABLED":
        errorMessage = "User with this email has been disabled.";
        break;
      case "ERROR_TOO_MANY_REQUESTS":
        errorMessage = "Too many requests. Try again later.";
        break;
      case "ERROR_OPERATION_NOT_ALLOWED":
        errorMessage = "Signing in with Email and Password is not enabled.";
        break;
      default:
        errorMessage = "An undefined Error happened.";
    }
  }
  if (user == null) {
    return Future.error(errorMessage);
  }

  return user.uid;
}

Future<String> signUp(String email, String password, String firstName) async {
  FirebaseUser user;

  try {
    AuthResult result = await _auth.createUserWithEmailAndPassword(
        email: email, password: password);
    user = result.user;
    name = user.displayName;
    email = user.email;
    userId = user.uid;

    Firestore.instance.collection('users').document(user.uid).setData({
      "uid": user.uid,
      "firstName": firstName,
      "email": email,
    });
  } catch (error) {
    switch (error.code) {
      case "ERROR_OPERATION_NOT_ALLOWED":
        errorMessage = "Anonymous accounts are not enabled";
        break;
      case "ERROR_WEAK_PASSWORD":
        errorMessage = "Your password is too weak";
        break;
      case "ERROR_INVALID_EMAIL":
        errorMessage = "Your email is invalid";
        break;
      case "ERROR_EMAIL_ALREADY_IN_USE":
        errorMessage = "Email is already in use on different account";
        break;
      case "ERROR_INVALID_CREDENTIAL":
        errorMessage = "Your email is invalid";
        break;

      default:
        errorMessage = "An undefined Error happened.";
    }
  }
  if (user == null) {
    return Future.error(errorMessage);
  }

  return user.uid;
}

void signOutGoogle(context) async {
  await _auth.signOut();
  await googleSignIn.signOut();

  print("User Sign Out");
}

Future<void> resetPassword(String email) async {
  try {
    await _auth.sendPasswordResetEmail(email: email);
  } catch (error) {
    switch (error.code) {
      case "ERROR_USER_NOT_FOUND":
        errorMessage = "Email address does not have a account";
        break;
      case "ERROR_INVALID_EMAIL":
        errorMessage = "Invalid email";
        break;

      default:
        errorMessage = "An undefined Error happened.";
    }
  }
  if (errorMessage != null) {
    return Future.error(errorMessage);
  }
}
