//https://medium.com/flutter-community/flutter-charts-and-graphs-demystified-72b1282e6882
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'services.dart';
import 'styles.dart';

class IssueCountData {
  final String month;
  final int count;
  charts.Color barColor = charts.ColorUtil.fromDartColor(Styles.backgroundColorBlue);
  IssueCountData(this.month, this.count);
}

final data = [
    new IssueCountData('Jan', 150),
    new IssueCountData('Feb', 173),
    new IssueCountData('Mar', 167),
    new IssueCountData('Apr', 189),
    new IssueCountData('May', 190),
    new IssueCountData('Jun', 230),
    new IssueCountData('Jul', 236),
    new IssueCountData('Aug', 198),
    new IssueCountData('Sep', 265),
    new IssueCountData('Oct', 278),
    new IssueCountData('Nov', 302),
    new IssueCountData('Dec', 324),
    new IssueCountData('Jan1', 150),
    new IssueCountData('Feb1', 173),
    new IssueCountData('Mar1', 167),
    new IssueCountData('Apr1', 189),
    new IssueCountData('May1', 190),
    new IssueCountData('Jun1', 230),
    new IssueCountData('Jul1', 236),
    new IssueCountData('Aug1', 198),
    new IssueCountData('Sep1', 265),
    new IssueCountData('Oct1', 278),
    new IssueCountData('Nov1', 302),
    new IssueCountData('Dec1', 324),
    new IssueCountData('Jan2', 150),
    new IssueCountData('Feb2', 173),
    new IssueCountData('Mar2', 167),
    new IssueCountData('Apr2', 189),
    new IssueCountData('May2', 190),
    new IssueCountData('Jun2', 230),
    new IssueCountData('Jul2', 236),
    new IssueCountData('Aug2', 198),
    new IssueCountData('Sep2', 265),
    new IssueCountData('Oct2', 278),
    new IssueCountData('Nov2', 302),
    new IssueCountData('Dec2', 324),
 ];


