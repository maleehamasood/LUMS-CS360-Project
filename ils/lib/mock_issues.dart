import 'package:flutter/cupertino.dart';
import 'services.dart';

class Issue{
  dynamic Issue_no;
  String Issue_ID;
  String Current_Status;
  String Issue_Logged_Timestamp;
  Issue({this.Issue_no,this.Issue_ID,this.Current_Status,this.Issue_Logged_Timestamp});
  factory Issue.fromJson(Map<String, dynamic> json){
    return Issue(
      Issue_no: json['Issue_ID'],
      Issue_ID: json["Description1"],
      Current_Status: json["Current_Status"],
      Issue_Logged_Timestamp: json["Issue_Logged_Timestamp"],
    );
  }
}