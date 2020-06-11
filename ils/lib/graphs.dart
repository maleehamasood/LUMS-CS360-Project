import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'styles.dart';
import 'area_graph.dart';
import 'category_graph.dart';
import 'location_graph.dart';

class Graphs extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return Scaffold(
      // appBar: _appBar(context),
      body:  PageView(
        children: <Widget>[
          // GraphPage(),
          AreaGraph(),
          CategoryGraph(),
          // SubCategoryGraph(),
          LocationGraph(),
        ],
        scrollDirection: Axis.horizontal,
        )
    );
  }
    Widget _appBar(BuildContext context) { 
    return new AppBar(
      title: Text('Generate Reports', style: Styles.appBar),
      leading: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            IconButton(
                icon: new Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.pop(context);
                }),
          ]),
      backgroundColor: Styles.backgroundColorOrange,
      centerTitle: true,
      actions: [
        // Image.asset('assets/images/swipe.png', height: 4.0, color: Colors.white,),
        // Icon(Icons.add),
    ],
      
    );
  }
}