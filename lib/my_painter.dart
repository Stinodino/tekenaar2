import 'package:flutter/material.dart';
import 'package:tekenaar2/lijn.dart';
import 'lijn.dart';
import 'my_home_page.dart';
import 'dart:ui' as ui;
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:async';

class MyPainter extends CustomPainter {
  MyPainter({this.mijnLijnen, this.mijnSize = const Size(0, 0)});

  List<lijn>? mijnLijnen;
  Size mijnSize = Size(0, 0);

  @override
  void paint(Canvas canvas, Size size) {//deze functie wordt opgeroepen elke keer dat vinger beweegt
    canvas=teken(canvas, size);
  }

  Canvas teken(Canvas canvas,Size size) {
    Paint verf = Paint();
    verf.strokeWidth = 2;

    if (imageGalerij == null) {
      //if(foto != null) mag blijkbaar ni
    } else {
      paintImage(//teken foto
        canvas: canvas,
        rect: Rect.fromLTWH(0, 0, mijnSize.width, mijnSize.height),
        image: imageGalerij!,
        fit: BoxFit.scaleDown,
        alignment: Alignment.topCenter,);
      //scale: 1.0,//geen idee wat da doet
      //flipHorizontally: false,//spiegelen
    }

    //interpoleer punten van lijnen
    if (mijnLijnen == null){}
    else {
      for (var lijn in mijnLijnen!) {
        verf.color = lijn.kleur;
        if (lijn.punten.length == 1) {
          //als de lijn een punt is
          canvas.drawCircle(lijn.punten[0], 2.0, verf);
        }

        for (int i = 0; i < lijn.punten.length - 1; i++) {
          canvas.drawLine(lijn.punten[i], lijn.punten[i + 1], verf);
        }
      }
    }

    return canvas;
  }


  ui.Picture canvasNaarPicture(){
    final recorder = ui.PictureRecorder();
    Canvas opslaagCanvas = ui.Canvas(recorder,Rect.fromPoints(Offset(0, 0), Offset(mijnSize.width, mijnSize.height)));
    opslaagCanvas = teken(opslaagCanvas,Size(0, 0));
    return recorder.endRecording();

  }

  Future<ui.Image> pictureToImage(ui.Picture picture) async {
    final img = await picture.toImage(mijnSize.width.toInt(), mijnSize.height.toInt());//picture naar image
    return img;
  }


  void slaOp() async {
    var tijd = DateTime.now();

    final fotoNaam =
        "tekenaar_"+ tijd.day.toString()+ "-"+tijd.month.toString()+"-"+tijd.year.toString()+"_"+tijd.hour.toString()+"-"+tijd.minute.toString()+"-"+tijd.second.toString();
    final recorder = ui.PictureRecorder();
    Canvas opslaagCanvas = ui.Canvas(recorder,Rect.fromPoints(Offset(0, 0), Offset(mijnSize.width, mijnSize.height)));
    opslaagCanvas = teken(opslaagCanvas,Size(0, 0));
    final picture = recorder.endRecording();
    final img = await picture.toImage(mijnSize.width.toInt(), mijnSize.height.toInt());//picture naar image
    if (img == null) return;
    final pngBytes = await img.toByteData(format: ui.ImageByteFormat.png);//image naar byteData
    await [Permission.storage].request();
    final result = await ImageGallerySaver.saveImage(pngBytes!.buffer.asUint8List(), name: fotoNaam);//byteData naar Uint8List en opslagen
    result['filePath'];
  }


  @override
  bool shouldRepaint(CustomPainter old) {
    //functie die altijd false returnt. geen idee waarom da erbij moet
    return false;
  }
}
