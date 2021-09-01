import 'package:flutter/material.dart';
import 'package:tekenaar2/lijn.dart';
import 'lijn.dart';
import 'my_home_page.dart';
import 'dart:ui' as ui;
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';

class MyPainter extends CustomPainter {
  MyPainter({this.mijnLijnen, this.sizeScherm = const Size(0, 0)});

  List<lijn>? mijnLijnen;
  Size sizeScherm = Size(0, 0);

  @override
  void paint(Canvas canvas, Size size) {
    //deze functie wordt opgeroepen elke keer dat vinger beweegt.
    //deze wordt vanzelf opgeroepen. kheb geen idee wanneer haha.
    //ik denk als er setstate gedaan wordt
    teken(canvas, size);
  }

  Canvas teken(Canvas canvas, Size size) {
    Paint verf = Paint();
    verf.strokeWidth = 2;

    if (image == null) {
      //if(foto != null) mag blijkbaar ni
    } else {
      paintImage(
        //teken foto
        canvas: canvas,
        rect: Rect.fromLTWH(0, 0, sizeScherm.width, sizeScherm.height),
        image: image!,
        fit: BoxFit.scaleDown,
        alignment: Alignment.topCenter,
      );
      //scale: 1.0,//geen idee wat da doet ma da past niks van de schaal aan
      //flipHorizontally: false,//spiegelen mss nuttig als optie later
    }

    //verbind punten van lijnen
    if (mijnLijnen == null) {
      //ik weet nog steeds ni waarom ik (mijnLijnen != null) ni mag doen :(
    } else {
      for (var lijn in mijnLijnen!) {
        verf.color = lijn.kleur;
        if (lijn.punten.length == 1) {
          //als de lijn een punt is
          canvas.drawCircle(lijn.punten[0], 2.0,
              verf); //cirkel tekenen. anders kan ik geen puntjes op de ij van Stijn tekenen
        }

        for (int i = 0; i < lijn.punten.length - 1; i++) {
          canvas.drawLine(lijn.punten[i], lijn.punten[i + 1], verf);
        }
      }
    }
    return canvas;
  }

  void slaagFotoOp(Size sizeFoto) async {
    //ergens wordt hier de kwaliteit verpest denk ik
    print(sizeFoto);
    print(sizeScherm);

    var tijd = DateTime.now();
    final fotoNaam = "tekenaar_" +
        tijd.day.toString() +
        "-" +
        tijd.month.toString() +
        "-" +
        tijd.year.toString() +
        "_" +
        tijd.hour.toString() +
        "-" +
        tijd.minute.toString() +
        "-" +
        tijd.second.toString();

    //omdat ik het normale canvas niet zelf gemaakt heb kan ik er geen recorder aan koppelen
    //brakke oplossing: men eigen canvas maken 1malig om foto op te slagen
    final recorder = ui.PictureRecorder();
    Canvas opslaagCanvas = ui.Canvas(
        recorder,
        //die afmetingen maken om een of andere reden totaal ni uit zolang ze niet 0,0 zijn.
        Rect.fromPoints(Offset(0, 0),
            Offset(sizeScherm.width * 69, sizeScherm.height * 2)));
    opslaagCanvas = teken(opslaagCanvas, Size(0, 0)); //same hier
    final picture =
        recorder.endRecording(); //deze picture is incluzief witte rand onderaan
    //bij picture naar image omzetting knip ik witte/zwarte rand er onderaan af
    final img = await picture.toImage(
        sizeScherm.width.floor(),
        (sizeScherm.width * (sizeFoto.height / sizeFoto.width))
            .floor()); //picture naar image
    final pngBytes = await img.toByteData(
        format: ui.ImageByteFormat.png); //image naar byteData
    await [Permission.storage].request();
    final result = await ImageGallerySaver.saveImage(
        pngBytes!.buffer.asUint8List(),
        name: fotoNaam); //byteData naar Uint8List en opslagen
    result['filePath'];
  }

  @override
  bool shouldRepaint(CustomPainter old) {
    //functie die altijd false returnt. geen idee waarom da erbij moet
    return false;
  }
}
