import 'package:flutter/material.dart';
import 'package:ils/graphs.dart';
import 'package:ils/issues_taken_up.dart';
import 'package:flutter/services.dart';
import 'package:ils/login_screen.dart';
import 'styles.dart';
import 'manager_team_issues.dart';
import 'change_details.dart';

class SpecificMenu extends StatefulWidget {
  var employee;
  var role;
  SpecificMenu(this.employee, this.role);
  @override
  _SpecificMenu createState() {
    return _SpecificMenu(this.employee, this.role);
  }
}

class _SpecificMenu extends State<SpecificMenu> {
  var employee;
  var role;
  _SpecificMenu(this.employee, this.role);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: new Icon(Icons.arrow_back),
          tooltip: 'Back',
          onPressed: () {
            Navigator.of(context).pop(null);
          },
        ),
        backgroundColor: Styles.backgroundColorOrange,
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: checkRole(context, this.role),
        ),
      ),
      backgroundColor: Styles.backgroundColorWhite,
    );
  }

//Checks the role of the employee to display necessary widgets
  List<Widget> checkRole(BuildContext context, String text) {
    if (text == "Manager") {
      //Navigate to Manager Screen
      return (_renderBodyManager(context, text));
    } else if (text == "Monitor") {
      //Navigate to Monitor Screen
      return (_renderBodyManager(context, text));
    } else if (text == "Admin") {
      //Navigate to Admin Screen
      return (_renderBodyAdmin(context, text));
    } else if (text == "Support") {
      //Navigate to support screen
      return (_renderBodySupport(context, text));
    } else {
      print("Error in role");
      print(text);
      return (_renderBodyManager(context, text));
    }
  }

//Function that returns a button given its parameters
  Widget _roundButton(
      BuildContext context, String text, String image, String color) {
    return Container(
      padding: EdgeInsets.fromLTRB(0, 15, 0, 0),
      child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Container(
                width: MediaQuery.of(context).size.width * 0.35,
                height: MediaQuery.of(context).size.height * 0.276,
                child: RaisedButton(
                    shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(30.0)),
                    onPressed: () {
                      toNewScreen(context, text);
                    },
                    color: Color(int.parse(color.substring(0, 6), radix: 16) +
                        0xFF000000),
                    child: Column(children: <Widget>[
                      Container(
                        width: MediaQuery.of(context).size.width * 0.15,
                        height: MediaQuery.of(context).size.height * 0.15,
                        padding: EdgeInsets.fromLTRB(0, 30, 0, 0),
                        child: Image(
                            color: Styles.backgroundColorWhite,
                            image: new AssetImage(image)),
                      ),
                      SizedBox(width: MediaQuery.of(context).size.width * 0.55),
                      Container(
                        height: MediaQuery.of(context).size.height * 0.12,
                        padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
                        child: Text(text,
                            textAlign: TextAlign.center,
                            style: Styles.buttonTextmenu),
                      )
                    ]))),
            // SizedBox(width: MediaQuery.of(context).size.width * 0.35),
          ]),
    );
  }

  // The function that renders the whole body of the Manager screen by returning widgets like banner image, title and buttons
  List<Widget> _renderBodyManager(BuildContext context, String text) {
    var result = List<Widget>();
    result.add(_bannerImage(MediaQuery.of(context).size.height * 0.2));
    result.add(_renderTitle(context, text));
    result.add(_renderButtonManager(context));
    // result.add(logoutButton(context));
    return result;
  }

//Function that returns the Support buttons widget consisting of issues taken up, generate graph, team issues and Logout
  Widget _renderButtonManager(BuildContext context) {
    return Column(mainAxisAlignment: MainAxisAlignment.start, children: <
        Widget>[
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          _roundButton(
              context, "Issues Taken Up", "assets/images/task.png", '26dbb7'),
          _roundButton(
              context, "Generate report", "assets/images/graph.png", 'dd5782')
        ],
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          _roundButton(context, "Team issues", "assets/images/team_issues.png",
              '3399CC'),
          _roundButton(context, "Logout", "assets/images/door.png", '7c7c7c'),
        ],
      )
    ]);
  }

