import 'package:Wellz/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:international_phone_input/international_phone_input.dart';
import 'package:Wellz/Services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'VerifyPhone.dart';

class SignUpPage extends StatefulWidget {
  SignUpPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  final AuthService _auth = AuthService();

  String phoneNumber;
  bool visible = false;
  String confirmedNumber = '';
  String error = '';
  String email = '';
  String password = '';
  String fullName = '';
  String verificationId = '';
  String number = '';

  bool codeSent = false;

  void onPhoneNumberChange(
      String number, String internationalizedPhoneNumber, String isoCode) {
    print(number);
    setState(() {
      phoneNumber = number;
    });
  }

  onValidPhoneNumber(
      String number, String internationalizedPhoneNumber, String isoCode) {
    setState(() {
      visible = true;
      confirmedNumber = internationalizedPhoneNumber;
    });
  }

  Future<void> verifyPhone(phoneNo) async {
    final PhoneVerificationCompleted verified = (AuthCredential authResult) {
      _auth.signIn(authResult);
    };

    final PhoneVerificationFailed verificationfailed =
        (AuthException authException) {
      print('${authException.message}');
    };

    final PhoneCodeSent smsSent = (String verId, [int forceResend]) {
      this.verificationId = verId;
      print("I am in the codeSent section");
      setState(() {
        this.codeSent = true;
        print("the new one is " + this.codeSent.toString());
      });
    };

    final PhoneCodeAutoRetrievalTimeout autoTimeout = (String verId) {
      this.verificationId = verId;
    };

    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: phoneNo,
        timeout: const Duration(seconds: 5),
        verificationCompleted: verified,
        verificationFailed: verificationfailed,
        codeSent: smsSent,
        codeAutoRetrievalTimeout: autoTimeout);
  }

  Widget _personalInfo() {
    return Text(
      'Personal Information',
      style: TextStyle(
          fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
    );
  }

  Widget _fullName() {
    return TextFormField(
      obscureText: false,
      decoration: InputDecoration(
//        contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        hintText: " Full Name",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.0),
          borderSide: BorderSide(color: Colors.black, width: 1.0),
        ),
      ),
      validator: (val) {
        Pattern pattern = r'^[a-z A-Z,.\-]+$';
        RegExp regex = new RegExp(pattern);
        bool validName = regex.hasMatch(val);
        if (val.isEmpty) {
          return 'Enter Your Full name';
        } else if (!validName) {
          return 'Invalid Name';
        }
        return null;
      },
      onChanged: (val) {
        setState(() {
          fullName = val;
        });
      },
    );
  }

  Widget _emailField() {
    return TextFormField(
      obscureText: false,
//      style: style,
      decoration: InputDecoration(
//        contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        hintText: " Email",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.0),
          borderSide: BorderSide(color: Colors.black, width: 1.0),
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

  Widget _passwordField() {
    return TextFormField(
        obscureText: true,
//      style: style,
        decoration: InputDecoration(
//        contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: " Password",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20.0),
            borderSide: BorderSide(color: Colors.black, width: 1.0),
          ),
        ),
        validator: (val) =>
            val.length < 6 ? 'Enter a password 6+ chars long' : null,
        onChanged: (val) {
          setState(() {
            password = val;
          });
        });
  }

  Widget _errorText() {
    return Text(error,
        style: TextStyle(
          fontSize: 20.0,
          fontFamily: "Montserrat",
          color: Colors.red,
        ));
  }

  Widget _signUpButton() {
    return InkWell(
      onTap: () async {
        if (_formKey.currentState.validate() && phoneNumber.isNotEmpty) {
          String number = "+961" + phoneNumber;
          print(number);
          this.number = number;

          dynamic checkNumber =
              await DatabaseService().checkPhoneNumberAndEmail(number, email);
          if (checkNumber) {
            error =
                "You are already registered with this phone number or email";
            FocusScope.of(context).unfocus();
            print("sorry you cannot go to OTP");
          } else {
            try {
              verifyPhone(number);
            } catch (e) {
              print("the verification could not proceed: " + e.toString());
            }
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
          'Register',
          style: TextStyle(
              fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return codeSent
        ? VerifyPhone(
            phoneNumber: number,
            fullName: fullName,
            email: email,
            password: password,
            verificationID: verificationId,
          )
        : Scaffold(
            appBar: AppBar(
              iconTheme: IconThemeData(
                color: Colors.black,
              ),
              centerTitle: true,
              backgroundColor: Colors.white,
              title: Text("Sign Up", style: TextStyle(color: Colors.black)),
            ),
            body: SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
//        height: MediaQuery.of(context).size.height,
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      _errorText(),
                      SizedBox(height: 20.0),
                      _personalInfo(),
                      SizedBox(height: 20.0),
                      _fullName(),
                      SizedBox(height: 20.0),
                      _emailField(),
                      SizedBox(height: 20.0),
                      _passwordField(),
                      SizedBox(height: 30.0),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        padding:
                            EdgeInsets.symmetric(horizontal: 14, vertical: 0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(30.0)),
//                  border: Border.all(color: Colors.black, width: 1),
//                color: Colors.black,
                        ),
                        child: InternationalPhoneInput(
                          onPhoneNumberChange: onPhoneNumberChange,
                          initialPhoneNumber: phoneNumber,
                          enabledCountries: ['+961', '+33'],
                          labelText: "Phone Number",
                        ),
                      ),
                      SizedBox(height: 50.0),
                      _signUpButton(),
                    ],
                  ),
                ),
              ),
            ),
          );
  }
}
