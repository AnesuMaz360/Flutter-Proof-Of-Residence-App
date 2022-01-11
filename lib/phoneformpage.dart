import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

enum MobileVerificationState {
  SHOW_MOBILE_FORM_STATE,
  SHOW_OTP_FORM_STATE,
}

class PhoneFormPage extends StatefulWidget {
  @override
  _PhoneFormPageFormState createState() => _PhoneFormPageFormState();
}

class _PhoneFormPageFormState extends State<PhoneFormPage> {
  MobileVerificationState currentState =
      MobileVerificationState.SHOW_MOBILE_FORM_STATE;
  final phoneController = TextEditingController();
  final otpController = TextEditingController();
  ConfirmationResult? webConfirmationResult;

  bool showLoading = false;

  FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> phoneNumberVerification(String phoneNumber) async {
    ConfirmationResult confirmationResult =
        await _auth.signInWithPhoneNumber(phoneNumber);
    webConfirmationResult = confirmationResult;
    setState(() {
      currentState = MobileVerificationState.SHOW_OTP_FORM_STATE;
    });
  }

  Future<void> confirmCode(String otpCode) async {
    setState(() {
      showLoading = true;
    });

    if (webConfirmationResult != null) {
      try {
        await webConfirmationResult!.confirm(otpCode);
        setState(() {
          showLoading = false;
        });
        Navigator.pushNamed(context, '/home');
      } catch (e) {
        setState(() {
          showLoading = false;
        });
        final snackBar =
            SnackBar(content: Text('Failed to sign in: ${e.toString()}'));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    } else {
      final snackBar = SnackBar(
          content: Text(
              'Please input sms code received after verifying phone number'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  getMobileFormWidget(context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: EdgeInsets.all(8.0),
          child: TextFormField(
            controller: phoneController,
            validator: (value) =>
                value!.isEmpty ? 'Email cannot be empty' : null,
            decoration: InputDecoration(
              labelText: 'Phone Number',
              hintText: 'Enter number with country code',
              border: OutlineInputBorder(),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(8.0),
        ),
        Padding(
          padding: EdgeInsets.all(8.0),
          child: TextButton(
            onPressed: () {
              phoneNumberVerification(phoneController.text);
            },
            child: Text(
              'Send',
              style: TextStyle(fontSize: 20.0),
            ),
            style: TextButton.styleFrom(
              primary: Colors.white,
              backgroundColor: Colors.green[900],
            ),
          ),
        ),
      ],
    );
  }

  getOtpFormWidget(context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: EdgeInsets.all(8.0),
          child: TextFormField(
            controller: otpController,
            validator: (value) => value!.isEmpty ? 'OTP cannot be empty' : null,
            decoration: InputDecoration(
              labelText: 'OTP',
              hintText: 'Enter OTP code',
              border: OutlineInputBorder(),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(8.0),
        ),
        Padding(
          padding: EdgeInsets.all(8.0),
          child: TextButton(
            onPressed: () {
              confirmCode(otpController.text);
            },
            child: Text(
              'Verify',
              style: TextStyle(fontSize: 20.0),
            ),
            style: TextButton.styleFrom(
              primary: Colors.white,
              backgroundColor: Colors.green[900],
            ),
          ),
        ),
      ],
    );
  }

  final GlobalKey<ScaffoldState> _scaffoldkey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Phone Number and OTP'),
        backgroundColor: Colors.green[900],
      ),
      key: _scaffoldkey,
      body: Container(
        child: showLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : currentState == MobileVerificationState.SHOW_MOBILE_FORM_STATE
                ? getMobileFormWidget(context)
                : getOtpFormWidget(context),
        padding: const EdgeInsets.all(16.0),
      ),
    );
  }
}
