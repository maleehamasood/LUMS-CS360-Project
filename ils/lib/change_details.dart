import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'styles.dart';
import 'services.dart';
import 'package:flutter/services.dart';
import 'employee_details.dart';
import 'assign_details.dart';
import 'info_details.dart';

// Change Details class inherits the characteristics of a stateful widget and creates
// the instance of an _ChangeDetailsScreen class which inherits the state of this class

class ChangeDetails extends StatefulWidget {
  final String type;
  final String issueID;
  final String selfID;

  ChangeDetails(this.type, this.issueID, this.selfID);

  @override
  State<StatefulWidget> createState() {
    return _ChangeDetailScreen(this.type, this.issueID, this.selfID);
  }
}

//This class basically creates an instance of stateful widget which will
//form the display of the Change Details screen
class _ChangeDetailScreen extends State<ChangeDetails> {
  String _screenType;
  String issueID;
  String selfID;
  final _formKey = GlobalKey<FormState>();
  bool _autoValidate = false;
  List<EmployeeMainInfo> tempEmployee = MockEmployee.FetchAny();

//This constructor assigns the variables of class their values once this screen is called and it also calls the _getExpertise() function to fetch data from db
  _ChangeDetailScreen(this._screenType, this.issueID, this.selfID) {
    _getExpertise();
  }

//This Function basically fetches data from the DB and updates the screen once loaded
  void _getExpertise() {
    AppServices.getExpertise().then((result) {
      setState(() {
        this.tempEmployee = result;
      });
    });
  }

  @override
//  This Function returns a basic screen with an appBar and body.
//  The body is basically a Form containing several nested widgets
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return Scaffold(
      appBar: _appBar(this._screenType),
      body: _changeDetailsScreen(context),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Styles.backgroundColorBlue,
        onPressed: () {
          _dialogBox(context, MediaQuery.of(context).size.height,
              MediaQuery.of(context).size.width);
        },
        child: Icon(Icons.search),
      ),
    );
  }

  //This functions builds the appbar Widget, takes text as an input to be
  // shown in the app bar and consists of a back button and info button also
  Widget _appBar(String text) {
    return new AppBar(
        leading: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            new IconButton(
              icon: new Icon(Icons.arrow_back),
              onPressed: () => Navigator.of(context).pop(null),
            ),
          ],
        ),
        title: Text(text, style: Styles.appBar),
        actions: [
          Padding(
              padding: EdgeInsets.only(right: 10),
              child: IconButton(
                  icon: new Icon(Icons.info_outline),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Info()),
                    );
                  }))
        ],
        backgroundColor: Styles.backgroundColorOrange,
        centerTitle: true);
  }

//This function returns a form widget to be displayed on screen
  Widget _changeDetailsScreen(BuildContext context) {
    return Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            _widgetListonScreen(context, MediaQuery.of(context).size.height,
                MediaQuery.of(context).size.width)
          ],
        ));
  }

