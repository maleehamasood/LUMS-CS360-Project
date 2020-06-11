import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'change_details.dart';
import 'styles.dart';
import 'styles.dart';
import 'services.dart';
import 'dart:convert';
import 'info_take_an_issue.dart';
import 'info_update_an_issue.dart';
import 'info_reassign_issue.dart';

// IssueDetails class inherits the characteristics of a stateful widget and creates
// the instance of an _IssueDetails class which inherits the state of this class
class IssueDetails extends StatefulWidget {
  final String issueID;
  final String text;
  final String selfID;

  IssueDetails(this.issueID, this.selfID, this.text);

  @override
  State<StatefulWidget> createState() {
    return _IssueDetails(this.issueID, this.selfID, this.text);
  }
}

//This class basically creates an instance of stateful widget which will
//form the display of the _IssueDetails screen
class _IssueDetails extends State<IssueDetails> {
  String selfID;
  String _issueId = "Loading...";
  String _initiatorUn = "Loading...";
  String _initiatorName = "Loading...";
  String _issueLocation = "Loading...";
  String _issueArea = "Loading...";
  String _issueCategory = "Loading...";
  String _issueSubCategory = "Loading...";
  String _issueBriefDescription = "Loading...";
  String _issueDetailDescription = "Loading...";
  String text = "";
  List<String> _actionOptions = [
    "Select Action",
    "Mark as Fixed",
    "Mark as Open",
    "Re-Assign"
  ];
  String _actionSelected = "Select Action";
  final _formKey = GlobalKey<FormState>();
  bool _autovalidate = false;

  _IssueDetails(this._issueId, this.selfID, this.text) {
    _getIssueByIID(this._issueId);
  }

// This function retrieves the branch location from which the issue is logged
  void _getNameOfBranch(String bID) {
    AppServices.getLocationByID(bID).then((result) {
      setState(() {
        this._issueLocation = result;
      });
    });
  }

// This function retrieves the name of the employee who logged the issue
  void _getNameOfEmp(String emID) {
    AppServices.getName1(emID).then((result) {
      setState(() {
        this._initiatorName = result;
      });
    });
  }

//This function retrieves the details of the issue selected from the db
  _getIssueByIID(String issueIID) {
    AppServices.getIssuesByID(issueIID).then((result) {
      var list1 = json.decode(result);
      setState(() {
        this._initiatorUn = list1[0]['Issue_logged_by'];
        this._issueArea = list1[0]['Area'];
        this._issueCategory = list1[0]['Category'];
        this._issueSubCategory = list1[0]['Sub_Category'];
        this._issueBriefDescription = list1[0]['Description1'];
        this._issueDetailDescription = list1[0]['Description2'];
        _getNameOfEmp(this._initiatorUn);
        _getNameOfBranch(list1[0]['Branch_ID']);
      });
    });
  }

  @override
  //  This Function returns a basic screen with an appBar and body.
//  The body is basically a Scaffold containing several nested widgets
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return Scaffold(
      appBar: _appBar(context, this.text),
      body: _issueDetailsScreen(context),
    );
  }

  //This functions builds the appbar Widget, takes text as an input to be
  // shown in the app bar and consists of a back button and an info button also
  Widget _appBar(BuildContext context, String text) {
    if (text == "New") {
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
          title: Text("Take an issue", style: Styles.appBar),
          actions: [
            Padding(
                padding: EdgeInsets.only(right: 10),
                child: IconButton(
                    icon: new Icon(Icons.info_outline),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => InfoTake()),
                      );
                    }))
          ],
          backgroundColor: Styles.backgroundColorOrange,
          centerTitle: true);
    } else if (text == "Update") {
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
          title: Text("Update an issue", style: Styles.appBar),
          actions: [
            Padding(
                padding: EdgeInsets.only(right: 10),
                child: IconButton(
                    icon: new Icon(Icons.info_outline),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => InfoUpdate()),
                      );
                    }))
          ],
          backgroundColor: Styles.backgroundColorOrange,
          centerTitle: true);
    } else if (text == "ManagerUpdate") {
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
          title: Text("Reassign", style: Styles.appBar),
          actions: [
            Padding(
                padding: EdgeInsets.only(right: 10),
                child: IconButton(
                    icon: new Icon(Icons.info_outline),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => InfoReassign()),
                      );
                    }))
          ],
          backgroundColor: Styles.backgroundColorOrange,
          centerTitle: true);
    }
  }

