import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'styles.dart';
import 'services.dart';
import 'employee_details.dart';
import 'info_change_teams.dart';
import 'info_change_role.dart';
import 'info_assign.dart';

// Change Details class inherits the characteristics of a stateful widget and creates
// the instance of an _ChangeDetailsScreen class which inherits the state of this class
class AssignDetails extends StatefulWidget {
  final String selfEmployee;
  final String type;
  final String _employeeID;
  final String issueID;

  AssignDetails(this.type, this._employeeID, this.issueID, this.selfEmployee);

  @override
  State<StatefulWidget> createState() {
    return _AssignDetailScreen(type, _employeeID, issueID, this.selfEmployee);
  }
}

//This class basically creates an instance of stateful widget which will
//form the display of the Assign Details screen
class _AssignDetailScreen extends State<AssignDetails> {
  String _screenType;
  String selfEmployee;
  String _employeeID;
  String issueID;
  List<String> teamList = ["Select Team"];
  List<String> roleList = [
    "Select Role",
    "Initiator",
    "Support Team Member",
    "Manager",
    "Monitor",
    "Admin"
  ];
  String _newTeamSelected = "Select Team";
  String _newRoleSelected = "Select Role";
  final _formKey = GlobalKey<FormState>();
  bool _autoValidate = false;
  Employee _employee = MockEmployeeDetailed.FetchAny();

//This constructor assigns the variables of class their values once this screen is called. If the screenType is "Change Team", the function getTeams is also called to update team list from db. It also calls the _getExpertisebyID() function to fetch data of that specific employee from db
  _AssignDetailScreen(
      this._screenType, this._employeeID, this.issueID, this.selfEmployee) {
    if (this._screenType == 'Change Team') {
      AppServices.getTeams().then((result) {
        setState(() {
          this.teamList = this.teamList + result;
        });
      });
    }
    AppServices.getExpertiseById(this._employeeID).then((result) {
      setState(() {
        this._employee = result;
      });
    });
  }

  @override
//  This Function returns a basic screen with an appBar and body.
//  The body is basically a main widget containing several nested card widgets and the relevant button
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return Scaffold(
      appBar: _appBar(this._screenType),
      body: _detailsScreenBody(context),
    );
  }

  //This functions builds the appbar Widget, takes text as an input to be
  // shown in the app bar and consists of a back button and info button also
  Widget _appBar(String text) {
    if (this._screenType == "Assign") {
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
                        MaterialPageRoute(builder: (context) => InfoAssign()),
                      );
                    }))
          ],
          backgroundColor: Styles.backgroundColorOrange,
          centerTitle: true);
    } else if (this._screenType == "Change Roles") {
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
                        MaterialPageRoute(builder: (context) => InfoRole()),
                      );
                    }))
          ],
          backgroundColor: Styles.backgroundColorOrange,
          centerTitle: true);
    } else if (this._screenType == "Change Team") {
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
                        MaterialPageRoute(builder: (context) => InfoTeams()),
                      );
                    }))
          ],
          backgroundColor: Styles.backgroundColorOrange,
          centerTitle: true);
    }
  }

