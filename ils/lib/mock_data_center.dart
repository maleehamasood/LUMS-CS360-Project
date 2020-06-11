import 'package:flutter/material.dart';
import 'services.dart';

//IssueLog is a class which contains all the relevant fields which will be
// displayed and updated on the Log an Issue Screen. It contains the Lists
// and variables for the location, area, category, sub-category, brief and
// detailed description and in case the user is logging an issue on someone
// else's behalf, then it contains the relevant person's details
class IssueLog {
  String locationSelected;
  String areaSelected;
  String categorySelected;
  String subCategorySelected;
  String briefDescription;
  String detailDescription;
  bool logOnBehalf;
  String nameOfInitiator;
  String idOfInitiator;
  List<String> area;
  List<String> category;
  List<String> subCategory;
  List<String> location;

//  This is the constructor for the IssueLog class which is called when the
//  instance of the IssueLog class is created. In this function, all the
//  variables of the class are initiated and set to default values
  IssueLog() {
    this.locationSelected = "Select Branch";
    this.areaSelected = "Select Area";
    this.categorySelected = "Select Category";
    this.subCategorySelected = "Select Sub-Category";
    this.briefDescription =  "Describe Issue Briefly(max 50 Charecters)";
    this.detailDescription = "Details of Issue";
    this.logOnBehalf = false;
    this.nameOfInitiator = "Malik Ali Hussain";
    this.idOfInitiator = "123456";
    this.area = ["Select Area"];
    this.category = ["Select Category"];
    this.subCategory = ["Select Sub-Category"];
    this.location = ['Select Branch'];
    _getAllLocations();
    _getAllArea();
    print(this.location);




  }
  String _descTrim(String description) {
    //This functions returns a string of the Issue description to be viewed on the screen,
    //it takes as an argument the whole description and trims it to fit according to the screen size.
    if (description.length >= 38) {
      return description.substring(0, 36) + "..";
    } else {
      return description;
    }
  }

  // This function queries the database and fetch all the branch locations
  void _getAllLocations() {
    AppServices.getLocation().then((allLocationsEver) {

      //      print("hello plzzzz ${MediaQuery.of(context).size.width}");
//      int trim_length =  (((MediaQuery.of(context).size.width)/10)-5).toInt();
      for(int i = 0; i< allLocationsEver.length;i++)
        {
          allLocationsEver[i] = _descTrim(allLocationsEver[i]);
        }
      this.location = this.location + allLocationsEver;
    });
  }
  // This function queries the database and fetch all the areas
  void _getAllArea() {
    AppServices.getArea().then((allAreassEver) {
      this.area = this.area + allAreassEver;
    });
  }
  // This function queries the database and fetch all the categories in the area
  // It takes the area as the parameter
  void getAllCategories(String area) {
    AppServices.getCategory(area).then((allCategoriesEver) {
      this.category = this.category + allCategoriesEver;
    });
  }
  // This function queries the database and fetch all the sub categories
  // in the given area and its category. It takes area and category as parameters
  void getAllSubCategories(String area,String category) {
    AppServices.getSubCategory(area,category).then((allCategoriesEver) {
      this.subCategory = this.subCategory + allCategoriesEver;
    });
  }
// This function posts the issue in the database.
//   It takes issueLoggedBy,  location,  area,  category,  subCategory,
//   brief description, detail description as parameters.
  void postIssue(String issueLoggedBy, String location, String area, String category, String subCategory, String description1,String description2) {
    AppServices.addIssue( issueLoggedBy,  location,  area,  category,  subCategory,  description1, description2).then((result) {
    });
  }
//This function takes in the username entered in the log on behalf popup dialog box
//  and validates it from the database
  bool checkEmpID(String un) {
    bool flag;
    AppServices.valEmployeeId(un).then((result){
      if(result == 'success')
      {flag = false;}
      else {flag = true;}
    });
    return flag;
  }
}
