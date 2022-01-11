import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignUpPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('E - Proof App'),
        backgroundColor: Colors.green[900],
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Image.asset("assets/images/eproof_app_logo.png"),
            Center(
              child: SizedBox(
                width: 400,
                child: Card(
                  child: SignUpForm(),
                ),
              ),
            ),
            SizedBox(
              height: 100.0,
            )
          ],
        ),
      ),
    );
  }
}

class SignUpForm extends StatefulWidget {
  @override
  _SignUpFormState createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  late String _email;
  late String _password;
  final _formKey = new GlobalKey<FormState>();

  bool validateAndSave() {
    final form = _formKey.currentState;
    if (form!.validate()) {
      form.save();
      Navigator.pushNamed(context, '/phoneForm');
      return true;
    } else {
      return false;
    }
  }

  void validateAndSubmit() async {
    if (validateAndSave()) {
      try {
        UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
                email: this._email, password: this._password);
        print('Registered user: ${userCredential.user}');
      } catch (e) {
        print('Error: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: TextFormField(
              validator: (value) =>
                  value!.isEmpty ? 'Email cannot be empty' : null,
              onSaved: (value) => _email = value!,
              decoration: InputDecoration(
                labelText: 'Email',
                hintText: 'Email',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: TextFormField(
              validator: (value) =>
                  value!.isEmpty ? 'Password cannot be empty' : null,
              onSaved: (value) => _password = value!,
              decoration: InputDecoration(
                labelText: 'Password',
                hintText: 'Password',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: TextButton(
              onPressed: validateAndSubmit,
              child: Text(
                'Create an account',
                style: TextStyle(fontSize: 20.0),
              ),
              style: TextButton.styleFrom(
                  primary: Colors.white, backgroundColor: Colors.green[900]),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/login');
                },
                child: Text('Already have an account? Log in here')),
          )
        ],
      ),
    );
  }
}
