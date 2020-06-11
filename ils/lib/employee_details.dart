import 'services.dart';
import 'package:flutter/material.dart';

class EmployeeMainInfo {
  //this a summarised class of employees to display a condensed summary of an employee

  String employeeID;
  String employeeName;
  String employeeRole;

  EmployeeMainInfo({this.employeeID, this.employeeName, this.employeeRole});
}

class Employee {
  // this is a detailed class of employees that gives all the attributes of an
  // employee needed as per the function being carried out
  String employeeID;
  String employeeName;
  String employeeRole;
  String employeeTeam;
  String employeeArea;
  String employeeCategory;
  String employeeSubCategory;

  Employee(
      {this.employeeID,
        this.employeeName,
        this.employeeRole,
        this.employeeTeam,
        this.employeeArea,
        this.employeeCategory,
        this.employeeSubCategory});
}

class MockEmployeeDetailed extends Employee {
  static Employee FetchAny() {
    //this function fetches the employee detail class and displays loading while the data is loading.
    return Employee(
        employeeID: 'Loading...',
        employeeName: 'Loading...',
        employeeRole: 'Loading...',
        employeeTeam: 'Loading...',
        employeeArea: 'Loading...',
        employeeCategory: 'Loading...',
        employeeSubCategory: 'Loading...');
  }
}

class MockEmployee extends EmployeeMainInfo {
  //this function fetches the employee summary class and displays loading while the data is loading.
  static List<EmployeeMainInfo> FetchAny() {
    return <EmployeeMainInfo>[
      EmployeeMainInfo(
        employeeID: 'Loading...',
        employeeName: '    Loading...',
        employeeRole: 'Loading...',
      ),
      EmployeeMainInfo(
        employeeID: 'Loading...',
        employeeName: '    Loading...',
        employeeRole: 'Loading...',
      ),
      EmployeeMainInfo(
        employeeID: 'Loading...',
        employeeName: '    Loading...',
        employeeRole: 'Loading...',
      ),
      EmployeeMainInfo(
        employeeID: 'Loading...',
        employeeName: '    Loading...',
        employeeRole: 'Loading...',
      ),
      EmployeeMainInfo(
        employeeID: 'Loading...',
        employeeName: '    Loading...',
        employeeRole: 'Loading...',
      ),
      EmployeeMainInfo(
        employeeID: 'Loading...',
        employeeName: '    Loading...',
        employeeRole: 'Loading...',
      ),
      EmployeeMainInfo(
        employeeID: 'Loading...',
        employeeName: '    Loading...',
        employeeRole: 'Loading...',
      ),
      EmployeeMainInfo(
        employeeID: 'Loading...',
        employeeName: '    Loading...',
        employeeRole: 'Loading...',
      ),
    ];
  }
}