//  This function creates a Form Widget which contains a column as its child.
//  This child in turn have several nested widgets returned by _widgetListonScreen
//  function
  Widget _issueDetailsScreen(BuildContext context) {
    return Column(
      children: <Widget>[
        _widgetListonScreen(context, MediaQuery.of(context).size.height,
            MediaQuery.of(context).size.width)
      ],
    );
  }

//  This Function takes in height and width as extra parameters to ensure that
//  the widget placement works for any screen size and returns a Scrollable
//  widget which contains a list of widgets. This list contains Rows and each
//  Row inturn conatins the widget to  be displayed
  Widget _widgetListonScreen(
      BuildContext context, double height, double width) {
    if (this.text == "New") {
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
                            "Initiator's Details",
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
                                "Employee ID:         ",
                                style: Styles.specialtextDefault,
                                textAlign: TextAlign.start,
                              ),
                              Text(
                                _initiatorUn,
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
                                "Name:                    ",
                                style: Styles.specialtextDefault,
                                textAlign: TextAlign.start,
                              ),
                              Text(
                                _initiatorName,
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
                                "Branch Location:  ",
                                style: Styles.specialtextDefault,
                                textAlign: TextAlign.start,
                              ),
                              Text(
                                _issueLocation,
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
                            "Area and Categories",
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
                                "Area:                       ",
                                style: Styles.specialtextDefault,
                                textAlign: TextAlign.start,
                              ),
                              Text(
                                _issueArea,
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
                                "Category:               ",
                                style: Styles.specialtextDefault,
                                textAlign: TextAlign.start,
                              ),
                              Text(
                                _issueCategory,
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
                                "Sub-Category:       ",
                                style: Styles.specialtextDefault,
                                textAlign: TextAlign.start,
                              ),
                              Text(
                                _issueSubCategory,
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
                            "Description",
                            style: Styles.secalertDialogBox,
                            textAlign: TextAlign.center,
                          )),
                      Container(
                          padding: EdgeInsets.fromLTRB(
                              width * 0.02, height * 0.02, 0, height * 0.02),
                          child: Text(
                            "Brief Description:",
                            style: Styles.specialtextDefault,
                            textAlign: TextAlign.left,
                          )),
                      Container(
                          padding: EdgeInsets.fromLTRB(width * 0.02,
                              height * 0.01, width * 0.02, height * 0.02),
                          child: Text(
                            _issueBriefDescription,
                            style: Styles.specialtextDefault,
                            textAlign: TextAlign.justify,
                          )),
                      Container(
                          padding: EdgeInsets.fromLTRB(
                              width * 0.02, height * 0.01, 0, height * 0.02),
                          child: Text(
                            "Detail Description:",
                            style: Styles.specialtextDefault,
                            textAlign: TextAlign.left,
                          )),
                      Container(
                          padding: EdgeInsets.fromLTRB(width * 0.02,
                              height * 0.01, width * 0.05, height * 0.02),
                          child: Text(
                            _issueDetailDescription,
                            style: Styles.specialtextDefault,
                            textAlign: TextAlign.justify,
                          )),
                    ],
                  ),
                ),
              ),
              _button("assets/images/take_issue.png", " Take up!", () {})
            ],
          ),
        ),
      );
    }
    if (this.text == "Update") {
      return Form(
        key: _formKey,
        child: Expanded(
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
                            decoration: BoxDecoration(
                                color: Styles.backgroundColorBlue),
                            padding: EdgeInsets.fromLTRB(
                                width * 0.02, height * 0.02, 0, height * 0.02),
                            child: Text(
                              "Initiator's Details",
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
                                  "Employee ID:         ",
                                  style: Styles.specialtextDefault,
                                  textAlign: TextAlign.start,
                                ),
                                Text(
                                  _initiatorUn,
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
                                  "Name:                    ",
                                  style: Styles.specialtextDefault,
                                  textAlign: TextAlign.start,
                                ),
                                Text(
                                  _initiatorName,
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
                                  "Branch Location:  ",
                                  style: Styles.specialtextDefault,
                                  textAlign: TextAlign.start,
                                ),
                                Text(
                                  _issueLocation,
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
                            decoration: BoxDecoration(
                                color: Styles.backgroundColorBlue),
                            padding: EdgeInsets.fromLTRB(
                                width * 0.02, height * 0.02, 0, height * 0.02),
                            child: Text(
                              "Area and Categories",
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
                                  "Area:                       ",
                                  style: Styles.specialtextDefault,
                                  textAlign: TextAlign.start,
                                ),
                                Text(
                                  _issueArea,
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
                                  "Category:               ",
                                  style: Styles.specialtextDefault,
                                  textAlign: TextAlign.start,
                                ),
                                Text(
                                  _issueCategory,
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
                                  "Sub-Category:       ",
                                  style: Styles.specialtextDefault,
                                  textAlign: TextAlign.start,
                                ),
                                Text(
                                  _issueSubCategory,
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
                            decoration: BoxDecoration(
                                color: Styles.backgroundColorBlue),
                            padding: EdgeInsets.fromLTRB(
                                width * 0.02, height * 0.02, 0, height * 0.02),
                            child: Text(
                              "Description",
                              style: Styles.secalertDialogBox,
                              textAlign: TextAlign.center,
                            )),
                        Container(
                            padding: EdgeInsets.fromLTRB(
                                width * 0.02, height * 0.02, 0, height * 0.02),
                            child: Text(
                              "Brief Description:",
                              style: Styles.specialtextDefault,
                              textAlign: TextAlign.left,
                            )),
                        Container(
                            padding: EdgeInsets.fromLTRB(width * 0.02,
                                height * 0.01, width * 0.05, height * 0.02),
                            child: Text(
                              _issueBriefDescription,
                              style: Styles.specialtextDefault,
                              textAlign: TextAlign.justify,
                            )),
                        Container(
                            padding: EdgeInsets.fromLTRB(
                                width * 0.02, height * 0.01, 0, height * 0.02),
                            child: Text(
                              "Detail Description:",
                              style: Styles.specialtextDefault,
                              textAlign: TextAlign.left,
                            )),
                        Container(
                            padding: EdgeInsets.fromLTRB(width * 0.02,
                                height * 0.01, width * 0.05, height * 0.02),
                            child: Text(
                              _issueDetailDescription,
                              style: Styles.specialtextDefault,
                              textAlign: TextAlign.justify,
                            )),
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
                      icon: const Icon(Icons.format_list_bulleted),
                      labelText: 'Action:',
                    ),
                    value: _actionSelected,
                    isDense: true,
                    validator: (value) =>
                        value == "Select Action" ? "Field required" : null,
                    onChanged: (value) {
                      setState(() {
                        _actionSelected = value;
                      });
                    },
                    items: _actionOptions.map((String value) {
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
                _button("assets/images/update.png", "   Update", () {})
              ],
            ),
          ),
        ),
      );
    }
    if (this.text == "ManagerUpdate") {
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
                            "Initiator's Details",
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
                                "Employee ID:         ",
                                style: Styles.specialtextDefault,
                                textAlign: TextAlign.start,
                              ),
                              Text(
                                _initiatorUn,
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
                                "Name:                    ",
                                style: Styles.specialtextDefault,
                                textAlign: TextAlign.start,
                              ),
                              Text(
                                _initiatorName,
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
                                "Branch Location:  ",
                                style: Styles.specialtextDefault,
                                textAlign: TextAlign.start,
                              ),
                              Text(
                                _issueLocation,
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
                            "Area and Categories",
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
                                "Area:                       ",
                                style: Styles.specialtextDefault,
                                textAlign: TextAlign.start,
                              ),
                              Text(
                                _issueArea,
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
                                "Category:               ",
                                style: Styles.specialtextDefault,
                                textAlign: TextAlign.start,
                              ),
                              Text(
                                _issueCategory,
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
                                "Sub-Category:       ",
                                style: Styles.specialtextDefault,
                                textAlign: TextAlign.start,
                              ),
                              Text(
                                _issueSubCategory,
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
                            "Description",
                            style: Styles.secalertDialogBox,
                            textAlign: TextAlign.center,
                          )),
                      Container(
                          padding: EdgeInsets.fromLTRB(
                              width * 0.02, height * 0.02, 0, height * 0.02),
                          child: Text(
                            "Brief Description:",
                            style: Styles.specialtextDefault,
                            textAlign: TextAlign.left,
                          )),
                      Container(
                          padding: EdgeInsets.fromLTRB(width * 0.02,
                              height * 0.01, width * 0.05, height * 0.02),
                          child: Text(
                            _issueBriefDescription,
                            style: Styles.specialtextDefault,
                            textAlign: TextAlign.justify,
                          )),
                      Container(
                          padding: EdgeInsets.fromLTRB(
                              width * 0.02, height * 0.01, 0, height * 0.02),
                          child: Text(
                            "Detail Description:",
                            style: Styles.specialtextDefault,
                            textAlign: TextAlign.left,
                          )),
                      Container(
                          padding: EdgeInsets.fromLTRB(width * 0.02,
                              height * 0.01, width * 0.05, height * 0.02),
                          child: Text(
                            _issueDetailDescription,
                            style: Styles.specialtextDefault,
                            textAlign: TextAlign.justify,
                          )),
                    ],
                  ),
                ),
              ),
              _button("assets/images/take_issue.png", "Re-Assign", () {})
            ],
          ),
        ),
      );
    }
  }

  //  This function displays a confirmation message once the db is updated with the changes
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

