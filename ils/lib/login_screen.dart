// The login screen is the first screen that appears when the app runs
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'services.dart';
import 'styles.dart';
import 'menu.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() {
    return _LoginScreenState();
  }
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String employee; //stores entered in Employee ID
  String _password; //stores entered in Password
  bool _autoValidate =
      false; //turns true when the input has been successfully validated
  bool _passwordVisible = true; //turns false to display the password input

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return Scaffold(
      body: _loginScreenBody(),
    );
  }

  // This function returns the skeleton body of the login screen
  Widget _loginScreenBody() {
    return SingleChildScrollView(
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
          _topHalf(context, MediaQuery.of(context).size.height * 0.5),
          _bottomHalf(context, MediaQuery.of(context).size.height * 0.5),
        ]));
  }

  // provides the skeleton code for the top half of login screen body
  Widget _topHalf(BuildContext context, double height) {
    return SingleChildScrollView(
        child: Container(
      alignment: Alignment.center,
      constraints: BoxConstraints.tightFor(height: height),
      decoration: BoxDecoration(color: Styles.backgroundColorWhite),
      child: _childOfTopHalf(height),
    ));
  }

  // populates the top half of login screen body
  Widget _childOfTopHalf(double height) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Image.asset('assets/images/logo.png', height: height * 0.5),
          Text(""),
          Text("Issue Logging System",
              style: Styles.mainPageTitle, textAlign: TextAlign.center),
        ]);
  }

  // provides the skeleton code for the bottom half of login screen body
  Widget _bottomHalf(BuildContext context, double height) {
    return SingleChildScrollView(
        child: Container(
      alignment: Alignment.center,
      constraints: BoxConstraints.tightFor(height: height),
      decoration: BoxDecoration(
        color: Styles.backgroundColorOrange,
        borderRadius: BorderRadius.all(Radius.circular(18)),
      ),
      child: _childOfBottomHalf(),
    ));
  }

// populates the bottom half of login screen body
  Widget _childOfBottomHalf() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Form(
              key: _formKey,
              autovalidate: _autoValidate,
              child: SingleChildScrollView(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                    _textFormFieldEmployee("Employee ID", Icons.person),
                    _textFormFieldPass("Password", Icons.lock)
                  ]))),
          Text(""),
          _button(),
        ],
      ),
    );
  }

  // Employee ID field
  Widget _textFormFieldEmployee(String hint, IconData icon) {
    return SingleChildScrollView(
        child: Container(
            width: MediaQuery.of(context).size.width * 0.75,
            child: TextFormField(
              onSaved: (value) => employee = value,
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.next,
              textAlign: TextAlign.justify,
              decoration: _inputDecorEmployee(hint, icon),
              validator: _validateEmployee,
            )));
  }

  // Employee ID field decoration function
  InputDecoration _inputDecorEmployee(String hint, IconData icon) {
    return InputDecoration(
      alignLabelWithHint: true,
      filled: true,
      fillColor: Styles.backgroundColorWhite,
      focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Styles.backgroundColorBlue, width: 2.0),
          borderRadius: BorderRadius.circular(Styles.radius)),
      contentPadding: EdgeInsets.symmetric(vertical: 22.0, horizontal: 15.0),
      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Styles.radius)),
      hintText: hint,
      hintStyle: Styles.mainPageDefault2,
      prefixIcon: Icon(icon, color: Styles.backgroundColorBlue),
    );
  }

// Employee ID Validation
// https://github.com/wilburt/flutter_form_validate/blob/master/lib/main.dart
  String _validateEmployee(String value) {
    if (value.isEmpty) {
      // The form is empty
      return "Enter Employee ID";
    }
    // This is just a regular expression for acceptable employee IDs
    String p = "^(0|[1-9][0-9]*)\$";
    RegExp regExp = new RegExp(p);
    if (regExp.hasMatch(value)) {
      // So, the employee ID is valid
      return null;
    }
    // The pattern of the email didn't match the regex above.
    return 'Employee ID is not valid';
  }

  // Password field function
  Widget _textFormFieldPass(String hint, IconData icon) {
    return SingleChildScrollView(
        child: Container(
            width: MediaQuery.of(context).size.width * 0.75,
            child: TextFormField(
              onSaved: (value) => _password = value,
              obscureText: _passwordVisible,
              textInputAction: TextInputAction.next,
              textAlign: TextAlign.justify,
              decoration: _inputDecorPass(hint, icon),
              validator: _validatePassword,
            )));
  }

  // Password field decoration function
  InputDecoration _inputDecorPass(String hint, IconData icon) {
    return InputDecoration(
      alignLabelWithHint: true,
      filled: true,
      fillColor: Styles.backgroundColorWhite,
      focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Styles.backgroundColorBlue, width: 2.0),
          borderRadius: BorderRadius.circular(Styles.radius)),
      contentPadding: EdgeInsets.symmetric(vertical: 22.0, horizontal: 15.0),
      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Styles.radius)),
      hintText: hint,
      hintStyle: Styles.mainPageDefault2,
      prefixIcon: Icon(icon, color: Styles.backgroundColorBlue),
      suffixIcon: _icon(),
    );
  }

  // Password Visible Icon
  // https://stackoverflow.com/questions/58327902/flutter-how-to-make-a-login-in-flutter
  IconButton _icon() {
    return IconButton(
        icon: Icon(
          _passwordVisible ? Icons.visibility_off : Icons.visibility,
          color: Styles.backgroundColorBlue,
        ),
        onPressed: () {
          setState(() {
            _passwordVisible = !_passwordVisible;
          });
        });
  }

  // Password Validation Function
  // https://github.com/wilburt/flutter_form_validate/blob/master/lib/main.dart
  String _validatePassword(String value) {
    if (value.length > 5) {
      return null;
    }
    return 'Password must be upto 6 characters';
  }

