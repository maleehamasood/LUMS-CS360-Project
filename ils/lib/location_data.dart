//https://medium.com/flutter-community/flutter-charts-and-graphs-demystified-72b1282e6882
import 'package:charts_flutter/flutter.dart' as charts;
import 'services.dart';
import 'styles.dart';

class LocationData {
  final String location;
  final int count;
  charts.Color barColor = charts.ColorUtil.fromDartColor(Styles.backgroundColorBlue);
  LocationData({this.location, this.count});
}

class TempData2 extends LocationData {
  static Future< List<dynamic>> FetchAny()async {
    var listt = await AppServices.getBranches();
    print(listt);
    var final_list = [];
    for(int i = 0;i<listt.length;i++)
    {
      var count1 = await AppServices.getCount('Branch_ID',listt[i].toString());
      final_list.add([listt[i],count1]);
    }
return final_list;
  }
}


