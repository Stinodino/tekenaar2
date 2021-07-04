import 'package:flutter/material.dart';
import 'package:tekenaar2/lijn.dart';

class MyPainter extends CustomPainter {
  MyPainter({this.mijnLijnen});
  //         <-- CustomPainter class
  //MyPainter(List<lijn> lijnen, {@required this.mijnLijnen});
  List<lijn>? mijnLijnen;

  @override
  void paint(Canvas canvas, Size size) {
    //                                             <-- Insert your painting code here.
    Paint verf = Paint();
    verf.color=Colors.red;
    verf.strokeWidth=2;

    for (var lijn in mijnLijnen!) {
      if (lijn.punten.length == 1) {
        canvas.drawCircle(lijn.punten[0], 2, verf);
      }
      else {
        for (int i = 0; i < lijn.punten.length - 1; i++) {
          canvas.drawLine(lijn.punten[i], lijn.punten[i + 1], verf);
        }
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter old) {
    //functie die altijd false returnt. geen idee waarom da erbij moet
    return false;
  }
}
