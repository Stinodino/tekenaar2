import 'package:flutter/material.dart';
import 'package:tekenaar2/lijn.dart';
import 'lijn.dart';
import 'my_home_page.dart';

class MyPainter extends CustomPainter {
  MyPainter({this.mijnLijnen});

  List<lijn>? mijnLijnen;


  @override
  void paint(Canvas canvas, Size size) {
    //                                             <-- Insert your painting code here.
    Paint verf = Paint();
    verf.color=Colors.red;
    verf.strokeWidth=2;

    if (imageGalerij == null){//if(foto != null) mag blijkbaar ni
    }
    else {
      //canvas.drawImage(imageGalerij!, Offset(0,0), verf);
      paintImage(canvas: canvas,
          rect: Rect.fromLTWH(0, 0, 393, 524.0),
          image: imageGalerij!,
          fit: BoxFit.scaleDown,
          repeat: ImageRepeat.noRepeat,
          //scale: 1.0,//geen idee wat da doet
          alignment: Alignment.topLeft,
          flipHorizontally: false,
          filterQuality: FilterQuality.high);

    }


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
