import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ResetPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reset Password'),
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
                  child: ResetForm(),
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

class ResetForm extends StatefulWidget {
  @override
  _ResetFormState createState() => _ResetFormState();
}

class _ResetFormState extends State<ResetForm> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  final _formKey = new GlobalKey<FormState>();
  final emailController = TextEditingController();

  String _email = '';

  bool validateAndSave() {
    final form = _formKey.currentState;
    if (form!.validate()) {
      form.save();
      return true;
    } else {
      return false;
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
              controller: emailController,
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
            child: TextButton(
              onPressed: () async {
                await _auth.sendPasswordResetEmail(email: emailController.text);
                Navigator.pushNamed(context, '/login');
              },
              child: Text(
                'Send Request',
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
                child: Text('Got your password? Login here')),
          )
        ],
      ),
    );
  }
}