//Function that returns the Admin buttons widget consisting of change role and Logout
  Widget _renderButtonAdmin(BuildContext context) {
    return Container(
        width: MediaQuery.of(context).size.width * 0.55,
        height: MediaQuery.of(context).size.height * 0.4,
        padding: EdgeInsets.fromLTRB(0, 50, 0, 0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            _roundButton(
                context, "Change Roles", "assets/images/role.png", 'dd5782'),
            logoutButton(context)
          ],
        ));
  }

  // The function that renders the whole body of the Admin screen by returning widgets like banner image, title and buttons
  List<Widget> _renderBodyAdmin(BuildContext context, String text) {
    var result = List<Widget>();
    result.add(_bannerImage(MediaQuery.of(context).size.height * 0.26));
    result.add(_renderTitle(context, text));
    result.add(_renderButtonAdmin(context));
    return result;
  }

//Function that returns the Support buttons widget consisting of issues taken up and Logout
  Widget _renderButtonSupport(BuildContext context) {
    return Container(
        width: MediaQuery.of(context).size.width * 0.55,
        height: MediaQuery.of(context).size.height * 0.4,
        padding: EdgeInsets.fromLTRB(0, 50, 0, 0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            _roundButton(
                context, "Issues Taken Up", "assets/images/task.png", '26dbb7'),
            logoutButton(context)
          ],
        ));
  }

  // The function that renders the whole body of the Suppor team screen by returning widgets like banner image, title and buttons
  List<Widget> _renderBodySupport(BuildContext context, String text) {
    var result = List<Widget>();
    result.add(_bannerImage(MediaQuery.of(context).size.height * 0.26));
    result.add(_renderTitle(context, text));
    result.add(_renderButtonSupport(context));
    return result;
  }

//Logout button that goes to login screen
  Widget logoutButton(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(0, 15, 0, 0),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Container(
                width: MediaQuery.of(context).size.width * 0.35,
                height: MediaQuery.of(context).size.height * 0.276,
                child: RaisedButton(
                    shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(25.0)),
                    onPressed: () {
                      Navigator.pop(
                        context,
                      );
                      Navigator.pop(
                        context,
                      );
                    },
                    color: Color(0xFF7c7c7c),
                    child: Column(children: <Widget>[
                      Container(
                        width: MediaQuery.of(context).size.width * 0.15,
                        height: MediaQuery.of(context).size.height * 0.15,
                        padding: EdgeInsets.fromLTRB(0, 30, 0, 0),
                        child: Image(
                            color: Styles.backgroundColorWhite,
                            image: new AssetImage("assets/images/door.png")),
                      ),
                      Container(
                        height: MediaQuery.of(context).size.height * 0.12,
                        padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
                        child: Text(
                          "Logout",
                          textAlign: TextAlign.center,
                          style: Styles.buttonTextmenu,
                        ),
                      )
                    ]))),
            SizedBox(width: 50),
          ]),
    );
  }

//Function that renders title widget
  Widget _renderTitle(BuildContext context, String text) {
    return (_sectionTitle(text));
    // result.add(_sectionText(location.facts[i].text));
  }

//Returns the title
  Widget _sectionTitle(String text) {
    return Container(
        padding: EdgeInsets.fromLTRB(25.0, 0.0, 25.0, 10.0),
        child:
            Text(text, textAlign: TextAlign.left, style: Styles.mainPageTitle));
  }

//Function that displays banner image after fetching it from URL
  Widget _bannerImage(double height) {
    return Container(
      constraints: BoxConstraints.tightFor(height: height),
      child: Image.network(
          'https://mettisglobal.news/wp-content/uploads/2018/12/IMG2594Allied-Bank-696x438.jpg',
          fit: BoxFit.fitWidth),
    );
  }

  void toNewScreen(BuildContext context, String text) {
    if (text == "Logout") {
      //navigate to specific menu screen
      Navigator.pop(
        context,
      );
      Navigator.pop(
        context,
      );
    } else if (text == "Team issues") {
      //navigate to specific menu screen
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ManagerTeamIssuesScreen(this.employee)),
      );
    } else if (text == "Issues Taken Up") {
      //navigate to specific menu screen
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => IssuesTakenUpScreen(this.employee)),
      );
    } else if (text == "Generate report") {
      //navigate to specific menu screen
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Graphs()),
      );
    } else if (text == "Change Roles") {
      //navigate to specific menu screen
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                ChangeDetails("Change Roles", " ", this.employee)),
      );
    } else if (text == "Change Team") {
      //navigate to specific menu screen
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                ChangeDetails("Change Team", "", this.employee)),
      );
    } else {
      print("Error in role");
      print(text);
      return;
    }
  }
}
