import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'styles.dart';
void main() {
  return runApp(MaterialApp(
    
    home: LoginScreen(),
    // home: AssignDetails('Assign','21100326',''),
    theme: _theme(),
    // routes: <String, WidgetBuilder>{
      // '/menu': (BuildContext context) => Menu(),
      // '/screen2': (BuildContext context) => Screen2(),
      // '/screen3': (BuildContext context) => Screen3(),
      // '/screen4': (BuildContext context) => Screen4()
    // },
  ));
}

// Themes for the appbar and the text
ThemeData _theme() {
  return ThemeData(
      appBarTheme: AppBarTheme(textTheme: TextTheme(title: Styles.appBar)),
      textTheme:
          TextTheme(title: Styles.headerDefault, body1: Styles.textDefault));
}