//This function returns a form widget to be displayed on screen
  Widget _detailsScreenBody(BuildContext context) {
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
//  widget which contains a list of widgets. This list contains cards showing the relevant information, a field to select an option(if the screen type is "Change Team" or "Change Role") and a button
  Widget _widgetListonScreen(
      BuildContext context, double height, double width) {
    if (this._screenType == "Assign") {
      return Expanded(
        child: Scrollbar(
          child: ListView(
            children: <Widget>[
              Center(
                child: Card(
                  elevation: 5.0,
                  margin: EdgeInsets.fromLTRB(
                      width * 0.04, height * 0.04, width * 0.04, 0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Container(
                          decoration:
                              BoxDecoration(color: Styles.backgroundColorBlue),
                          padding: EdgeInsets.fromLTRB(
                              width * 0.02, height * 0.02, 0, height * 0.02),
                          child: Text(
                            "Employee Details",
                            style: Styles.secalertDialogBox,
                            textAlign: TextAlign.center,
                          )),
                      Flexible(
                        child: SizedBox(
                          height: height / 15,
                          child: ListView(
                            padding: EdgeInsets.fromLTRB(
                                width * 0.02, height * 0.02, width * 0.02, 0),
                            scrollDirection: Axis.horizontal,
                            children: <Widget>[
                              Text(
                                "Employee ID:      ",
                                style: Styles.specialtextDefault,
                                textAlign: TextAlign.start,
                              ),
                              Text(
                                this._employee.employeeID,
                                style: Styles.specialtextDefault,
                                textAlign: TextAlign.start,
                              )
                            ],
                          ),
                        ),
                      ),
                      Flexible(
                        child: SizedBox(
                          height: height / 15,
                          child: ListView(
                            padding: EdgeInsets.fromLTRB(
                                width * 0.02, height * 0.01, width * 0.02, 0),
                            scrollDirection: Axis.horizontal,
                            children: <Widget>[
                              Text(
                                "Name:                 ",
                                style: Styles.specialtextDefault,
                                textAlign: TextAlign.start,
                              ),
                              Text(
                                this._employee.employeeName,
                                style: Styles.specialtextDefault,
                                textAlign: TextAlign.start,
                              )
                            ],
                          ),
                        ),
                      ),
                      Flexible(
                        child: SizedBox(
                          height: height / 15,
                          child: ListView(
                            padding: EdgeInsets.fromLTRB(
                                width * 0.02, height * 0.01, width * 0.02, 0),
                            scrollDirection: Axis.horizontal,
                            children: <Widget>[
                              Text(
                                "Role:                    ",
                                style: Styles.specialtextDefault,
                                textAlign: TextAlign.start,
                              ),
                              Text(
                                this._employee.employeeRole,
                                style: Styles.specialtextDefault,
                                textAlign: TextAlign.start,
                              )
                            ],
                          ),
                        ),
                      ),
                      Flexible(
                        child: SizedBox(
                          height: height / 15,
                          child: ListView(
                            padding: EdgeInsets.fromLTRB(
                                width * 0.02, height * 0.01, width * 0.02, 0),
                            scrollDirection: Axis.horizontal,
                            children: <Widget>[
                              Text(
                                "Team:                  ",
                                style: Styles.specialtextDefault,
                                textAlign: TextAlign.start,
                              ),
                              Text(
                                this._employee.employeeTeam,
                                style: Styles.specialtextDefault,
                                textAlign: TextAlign.start,
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Center(
                child: Card(
                  elevation: 5.0,
                  margin: EdgeInsets.fromLTRB(
                      width * 0.04, height * 0.04, width * 0.04, 0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Container(
                          decoration:
                              BoxDecoration(color: Styles.backgroundColorBlue),
                          padding: EdgeInsets.fromLTRB(
                              width * 0.02, height * 0.02, 0, height * 0.02),
                          child: Text(
                            "Expertise",
                            style: Styles.secalertDialogBox,
                            textAlign: TextAlign.center,
                          )),
                      Flexible(
                        child: SizedBox(
                          height: height / 15,
                          child: ListView(
                            padding: EdgeInsets.fromLTRB(
                                width * 0.02, height * 0.02, width * 0.02, 0),
                            scrollDirection: Axis.horizontal,
                            children: <Widget>[
                              Text(
                                "Area:                    ",
                                style: Styles.specialtextDefault,
                                textAlign: TextAlign.start,
                              ),
                              Text(
                                this._employee.employeeArea,
                                style: Styles.specialtextDefault,
                                textAlign: TextAlign.start,
                              )
                            ],
                          ),
                        ),
                      ),
                      Flexible(
                        child: SizedBox(
                          height: height / 15,
                          child: ListView(
                            padding: EdgeInsets.fromLTRB(
                                width * 0.02, height * 0.01, width * 0.02, 0),
                            scrollDirection: Axis.horizontal,
                            children: <Widget>[
                              Text(
                                "Category:            ",
                                style: Styles.specialtextDefault,
                                textAlign: TextAlign.start,
                              ),
                              Text(
                                this._employee.employeeCategory,
                                style: Styles.specialtextDefault,
                                textAlign: TextAlign.start,
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              _button("assets/images/take_issue.png", "Assign", () {})
            ],
          ),
        ),
      );
    }
    if (this._screenType == "Change Roles") {
      return Expanded(
        child: Scrollbar(
          child: ListView(
            children: <Widget>[
              Center(
                child: Card(
                  elevation: 5.0,
                  margin: EdgeInsets.fromLTRB(
                      width * 0.04, height * 0.04, width * 0.04, 0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Container(
                          decoration:
                              BoxDecoration(color: Styles.backgroundColorBlue),
                          padding: EdgeInsets.fromLTRB(
                              width * 0.02, height * 0.02, 0, height * 0.02),
                          child: Text(
                            "Employee Details",
                            style: Styles.secalertDialogBox,
                            textAlign: TextAlign.center,
                          )),
                      Flexible(
                        child: SizedBox(
                          height: height / 15,
                          child: ListView(
                            padding: EdgeInsets.fromLTRB(
                                width * 0.02, height * 0.02, width * 0.02, 0),
                            scrollDirection: Axis.horizontal,
                            children: <Widget>[
                              Text(
                                "Employee ID:      ",
                                style: Styles.specialtextDefault,
                                textAlign: TextAlign.start,
                              ),
                              Text(
                                this._employee.employeeID,
                                style: Styles.specialtextDefault,
                                textAlign: TextAlign.start,
                              )
                            ],
                          ),
                        ),
                      ),
                      Flexible(
                        child: SizedBox(
                          height: height / 15,
                          child: ListView(
                            padding: EdgeInsets.fromLTRB(
                                width * 0.02, height * 0.01, width * 0.02, 0),
                            scrollDirection: Axis.horizontal,
                            children: <Widget>[
                              Text(
                                "Name:                 ",
                                style: Styles.specialtextDefault,
                                textAlign: TextAlign.start,
                              ),
                              Text(
                                this._employee.employeeName,
                                style: Styles.specialtextDefault,
                                textAlign: TextAlign.start,
                              )
                            ],
                          ),
                        ),
                      ),
                      Flexible(
                        child: SizedBox(
                          height: height / 15,
                          child: ListView(
                            padding: EdgeInsets.fromLTRB(
                                width * 0.02, height * 0.01, width * 0.02, 0),
                            scrollDirection: Axis.horizontal,
                            children: <Widget>[
                              Text(
                                "Role:                    ",
                                style: Styles.specialtextDefault,
                                textAlign: TextAlign.start,
                              ),
                              Text(
                                this._employee.employeeRole,
                                style: Styles.specialtextDefault,
                                textAlign: TextAlign.start,
                              )
                            ],
                          ),
                        ),
                      ),
                      Flexible(
                        child: SizedBox(
                          height: height / 15,
                          child: ListView(
                            padding: EdgeInsets.fromLTRB(
                                width * 0.02, height * 0.01, width * 0.02, 0),
                            scrollDirection: Axis.horizontal,
                            children: <Widget>[
                              Text(
                                "Team:                  ",
                                style: Styles.specialtextDefault,
                                textAlign: TextAlign.start,
                              ),
                              Text(
                                this._employee.employeeTeam,
                                style: Styles.specialtextDefault,
                                textAlign: TextAlign.start,
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Container(
                height: height / 6,
                padding: EdgeInsets.fromLTRB(
                    width * 0.05, height * 0.04, width * 0.05, 0),
                child: DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    icon: const Icon(Icons.fiber_new),
                    labelText: 'New Role:',
                  ),
                  value: _newRoleSelected,
                  isDense: true,
                  validator: (value) =>
                      value == "Select Role" ? "Field required" : null,
                  onChanged: (value) {
                    setState(() {
                      _newRoleSelected = value;
                    });
                  },
                  //_onSelectTeam(value),
                  items: roleList.map((String value) {
                    return new DropdownMenuItem(
                      value: value,
                      child: new Text(
                        value,
                        style: Styles.verySmalltextDefault,
                      ),
                    );
                  }).toList(),
                ),
              ),
              _button("assets/images/update.png", "Update", () {})
            ],
          ),
        ),
      );
    }
    if (this._screenType == "Change Team") {
      return Expanded(
        child: Scrollbar(
          child: ListView(
            children: <Widget>[
              Center(
                child: Card(
                  elevation: 5.0,
                  margin: EdgeInsets.fromLTRB(
                      width * 0.04, height * 0.04, width * 0.04, 0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Container(
                          decoration:
                              BoxDecoration(color: Styles.backgroundColorBlue),
                          padding: EdgeInsets.fromLTRB(
                              width * 0.02, height * 0.02, 0, height * 0.02),
                          child: Text(
                            "Employee Details",
                            style: Styles.secalertDialogBox,
                            textAlign: TextAlign.center,
                          )),
                      Flexible(
                        child: SizedBox(
                          height: height / 15,
                          child: ListView(
                            padding: EdgeInsets.fromLTRB(
                                width * 0.02, height * 0.02, width * 0.02, 0),
                            scrollDirection: Axis.horizontal,
                            children: <Widget>[
                              Text(
                                "Employee ID:      ",
                                style: Styles.specialtextDefault,
                                textAlign: TextAlign.start,
                              ),
                              Text(
                                this._employee.employeeID,
                                style: Styles.specialtextDefault,
                                textAlign: TextAlign.start,
                              )
                            ],
                          ),
                        ),
                      ),
                      Flexible(
                        child: SizedBox(
                          height: height / 15,
                          child: ListView(
                            padding: EdgeInsets.fromLTRB(
                                width * 0.02, height * 0.01, width * 0.02, 0),
                            scrollDirection: Axis.horizontal,
                            children: <Widget>[
                              Text(
                                "Name:                 ",
                                style: Styles.specialtextDefault,
                                textAlign: TextAlign.start,
                              ),
                              Text(
                                this._employee.employeeName,
                                style: Styles.specialtextDefault,
                                textAlign: TextAlign.start,
                              )
                            ],
                          ),
                        ),
                      ),
                      Flexible(
                        child: SizedBox(
                          height: height / 15,
                          child: ListView(
                            padding: EdgeInsets.fromLTRB(
                                width * 0.02, height * 0.01, width * 0.02, 0),
                            scrollDirection: Axis.horizontal,
                            children: <Widget>[
                              Text(
                                "Role:                    ",
                                style: Styles.specialtextDefault,
                                textAlign: TextAlign.start,
                              ),
                              Text(
                                this._employee.employeeRole,
                                style: Styles.specialtextDefault,
                                textAlign: TextAlign.start,
                              )
                            ],
                          ),
                        ),
                      ),
                      Flexible(
                        child: SizedBox(
                          height: height / 15,
                          child: ListView(
                            padding: EdgeInsets.fromLTRB(
                                width * 0.02, height * 0.01, width * 0.02, 0),
                            scrollDirection: Axis.horizontal,
                            children: <Widget>[
                              Text(
                                "Team:                  ",
                                style: Styles.specialtextDefault,
                                textAlign: TextAlign.start,
                              ),
                              Text(
                                this._employee.employeeTeam,
                                style: Styles.specialtextDefault,
                                textAlign: TextAlign.start,
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Center(
                child: Card(
                  elevation: 5.0,
                  margin: EdgeInsets.fromLTRB(
                      width * 0.04, height * 0.04, width * 0.04, 0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Container(
                          decoration:
                              BoxDecoration(color: Styles.backgroundColorBlue),
                          padding: EdgeInsets.fromLTRB(
                              width * 0.02, height * 0.02, 0, height * 0.02),
                          child: Text(
                            "Expertise",
                            style: Styles.secalertDialogBox,
                            textAlign: TextAlign.center,
                          )),
                      Flexible(
                        child: SizedBox(
                          height: height / 15,
                          child: ListView(
                            padding: EdgeInsets.fromLTRB(
                                width * 0.02, height * 0.02, width * 0.02, 0),
                            scrollDirection: Axis.horizontal,
                            children: <Widget>[
                              Text(
                                "Area:                    ",
                                style: Styles.specialtextDefault,
                                textAlign: TextAlign.start,
                              ),
                              Text(
                                this._employee.employeeArea,
                                style: Styles.specialtextDefault,
                                textAlign: TextAlign.start,
                              )
                            ],
                          ),
                        ),
                      ),
                      Flexible(
                        child: SizedBox(
                          height: height / 15,
                          child: ListView(
                            padding: EdgeInsets.fromLTRB(
                                width * 0.02, height * 0.01, width * 0.02, 0),
                            scrollDirection: Axis.horizontal,
                            children: <Widget>[
                              Text(
                                "Category:            ",
                                style: Styles.specialtextDefault,
                                textAlign: TextAlign.start,
                              ),
                              Text(
                                this._employee.employeeCategory,
                                style: Styles.specialtextDefault,
                                textAlign: TextAlign.start,
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                height: height / 6,
                padding: EdgeInsets.fromLTRB(
                    width * 0.05, height * 0.04, width * 0.05, 0),
                child: DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    icon: const Icon(Icons.supervised_user_circle),
                    labelText: 'New Team:',
                  ),
                  value: _newTeamSelected,
                  isDense: true,
                  validator: (value) =>
                      value == "Select Team" ? "Field required" : null,
                  onChanged: (value) {
                    setState(() {
                      _newTeamSelected = value;
                    });
                  },
                  //_onSelectTeam(value),
                  items: teamList.map((String value) {
                    return new DropdownMenuItem(
                      value: value,
                      child: new Text(
                        value,
                        style: Styles.verySmalltextDefault,
                      ),
                    );
                  }).toList(),
                ),
              ),
              _button("assets/images/update.png", "Update", () {})
            ],
          ),
        ),
      );
    }
  }

//  This function takes the path of the picture to be displayed as button icon and the label to be given on button as arguments and returns a button to be displayed on screen
  Widget _button(String logo, String label, action()) {
    return InkWell(
        onTap: () {},
        child: Container(
            margin: EdgeInsets.symmetric(
                vertical: 20,
                horizontal: MediaQuery.of(context).size.width * 0.32),
            decoration: BoxDecoration(
                color: Styles.backgroundColorBlue,
                borderRadius: BorderRadius.circular(15)),
            height: 36,
            width: 170,
            child: Container(
                alignment: Alignment.center,
                child: FlatButton.icon(
                    onPressed: () {
                      _onButtonTap();
                    }, //action(),
                    icon: Image(
                      image: AssetImage(logo),
                      height: 18,
                      alignment: Alignment.centerLeft,
                    ),
                    label: Container(
                        child: Text(label, style: Styles.buttonDefault1))))));
  }

//  This function is called once the button is tapped and it then calls the relevant functions(according to the screen type) to update the db
  void _onButtonTap() {
    if (_formKey.currentState.validate()) {
      if (this._screenType == "Assign") {
        _assignIssue(this._employeeID, this.issueID);
      }
      if (this._screenType == "Change Roles") {
        String tempRole = '';
        if (_newRoleSelected == 'Initiator') {
          tempRole = '5';
        } else if (_newRoleSelected == 'Support Team Member') {
          tempRole = '4';
        } else if (_newRoleSelected == 'Manager') {
          tempRole = '3';
        } else if (_newRoleSelected == 'Monitor') {
          tempRole = '2';
        } else if (_newRoleSelected == 'Admin') {
          tempRole = '1';
        }
        _updateRole(this._employeeID, tempRole);
      }
      if (this._screenType == "Change Team") {
        _updateTeam(this._employeeID, this._newTeamSelected);
      }
    } else {
      setState(() {
        _autoValidate = true;
      });
    }
  }

//  This function assigns the issue selected to the support team member selected in db
  void _assignIssue(String empID, String iID) {
    AppServices.assignIssue(empID, iID).then((result) {
      if (result == 'success') {
        _confirmation(context);
      } else {
        _error(context);
      }
      Future.delayed(const Duration(seconds: 1), () {
        setState(() {
          if (result == 'success') {
            Navigator.pop(
              context,
            );
            Navigator.pop(
              context,
            );
          } else {
            Navigator.pop(
              context,
            );
            Navigator.pop(
              context,
            );
          }
        });
      });
    });
  }

//  This function updates the new team selected of the employee in db
  void _updateTeam(String empID, String bID) {
    AppServices.updateTeam(empID, bID).then((result) {
      if (result == 'success') {
        _confirmation(context);
      } else {
        _error(context);
      }
      Future.delayed(const Duration(seconds: 1), () {
        setState(() {
          if (result == 'success') {
            Navigator.pop(
              context,
            );
            Navigator.pop(
              context,
            );
          } else {
            Navigator.pop(
              context,
            );
            Navigator.pop(
              context,
            );
          }
        });
      });
    });
  }

//  This function updates the new role selected of the employee in db
  void _updateRole(String empID, String role) {
    AppServices.updateRole(empID, role).then((result) {
      if (result == 'success') {
        _confirmation(context);
      } else {
        _error(context);
      }
      Future.delayed(const Duration(seconds: 1), () {
        setState(() {
          if (result == 'success') {
            Navigator.pop(
              context,
            );
            Navigator.pop(
              context,
            );
          } else {
            Navigator.pop(
              context,
            );
            Navigator.pop(
              context,
            );
          }
        });
      });
    });
  }

//  This function displays a confirmation message once the db is updated
  _confirmation(BuildContext context) {
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
                        icon: new Icon(Icons.check_circle_outline),
                        iconSize: 70,
                        color: Colors.green,
                        onPressed: () {},
                      ),
                    ),
                    Container(
                        margin:
                            EdgeInsets.fromLTRB(0, height / 60, 0, height / 60),
                        alignment: Alignment.topCenter,
                        child: Text("Success!", style: Styles.headerDefault)),
                  ],
                )),
            backgroundColor: Styles.backgroundColorWhite,
          );
        });
  }

//  This function displays an error message if the system fails to update the db.
  _error(BuildContext context) {
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
                        icon: new Icon(Icons.error),
                        iconSize: 70,
                        color: Colors.red,
                        onPressed: () {},
                      ),
                    ),
                    Container(
                        margin:
                            EdgeInsets.fromLTRB(0, height / 60, 0, height / 60),
                        alignment: Alignment.topCenter,
                        child: Text("Action Failed!",
                            style: Styles.headerDefault)),
                  ],
                )),
            backgroundColor: Styles.backgroundColorWhite,
          );
        });
  }
}
