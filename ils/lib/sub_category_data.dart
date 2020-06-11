//https://medium.com/flutter-community/flutter-charts-and-graphs-demystified-72b1282e6882
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'services.dart';
import 'styles.dart';

class SubCategoryData {
  final String subcategory;
  final int count;
  charts.Color barColor = charts.ColorUtil.fromDartColor(Styles.backgroundColorBlue);
  SubCategoryData(this.subcategory, this.count);
}

final data = [
    new SubCategoryData('Computer', 150),
    new SubCategoryData('Zoom', 150),
    new SubCategoryData('Sound', 150),
    new SubCategoryData('API', 150),
 ];