// Login Button
  Widget _button() {
    return SingleChildScrollView(
        child: Container(
      width: MediaQuery.of(context).size.width * 0.75,
      height: 70.0,
      child: _buttonWidget(),
    ));
  }

  // Login Button helper function
  Widget _buttonWidget() {
    return RaisedButton(
      highlightColor: Styles.backgroundColorWhite,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Styles.radius * 0.5)),
      onPressed: _validateInputs,
      elevation: 2.0,
      child: Text("Login", style: Styles.mainPageDefault),
      highlightElevation: 8.0,
      color: Styles.backgroundColorBlue,
    );
  }

  // Validates the employee ID and password
  // https://github.com/wilburt/flutter_form_validate/blob/master/lib/main.dart
  _validateInputs() {
    final form = _formKey.currentState;
    if (form.validate()) {
      // Text forms was validated.
      form.save();
      _validateEmployees();
    } else {
      setState(() => _autoValidate = true);
    }
  }

  // Validates the employee ID and password
  _validateEmployees() {
    AppServices.valEmployee(employee, _password).then((result) {
      setState(() {
        if ('success' == result) {
          _loading(context);
          AppServices.getRole(employee).then((result) {
            String tempRole = result;
            AppServices.getName(employee).then((result) {
              Future.delayed(const Duration(seconds: 3), () {
                Navigator.pop(
                  context,
                );
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Menu(employee, tempRole, result)),
                );
              });
            });
          });
        } else {
// https://stackoverflow.com/questions/49706046/how-run-code-after-showdialog-is-dismissed-in-flutter
          showDialog(context: context, child: _error(context));
        }
      });
    });
  }

  _error(BuildContext context) {
    //this function calls an error dialog box if incorrect credentials are entered
    var height = MediaQuery.of(context).size.height * 0.15;
    var width = MediaQuery.of(context).size.width * 0.15;
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0))),
            title: Container(
                margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(5)),
                child: Column(
                  children: <Widget>[
                    Container(
                      margin:
                          EdgeInsets.fromLTRB(0, height / 50, 0, height / 50),
                      alignment: Alignment.topCenter,
                      child: IconButton(
                        icon: new Icon(Icons.cancel),
                        iconSize: 70,
                        color: Colors.red,
                        onPressed: () {},
                      ),
                    ),
                    Container(
                        margin:
                            EdgeInsets.fromLTRB(0, height / 60, 0, height / 60),
                        alignment: Alignment.topCenter,
                        child: Text(
                          "Invalid Credentials Entered.",
                          style: Styles.headerDefault,
                          textAlign: TextAlign.center,
                        )),
                  ],
                )),
            backgroundColor: Styles.backgroundColorWhite,
          );
        });
  }

  _loading(BuildContext context) {
    //this function calls a loading dialog box
    var height = MediaQuery.of(context).size.height * 0.15;
    var width = MediaQuery.of(context).size.width * 0.15;
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0))),
            title: Container(
                margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(5)),
                child: Column(
                  children: <Widget>[
                    Container(
                      margin:
                          EdgeInsets.fromLTRB(0, height / 50, 0, height / 50),
                      alignment: Alignment.topCenter,
                      child: IconButton(
                        icon: new Icon(Icons.timelapse),
                        iconSize: 70,
                        color: Colors.red,
                        onPressed: () {},
                      ),
                    ),
                    Container(
                        margin:
                            EdgeInsets.fromLTRB(0, height / 60, 0, height / 60),
                        alignment: Alignment.topCenter,
                        child: Text(
                          "Loading please wait!",
                          style: Styles.headerDefault,
                          textAlign: TextAlign.center,
                        )),
                  ],
                )),
            backgroundColor: Styles.backgroundColorWhite,
          );
        });
  }
}
