import 'package:Wellz/Home/Home.dart';
import 'package:Wellz/services/database.dart';
import 'package:flutter/material.dart';
import 'package:international_phone_input/international_phone_input.dart';
import 'package:Wellz/Authenticate/SignInWithOTP.dart';
import 'package:Wellz/Authenticate/ForgetPassword.dart';
import 'package:Wellz/Services/auth.dart';
import 'package:Wellz/Shared/loading.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  int _form = 1;

  final _formKey = GlobalKey<FormState>();
  final _formKey2 = GlobalKey<FormState>();

  final AuthService _auth = AuthService();

  bool visible = false;
  String confirmedNumber = '';

  String email = '';
  String password = '';
  String error = '';
  bool loading = false;

  String phoneNumber = '';

  bool codeSent = false;

  String verificationId = '';

  String number;

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

//  final String title;
  Widget _emailField() {
    return TextFormField(
//      keyboardType: TextInputType.number,
      obscureText: false,
//      style: style,
      decoration: InputDecoration(
//        contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
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

  Widget _passwordField() {
    return TextFormField(
      obscureText: true,
//      style: style,
      decoration: InputDecoration(
//        contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        hintText: " Password",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
      ),
      validator: (val) =>
          val.length < 6 ? 'Enter a password 6+ chars long' : null,
      onChanged: (val) {
        setState(() {
          password = val;
        });
      },
    );
  }

  Widget _phoneField() {
    return Container(
      // width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.symmetric(horizontal: 14, vertical: 0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(30.0)),
      ),
      child: InternationalPhoneInput(
        onPhoneNumberChange: onPhoneNumberChange,
        initialPhoneNumber: phoneNumber,
        enabledCountries: ['+961', '+33'],
        labelText: "Phone Number",
      ),
    );
  }

  Widget _forgetPass(BuildContext context) {
    return InkWell(
        onTap: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => ForgetPassword()));
        },
        child: Text(
          'Forgot Password?',
          style: TextStyle(
              fontSize: 15.0,
              fontWeight: FontWeight.bold,
              color: Colors.purple,
              fontFamily: 'Montserrat'),
        ));
  }

  Widget _errorText() {
    return Text(error,
        style: TextStyle(
          fontSize: 20.0,
          fontFamily: "Montserrat",
          color: Colors.red,
        ));
  }

  Widget _signInWithEmailButton(BuildContext context) {
    return InkWell(
      onTap: () async {
        if (_formKey.currentState.validate()) {
          setState(() {
            loading = true;
          });
          dynamic result =
              await _auth.signInWithEmailAndPassword(email, password);
          if (result == null) {
            setState(() {
              loading = false;
              error = "Invalid Username or password";
              print(error);
            });
          } else {
            setState(() {
              loading = false;
            });
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => Dashboard()));
            print("we are signing in");
          }
        }
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(vertical: 14),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(20.0)),
          color: Colors.purple,
        ),
        child: Text(
          'Sign In',
          style: TextStyle(
              fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
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

  Widget _signInWithPhoneButton(BuildContext context) {
    return InkWell(
      onTap: () async {
        if (_formKey2.currentState.validate()) {
          String number = "+961" + phoneNumber;
          print(number);
          this.number = number;

          dynamic checkNumber =
              await DatabaseService().checkPhoneNumber(number);

          print("the number is answered as : " + checkNumber.toString());
          if (checkNumber) {
            try {
              verifyPhone(number);
            } catch (e) {
              print("the verification could not proceed: " + e.toString());
            }
          } else {
            error = "You are Not registered with this phone number or email";
            FocusScope.of(context).unfocus();
            print("sorry you cannot go to OTP");
          }

          return codeSent
              ? SignInWithOTP(
                  phoneNumber: ("+961" + phoneNumber),
                  verificationID: verificationId,
                )
              : print("could not sign you in from Navigator");
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
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.phone,
              color: Colors.white,
            ),
            SizedBox(
              width: 20.0,
            ),
            Text(
              'Sign In with phone number',
              style: TextStyle(
                  fontSize: 15,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  Widget _goToEmailSignIn(BuildContext context) {
    return InkWell(
      onTap: () async {
        setState(() {
          _form = 1;
        });
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(vertical: 14),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(20.0)),
          border: Border.all(color: Colors.purple, width: 2),
          color: Colors.white,
        ),
        child: Text(
          'Sign In with Email',
          style: TextStyle(
              fontSize: 20, color: Colors.purple, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _goToPhoneSignIn(BuildContext context) {
    return InkWell(
        onTap: () async {
      setState(() {
        _form = 2;
      });
    },
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(vertical: 14),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(20.0)),
          border: Border.all(color: Colors.purple, width: 2),
          color: Colors.white,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.phone,
              color: Colors.purple,
            ),
            SizedBox(
              width: 20.0,
            ),
            Text(
              'Sign In with phone number',
              style: TextStyle(
                  fontSize: 20,
                  color: Colors.purple,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  Widget form1(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 30.0,
        vertical: 10.0,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            _errorText(),
            SizedBox(height: 20.0),
            _emailField(),
            SizedBox(height: 15.0),
            _passwordField(),
            SizedBox(height: 20.0),
            _signInWithEmailButton(context),
            SizedBox(height: 20.0),
            _forgetPass(context),
            SizedBox(height: 40.0),
            Text(
              "or",
              style: TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 30.0),
            _goToPhoneSignIn(context),
          ],
        ),
      ),
    );
  }

  Widget form2(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 30,
      ),
      child: Form(
        key: _formKey2,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            _errorText(),
            SizedBox(height: 20.0),
            _phoneField(),
            SizedBox(height: 40.0),
            _signInWithPhoneButton(context),
            SizedBox(height: 20.0),
            Text(
              "or",
              style: TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 30.0),
            _goToEmailSignIn(context),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : codeSent
            ? SignInWithOTP(
                phoneNumber: ("+961" + phoneNumber),
                verificationID: verificationId,
              )
            : Scaffold(
                appBar: AppBar(
                  iconTheme: IconThemeData(
                    color: Colors.black,
                  ),
                  centerTitle: true,
                  backgroundColor: Colors.white,
                  title: Text("Sign In", style: TextStyle(color: Colors.black)),
                ),
                body: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      _form == 1 ? form1(context) : form2(context)
                    ],
                  ),
                ),
              );
  }
}