//  This function takes the path of the picture to be displayed as button icon and the label to be given on button as arguments and returns a button to be displayed on screen
  Widget _button(String logo, String label, action()) {
    return InkWell(
        onTap: () {},
        child: Container(
            margin: EdgeInsets.symmetric(
                vertical: 30,
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
                      if (this.text == "New") {
                        _assignIssue(this.selfID, this._issueId);
                        updatestatus(this._issueId, 'TakenUp');
                      } else if (this.text == "Update") {
                        if (_formKey.currentState.validate()) {
                          if (label == "Re-Assign") {
                            this._actionSelected = "Re-Assign";
                          }
                          if (this._actionSelected == "Mark as Fixed") {
                            updatestatus(this._issueId, 'Fixed');
                          } else if (this._actionSelected == "Mark as Open") {
                            _assignIssue("", this._issueId);
                            updatestatus(this._issueId, 'Open');
                          } else {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ChangeDetails(
                                      "Assign", this._issueId, this.selfID)),
                            );
                          }
                        } else {
                          setState(() {
                            _autovalidate = true;
                          });
                        }
                      } else {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ChangeDetails(
                                  "Assign", this._issueId, this.selfID)),
                        );
                      }
                    }, //action(),
                    icon: Image(
                      image: AssetImage(logo),
                      height: 18,
                      alignment: Alignment.centerLeft,
                    ),
                    label: Text(label, style: Styles.buttonDefault1)))));
  }

  //this function takes commands of changing the status of an issue and changes it accordingly in the database
  updatestatus(String issue_ID, String new_status) {
    AppServices.updateStatus(issue_ID, new_status).then((result) {
      if (result == 'success') {
        if (new_status == "Open") {
          AppServices.sendOpenUpdate(issue_ID);
        }
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

  //  This function assigns the issue selected to the support team member selected in db
  void _assignIssue(String empID, String iID) {
    AppServices.assignIssue(empID, iID).then((result) {
      if (result == "success") {}
    });
  }
}
