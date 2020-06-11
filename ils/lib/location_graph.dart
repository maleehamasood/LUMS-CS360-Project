import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'styles.dart';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'location_data.dart';

class LocationGraph extends StatefulWidget {
  @override
  _LocationGraph createState() {
    return _LocationGraph();
  }
}

class _LocationGraph extends State<LocationGraph> {
  static GlobalKey previewContainer = new GlobalKey();

//  ############# see this #############################33

  List<LocationData> lines = ([
    new LocationData(location: ' ', count: 0),
  ]);
  List<charts.Series<LocationData, String>> series1 = [];
  _LocationGraph() {
    series1 = [
      charts.Series(
          id: "Count of Issues",
          data: lines,
          domainFn: (LocationData series, _) => series.location.toString(),
          measureFn: (LocationData series, _) => series.count,
          colorFn: (LocationData series, _) => series.barColor)
    ];
    _getSeriesData();
  }

//  ############# see this #############################33

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return Scaffold(
      appBar: _appBar(context),
      body: _graphPageBody(),
      backgroundColor: Styles.backgroundColorWhite,
      // floatingActionButton: FloatingActionButton(
      //   backgroundColor: Styles.backgroundColorBlue,
      //   onPressed: () {
      //     takeScreenShot();
      //   },
      //   child: Icon(Icons.save),
      // ),
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
        Image.asset(
          'assets/images/swipe.png',
          height: 4.0,
          color: Colors.white,
          scale: 5,
        ),
        // Icon(Icons.add),
      ],
    );
  }

  Widget _graphPageBody() {
    return SingleChildScrollView(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        _mainGraph(MediaQuery.of(context).size.height * 0.825),
      ],
    ));
  }

  // https://medium.com/flutter-community/flutter-charts-and-graphs-demystified-72b1282e6882
  Widget _mainGraph(double height) {
    return RepaintBoundary(
        key: previewContainer,
        child: Container(
          height: height,
          padding: EdgeInsets.all(20),
          child: _card(),
        ));
  }

  Widget _card() {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      color: Styles.backgroundColorWhite,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            Text("Number of Issues Logged Per Location",
                style: Styles.headerDefault, textAlign: TextAlign.center),
            SizedBox(height: 25),
            Expanded(
              child: charts.BarChart(
                series1,
                animate: true,
                domainAxis: charts.OrdinalAxisSpec(
                    renderSpec:
                        charts.SmallTickRendererSpec(labelRotation: 60)),
                behaviors: [
                  // Adding this behavior will allow tapping a bar to center it in the viewport
                  charts.SlidingViewport(
                    charts.SelectionModelType.action,
                  ),
                  charts.PanBehavior(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

// https://medium.com/flutter-community/flutter-charts-and-graphs-demystified-72b1282e6882
  _getSeriesData() async {
    var listt = await TempData2.FetchAny();
    print("here1");
    // print(int.parse(x[0]));
    print(listt);
    print("here2");
    List<LocationData> temp = [];
    setState(() {
      _loading(context);
      Future.delayed(const Duration(seconds: 2), () {
        Navigator.pop(
          context,
        );
      });
      for (int i = 0; i < listt.length; i++) {
        temp.add(
            LocationData(location: listt[i][0], count: int.parse(listt[i][1])));
      }
      this.lines = temp;
      this.series1 = [
        charts.Series(
            id: "Count of Issues",
            data: this.lines,
            domainFn: (LocationData series, _) => series.location.toString(),
            measureFn: (LocationData series, _) => series.count,
            colorFn: (LocationData series, _) => series.barColor)
      ];
    });
  }

  //https://stackoverflow.com/questions/51117958/how-to-take-a-screenshot-of-the-current-widget-flutter
  takeScreenShot() async {
    RenderRepaintBoundary boundary =
        previewContainer.currentContext.findRenderObject();
    ui.Image image = await boundary.toImage();
    final directory = (await getApplicationDocumentsDirectory()).path;
    ByteData byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    Uint8List pngBytes = byteData.buffer.asUint8List();
    print(directory);
    File imgFile = new File('$directory/screenshot_location_issues.png');
    imgFile.writeAsBytes(pngBytes);
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
