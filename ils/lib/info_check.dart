import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'styles.dart';

class Info extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return Scaffold(
        body: NestedScrollView(
      headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
        return <Widget>[
          SliverAppBar(
              leading: IconButton(
                icon: new Icon(Icons.arrow_back),
                tooltip: 'Back',
                onPressed: () {
                  Navigator.of(context).pop(null);
                },
              ),
              expandedHeight: MediaQuery.of(context).size.height * 0.2,
              floating: false,
              pinned: true,
              backgroundColor: Styles.backgroundColorOrange,
              flexibleSpace: FlexibleSpaceBar(
                  centerTitle: true,
                  title: RichText(
                    text: TextSpan(
                      children: [
                        WidgetSpan(
                          child: Icon(
                            Icons.info_outline,
                            size: 15,
                            color: Colors.white,
                          ),
                        ),
                        TextSpan(
                            text: " Check all issues",
                            style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'Roboto-Black',
                                fontSize: 20,
                                fontWeight: FontWeight.w500)),
                      ],
                    ),
                  )))
        ];
      },
      body: SingleChildScrollView(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: _renderbody(context, " "),
      )),
      // backgroundColor: Styles.backgroundColorWhite,
    ));
  }

  List<Widget> _renderbody(BuildContext context, String text) {
    var result = List<Widget>();
    result.addAll(_renderTitle(context, text));
    return result;
  }

  //Function that renders title widget
  List<Widget> _renderTitle(BuildContext context, String text) {
    var result = List<Widget>();
    result.add(_sectionTitle(text));
    result.add(_sectionText(
        "This feature allows support team members to check all issues in the city, logged in the system that are currently open."));
    result.add(_sectionsubTitle("Status"));
    result.add(_sectionText(
        "The status of every issue in visible on the left side of each issue card. A green tick indicates that it is still open for support team members to take up."));
    result.add(_sectionsubTitle("Issue title"));
    result.add(_sectionText(
        "A brief description of the issue logged in is used as the title in each card to make it easier for you to identify an issue."));
    result.add(_sectionsubTitle("Date and time"));
    result.add(_sectionText(
        "Beneath each title are the exact date and time of when the issue was logged in."));
    result.add(_sectionsubTitle("On selection"));
    result.add(_sectionText(
        "On selecting an issue card, you will be directed to a new screen where you can view the exact details of the specific issue, and can choose to accept it."));
    // result.add(_sectionsubTitle(" "));
    return result;
  }

  //Returns the title
  Widget _sectionTitle(String text) {
    return Container(
        padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
        child: Text(text,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 30,
              fontFamily: 'Roboto-Black',
              fontWeight: FontWeight.w500,
              color: Color(0xFF808080),
            )));
  }

  Widget _sectionsubTitle(String text) {
    return Container(
        padding: EdgeInsets.fromLTRB(25.0, 13.0, 25.0, 8.0),
        child: Text(text,
            textAlign: TextAlign.left,
            style: TextStyle(
              fontSize: 22,
              fontFamily: 'Roboto-Regular',
              fontWeight: FontWeight.w500,
              color: Color(0xFF808080),
            )));
  }

  Widget _sectionText(String text) {
    return Container(
        padding: EdgeInsets.fromLTRB(25.0, 8.0, 25.0, 8.0),
        child: Text(text,
            style: TextStyle(fontSize: 18, fontFamily: 'Roboto-Regular')));
  }
}