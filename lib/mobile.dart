import 'package:e_proof_app/phoneformpage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class Mobile {
  late MobileVerificationState currentState;
  late String verificationID;
  FirebaseAuth _auth = FirebaseAuth.instance;
  late PhoneFormPage phoneFormPage;

  Future<void> saveAndLaunchFile(List<int> bytes, String fileName) async {
    final path = (await getExternalStorageDirectory())!.path;
    final file = File('$path/$fileName');
    await file.writeAsBytes(bytes, flush: true);
    OpenFile.open('$path/$fileName');
  }

  void setOtpState() {
    currentState = MobileVerificationState.SHOW_OTP_FORM_STATE;
  }

  void signInWithPhoneAuthCredential(
      PhoneAuthCredential phoneAuthCredential, BuildContext context) async {
    try {
      final authCredential =
          await _auth.signInWithCredential(phoneAuthCredential);

      if (authCredential.user != null) {
        Navigator.pushNamed(context, '/home');
      }
    } on FirebaseAuthException catch (e) {
      final snackBar = SnackBar(content: Text(e.message!));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  Future<void> phoneNumberVerification(
      String phoneNumber, BuildContext context) async {
    await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (phoneAuthCredential) async {
          signInWithPhoneAuthCredential(phoneAuthCredential, context);
        },
        verificationFailed: (verificationFailed) async {
          final snackBar = SnackBar(content: Text(verificationFailed.message!));
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        },
        codeSent: (verificationId, resendingToken) async {
          verificationID = verificationId;
        },
        codeAutoRetrievalTimeout: (verificationId) async {});
  }

  Future<void> confirmCode(String otpCode, BuildContext context) async {
    PhoneAuthCredential phoneAuthCredential = PhoneAuthProvider.credential(
        verificationId: verificationID, smsCode: otpCode);
    signInWithPhoneAuthCredential(phoneAuthCredential, context);
  }
}
