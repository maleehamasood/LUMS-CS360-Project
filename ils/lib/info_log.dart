import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
                            text: "  Log an issue",
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
        "This feature allows you to log in an issue that you are currently facing at your workplace."));
    result.add(_sectionsubTitle("Branch Location"));
    result.add(_sectionText(
        "Select the geographical location of the branch where the issue is being faced"));
    result.add(_sectionsubTitle("Area"));
    result.add(_sectionText("Select the appropriate area of relevance of the issue (e.g IT)"));
    result.add(_sectionsubTitle("Category"));
    result.add(_sectionText(
        "Select the relevant category group of the issue to be logged (e.g Hardware)"));
    result.add(_sectionsubTitle("Sub Category"));
    result.add(_sectionText(
        "Select the relevant sub category group of the issue to be logged (e.g Mouse)"));
    result.add(_sectionsubTitle("Brief Description"));
    result.add(_sectionText(
        "Write a short description on the issue being faced (e.g Bluetooth Mouse connection problem)"));
    result.add(_sectionsubTitle("Detailed Description"));
    result.add(_sectionText(
        "Describe clearly and in detail the description of the issue being faced (e.g Bluetooth Mouse is not connecting to my desk computer, however, conects to other computers)"));
    result.add(_sectionsubTitle(" "));
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