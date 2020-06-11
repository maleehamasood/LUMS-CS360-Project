import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:ils/mock_issues.dart';
import 'employee_details.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart'; //For creating the SMTP Server

// This class is responsible for all the services that the ILS application will be using
// Functions in this class execule relevent CRUD operations on the cloud clearDB databse via php API file.
// Email services set up used by the applications is also executed in this class.

class AppServices {
  // _ROOT links to our hosted php API file
  static const ROOT = 'https://ilslumsapp.000webhostapp.com';

  // This function adds Issue to Issues table
  static Future<String> addIssue(
      String issueLoggedBy,
      String location,
      String area,
      String category,
      String subCategory,
      String description1,
      String description2) async {
    try {
      var map = Map<String, dynamic>();
      map['action'] = 'LOG_ISSUE';
      map['Issue_logged_by'] = issueLoggedBy;
      map['Location'] = location;
      map['Area'] = area;
      map['Category'] = category;
      map['Sub_Category'] = subCategory;
      map['Description1'] = description1;
      map['Description2'] = description2;
      final response = await http.post(ROOT, body: map);
      if (200 == response.statusCode) {
        // sends mails to relevant support team when issues is logged
        sendMailUponAddingIssue(issueLoggedBy, location, area, category,
            subCategory, description1, description2);
        return response.body;
      } else {
        return "error";
      }
    } catch (e) {
      return "Failure";
    }
  }

  // This function sends Mails to the relevant list
  // https://medium.com/@achinthaisuru444/sending-emails-using-flutter-f588387280db
  static Future<void> _sendMails(String selfemail, List<String> cclist,
      String finalString, String subject) async {
    String username = "noreply.ils.lums@gmail.com"; //Your Email;
    String password = "flutterapp"; //Your Email's password;

    final smtpServer = gmail(username, password);
    // Creating the Gmail server

    // Create our email message.
    final message = Message()
      ..from = Address(username)
      ..recipients.add(selfemail) //recipent email
      ..ccRecipients.addAll(cclist) //cc Recipents emails
      ..subject = subject //subject of the email
      ..text = finalString; //body of the email

    try {
      final sendReport = await send(message, smtpServer);
    } on MailerException catch (e) {
      // e.toString() will show why the email is not sending
    }
  }

  // This function sends Mails to the relevant support team members when an issue related to their expertise is posted
  static Future<void> sendMailUponAddingIssue(
      String empID,
      String bID,
      String area,
      String category,
      String subCategory,
      String description1,
      String description2) async {
    var temp = await getEmail(empID);
    var temp1 = temp[0];
    String recipient = temp1;
    var time = DateTime.now();
    String IssueLoggedSucc =
        "Dear User,\nA new issue has been logged by ${empID} on ${time} with the following details:\nArea: ${area}\nCategory: ${category}\nSub-category: ${subCategory}\nBrief Description: ${description1}\nDetailed Description: ${description2}\nThank you for using the ILS app!\nLog on to the ILS app for further actions and details";
    String IssueLoggedSuccSub = "New Issue Logged";
    List<String> ccList = [];
    var tempCC = await getInCityEmail(bID);
    for (int i = 0; i < tempCC.length; i++) {
      ccList.add(tempCC[i]);
    }
    // sending mails
    _sendMails(recipient, ccList, IssueLoggedSucc, IssueLoggedSuccSub);
  }

  // This function validates username and password at login screen
  static Future<String> valEmployee(String un, String pw) async {
    try {
      var map = Map<String, dynamic>();
      map['action'] = 'VALIDATE_EMP';
      map['Employee_ID'] = un;
      map['Password'] = pw;
      final response = await http.post(ROOT, body: map);
      if (200 == response.statusCode) {
        return response.body;
      } else {
        return "error1";
      }
    } catch (e) {
      return "Failure";
    }
  }

  // This function validates username and employee_ID field while logging an issue on behalf of employee
  static Future<String> valEmployeeId(String un) async {
    try {
      var map = Map<String, dynamic>();
      map['action'] = 'VALIDATE_EMP_ID';
      map['Employee_ID'] = un;
      final response = await http.post(ROOT, body: map);
      if (200 == response.statusCode) {
        return response.body;
      } else {
        return "error1";
      }
    } catch (e) {
      return "Failure";
    }
  }

