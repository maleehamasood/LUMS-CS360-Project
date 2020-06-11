import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'specific_menu.dart';
import 'styles.dart';
import 'view_status_of_issues_screen.dart';
import 'check_all_issues_screen.dart';
import 'log_an_issue.dart';
import 'package:ils/graphs.dart';
import 'change_details.dart';
// import 'services.dart';

class Menu extends StatefulWidget {
  var employee;
  var name;
  var role;
  Menu(this.employee, this.role, this.name);
  @override
  _Menu createState() {
    return _Menu(this.employee, this.role, this.name);
  }
}

class _Menu extends State<Menu> {
  var name;
  var role;
  var employee;
  _Menu(this.employee, this.role, this.name);
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    print("Calling ${this.role} menu for ${this.name}");
    if (this.role == '1') {
      this.role = 'Admin';
    } else if (this.role == '2') {
      this.role = 'Monitor';
    } else if (this.role == '3') {
      this.role = 'Manager';
    } else if (this.role == '4') {
      this.role = 'Support';
    } else if (this.role == '5') {
      this.role = 'Employee';
    }
    return Scaffold(
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

//This function checks the role of the employee and displays the apprropriate screen of widgets to the user depending on the role.
  List<Widget> checkRole(BuildContext context, String text) {
    if (text == "Employee") {
      print("${this.role}! was here1");
      return (_renderBodyEmployee(context, "Welcome " + this.name + "!"));
    } else if (text == "Monitor") {
      print("${this.role}! was here2");
      return (_renderBodyMonitor(context, "Welcome " + this.name + "!"));
    } else if (text == "Admin") {
      print("${this.role}! was here3");
      return (_renderBodyAdmin(context, "Welcome " + this.name + "!"));
    } else {
      print("${this.role}! was here4");
      return (_renderBody(context, "Welcome " + this.name + "!"));
    }
  }

  //The function that renders the whole body of the default screen by returning widgets like banner image, title and buttons
  List<Widget> _renderBody(BuildContext context, String text) {
    var result = List<Widget>();
    result.add(_bannerImage(MediaQuery.of(context).size.height * 0.26));
    result.addAll(_renderTitle(context, text));
    result.add(renderButtons(context));
    return result;
  }

  //The function that renders the whole body of the Monitor screen by returning widgets like banner image, title and buttons
  List<Widget> _renderBodyMonitor(BuildContext context, String text) {
    var result = List<Widget>();
    result.add(_bannerImage(MediaQuery.of(context).size.height * 0.26));
    result.addAll(_renderTitle(context, text));
    result.add(renderButtonsMonitor(context));
    return result;
  }

  //Function that returns the Monitor buttons widget in a 2x2 order consisting of log an issue, view status of issues, Generate report and Logout
  Widget renderButtonsMonitor(BuildContext context) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Column(mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[
            roundButton(
                context, "Log an issue", "assets/images/pen.png", '2e7bef'),
            roundButton(
                context, "Generate Report", "assets/images/graph.png", 'dd5782')
          ]),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              roundButton(context, "View your issues",
                  "assets/images/eye.png", 'e17272'),
              roundButton(context, "Logout", "assets/images/door.png", '7c7c7c')
            ],
          )
        ]);
  }

  //The function that renders the whole body of the Monitor screen by returning widgets like banner image, title and buttons
  List<Widget> _renderBodyAdmin(BuildContext context, String text) {
    var result = List<Widget>();
    result.add(_bannerImage(MediaQuery.of(context).size.height * 0.26));
    result.addAll(_renderTitle(context, text));
    result.add(renderButtonsAdmin(context));
    return result;
  }

  //Function that returns the Admin buttons widget in a 2x2 order consisting of log an issue, view status of issues, Change team and Logout
  Widget renderButtonsAdmin(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: <
        Widget>[
      Column(mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[
        roundButton(context, "Log an issue", "assets/images/pen.png", '2e7bef'),
        roundButton(context, "Change Team", "assets/images/team.png", 'a473ed')
      ]),
      Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          roundButton(context, "View your issues", "assets/images/eye.png",
              'e17272'),
          roundButton(
              context, "More", "assets/images/arrow_forward.png", 'f4c964')
        ],
      )
    ]);
  }

    // The function that renders the whole body of the Employee screen by returning widgets like banner image, title and buttons
  List<Widget> _renderBodyEmployee(BuildContext context, String text) {
    var result = List<Widget>();
    result.add(_bannerImage(MediaQuery.of(context).size.height * 0.25));
    result.addAll(_renderTitle(context, text));
    result.add(renderButtonsEmployee(context));
    return result;
  }

  // Function that returns the buttons widget of an employee in a triangular order
  Widget renderButtonsEmployee(BuildContext context) {
    return Column(mainAxisAlignment: MainAxisAlignment.start, children: <
        Widget>[
      Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: <Widget>[
        roundButton(context, "Log an issue", "assets/images/pen.png", '2e7bef'),
        roundButton(
            context, "View your issues", "assets/images/eye.png", 'e17272')
      ]),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          roundButton(context, "Logout", "assets/images/door.png", '7c7c7c'),
        ],
      )
    ]);
  }


  //Function that displays banner image of the ABL logo after fetching it from URL
  Widget _bannerImage(double height) {
    return Container(
      constraints: BoxConstraints.tightFor(height: height),
      child: Image.network(
          'https://mettisglobal.news/wp-content/uploads/2018/12/IMG2594Allied-Bank-696x438.jpg',
          fit: BoxFit.fitWidth),
    );
  }

  //Following two functions are used to render the welcome + name title
  List<Widget> _renderTitle(BuildContext context, String text) {
    var result = List<Widget>();
    result.add(_sectionTitle(context, text));
    return result;
  }

  Widget _sectionTitle(BuildContext context, String text) {
    return Container(
        padding: EdgeInsets.fromLTRB(25.0, 25.0, 25.0, 10.0),
        child:
            Text(text, textAlign: TextAlign.left, style: Styles.mainPageTitle));
  }

