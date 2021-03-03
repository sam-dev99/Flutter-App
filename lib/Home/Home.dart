import 'package:Wellz/Home/More.dart';
import 'package:Wellz/Home/Refer.dart';
import 'package:Wellz/Home/Services.dart';
import 'package:Wellz/Home/Sessions.dart';
import 'package:flutter/material.dart';


class Dashboard extends StatelessWidget {
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyStatefulWidget(),
    );
  }
}

class MyStatefulWidget extends StatefulWidget {
  MyStatefulWidget({Key key}) : super(key: key);

  @override
  _MyStatefulWidgetState createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {

  int _selectedIndex = 0;

  final List<Widget> _widgetOptions =
      [
        Services(),
        Sessions(),
        Refer(),
        More()
      ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
//      AppBar(
//        title: Text('Services'),
//        actions: <Widget>[
//          FlatButton.icon(
//            icon: Icon(Icons.person),
//            label: Text('Logout'),
//            onPressed: () async {
//              await _auth.signOut();
//              Navigator.pop(context);
////              return WelcomePage();
//            },
//          ),
//        ],
//      ),

      body: _widgetOptions[_selectedIndex],
//      SingleChildScrollView(
//        child: Column(
//          children: <Widget>[_form == 1 ? form1(context) : form2(context)],
//        ),
//      ),

      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text('Home'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            title: Text('Sessions'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.card_giftcard),
            title: Text('Refer'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.more),
            title: Text('More'),
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.purple[400],
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}