  // This function parses data to json list
  static List<Issue> parseResponse(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    List<Issue> mylist =
        parsed.map<Issue>((json) => Issue.fromJson(json)).toList();
    return mylist;
  }

  // This function returns a list of all issues from issue table
  static Future<List<Issue>> getIssues() async {
    try {
      var map = Map<String, dynamic>();
      map['action'] = '_GET_ALL_ISSUES';
      final response = await http.post(ROOT, body: map);
      if (200 == response.statusCode) {
        List<Issue> list = parseResponse(response.body);
        return list;
      } else {
        return List<Issue>();
      }
    } catch (e) {
      return List<Issue>(); // return an empty list on exception/error
    }
  }

  // This function returns a list of issues logged by employee itself
  static Future<List<Issue>> getIssuesByEmp(String un) async {
    try {
      var map = Map<String, dynamic>();
      map['action'] = '_GET_ALL_ISSUES_BY_EMP';
      map['Employee_ID'] = un;
      final response = await http.post(ROOT, body: map);
      if (200 == response.statusCode) {
        List<Issue> list = parseResponse(response.body);
        return list;
      } else {
        return List<Issue>();
      }
    } catch (e) {
      return List<Issue>(); // return an empty list on exception/error
    }
  }

  // This function return issues of team to the manager
  static Future<List<Issue>> getIssuesByTeam(String un) async {
    try {
      var map = Map<String, dynamic>();
      map['action'] = '_GET_ALL_ISSUES_BY_MANAGERS_TEAM';
      map['Employee_ID'] = un;
      final response = await http.post(ROOT, body: map);
      if (200 == response.statusCode) {
        List<Issue> list = parseResponse(response.body);
        return list;
      } else {
        return List<Issue>();
      }
    } catch (e) {
      return List<Issue>(); // return an empty list on exception/error
    }
  }

  // This function return issues taken by an individual support team member
  static Future<List<Issue>> getYourTakenIssues(String un) async {
    try {
      var map = Map<String, dynamic>();
      map['action'] = '_GET_YOUR_TAKEN_ISSUES';
      map['Employee_ID'] = un;
      final response = await http.post(ROOT, body: map);
      if (200 == response.statusCode) {
        List<Issue> list = parseResponse(response.body);
        return list;
      } else {
        return List<Issue>();
      }
    } catch (e) {
      return List<Issue>(); // return an empty list on exception/error
    }
  }

  // This function returns issues reported within City
  static Future<List<Issue>> getAllInCItyIssues(String un) async {
    try {
      var map = Map<String, dynamic>();
      map['action'] = '_GET_ALL_INCITY_ISSUES';
      map['Employee_ID'] = un;
      final response = await http.post(ROOT, body: map);
      if (200 == response.statusCode) {
        List<Issue> list = parseResponse(response.body);
        return list;
      } else {
        return List<Issue>();
      }
    } catch (e) {
      return List<Issue>(); // return an empty list on exception/error
    }
  }

  // This function updates current status of issue logged
  static Future<String> updateStatus(String issueID, String newStatus) async {
    try {
      var map = Map<String, dynamic>();
      map['action'] = 'UPDATE_STATUS';
      map['Issue_ID'] = issueID;
      map['new_status'] = newStatus;
      final response = await http.post(ROOT, body: map);
      if (200 == response.statusCode) {
        if (newStatus == 'Fixed') {
          _sendFixUpdate(issueID);
        }
        if (newStatus == 'Closed') {
          _sendClosedUpdate(issueID);
        }
        return response.body;
      } else {
        return "error1";
      }
    } catch (e) {
      return "Failure";
    }
  }