//Function that returns the default buttons widget in a 2x2 order consisting of log an issue, view status of issues, check all issues and more
  Widget renderButtons(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: <
        Widget>[
      Column(mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[
        roundButton(context, "Log an issue", "assets/images/pen.png", '2e7bef'),
        roundButton(
            context, "Check all issues", "assets/images/view.png", '90EE90')
      ]),
      Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          roundButton(
              context, "View your issues", "assets/images/eye.png", 'e17272'),
          roundButton(
              context, "More", "assets/images/arrow_forward.png", 'f4c964')
        ],
      )
    ]);
  }

//Function that returns a single button given its parameters of text, image icon and color
  Widget roundButton(
      BuildContext context, String text, String image, String color) {
    return Container(
      padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
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
                      // SizedBox(width: MediaQuery.of(context).size.width * 0.55),
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

//Goes to new screen depending on the button clicked
  void toNewScreen(BuildContext context, String text) {
    if (text == "Log an issue") {
      //Navigate to Log an issue Screen
      //  _issueactions(context);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => LoganIssue(employee)),
      );
    } else if (text == "View your issues") {
      //Navigate to View all issues Screen
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ViewStatusOfIssuesScreen(employee)),
      );
    } else if (text == "Check all issues") {
      //Navigate to Check status of issues Screen
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => CheckAllIssuesScreen(employee)),
      );
    } else if (text == "More") {
      if (this.role == '1') {
        this.role = 'Admin';
      } else if (this.role == '2') {
        this.role = 'Monitor';
      } else if (this.role == '3') {
        this.role = 'Manager';
      } else if (this.role == '4') {
        this.role = 'Support';
      } else if (this.role == '5') {
        this.role = 'Employee';
      }
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => SpecificMenu(this.employee, this.role)),
      );
    } else if (text == "Logout") {
      Navigator.pop(
        context,
      );
    } else if (text == "Change Team") {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                ChangeDetails("Change Team", " ", this.employee)),
      );
    } else if (text == "Generate Report") {
      //navigate to specific menu screen
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Graphs()),
      );
    } else {
      print("Error in role");
      return;
    }
  }
}
