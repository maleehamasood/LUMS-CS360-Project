import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'styles.dart';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'sub_category_data.dart';

class SubCategoryGraph extends StatefulWidget {
  @override
  _SubCategoryGraph createState() {
    return _SubCategoryGraph();
  }
}

class _SubCategoryGraph extends State<SubCategoryGraph> {
  static GlobalKey previewContainer = new GlobalKey();

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
      color: Styles.backgroundColorWhite,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            Text("Number of Issues Logged Per Sub-Category",
                style: Styles.headerDefault, textAlign: TextAlign.center),
            SizedBox(height: 25),
            Expanded(
              child: charts.BarChart(
                _getSeriesData(),
                animate: true,
                domainAxis: charts.OrdinalAxisSpec(
                    renderSpec:
                        charts.SmallTickRendererSpec(labelRotation: 60)),
              ),
            ),
          ],
        ),
      ),
    );
  }

// https://medium.com/flutter-community/flutter-charts-and-graphs-demystified-72b1282e6882
  _getSeriesData() {
    List<charts.Series<SubCategoryData, String>> series = [
      charts.Series(
          id: "Count of Issues",
          data: data,
          domainFn: (SubCategoryData series, _) =>
              series.subcategory.toString(),
          measureFn: (SubCategoryData series, _) => series.count,
          colorFn: (SubCategoryData series, _) => series.barColor)
    ];
    return series;
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
    File imgFile = new File('$directory/screenshot_sub_category_issues.png');
    imgFile.writeAsBytes(pngBytes);
  }
}