  // This functions sends email to initiator when issue is fixed
  static Future<void> _sendFixUpdate(String iID) async {
    var result = await getIssuesByID(iID);
    var list1 = json.decode(result);
    String supportMemberID = list1[0]['Issue_Taken_By'];
    String empID = list1[0]['Issue_logged_by'];
    String area = list1[0]['Area'];
    String category = list1[0]['Category'];
    String subCategory = list1[0]['Sub_Category'];
    String description1 = list1[0]['Description1'];
    String description2 = list1[0]['Description2'];
    var temp = await getEmail(empID);
    var temp1 = temp[0];
    String recipient = temp1;
    var time = DateTime.now();
    String MarkedAsFixed =
        "Dear user,\nThe issue you logged in with the details stated below has been marked as fixed by the support staff member ${supportMemberID}.\nPlease mark it as closed or open as per your satisfaction.\nArea: ${area}\nCategory: ${category}\nSub-category: ${subCategory}\nBrief Description: ${description1}\nDetailed Description: ${description2}\nThank you for using the ILS app!\nLog on to the ILS app for further actions and details";
    String MarkedAsFixedSub = "Marked as Fixed";
    List<String> ccList = [];
    // sending emails
    _sendMails(recipient, ccList, MarkedAsFixed, MarkedAsFixedSub);
  }

  // This functions sends email to to the relevent in city support team members when issue is marked as open,
  static Future<void> sendOpenUpdate(String iID) async {
    var result = await getIssuesByID(iID);
    var list1 = json.decode(result);
    String empID = list1[0]['Issue_logged_by'];
    String bID = list1[0]['Branch_ID'];
    String area = list1[0]['Area'];
    String category = list1[0]['Category'];
    String subCategory = list1[0]['Sub_Category'];
    String description1 = list1[0]['Description1'];
    String description2 = list1[0]['Description2'];
    var temp = await getEmail(empID);
    var temp1 = temp[0];
    String recipient = temp1;
    var time = DateTime.now();
    String MarkedAsOpen =
        "Dear user,\nThe issue logged by ${empID} has been marked as open with the following details: \nArea: ${area}\nCategory: ${category}\nSub-category: ${subCategory}\nBrief Description: ${description1}\nDetailed Description: ${description2}\nThank you for using the ILS app!\nLog on to the ILS app for further actions and details";
    String MarkedAsOpenSub = "Marked as Open";
    List<String> ccList = [];
    var tempCC = await getInCityEmail(bID);
    for (int i = 0; i < tempCC.length; i++) {
      ccList.add(tempCC[i]);
    }
    _sendMails(recipient, ccList, MarkedAsOpen, MarkedAsOpenSub);
  }

  // This functions sends email to support team member who fixed the issue when issue is fixed but then re-opened by initiator
  static Future<void> sendUnsatisfiedEmail(String iID) async {
    var result = await getIssuesByID(iID);
    var list1 = json.decode(result);
    String supportMemberID = list1[0]['Issue_Taken_By'];
    String empID = list1[0]['Issue_logged_by'];
    String bID = list1[0]['Branch_ID'];
    String area = list1[0]['Area'];
    String category = list1[0]['Category'];
    String subCategory = list1[0]['Sub_Category'];
    String description1 = list1[0]['Description1'];
    String description2 = list1[0]['Description2'];
    var temp = await getEmail(supportMemberID);
    var temp1 = temp[0];
    var employee_mail = await getEmail(empID);
    var cc = employee_mail[0];
    String recipient = temp1;
    var time = DateTime.now();
    String SolvedIssueMarkedAsOpen =
        "Dear user,\nThe issue that was ‘Marked as Fixed’ with the details stated below has been  re-opened by the initiator ${empID}.\nThe initiator is not satisfied with the resolution of the issue.\nArea: ${area}\nCategory: ${category}\nSub-category: ${subCategory}\nBrief Description: ${description1}\nDetailed Description: ${description2}\nThank you for using the ILS app!\nLog on to the ILS app for further actions and details";
    String MarkedAsOpenSub = "Marked as Open";
    String SolvedIssueMarkedAsOpenSub = "Marked as Open";
    List<String> ccList = [cc];
    _sendMails(
        recipient, ccList, SolvedIssueMarkedAsOpen, SolvedIssueMarkedAsOpenSub);
  }

