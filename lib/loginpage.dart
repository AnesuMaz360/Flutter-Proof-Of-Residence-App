import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('E - Proof App'),
        centerTitle: true,
        backgroundColor: Colors.green[900],
        automaticallyImplyLeading: false,
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Image.asset("images/eproof_app_logo.png"),
            Center(
              child: SizedBox(
                width: 400,
                child: Card(
                  child: LoginForm(),
                ),
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            Text('Developed by Tekda Pty Ltd/Gaia Inc'),
          ],
        ),
      ),
    );
  }
}

class LoginForm extends StatefulWidget {
  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = new GlobalKey<FormState>();

  late String _email;
  late String _password;

  bool validateAndSave() {
    final form = _formKey.currentState;
    if (form!.validate()) {
      form.save();
      return true;
    } else {
      return false;
    }
  }

  void validateAndSubmit() async {
    if (validateAndSave()) {
      try {
        UserCredential userCredential = await FirebaseAuth.instance
            .signInWithEmailAndPassword(
                email: this._email, password: this._password);
        Navigator.pushNamed(context, '/phoneform');
        print('Signed in: ${userCredential.user}');
      } catch (e) {
        final snackBar = SnackBar(content: Text(e.toString()));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        Navigator.pushNamed(context, '/login');
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
                fillColor: Colors.white,
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
                'Login',
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
                  Navigator.pushNamed(context, '/resetpage');
                },
                child: Text('Forgot Password?')),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/signup');
                },
                child: Text('Need an account? Sign up here')),
          )
        ],
      ),
    );
  }
}
