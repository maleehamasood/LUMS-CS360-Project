import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'styles.dart';
import 'issue_count_data.dart';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'area_graph.dart';
import 'category_graph.dart';
import 'sub_catergory_graph.dart';
import 'location_graph.dart';

class GraphPage extends StatefulWidget {
  @override
  _GraphPage createState() {
    return _GraphPage();
  }
}

class _GraphPage extends State<GraphPage> {
  static GlobalKey previewContainer = new GlobalKey();

  final options = ['Area', 'Category', 'Sub-Category', 'Location'];
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return Scaffold(
      appBar: _appBar(),
      body: _graphPageBody(),
      backgroundColor: Styles.backgroundColorWhite,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Styles.backgroundColorBlue,
        onPressed: () {
          takeScreenShot();
        },
        child: Icon(Icons.save),
      ),
    );
  }

  Widget _appBar() {
    return new AppBar(
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
    );
  }

  Widget _graphPageBody() {
    return SingleChildScrollView(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        _mainGraph(MediaQuery.of(context).size.height * 0.7),
        SizedBox(height: 4.0),
        Text(
          " More graphs of number of issues per:",
          style: Styles.textDefault,
        ),
        SizedBox(height: 20.0),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Expanded(
              child: SizedBox(
                height: 36.0,
                child: new ListView.builder(
                  padding: const EdgeInsets.only(right: 10.0),
                  scrollDirection: Axis.horizontal,
                  itemCount: 4,
                  itemBuilder: (BuildContext ctxt, int index) {
                    return Row(children: [
                      Text(" "),
                      _button(options[index]),
                      Text(" ")
                    ]);
                  },
                ),
              ),
            ),
          ],
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
        ),
        SizedBox(height: 12.0),
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
      color: Styles.backgroundColorWhite,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            Text("Total Number of Issues Logged", style: Styles.headerDefault),
            SizedBox(height: 25),
            Expanded(
              child: charts.BarChart(
                _getSeriesData(),
                animate: true,
                domainAxis: charts.OrdinalAxisSpec(
                    renderSpec:
                        charts.SmallTickRendererSpec(labelRotation: 60),
                        viewport: new charts.OrdinalViewport('', 12),),
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
  _getSeriesData() {
    List<charts.Series<IssueCountData, String>> series = [
      charts.Series(
          id: "Count of Issues",
          data: data,
          domainFn: (IssueCountData series, _) => series.month.toString(),
          measureFn: (IssueCountData series, _) => series.count,
          colorFn: (IssueCountData series, _) => series.barColor)
    ];
    return series;
  }

  Widget _button(String text) {
    return Container(
        alignment: Alignment.center,
        padding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 0.0),
        width: 135.0,
        height: 36.0,
        decoration: BoxDecoration(
          color: Styles.backgroundColorBlue,
          borderRadius: BorderRadius.all(Radius.circular(15)),
        ),
        child: Container(
            width: 120.0,
            height: 36.0,
            child: FlatButton(
              child: Text(
                text,
                style: Styles.buttonText,
                textAlign: TextAlign.center,
              ),
              onPressed: () {
                toNewScreen(context, text);
              },
            )));
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
    File imgFile = new File('$directory/screenshot_total_issues.png');
    imgFile.writeAsBytes(pngBytes);
  }

  void toNewScreen(BuildContext context, String text) {
    if (text == options[0]) {
      //Navigate to Log an issue Screen
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => AreaGraph()),
      );
    } else if (text == options[1]) {
      //Navigate to View all issues Screen
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => CategoryGraph()),
      );
    } else if (text == options[2]) {
      //Navigate to Check status of issues Screen
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => SubCategoryGraph()),
      );
    } else if (text == options[3]) {
      //navigate to specific menu screen
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => LocationGraph()),
      );
    } else {
      print("Error in role");
      return;
    }
  }
}