  // This functions send email when issue is fixed but then re-opened by initiator to support team member who fixed the issue
  static Future<void> _sendClosedUpdate(String iID) async {
    var result = await getIssuesByID(iID);
    var list1 = json.decode(result);
    String supportMemberID = list1[0]['Issue_Taken_By'];
    String empID = list1[0]['Issue_logged_by'];
    // this._issueLocation = list1[0]['Branch_ID'];
    String area = list1[0]['Area'];
    String category = list1[0]['Category'];
    String subCategory = list1[0]['Sub_Category'];
    String description1 = list1[0]['Description1'];
    String description2 = list1[0]['Description2'];
    var temp = await getEmail(empID);
    var temp1 = temp[0];
    var tempSup = await getEmail(supportMemberID);
    var cc = tempSup[0];
    String recipient = temp1;
    var time = DateTime.now();
    String MarkedAsClosed =
        "Dear user,\nThe issue which was ‘marked as fixed’ with the details stated below has been 'marked as closed' by the initiator ${empID}.\nArea: ${area}\nCategory: ${category}\nSub-category: ${subCategory}\nBrief Description: ${description1}\nDetailed Description: ${description2}\nThank you for using the ILS app!\nLog on to the ILS app for further actions and details";
    String MarkedAsClosedSub = "Marked as Closed";
    List<String> ccList = [cc];
    _sendMails(recipient, ccList, MarkedAsClosed, MarkedAsClosedSub);
  }

  // This function returns list of all Locations for the log_an_issue form dropdown
  static Future<List<String>> getLocation() async {
    try {
      var map = Map<String, dynamic>();
      map['action'] = '_GET_ALL_LOCATIONS';
      final response = await http.post(ROOT, body: map);
      var list = json.decode(response.body);
      List<String> l1 = new List(list.length);
      for (var i = 0; i < list.length; i++) {
        var temp = list[i];
        l1[i] =
            temp['Branch_ID'] + ' - ' + temp['Address'] + ', ' + temp['city'];
      }
      return l1;
    } catch (e) {
      return List<String>(); // return an empty list on exception/error
    }
  }

  // This function returns list of all Locations for the log_an_issue form dropdown
  static Future<List<String>> getBranches() async {
    try {
      var map = Map<String, dynamic>();
      map['action'] = '_GET_ALL_BRANCH';
      final response = await http.post(ROOT, body: map);
      var list = json.decode(response.body);
      List<String> l1 = new List(list.length);
      for (var i = 0; i < list.length; i++) {
        var temp = list[i];
        l1[i] = temp['Branch_ID'];
      }
      return l1;
    } catch (e) {
      return List<String>(); // return an empty list on exception/error
    }
  }

  // This function returns list of all Areas of interest for the log_an_issue form dropdown
  static Future<List<String>> getArea() async {
    try {
      var map = Map<String, dynamic>();
      map['action'] = '_GET_ALL_AREA';
      final response = await http.post(ROOT, body: map);
      var list1 = json.decode(response.body);
      List<String> l1 = new List(list1.length);
      for (var i = 0; i < list1.length; i++) {
        var temp = list1[i];
        l1[i] = temp['Area'];
      }
      return l1;
    } catch (e) {
      return List<String>(); // return an empty list on exception/error
    }
  }

  // This function returns list of all Categories w.r.t Area for the log_an_issue form dropdown
  static Future<List<String>> getCategory(String area) async {
    try {
      var map = Map<String, dynamic>();
      map['action'] = '_GET_ALL_CATEGORY';
      map['Area'] = area;
      final response = await http.post(ROOT, body: map);
      var list2 = json.decode(response.body);
      List<String> l1 = new List(list2.length);
      for (var i = 0; i < list2.length; i++) {
        var temp = list2[i];
        l1[i] = temp['Category'];
      }
      return l1;
    } catch (e) {
      return List<String>(); // return an empty list on exception/error
    }
  }

