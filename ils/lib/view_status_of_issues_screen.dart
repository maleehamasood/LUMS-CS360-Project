import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'services.dart';
import 'styles.dart';
import 'mock_issues.dart';
import 'info_view.dart';

class ViewStatusOfIssuesScreen extends StatefulWidget {
  final employee;

  ViewStatusOfIssuesScreen(this.employee);

  @override
  State<StatefulWidget> createState() {
    return _ViewStatusOfIssuesScreenState(employee);
  }
}

class _ViewStatusOfIssuesScreenState extends State<ViewStatusOfIssuesScreen> {
  var employee;
  final openLogo = "assets/images/issueOpen.png";
  final closedLogo = "assets/images/issueClosed.png";
  final solvedLogo = "assets/images/issueTakenup.png";
  List<Issue> arrayOfIssues = [];

  _ViewStatusOfIssuesScreenState(this.employee) {
    _getAllIssues();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return Scaffold(
        //This scaffold is the basic screen where the widgets are placed
        backgroundColor: Styles.backgroundColorWhite,
        appBar: _appBar("View your issues"),
        body: _viewStatusOfIssuesScreenBody());
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
                }),
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

  Widget _viewStatusOfIssuesScreenBody() {
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
    //this function trims the timestamp into the date and time separately
    var time;
    var date;

    date = timestamp.substring(0, 10);
    time = timestamp.substring(11, timestamp.length);

    return [date, time];
  }

  Widget _showTimeStamp(List<Issue> arrayOfIssues, int index, double font) {
    //this function is responsible to show the timestamp of each issue in the card
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
    //this function writes each issue in the form of a card
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
                  onTap: () => _issueActions(
                      arrayOfIssues, index, context, height, width),
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

  _getAllIssues() {
    //this function fetches all the issues from the database and returns them to the front end
    AppServices.getIssuesByEmp(employee).then((allIssuesEver) {
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

  _issueActions(List<Issue> arrayOfIssues, int index, BuildContext context,
      double height, double width) {
    //when an issue is clicked this alertdialog is shown which allows the user to mark the issue as open or closed
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
                        child:
                            Text("ISSUE DETAIL", style: Styles.headerDefault)),
                    Container(
                      margin:
                          EdgeInsets.fromLTRB(0, height / 50, 0, height / 50),
                      child: Text(
                        "Description: ",
                        style: Styles.subheadingDefault,
                      ),
                      alignment: Alignment.topLeft,
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(0, 0, 0, height / 50),
                      child: Text(arrayOfIssues[index].Issue_ID,
                          style: Styles.textDefault),
                      alignment: Alignment.topLeft,
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(0, 0, 0, height / 50),
                      child: Text(
                        "Status: ",
                        style: Styles.subheadingDefault,
                        textAlign: TextAlign.start,
                      ),
                      alignment: Alignment.topLeft,
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(0, 0, 0, height / 50),
                      child: Text(
                        arrayOfIssues[index].Current_Status,
                        style: Styles.textDefault,
                        textAlign: TextAlign.start,
                      ),
                      alignment: Alignment.topLeft,
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
                      child: Row(children: [
                        Icon(
                          Icons.access_time,
                          size: 20,
                          color: Styles.iconColorGray,
                        ),
                        Text(
                          _timeStampTrim(arrayOfIssues[index]
                                  .Issue_Logged_Timestamp)[1] +
                              "     ",
                          style: TextStyle(
                              fontSize: 15,
                              color: Styles.iconColorGray,
                              fontFamily: 'Roboto-Regular'),
                        )
                      ]),
                      alignment: Alignment.topLeft,
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
                      child: Row(children: [
                        Icon(
                          Icons.date_range,
                          size: 20,
                          color: Styles.iconColorGray,
                        ),
                        Text(
                          _timeStampTrim(arrayOfIssues[index]
                                  .Issue_Logged_Timestamp)[0] +
                              "     ",
                          style: TextStyle(
                              fontSize: 15,
                              color: Styles.iconColorGray,
                              fontFamily: 'Roboto-Regular'),
                        )
                      ]),
                      alignment: Alignment.topLeft,
                    ),
                  ],
                )),
            actions: <Widget>[
              _openButton(openLogo, "Mark as Open", index),
              _closeButton(closedLogo, "Mark as Closed", index)
            ],
            backgroundColor: Styles.backgroundColorWhite,
          );
        });
  }

  Widget _openButton(String logo, String label, int index) {
    //this function makes the open button on the alertdialog
    return Container(
        margin: EdgeInsets.symmetric(vertical: 10, horizontal: 0),
        decoration: BoxDecoration(
            color: Styles.backgroundColorBlue,
            borderRadius: BorderRadius.circular(15)),
        height: 36,
        width: 170,
        child: FlatButton.icon(
            icon: Image(
              image: AssetImage(logo),
              height: 18,
              alignment: Alignment.centerLeft,
            ),
            label: Text(label, style: Styles.buttonDefault1),
            onPressed: () {
              updateStatus(arrayOfIssues[index].Issue_no, 'Open');
            }));
  }

  Widget _closeButton(String logo, String label, int index) {
    //this function makes the close button on the alertdialog
    return Container(
        margin: EdgeInsets.symmetric(vertical: 10, horizontal: 0),
        decoration: BoxDecoration(
            color: Styles.backgroundColorBlue,
            borderRadius: BorderRadius.circular(15)),
        height: 36,
        width: 170,
        child: FlatButton.icon(
            icon: Image(
              image: AssetImage(logo),
              height: 18,
              alignment: Alignment.centerLeft,
            ),
            label: Text(label, style: Styles.buttonDefault1),
            onPressed: () {
              updateStatus(arrayOfIssues[index].Issue_no, 'Closed');
            }));
  }

  updateStatus(String issue_ID, String new_status) {
    //this function takes commands of changing the status of an issue and changes it accordingly in the database
    AppServices.updateStatus(issue_ID, new_status).then((result) {
      if (result == 'success') {
        if (new_status == "Open") {
          AppServices.sendUnsatisfiedEmail(issue_ID);
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
            Navigator.pop(
              context,
            );
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ViewStatusOfIssuesScreen(employee)),
            );
          } else {
            Navigator.pop(
              context,
            );
            Navigator.pop(
              context,
            );
            Navigator.pop(
              context,
            );
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ViewStatusOfIssuesScreen(employee)),
            );
          }
        });
      });
    });
  }

  _error(BuildContext context) {
    //this function calls a confirmation dialog box after a successful change in status is made
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

  _confirmation(BuildContext context) {
    //this function calls a confirmation dialog box after a successful change in status is made
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