//  This Function takes in height and width as extra parameters to ensure that
//  the widget placement works for any screen size and returns a Scrollable
//  widget which contains a list of widgets. This list contains Rows and each
//  Row inturn conatins the widget to  be displayed
  Widget _widgetListonScreen(
      BuildContext context, double height, double width) {
    return Expanded(
        child: Scrollbar(
            child: ListView(children: <Widget>[
      Center(
        child: Card(
          elevation: 1.0,
          margin:
              EdgeInsets.fromLTRB(width * 0.04, height * 0.02, width * 0.04, 0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Container(
                decoration: BoxDecoration(color: Styles.backgroundColorBlue),
                padding: EdgeInsets.fromLTRB(
                    width * 0.02, height * 0, 0, height * 0),
                child: Row(
                  children: <Widget>[
                    Column(children: <Widget>[
                      Container(
                        padding: EdgeInsets.fromLTRB(
                            width * 0.20, height * 0.02, 0, height * 0.02),
                        child: Text(
                          "Name",
                          style: Styles.secalertDialogBox,
                        ),
                      )
                    ]),
                    Column(children: <Widget>[
                      Container(
                        padding: EdgeInsets.fromLTRB(
                            width * 0.27, height * 0.02, 0, height * 0.02),
                        child: Text(
                          "Role",
                          style: Styles.secalertDialogBox,
                        ),
                      )
                    ]),
                  ],
                ),
              ),
              Center(
                child: Card(
                  elevation: 0.0,
                  margin: EdgeInsets.fromLTRB(
                      width * 0.04, height * 0, width * 0.04, 0),
                  child: Container(
                    height: height * 0.78,
                    padding: EdgeInsets.fromLTRB(
                        width * 0.04, height * 0.02, width * 0.04, 0),
                    child: ListView(
                      children: _employeeList(
                          this._screenType, tempEmployee, height, width),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ])));
  }

  //This functions returns a string of the Issue description to be viewed on the screen,
  //it takes as an argument the whole description and trims it to fit according to the screen size.
  String _descTrim(String description) {
    if (description.length >= 16) {
      return description.substring(0, 14) + "..";
    } else {
      return description;
    }
  }

  //This functions returns a string of the Issue description to be viewed on the screen,
  //it takes as an argument the whole description and trims it to fit according to the screen size.
  String _descTrim2(String description) {
    if (description.length > 9) {
      return description.substring(0, 7);
    } else {
      return description;
    }
  }

//This Function returns the list of employees displaying their names and roles in the form of a scrollable list
  List<Widget> _employeeList(String type, List<EmployeeMainInfo> tempEmployee,
      double height, double width) {
    List<Widget> result = [];
    for (int i = 0; i < tempEmployee.length; i++) {
      result.add(Container(
        padding:
            EdgeInsets.fromLTRB(width * 0.005, height * 0.02, width * 0.005, 0),
        height: height / 12,
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => AssignDetails(this._screenType,
                      tempEmployee[i].employeeID, this.issueID, this.selfID)),
            );
          },
          splashColor: Styles.iconColorGray,
          focusColor: Styles.iconColorGray,
          hoverColor: Styles.iconColorGray,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Column(children: <Widget>[
                Container(
                  width: width * 0.4,
                  child: Text(
                    _descTrim(tempEmployee[i].employeeName),
                    style: Styles.specialtextDefault,
                    textAlign: TextAlign.center,
                  ),
                ),
              ]),
              Column(children: <Widget>[
                Container(
                  width: width * 0.35,
                  padding: EdgeInsets.fromLTRB(width * 0.05, 0, 0, 0),
                  child: Text(
                    _descTrim2(tempEmployee[i].employeeRole),
                    style: Styles.specialtextDefault,
                    textAlign: TextAlign.center,
                  ),
                ),
              ]),
            ],
          ),
        ),
      ));
    }
    return result;
  }

//  This Dialog Box appears when the users clicks on the raised button and allows him to search employee with the name and id in the db
  void _dialogBox(BuildContext context, double height, double width) {
    String _tempName = "";
    String _tempID = "";
    final _formKey1 = GlobalKey<FormState>();
    bool _autoValidate1 = false;
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(new Radius.circular(15.0)),
            ),
            title: Text(
              "Initiator's Details",
              style: Styles.alertDialogBox,
              textAlign: TextAlign.center,
            ),
            content: Card(
              child: Form(
                key: _formKey1,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    TextFormField(
                      decoration: InputDecoration(
                        icon: Icon(Icons.text_fields),
                        hintText: 'Enter Name',
                        hintStyle: Styles.verySmalltextDefault,
                        labelText: "Name:",
                      ),
                      onChanged: (value) => _tempID = value,
                      validator: (value) =>
                          value == "" ? "Field Required" : null,
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                        icon: Icon(Icons.person_outline),
                        hintText: 'Enter Employee ID',
                        hintStyle: Styles.verySmalltextDefault,
                        labelText: "Username:",
                      ),
                      onChanged: (value) => _tempName = value,
                      validator: (value) =>
                          value == "" ? "Field Required" : null,
                    ),
                  ],
                ),
              ),
            ),
            actions: <Widget>[
              FlatButton(
                onPressed: () {
                  setState(() {
                    Navigator.pop(context);
                  });
                },
                child: Text(
                  "Cancel",
                  style: Styles.alertDialogBoxButtons,
                ),
              ),
              FlatButton(
                onPressed: () {
                  if (_formKey1.currentState.validate()) {
                    _validateNameEmployees(_tempName, _tempID);
                    Navigator.pop(context);
                  } else {
                    setState(() {
                      _autoValidate = true;
                    });
                  }
                },
                child: Text(
                  "Continue",
                  style: Styles.alertDialogBoxButtons,
                ),
              )
            ],
          );
        });
  }

//This function takes in employee name and id as arguments and validates it from the db
//  Incase, the validation fails, it shows an error dialog box, the code of which was taken from the source mentioned below and integrated in the code
// https://stackoverflow.com/questions/49706046/how-run-code-after-showdialog-is-dismissed-in-flutter
  _validateNameEmployees(String nameEmployee, String empID) {
    AppServices.valEmployeeName(nameEmployee, empID).then((result) {
      if ('success' == result) {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => AssignDetails(
                  this._screenType, empID, this.issueID, this.selfID)),
        );
      } else {
        showDialog(
          context: context,
          child: new AlertDialog(
            title: const Text('Invalid Employee ID / Name'),
            actions: [
              new FlatButton(
                child: const Text('Please try again.',
                    textAlign: TextAlign.center),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
        );
      }
    });
  }
}
