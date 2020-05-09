import 'package:flutter/material.dart';
import 'package:draggable_drawer/widgets/transition_drawer.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:async';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Draggable Drawer Example',
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      home: Material(
        child: AppDrawer(),
      ),
    );
  }
}

class AppDrawer extends StatefulWidget {
  const AppDrawer({
    Key key,
  }) : super(key: key);

  @override
  _AppDrawerState createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  StreamController<void> toggleStream;

  @override
  void initState() {
    super.initState();
    toggleStream = StreamController<void>();
  }

  @override
  void dispose() {
    super.dispose();
    toggleStream.close();
  }

  @override
  Widget build(BuildContext context) {
    return TransitionDrawer(
      toggleStream: toggleStream,
      menu: Container(
        color: Colors.white,
        child: DefaultTextStyle(
          style: GoogleFonts.cairo(
            fontStyle: FontStyle.italic,
            fontWeight: FontWeight.bold,
            fontSize: 34,
          ),
          child: Container(
            decoration: BoxDecoration(
              // borderRadius: BorderRadius.circular(10.0),
              color: Color.fromRGBO(68, 61, 164, 1),
            ),
            child: ListView(
              children: <Widget>[
                SizedBox(
                  height: 100.0,
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: FlatButton(
                    padding: EdgeInsets.symmetric(
                      horizontal: 30.0,
                      vertical: 15.0,
                    ),
                    // color: Colors.blueAccent,
                    textColor: Colors.white,
                    child: Row(
                      children: <Widget>[
                        Icon(Icons.verified_user),
                        SizedBox(width: 15),
                        Text(
                          'Signup',
                          style: GoogleFonts.cairo().copyWith(
                            fontSize: 21.0,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    onPressed: () {},
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      app: Scaffold(
        appBar: AppBar(
          title: Text('Draggable Drawer'),
          leading: IconButton(
            icon: Icon(
              Icons.menu,
              color: Colors.white,
            ),
            onPressed: () {
              toggleStream.add(null);
            },
          ),
        ),
      ),
    );
  }
}
