import 'package:cookit/services/auth.dart';
import 'package:cookit/wrapper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'models/User.dart';

void main() {
  runApp(
    MyApp(),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamProvider<User>.value(
      value: AuthService().user,
      child: MaterialApp(
        theme: ThemeData.light().copyWith(
          primaryColor: Colors.orange,
          accentColor: Colors.redAccent,
          backgroundColor: Colors.grey,
          buttonTheme: ButtonThemeData(
            buttonColor: Colors.orange,
            textTheme: ButtonTextTheme.normal,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
        ),
        darkTheme: ThemeData.dark().copyWith(
          primaryColor: Colors.orange,
          accentColor: Colors.redAccent,
          buttonTheme: ButtonThemeData(
            buttonColor: Colors.orange,
            textTheme: ButtonTextTheme.normal,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
        ),
        themeMode: ThemeMode.system,
        debugShowCheckedModeBanner: false,
        home: Wrapper(),
      ),
    );
  }
}
