import 'package:flutter/material.dart';

class CustomDialog extends StatelessWidget {
  final String title;
  final Image image;

  CustomDialog({
    @required this.title,
    this.image,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(35.0),
      ),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: dialogContent(context),
    );
  }

  dialogContent(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          width: 650,
          height: 150,
          padding: EdgeInsets.only(
            // top: Consts.avatarRadius //+ Consts.padding,
              // bottom: Consts.padding,
              // left: Consts.padding,
              // right: Consts.padding,
              ),
          // margin: EdgeInsets.only(top: Consts.avatarRadius),
          decoration: new BoxDecoration(
            color: Colors.white,
            shape: BoxShape.rectangle,
            border: Border.all(width: 2),
            borderRadius: BorderRadius.circular(40.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10.0,
                offset: const Offset(0.0, 10.0),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min, // To make the card compact
            children: <Widget>[
              Container(
                padding: EdgeInsets.fromLTRB(0, 16, 0, 10),
                child: Image(
                  image: new AssetImage("assets/images/check1.png"),
                  // fit: BoxFit.fill,
                ),
              ),
              Text(
                title,
                style: new TextStyle(
                  color: Colors.grey[700],
                  fontSize: 25,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class Consts {
  Consts._();

  static const double padding = 16.0;
  static const double avatarRadius = 66.0;
}

// showDialog(
//   context: context,
//   builder: (BuildContext context) => CustomDialog(
//         title: "Success",
//       ),
// );

// TODO
// 1. split functions
// 2. comment each function's use
// 3. Align Buttons according to any screen
// 4. remove unnecessary comments
// 5. Class names are nouns, func names are verbs
// 6. arrow doesn't look much in the center sent you a picture
// 7. Is the background white? It is black in the picture