  // This function returns list of all Sub_Categories w.r.t Area and Category for the log_an_issue form dropdown
  static Future<List<String>> getSubCategory(
      String area, String category) async {
    try {
      var map = Map<String, dynamic>();
      map['action'] = '_GET_ALL_SUBCATEGORY';
      map['Area'] = area;
      map['Category'] = category;
      final response = await http.post(ROOT, body: map);
      var list1 = json.decode(response.body);
      List<String> l1 = new List(list1.length);
      for (var i = 0; i < list1.length; i++) {
        var temp = list1[i];
        l1[i] = temp['Sub_Category'];
      }
      return l1;
    } catch (e) {
      return List<String>(); // return an empty list on exception/error
    }
  }

  // This function returns first name assigned to employee_id
  static Future<String> getName(String empID) async {
    try {
      var map1 = Map<String, dynamic>();
      map1['action'] = 'GET_NAME';
      map1['Employee_ID'] = empID;
      final response = await http.post(ROOT, body: map1);
      var list1 = json.decode(response.body);
      var tempStr = list1[0];
      String val = tempStr['Name'];
      var _index = val.indexOf(' ');
      String valFinal = val.substring(0, _index);
      return valFinal;
    } catch (e) {
      return ''; // return an empty list on exception/error
    }
  }

  // This function returns name assigned to employee_id
  static Future<String> getName1(String empID) async {
    try {
      var map1 = Map<String, dynamic>();
      map1['action'] = 'GET_NAME';
      map1['Employee_ID'] = empID;
      final response = await http.post(ROOT, body: map1);
      var list1 = json.decode(response.body);
      var tempStr = list1[0];
      String val = tempStr['Name'];
      return val;
    } catch (e) {
      return ''; // return an empty list on exception/error
    }
  }

  // This function returns role assigned to employee_id
  static Future<String> getRole(String empID) async {
    try {
      var map1 = Map<String, dynamic>();
      map1['action'] = 'GET_ROLE';
      map1['Employee_ID'] = empID;
      final response = await http.post(ROOT, body: map1);
      var list1 = json.decode(response.body);
      var tempStr = list1[0];
      String val = tempStr['Role'];
      return val;
    } catch (e) {
      return ''; // return an empty list on exception/error
    }
  }

  // This function returns issue by issuee_id
  static Future<String> getIssuesByID(String issueID) async {
    try {
      var map1 = Map<String, dynamic>();
      map1['action'] = '_GET_ISSUE_BY_ISSUE_ID';
      map1['Issue_ID'] = issueID;
      final response = await http.post(ROOT, body: map1);
      var list1 = response.body;
      var tempStr = list1;
      return tempStr;
    } catch (e) {
      return ''; // return an empty list on exception/error
    }
  }

  // This function returns address by Branch_id
  static Future<String> getLocationByID(String bID) async {
    try {
      var map = Map<String, dynamic>();
      map['action'] = '_GET_ALL_LOCATIONS_BY_ID';
      map['Branch_ID'] = bID;
      final response = await http.post(ROOT, body: map);
      var list = json.decode(response.body);
      list = list[0]['Branch_ID'] +
          ' - ' +
          list[0]['Address'] +
          ', ' +
          list[0]['city'];
      return list.toString();
    } catch (e) {
      return ''; // return an empty list on exception/error
    }
  }

  // This function validates name assigned to employee_id
  static Future<String> valEmployeeName(String un, String name) async {
    try {
      var map = Map<String, dynamic>();
      map['action'] = 'VALIDATE_NAME_OF_EMP';
      map['Employee_ID'] = un;
      map['Name'] = name;
      final response = await http.post(ROOT, body: map);
      if (200 == response.statusCode) {
        return response.body;
      } else {
        return "error1";
      }
    } catch (e) {
      return "Failure";
    }
  }

  // This function updates role of employee_id
  static Future<String> updateRole(String empID, String role) async {
    try {
      var map = Map<String, dynamic>();
      map['action'] = 'UPDATE_ROLE';
      map['Employee_ID'] = empID;
      map['Role'] = role;
      final response = await http.post(ROOT, body: map);
      if (200 == response.statusCode) {
        return response.body;
      } else {
        return "error1";
      }
    } catch (e) {
      return "Failure";
    }
  }

