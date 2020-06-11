import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/services.dart';
import 'styles.dart';
import 'services.dart';
import 'info_log.dart';

//LoganIssue class inherits the characteristics of a stateful widget and creates
// the instance of an _IssueLogged class which inherits the state of this class
class LoganIssue extends StatefulWidget {
  final String employee;

  LoganIssue(this.employee);

  @override
  State<StatefulWidget> createState() {
    return _IssueLogged(employee);
  }
}

//This class basically creates an instance of stateful widget which will
//form the display of the Log an Issue screen
class _IssueLogged extends State<LoganIssue> {
  var employee;
  final _formKey = GlobalKey<FormState>();
  bool _autoValidate = false;
  String locationSelected = "Select Branch";
  String areaSelected = "Select Area";
  String categorySelected = "Select Category";
  String subCategorySelected = "Select Sub-Category";
  String briefDescription = "Describe Issue Briefly(max 50 Charecters)";
  String detailDescription = "Details of Issue";
  bool logOnBehalf = false;
  String nameOfInitiator = "Malik Ali Hussain";
  String idOfInitiator = "123456";
  List<String> area = ["Select Area"];
  List<String> category = ["Select Category"];
  List<String> subCategory = ["Select Sub-Category"];
  List<String> location = ['Select Branch'];
  String _tempName = "";
  String _tempID = "";

//This constructor assigns the variables of class their values once this screen is called and also called the relevant functions to fetch the data from db
  _IssueLogged(this.employee) {
    _getAllLocations();
    _getAllArea();
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
      appBar: _appBar("Log an Issue"),
      body: _issueDetailsScreen(context),
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

//  This function creates a Form Widget which contains a column as its child.
//  This child in turn have several nested widgets returned by _widgetListonScreen
//  function
  Widget _issueDetailsScreen(BuildContext context) {
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
//  widget which contains a list of widgets. This list contains dropdown menus,
//  a checkbox and a button to  be displayed
  Widget _widgetListonScreen(
      BuildContext context, double height, double width) {
    return Expanded(
      child: Scrollbar(
        child: ListView(
          children: <Widget>[
            Container(
              height: height / 7,
              padding: EdgeInsets.fromLTRB(
                  width * 0.05, height * 0.03, width * 0.05, 0),
              child: DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  icon: const Icon(Icons.pin_drop),
                  labelText: 'Branch Location:',
                ),
                value: this.locationSelected,
                isDense: true,
                validator: (value) =>
                    value == "Select Branch" ? "field required" : null,
                onChanged: (value) => _onSelectLocation(value),
                items: this.location.map((String value) {
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
            Container(
              height: height / 8,
              padding: EdgeInsets.fromLTRB(
                  width * 0.05, height * 0.008, width * 0.05, 0),
              child: DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  icon: const Icon(Icons.bubble_chart),
                  labelText: 'Area:',
                ),
                value: this.areaSelected,
                isDense: true,
                validator: (value) =>
                    value == "Select Area" ? "field required" : null,
                onChanged: (value) => _onSelectArea(value),
                items: this.area.map((String value) {
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
            Container(
              height: height / 8,
              padding: EdgeInsets.fromLTRB(width * 0.05, 0, width * 0.05, 0),
              child: DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  icon: const Icon(Icons.list),
                  labelText: 'Category:',
                ),
                value: this.categorySelected,
                isDense: true,
                validator: (value) =>
                    value == "Select Category" ? "field required" : null,
                onChanged: (value) => _onSelectCategory(value),
                items: this.category.map((String value) {
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
            Container(
              height: height / 8,
              padding: EdgeInsets.fromLTRB(width * 0.05, 0, width * 0.05, 0),
              child: DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  icon: const Icon(Icons.filter_list),
                  labelText: 'Sub-Category:',
                ),
                value: this.subCategorySelected,
                isDense: true,
                validator: (value) =>
                    value == "Select Sub-Category" ? "field required" : null,
                onChanged: (value) => _onSelectSubCategory(value),
                items: this.subCategory.map((String value) {
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
            Container(
              height: height / 8,
              padding: EdgeInsets.fromLTRB(width * 0.05, 0, width * 0.05, 0),
              child: TextFormField(
                decoration: InputDecoration(
                  icon: Icon(Icons.text_fields),
                  hintText: 'Describe the Issue Briefly(max 50 Charecters)',
                  hintStyle: Styles.verySmalltextDefault,
                  labelText: 'Brief Description:',
                ),
                maxLength: 50,
                validator: (value) =>
                    value == "" ? "Description Required" : null,
                onChanged: (value) => _onBriefDescription(value),
              ),
            ),
            Container(
              height: height / 8,
              padding: EdgeInsets.fromLTRB(width * 0.05, 0, width * 0.05, 0),
              child: TextFormField(
                decoration: InputDecoration(
                  icon: Icon(Icons.subject),
                  hintText: 'Details of the Issue',
                  hintStyle: Styles.verySmalltextDefault,
                  labelText: "Detailed Description:",
                ),
                validator: (value) =>
                    value == "" ? "Description Required" : null,
                onChanged: (value) => _onDetailDescription(value),
              ),
            ),
            Container(
              height: height / 16,
              padding: EdgeInsets.fromLTRB(width * 0.025, 0, width * 0.025, 0),
              child: CheckboxListTile(
                title: Text(
                  'Log Issue on behalf',
                  style: Styles.smalltextDefault,
                  textAlign: TextAlign.start,
                ),
                value: this.logOnBehalf,
                onChanged: (value) =>
                    _onSelectCheckBox(context, value, height, width),
              ),
            ),
            _button("assets/images/issueOpen.png", "Submit", () {})
          ],
        ),
      ),
    );
  }

//  This function is called when the user selects the area of the issue to be
//  logged. This function contains another setState function which keeps on
//  updating the form on every click on the button. This function updates the
//  values of the category (from database), sub category and area variables and lists
  void _onSelectArea(String value) {
    setState(() {
      this.categorySelected = "Select Category";
      this.subCategorySelected = "Select Sub-Category";
      this.areaSelected = value;
      this.category = ["Select Category"];
      this.subCategory = ["Select Sub-Category"];
      this.getAllCategories(value);
    });
  }

//This functions returns a string of the Issue description to be viewed on the screen,
  //it takes as an argument the whole description and trims it to fit according to the screen size.
  String _descTrim(String description) {
    if (description.length >= 38) {
      return description.substring(0, 36) + "..";
    } else {
      return description;
    }
  }

  // This function queries the database and fetch all the branch locations
  void _getAllLocations() {
    AppServices.getLocation().then((allLocationsEver) {
      setState(() {
        for (int i = 0; i < allLocationsEver.length; i++) {
          allLocationsEver[i] = _descTrim(allLocationsEver[i]);
        }
        this.location = this.location + allLocationsEver;
      });
    });
  }

  // This function queries the database and fetch all the areas
  void _getAllArea() {
    AppServices.getArea().then((allAreassEver) {
      setState(() {
        this.area = this.area + allAreassEver;
      });
    });
  }

  // This function queries the database and fetch all the categories in the area
  // It takes the area as the parameter
  void getAllCategories(String area) {
    AppServices.getCategory(area).then((allCategoriesEver) {
      setState(() {
        this.category = this.category + allCategoriesEver;
      });
    });
  }

  // This function queries the database and fetch all the sub categories
  // in the given area and its category. It takes area and category as parameters
  void getAllSubCategories(String area, String category) {
    AppServices.getSubCategory(area, category).then((allCategoriesEver) {
      setState(() {
        this.subCategory = this.subCategory + allCategoriesEver;
      });
    });
  }

//  This function is called when the user selects the category of the issue to be
//  logged. This function contains another setState function which keeps on
//  updating the form on every click on the button. This function updates the
//  values of the category, sub category(from database) variables and list.
  void _onSelectCategory(String value) {
    setState(() {
      this.subCategorySelected = "Select Sub-Category";
      this.categorySelected = value;
      this.subCategory = ["Select Sub-Category"];
      this.getAllSubCategories(this.areaSelected, value);
    });
  }

//  This function is called when the user selects the sub category of the issue to be
//  logged. This function contains another setState function which keeps on
//  updating the form on every click on the button. This function updates the
//  value of the  sub category variable.
  void _onSelectSubCategory(String value) {
    setState(() {
      this.subCategorySelected = value;
    });
  }

//  This function is called when the user selects the Branch Location of the
//  issue to be logged. This function contains another setState function which keeps on
//  updating the form on every click on the button. This function updates the
//  values of the branch location variable.
  void _onSelectLocation(String value) {
    setState(() {
      this.locationSelected = value;
    });
  }

//  This function is called when the user taps on the Brief Description TextField.
//  This function contains another setState function which keeps on
//  updating the form on every change in the field. This function updates the
//  values of the brief description variable.
  void _onBriefDescription(String value) {
    setState(() {
      this.briefDescription = value;
    });
  }

//  This function is called when the user taps on the Detailed Description TextField.
//  This function contains another setState function which keeps on
//  updating the form on every change in the field. This function updates the
//  values of the detailed description variable.
  void _onDetailDescription(String value) {
    setState(() {
      this.detailDescription = value;
    });
  }

//  This function is called when the user clicks on the Log on Behalf CheckBox.
//  This function contains another setState function which keeps on
//  updating the form on every change in the field. This function updates the
//  values of the log on behalf variable. If the value is true then it calls
//  the _dialogBox function to show a popup and get the actual initiators details
//  from the user and update the employee name and id variables accordingly
  void _onSelectCheckBox(
      BuildContext context, bool value, double height, double width) {
    setState(() {
      this.logOnBehalf = value;
      if (this.logOnBehalf) {
        _dialogBox(context, height, width);
      }
      if (this.logOnBehalf == false) {
        this.idOfInitiator = this.employee;
      }
    });
  }

//  This function is called when the value of the log on behalf variable is true.
//  This functions creates a popup dialog box to get the actual initiators details
//  from the user and update the employee name and id variables accordingly if pressed
//  continue button and got validated successfully. Otherwise the value of the
//  log on behalf is set to false
  void _dialogBox(BuildContext context, double height, double width) {
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
                    this.logOnBehalf = false;
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

  _validateNameEmployees(String eID, String nameEmployee) {
    AppServices.valEmployeeName(eID, nameEmployee).then((result) {
      if ('success' == result) {
        setState(() {
          this.idOfInitiator = eID;
        });
      } else {
        setState(() {
          this.logOnBehalf = false;
        });
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

//  This function takes the path of the picture to be displayed as button icon and the label to be given on button as arguments and returns a button to be displayed on screen
  Widget _button(String logo, String label, action()) {
    return InkWell(
        onTap: () {},
        child: Container(
            margin: EdgeInsets.symmetric(
                vertical: 10,
                horizontal: MediaQuery.of(context).size.width * 0.35),
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
                        padding: EdgeInsets.fromLTRB(
                            MediaQuery.of(context).size.width * 0.005, 0, 0, 0),
                        child: Text(label, style: Styles.buttonDefault1))))));
  }

//  This function will be called when the submit button is pressed. This function
//  validates all the fields of the form except the log on behalf as it is not
//  mandatory and until all of the mandatory fields are not filled it restricts the
//  user from proceeding ahead. Once all the fields are filled. It then logs the
//  issue of the user in the database
  void _onButtonTap() {
    if (_formKey.currentState.validate()) {
      if (this.logOnBehalf == false) {
        this.idOfInitiator = employee;
      }
      var _index = this.locationSelected.indexOf(' ');
      String newLocation = this.locationSelected.substring(0, _index);
      this.postIssue(
          this.idOfInitiator.toString(),
          newLocation,
          this.areaSelected,
          this.categorySelected,
          this.subCategorySelected,
          this.briefDescription,
          this.detailDescription);
    } else {
      setState(() {
        _autoValidate = true;
      });
    }
  }

  //  This function displays a confirmation message once the db is updated with the new issue
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
                        child: Center(
                            child:
                                Text("Success!", style: Styles.headerDefault))),
                  ],
                )),
            backgroundColor: Styles.backgroundColorWhite,
          );
        });
  }

// This function posts the issue in the database.
//   It takes issueLoggedBy,  location,  area,  category,  subCategory,
//   brief description, detail description as parameters.
  void postIssue(
      String issueLoggedBy,
      String location,
      String area,
      String category,
      String subCategory,
      String description1,
      String description2) {
    AppServices.addIssue(issueLoggedBy, location, area, category, subCategory,
            description1, description2)
        .then((result) {
      if (result == "success") {
        _confirmation(context);
        Future.delayed(const Duration(seconds: 1), () {
          Navigator.of(context).pop(null);
          Navigator.of(context).pop(null);
        });
      } else {
        _error(context);
        Future.delayed(const Duration(seconds: 1), () {
          Navigator.of(context).pop(null);
          Navigator.of(context).pop(null);
        });
      }
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
