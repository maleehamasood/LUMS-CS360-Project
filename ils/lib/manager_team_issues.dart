import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'styles.dart';
import 'mock_issues.dart';
import 'services.dart';
import 'package:flutter/services.dart';
import 'take_an_issue.dart';
import 'info_team_issues.dart';

class ManagerTeamIssuesScreen extends StatefulWidget {
  var employee;
  @override
  State<StatefulWidget> createState() {
    return _ManagerTeamIssuesScreenState(employee);
  }

  ManagerTeamIssuesScreen(this.employee);
}

class _ManagerTeamIssuesScreenState extends State<ManagerTeamIssuesScreen> {
  var employee;
  final openLogo = "assets/images/issueOpen.png";
  final closedLogo = "assets/images/issueClosed.png";
  final solvedLogo = "assets/images/issueTakenup.png";

  _ManagerTeamIssuesScreenState(this.employee) {
    _getTeamIssues(this.employee);
  }

  List<Issue> arrayOfIssues = [];

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return Scaffold(
        //This scaffold is the basic screen where the widgets are placed
        backgroundColor: Styles.backgroundColorWhite,
        appBar: _appBar("Team issues"),
        body: _checkAllIssuesScreenBody());
  }

  Widget _appBar(String text) {
    //This functions builds the appbar Widget, takes text as an input to be shown in the app bar and consists of a back button also
    return new AppBar(
        leading: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            new IconButton(
                icon: new Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.pop(
                    context,
                  );
                } //=> Navigator.of(context).pop(null),
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

  Widget _checkAllIssuesScreenBody() {
    //This function compiles the body of the screen into a Widget to be passed to the primary scaffold.
    // Uses screen sizes to size and place widgets.
    return Container(
        child: _issueList(context, MediaQuery.of(context).size.height,
            MediaQuery.of(context).size.width));
  }

  Widget _logoDecide(String status, height) {
    //This function returns a string which is the path to the status logo of the respective Issue the program is catering at the moment.
    // It takes in as an argument the Status from the Database and assigns a logo accordingly from the assets.

    var statusLogo;

    if (status == "Closed") {
      statusLogo = closedLogo;
    } else if (status == "Open") {
      statusLogo = openLogo;
    } else if (status == "Fixed") {
      statusLogo = solvedLogo;
    } else if (status == "TakenUp") {
      statusLogo = solvedLogo;
    }
    return Container(
      padding: EdgeInsets.only(right: height / 60),
      height: height / 5,
      decoration: new BoxDecoration(
          border: new Border(
              right: new BorderSide(width: 1.0, color: Styles.iconColorGray))),
      child: Image(
          image: AssetImage(
            statusLogo,
          ),
          height: height / 22,
          width: height / 22),
    );
  }

  String _descTrim(String description) {
    //This functions returns a string of the Issue description to be viewed on the screen,
    //it takes as an argument the whole description and trims it to fit according to the screen size.
    if (description.length >= 23) {
      return description.substring(0, 23) + "..";
    } else {
      return description;
    }
  }

  _timeStampTrim(String timestamp) {
    var time;
    var date;

    date = timestamp.substring(0, 10);
    time = timestamp.substring(11, timestamp.length);

    return [date, time];
  }

  Widget _showTimeStamp(List<Issue> arrayOfIssues, int index, double font) {
    return Row(children: [
      Icon(
        Icons.access_time,
        size: font,
        color: Styles.iconColorGray,
      ),
      Text(
        _timeStampTrim(arrayOfIssues[index].Issue_Logged_Timestamp)[1] +
            "     ",
        style: TextStyle(
            fontSize: font,
            color: Styles.iconColorGray,
            fontFamily: 'Roboto-Regular'),
      ),
      Icon(
        Icons.date_range,
        size: font,
        color: Styles.iconColorGray,
      ),
      Text(
        _timeStampTrim(arrayOfIssues[index].Issue_Logged_Timestamp)[0] +
            "     ",
        style: TextStyle(
            fontSize: font,
            color: Styles.iconColorGray,
            fontFamily: 'Roboto-Regular'),
      )
    ]);
  }

  Widget _makeIssueCard(List<Issue> arrayOfIssues, int index,
      BuildContext context, double height, double width) {
    return Container(
        height: height / 6,
        width: width,
        margin: EdgeInsets.fromLTRB(width * 0.01, 0, width * 0.01, 0),
        child: Card(
            elevation: 5,
            margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
            child: Container(
                alignment: Alignment.center,
                child: ListTile(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => IssueDetails(
                              arrayOfIssues[index].Issue_no,
                              this.employee,
                              "ManagerUpdate")),
                    );
                  },
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 20.0, vertical: 0.0),
                  leading:
                      _logoDecide(arrayOfIssues[index].Current_Status, height),
                  title: Container(
                      margin: EdgeInsets.fromLTRB(0, 0, 0, height / 72),
                      child: Text(
                        _descTrim(arrayOfIssues[index].Issue_ID),
                        style: Styles.textDefault,
                      )),
                  subtitle: _showTimeStamp(arrayOfIssues, index, 15),
                  trailing: Icon(Icons.arrow_forward_ios),
                ))));
  }

  _getTeamIssues(String employee) {
    AppServices.getIssuesByTeam(employee).then((allIssuesEver) {
      setState(() {
        arrayOfIssues = allIssuesEver.reversed.toList();
      });
    });
  }

  Widget _issueList(BuildContext context, double height, double width) {
    //This function will call another function to fetch the issues from the database in the form of an array.
    // It will then iterate through the issues to create a scrollable list of issues that will be Cards and can be tapped for further description and actions.
    //Height and width pf the screen are used for placement. The above two functions are helper functions of this function.
    //List<Issue> arrayOfIssues = MockIssues.FetchAny();

    if (arrayOfIssues.length > 0) {
      return ListView.builder(
          itemCount: arrayOfIssues.length,
          itemBuilder: (context, index) {
            return _makeIssueCard(arrayOfIssues, index, context, height, width);
          });
    }
  }
}