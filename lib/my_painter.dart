import 'package:flutter/material.dart';
import 'package:tekenaar2/lijn.dart';
import 'lijn.dart';
import 'my_home_page.dart';

class MyPainter extends CustomPainter {
  MyPainter({this.mijnLijnen, this.mijnSize = const Size(0, 0)});

  List<lijn>? mijnLijnen;
  Size mijnSize = Size(0, 0);

  @override
  void paint(Canvas canvas, Size size) {
    Paint verf = Paint();
    verf.color = Colors.red;
    verf.strokeWidth = 2;

    if (imageGalerij == null) {
      //if(foto != null) mag blijkbaar ni
    } else {
      paintImage(
          canvas: canvas,
          rect: Rect.fromLTWH(0, 0, mijnSize.width, mijnSize.height),
          image: imageGalerij!,
          fit: BoxFit.scaleDown,
          alignment: Alignment.topLeft,);
          //scale: 1.0,//geen idee wat da doet
          //flipHorizontally: false,//spiegelen
    }

    //interpoleer punten van lijnen
    if (mijnLijnen == null) return;

    for (var lijn in mijnLijnen!) {
      if (lijn.punten.length == 1) {
        //als de lijn een punt is
        canvas.drawCircle(lijn.punten[0], 2.0, verf);
      }

      for (int i = 0; i < lijn.punten.length - 1; i++) {
        canvas.drawLine(lijn.punten[i], lijn.punten[i + 1], verf);
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter old) {
    //functie die altijd false returnt. geen idee waarom da erbij moet
    return false;
  }
}
