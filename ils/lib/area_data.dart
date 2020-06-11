//https://medium.com/flutter-community/flutter-charts-and-graphs-demystified-72b1282e6882
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'services.dart';
import 'styles.dart';

class AreaData {
  final String area;
  final int count;
  charts.Color barColor = charts.ColorUtil.fromDartColor(Styles.backgroundColorBlue);
  AreaData({this.area, this.count});
}

class TempData1 extends AreaData {
  static Future<List<String>> FetchAny()async {
    var count1 = await AppServices.getCount('Area','IT-Support');
    return [count1];
  }
}
 