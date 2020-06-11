// Made with help from www.thefluttercrashcourse.com
import 'package:flutter/material.dart';

class Styles {
  // variables to ensure consistency in style
  static const _fontNameHeader = 'Roboto-Bold';
  static const _fontNameDefault = 'Roboto-Regular';
  static const _fontNameMain = 'Roboto-Black';
  static const _textSizeXLarge = 35.0;
  static const _textSizeLarge = 25.0;
  static const _textSizeMedium = 22.0;
  static const _textSizeSmall = 18.0;
  static const _textXSizeSmall = 15.0;
  static const _textVSizeSmall = 15.0;
  static const _textSpecialSizeSmall = 18.0;
  static final Color _textColorBlue = hexToColor('193C76');
  static final Color _textColorWhite = hexToColor('FFFFFF');
  static final Color textColorGray = hexToColor('808080');
  static final Color backgroundColorOrange = hexToColor('F47320');
  static final Color backgroundColorBlue = hexToColor('193C76');
  static final Color backgroundColorWhite = hexToColor('FFFFFF');
  static final Color backgroundColorGray = Colors.grey[350];
  static final Color buttonColorBlue = Colors.blue[600];
  static final Color buttonColorRed = Colors.red[300];
  static final Color buttonColorGreen = hexToColor('FF64f48a');
  static final Color buttonColorYellow = hexToColor('FF64f48a');
  static final Color buttonColorOrange = hexToColor('FFf79a55');
  static final Color iconColorGray = hexToColor('808080');
  static final radius = 50.0;
  static final buttonWidth = 140.0;
  static final buttonHeight = 170.0;
  static final inButtonWidth = 90.0;
  static final inButtonHeight = 100.0;
  // appbar text theme
  static final appBar = TextStyle(
    backgroundColor: backgroundColorOrange,
    fontFamily: _fontNameHeader,
    fontSize: _textSizeLarge,
    color: _textColorWhite,
  );
  //AlertDialogBox theme
  static final alertDialogBox = TextStyle(
    fontFamily: _fontNameDefault,
    fontSize: _textSizeMedium,
    color: Colors.black54,
  );
  static final secalertDialogBox = TextStyle(
    fontFamily: _fontNameDefault,
    fontSize: _textSizeMedium,
    color: _textColorWhite,
  );
  static final alertDialogBoxButtons = TextStyle(
    fontFamily: _fontNameDefault,
    fontSize: _textXSizeSmall,
    color: _textColorBlue 
  );
  // default text themes
  static final headerDefault = TextStyle(
    fontFamily: _fontNameHeader,
    fontSize: _textSizeLarge,
    color: textColorGray,
  );
  static final textDefault = TextStyle(
    fontFamily: _fontNameDefault,
    fontSize: _textSizeSmall,
    color: textColorGray,
  );
  static final specialtextDefault = TextStyle(
    fontFamily: _fontNameDefault,
    fontSize: _textSpecialSizeSmall,
    color: textColorGray,
  );
  static final smalltextDefault = TextStyle(
    fontFamily: _fontNameDefault,
    fontSize: _textXSizeSmall,
    color: textColorGray,
  );
  static final verySmalltextDefault = TextStyle(
    fontFamily: _fontNameDefault,
    fontSize: _textVSizeSmall,
    color: textColorGray,
  );
  // main page themes
  static final mainPageTitle = TextStyle(
    fontFamily: _fontNameMain,
    fontSize: _textSizeXLarge,
    color: _textColorBlue,
    fontWeight: FontWeight.bold,
  );
  static final mainPageDefault = TextStyle(
    fontFamily: _fontNameDefault,
    fontSize: _textSizeSmall,
    color: _textColorWhite,
  );
  static final mainPageDefault2 = TextStyle(
    fontFamily: _fontNameDefault,
    fontSize: _textSizeSmall,
    color: _textColorBlue,
  );
  // button themes
  static final buttonText = TextStyle(
    fontFamily: _fontNameDefault,
    fontSize: _textXSizeSmall,
    color: _textColorWhite,
    fontWeight: FontWeight.bold,
  );
  static final buttonTextmenu = TextStyle(
    fontFamily: _fontNameDefault,
    fontSize: _textSizeSmall,
    color: _textColorWhite,
    fontWeight: FontWeight.w500,
  );
  static final textButtonText = TextStyle(
    fontFamily: _fontNameDefault,
    fontSize: _textXSizeSmall,
    color: _textColorBlue,
    fontWeight: FontWeight.bold,
  );
  static final subheadingDefault = TextStyle(
      fontFamily: _fontNameDefault,
      fontSize: _textSizeMedium,
      color: textColorGray,
      fontWeight: FontWeight.bold);
  static final buttonDefault = TextStyle(
    fontFamily: _fontNameHeader,
    fontSize: _textSizeSmall,
    color: _textColorWhite,
  );
  static final buttonDefault1 = TextStyle(
    fontFamily: _fontNameHeader,
    fontSize: _textXSizeSmall,
    color: _textColorWhite,
  );
  static final buttonDefault2 = TextStyle(
    fontFamily: _fontNameHeader,
    fontSize: _textXSizeSmall,
    color: _textColorWhite,
  );
  static final dialogheadingDefault = TextStyle(
      fontFamily: _fontNameDefault,
      fontSize: _textSizeMedium,
      color: _textColorWhite,
      fontWeight: FontWeight.bold
  );

  static final dialogtextDefault = TextStyle(
    fontFamily: _fontNameDefault,
    fontSize: _textSizeSmall,
    color: _textColorWhite,
  );
  // function that converts a hex number to a colour
  static Color hexToColor(String code) {
    return Color(int.parse(code.substring(0, 6), radix: 16) + 0xFF000000);
  }
  static final headerDefaultUnderlined = TextStyle(
    fontFamily: _fontNameHeader,
    fontSize: _textSizeLarge,
    color: textColorGray,
    fontWeight: FontWeight.bold,
    decoration: TextDecoration.underline
  );
}
