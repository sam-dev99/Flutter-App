import 'package:flutter/material.dart';
import 'package:Wellz/Authenticate/loginPage.dart';
import 'package:Wellz/Authenticate/NewRegister.dart';

class WelcomePage extends StatefulWidget {
  WelcomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  Widget _submitButton() {
    return InkWell(
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => LoginPage()));
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(vertical: 13),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(20.0)),
          border: Border.all(color: Colors.white, width: 1),
        ),
        child: Text(
          'Already have an account',
          style: TextStyle(
              fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _signUpButton() {
    return InkWell(
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => SignUpPage()));
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(vertical: 13),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(20.0)),
          color: Colors.white,
        ),
        child: Text(
          'Sign Up',
          style: TextStyle(
              fontSize: 20, color: Colors.purple, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _titlePic() {
    return Container(
      child: Image.asset('images/Wellz_Logo.png',
          width: 120.0, height: 120.0, fit: BoxFit.fill),
    );
  }

  Widget _title() {
    return Text(
      'WELLZ',
      style: TextStyle(shadows: [
        Shadow(
          blurRadius: 10.0,
          color: Colors.black,
          offset: Offset(5.0, 5.0),
        ),
      ], fontSize: 35.0, fontWeight: FontWeight.bold, color: Colors.white),
    );
  }

  Widget _getStarted() {
    return Text(
      'Let\'s get started!',
      style: TextStyle(
          fontSize: 40.0,
          fontWeight: FontWeight.bold,
          color: Colors.white,
          fontFamily: 'Montserrat'),
    );
  }

  Widget _continue() {
    return InkWell(
        onTap: () {},
        child: Text(
          'Continue without an account ',
          style: TextStyle(
              fontSize: 15.0,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontFamily: 'Montserrat'),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 30),
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("images/backgroundmain.png"),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Container(
                height: MediaQuery.of(context).size.height / 2,
                child: Column(
                  children: <Widget>[
                    _titlePic(),
                    SizedBox(height: 20),
                    _title(),
                  ],
                ),
              ),
              _getStarted(),
              SizedBox(height: 20),
              _submitButton(),
              SizedBox(height: 20),
              _signUpButton(),
              SizedBox(height: 10),
              _continue(),
              SizedBox(height: 60)
            ],
          ),
        ),
      ),
    );
  }
}