  // This function updates team of employee_id
  static Future<String> updateTeam(String empID, String bID) async {
    try {
      var map = Map<String, dynamic>();
      map['action'] = 'UPDATE_TEAM';
      map['Employee_ID'] = empID;
      map['Branch_ID'] = bID;
      final response = await http.post(ROOT, body: map);
      if (200 == response.statusCode) {
        return response.body;
      } else {
        return "error1";
      }
    } catch (e) {
      return "Failure";
    }
  }

  // This function assigns issue to employee_id
  static Future<String> assignIssue(String empID, String iID) async {
    try {
      var map = Map<String, dynamic>();
      map['action'] = 'ASSIGN_ISSUE';
      map['Employee_ID'] = empID;
      map['Issue_ID'] = iID;
      final response = await http.post(ROOT, body: map);
      if (200 == response.statusCode) {
        _sendAssignMail(empID, iID);
        return response.body;
      } else {
        return "error1";
      }
    } catch (e) {
      return "Failure";
    }
  }

  // This function sends email to relevent support team member when an issue is assigned to him
  static Future<void> _sendAssignMail(String empID, String iID) async {
    var result = await getIssuesByID(iID);
    var list1 = json.decode(result);
    String initiatorID = list1[0]['Issue_logged_by'];
    String area = list1[0]['Area'];
    String category = list1[0]['Category'];
    String subCategory = list1[0]['Sub_Category'];
    String description1 = list1[0]['Description1'];
    String description2 = list1[0]['Description2'];
    var temp = await getEmail(initiatorID);
    var temp1 = temp[0];
    var tempSup = await getEmail(empID);
    var cc = tempSup[0];
    String recipient = temp1;
    var time = DateTime.now();
    String IssueRefferedToPerson =
        "Dear user,\nAn issue logged by the user ${initiatorID} been referred to the support team member ${empID}, with the following details.\n\nArea: ${area}\nCategory: ${category}\nSub-category: ${subCategory}\nBrief Description: ${description1}\nDetailed Description: ${description2}\nThank you for using the ILS app!\nLog on to the ILS app for further actions and details";
    String IssueRefferedToPersonSub = "Issue Assigned";
    List<String> ccList = [cc];
    _sendMails(
        recipient, ccList, IssueRefferedToPerson, IssueRefferedToPersonSub);
  }

  // This function returns expertise of all suport_team members
  static Future<List<EmployeeMainInfo>> getExpertise() async {
    try {
      var map = Map<String, dynamic>();
      map['action'] = '_GET_EXPERTISE';
      final response = await http.post(ROOT, body: map);
      var list = json.decode(response.body);
      List<EmployeeMainInfo> l1 = new List(list.length);
      for (var i = 0; i < list.length; i++) {
        var temp = list[i];
        if (temp['Role'] == '1') {
          temp['Role'] = 'Admin';
        } else if (temp['Role'] == '2') {
          temp['Role'] = 'Monitor';
        } else if (temp['Role'] == '3') {
          temp['Role'] = 'Manager';
        } else if (temp['Role'] == '4') {
          temp['Role'] = 'Support Team Member';
        } else if (temp['Role'] == '5') {
          temp['Role'] = 'Initiator';
        }
        l1[i] = EmployeeMainInfo(
            employeeID: temp['Employee_ID'],
            employeeName: temp['Name'],
            employeeRole: temp['Role']);
      }
      return l1;
    } catch (e) {
      return List<
          EmployeeMainInfo>(); // return an empty list on exception/error
    }
  }

