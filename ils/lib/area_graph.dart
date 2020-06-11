import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'styles.dart';
import 'area_data.dart';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'info_graph.dart';

class AreaGraph extends StatefulWidget {
  @override
  _AreaGraph createState() {
    return _AreaGraph();
  }
}

class _AreaGraph extends State<AreaGraph> {
  static GlobalKey previewContainer = new GlobalKey();

  //  ############# see this #############################33

  List<AreaData> lines = ([
    new AreaData(area: 'IT-Supprt', count: 0),
  ]);
  List<charts.Series<AreaData, String>> series1 = [];
  _AreaGraph() {
    print("HIIIIIII");
    series1 = [
      charts.Series(
          id: "Count of Issues",
          data: lines,
          domainFn: (AreaData series, _) => series.area.toString(),
          measureFn: (AreaData series, _) => series.count,
          colorFn: (AreaData series, _) => series.barColor)
    ];
    _getSeriesData1();
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
        Padding(
            padding: EdgeInsets.only(right: 10, top: 5),
            child: IconButton(
                icon: new Icon(Icons.info_outline),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Info()),
                  );
                }))
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
            Text(
              "Number of Issues Logged Per Area",
              style: Styles.headerDefault,
              textAlign: TextAlign.center,
            ),
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
  _getSeriesData1() async {
    var x = await TempData1.FetchAny();
    print("here1");
    print(int.parse(x[0]));
    print(x);
    print("here2");
    setState(() {
      _loading(context);
      Future.delayed(const Duration(seconds: 2), () {
        Navigator.pop(
          context,
        );
      });
      this.lines = ([
        new AreaData(area: 'IT-Support', count: int.parse(x[0])),
      ]);
      this.series1 = [
        charts.Series(
            id: "Count of Issues",
            data: this.lines,
            domainFn: (AreaData series, _) => series.area.toString(),
            measureFn: (AreaData series, _) => series.count,
            colorFn: (AreaData series, _) => series.barColor)
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
    File imgFile = new File('$directory/screenshot_area_issues.png');
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
