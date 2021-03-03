import 'package:flutter/material.dart';
import 'package:Wellz/Services/auth.dart';

class ForgetPassword extends StatefulWidget {
  @override
  _ForgetPasswordState createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  String email = '';
  String error = '';
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();

  Widget _resetInfo() {
    return Text(
      'Enter the Email you wish to reset password for: ',
      style: TextStyle(
          fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black),
    );
  }

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Reset link was successfully  sent!'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('A reset password link was sent to '+ email+'\n'),
                Text('Press OK to go back to Sign In page'),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Widget _submitButton() {
    return InkWell(
      onTap: () async {
        if (_formKey.currentState.validate()) {
          try {
            await _auth.sendPasswordResetEmail(email);
            await _showMyDialog();
            Navigator.pop(context);
          } catch (e) {
            print(e.toString());
          }
        }
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(vertical: 14),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(20.0)),
//          border: Border.all(color: Colors.black, width: 2),
          color: Colors.purple,
        ),
        child: Text(
          'Submit',
          style: TextStyle(
              fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _emailField() {
    return TextFormField(
      obscureText: false,
      decoration: InputDecoration(
        hintText: " Email",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
      ),
      validator: (val) {
        Pattern pattern =
            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

        RegExp regex = new RegExp(pattern);
        bool validEmail = regex.hasMatch(val);

        if (val.isEmpty) {
          return "Email is empty";
        } else if (!validEmail) {
          return "Invalid Email";
        }
        return null;
      },
      onChanged: (val) {
        setState(() {
          email = val;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        title: Text("Reset Password", style: TextStyle(color: Colors.black)),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 30, vertical: 40),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                _resetInfo(),
                SizedBox(height: 20.0),
                _emailField(),
                SizedBox(height: 40.0),
                _submitButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