  // This function returns expertise of suport_team member
  static Future<Employee> getExpertiseById(String eID) async {
    try {
      var map = Map<String, dynamic>();
      map['action'] = '_GET_EXPERTISE_BY_ID';
      map['Employee_ID'] = eID;
      final response = await http.post(ROOT, body: map);
      var list = json.decode(response.body);
      var map2 = Map<String, dynamic>();
      map2['action'] = '_GET_Category_BY_ID';
      map2['Employee_ID'] = eID;
      final response1 = await http.post(ROOT, body: map2);
      var list1 = json.decode(response1.body);
      String categories = '';
      var temp = list[0];
      if (temp['Role'] == '1') {
        temp['Role'] = 'Admin';
      } else if (temp['Role'] == '2') {
        temp['Role'] = 'Monitor';
      } else if (temp['Role'] == '3') {
        temp['Role'] = 'Manager';
      } else if (temp['Role'] == '4') {
        temp['Role'] = 'Support Team Member';
      } else if (temp['Role'] == '5') {
        temp['Role'] = 'Initiator';
      }

      for (var i = 0; i < list1.length; i++) {
        var temp1 = list1[i];
        categories = categories + temp1['Category'] + ', ';
      }
      categories = categories.substring(0, categories.length - 2);
      Employee l1 = Employee(
          employeeID: temp['Employee_ID'],
          employeeName: temp['Name'],
          employeeRole: temp['Role'],
          employeeTeam: temp['Branch_ID'],
          employeeArea: temp['Area'],
          employeeCategory: categories,
          employeeSubCategory: 'Malik');
      return l1;
    } catch (e) {
      return Employee(); // return an empty list on exception/error
    }
  }

  // This function returns all Branch_IDs
  static Future<List<String>> getTeams() async {
    try {
      var map = Map<String, dynamic>();
      map['action'] = '_GET_ALL_BRANCH';
      final response = await http.post(ROOT, body: map);
      var list1 = json.decode(response.body);
      List<String> l1 = new List(list1.length);
      for (var i = 0; i < list1.length; i++) {
        var temp = list1[i];
        l1[i] = temp['Branch_ID'];
      }
      return l1;
    } catch (e) {
      return List<String>(); // return an empty list on exception/error
    }
  }

  // This function returns count from a key value querry from issues
  static Future<String> getCount(String key, String val) async {
    try {
      var map = Map<String, dynamic>();
      map['action'] = 'COUNT_FROM_ISSUES';
      map['Key'] = key;
      map['Val'] = val;
      final response = await http.post(ROOT, body: map);
      var list = json.decode(response.body);
      if (200 == response.statusCode) {
        return list['Count(*)'];
      } else {
        return "error1";
      }
    } catch (e) {
      return "Failure";
    }
  }

  // This function return's email of an any individual from issues table using key value
  static Future<List<String>> getEmail(String val) async {
    try {
      var map = Map<String, dynamic>();
      map['action'] = '_GET_EMAIL';
      map['Val'] = val;
      final response = await http.post(ROOT, body: map);
      var list1 = json.decode(response.body);
      List<String> l1 = new List(list1.length);
      for (var i = 0; i < list1.length; i++) {
        var temp = list1[i];
        l1[i] = temp['Email'];
      }
      return l1;
    } catch (e) {
      return List<String>(); // return an empty list on exception/error
    }
  }

  // This function returns Emails of entire relevant support team under same branch_ID
  static Future<List<String>> getTeamEmail(String iID) async {
    try {
      var map = Map<String, dynamic>();
      map['action'] = '_GET_Team_EMAILS';
      map['Issue_ID'] = iID;
      final response = await http.post(ROOT, body: map);
      var list1 = json.decode(response.body);
      List<String> l1 = new List(list1.length);
      for (var i = 0; i < list1.length; i++) {
        var temp = list1[i];
        l1[i] = temp['Email'];
      }
      return l1;
    } catch (e) {
      return List<String>(); // return an empty list on exception/error
    }
  }

  // This function returns emails of all relevent support team members within the city
  static Future<List<String>> getInCityEmail(String bID) async {
    try {
      var map = Map<String, dynamic>();
      map['action'] = '_GET_CITY_EMAILS';
      map['Branch_ID'] = bID;
      final response = await http.post(ROOT, body: map);
      var list1 = json.decode(response.body);
      List<String> l1 = new List(list1.length);
      for (var i = 0; i < list1.length; i++) {
        var temp = list1[i];
        l1[i] = temp['Email'];
      }
      return l1;
    } catch (e) {
      return List<String>(); // return an empty list on exception/error
    }
  }
}
