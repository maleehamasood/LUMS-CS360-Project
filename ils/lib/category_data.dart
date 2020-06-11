//https://medium.com/flutter-community/flutter-charts-and-graphs-demystified-72b1282e6882
import 'package:charts_flutter/flutter.dart' as charts;
import 'services.dart';
import 'styles.dart';

class CategoryData {
  final String category;
  final int count;
  charts.Color barColor = charts.ColorUtil.fromDartColor(Styles.backgroundColorBlue);
  CategoryData({this.category, this.count});
}



//  ############# see this #############################33
class TempData extends CategoryData {
  static Future<List<String>> FetchAny()async {
    var count1 = await AppServices.getCount('Category',"Hardware");
    var count2 = await AppServices.getCount('Category','Software');
    var count3 = await AppServices.getCount('Category',"Communication");
    var count4 = await AppServices.getCount('Category',"General");
    return [count1,count2,count3,count4];
  }
}

//  ############# see this #############################33