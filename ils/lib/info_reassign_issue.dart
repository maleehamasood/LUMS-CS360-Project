import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'styles.dart';

class InfoReassign extends StatelessWidget {
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
                            text: " Reasign issue",
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
        "This feature allows the manager to re-assign an issue, previously taken up by one of his team members, to other support team member"));
    result.add(_sectionsubTitle("Initiator's Details"));
    result.add(_sectionText(
        "The deatils of the employee who logged the issue. These details include the Employee ID, Name and the Branch Location from where the issue was logged"));
    result.add(_sectionsubTitle("Area and Categories"));
    result.add(_sectionText(
        "The relevant Area, Category and Sub-Category of the Issue are displayed to the user"));
    result.add(_sectionsubTitle("Description"));
    result.add(_sectionText(
        "The Brief and Detailed description of the issue are displayed to the user"));
    result.add(_sectionsubTitle("Re-Assign"));
    result.add(_sectionText(
        "On clicking the button the issue will be assigned to the selected support team member for fixation"));
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