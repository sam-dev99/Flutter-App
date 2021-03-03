import 'package:flutter/material.dart';
import 'package:pin_entry_text_field/pin_entry_text_field.dart';
import 'package:Wellz/Services/auth.dart';
import 'package:Wellz/Shared/loading.dart';

class VerifyPhone extends StatefulWidget {
  final String email;
  final String fullName;
  final String password;
  final String phoneNumber;
  final String verificationID;

  VerifyPhone(
      {Key key,
      this.phoneNumber,
      this.fullName,
      this.email,
      this.password,
      this.verificationID})
      : super(key: key);

  _VerifyPhoneState createState() => _VerifyPhoneState();
}

class _VerifyPhoneState extends State<VerifyPhone> {
  String _pin = '';
  bool loading = false;
  String error = '';

  final AuthService _auth = AuthService();

  bool verified = false;

  String get verID {
    return widget.verificationID;
  }

  String get email {
    return widget.email;
  }

  String get fullname {
    return widget.fullName;
  }

  String get number {
    return widget.phoneNumber;
  }

  String get password {
    return widget.password;
  }

  Widget _errorText() {
    return Text(error,
        style: TextStyle(
          fontSize: 20.0,
          fontFamily: "Montserrat",
          color: Colors.red,
        ));
  }

  Widget _resendCode() {
    return InkWell(
      onTap: () {
        // verifyPhone(number, context);
        print("I will resend the code");
      },
      child: Text(
        'Resend Codes',
        style: TextStyle(
            fontSize: 15.0,
            fontWeight: FontWeight.bold,
            color: Colors.purple,
            fontFamily: 'Montserrat'),
      ),
    );
  }

  Widget _changeNumber() {
    return InkWell(
      onTap: () {
        Navigator.of(context).pop();
      },
      child: Text(
        'Change Phone Number',
        style: TextStyle(
            fontSize: 15.0,
            fontWeight: FontWeight.bold,
            color: Colors.purple,
            fontFamily: 'Montserrat'),
      ),
    );
  }

  Widget _submitButton() {
    return InkWell(
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
      // ignore: missing_return
      onTap: () async {
        setState(() {
          loading = true;
        });
        try {
          dynamic result = await _auth.signInWithOTP(_pin, verID);

          if (result) {
            dynamic res = await _auth.registerWithEmailAndPassword(
                fullname, email, password, number);
            if (res != null) {
              setState(() {
                loading = false;
                verified = true;
              });
              print("you signed in");
              Navigator.pop(context);
            } else {
              return false;
            }
          } else {
            print("something wrong with the otp");

            setState(() {
              error = "Wrong OTP";
              loading = false;
            });
          }
        } catch (e) {
          setState(() {
            error = "Wrong OTP";
            loading = false;
          });

          print("Something went Wrong MR.");
        }
      },
    );
  }

  Widget _smsText() {
    return Text(
      'Enter 6 digits verification code sent to ' + number,
      style: TextStyle(
        fontSize: 28.0,
        fontFamily: 'Montserrat',
        color: Colors.black,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
//    verifyPhone(number, context);
    return loading
        ? Loading()
        : Scaffold(
            appBar: AppBar(
              iconTheme: IconThemeData(
                color: Colors.black,
              ),
              centerTitle: true,
              backgroundColor: Colors.white,
              title:
                  Text("Verify Phone", style: TextStyle(color: Colors.black)),
            ),
            body: SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 40),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    _smsText(),
                    SizedBox(height: 50.0),
                    PinEntryTextField(
                      showFieldAsBox: false,
                      fields: 6,
                      onSubmit: (val) async {
                        _pin = val;
                      },
                    ),
                    SizedBox(height: 20.0),
                    _errorText(),
                    SizedBox(height: 50.0),
                    _submitButton(),
                    SizedBox(height: 30.0),
                    _resendCode(),
                    SizedBox(height: 10.0),
                    _changeNumber()
                  ],
                ),
              ),
            ),
          );
  }
}
