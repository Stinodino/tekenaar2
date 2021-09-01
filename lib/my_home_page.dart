import 'dart:io';
import 'package:flutter/material.dart';
import 'my_painter.dart';
import 'lijn.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:ui' as ui;
import 'dart:async';
import 'dart:typed_data';


class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

//globeale variables
List<lijn>? lijnen;
ui.Image? image;

class _MyHomePageState extends State<MyHomePage> {
  //variables homepage
  double x = 0;//om rare reden werkt setstate alleen als er een text widget veranderd.
  // deze x is in de textwidget zodat de custompainter geupdate kan worden met setstate
  //ik weet dat da brak en marginaal is ma kheb duuzend uur gezocht en niks deftigers gevonden
  double offset = 150; //offset door 2 balken bovenaan
  List kleurtjes = [
    Colors.red,
    Colors.blue,
    Colors.green,
    Colors.black,
    Colors.yellow,
    Colors.orange,
    Colors.white,
    Colors.purple,
  ];
  bool isImageloaded = false;
  Color kleur = Colors.red;
  Size sizeFoto = Size(0, 0);

  //foto uit galerij halen
  void fotoKiezen() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile==null) return;
    File fileGalerij = File(pickedFile.path);

    //afmetingen uit foto halen
    var decodedImage = await decodeImageFromList(fileGalerij.readAsBytesSync());
    sizeFoto = Size(decodedImage.width.toDouble(),decodedImage.height.toDouble());

    //File naar Image
    Uint8List bytes = fileGalerij.readAsBytesSync();
    image = await loadImage(Uint8List.view(bytes.buffer));
  }

  //lijst van bits in Image omzetten
  Future<ui.Image> loadImage(Uint8List img) {
    final Completer<ui.Image> completer = Completer();
    ui.decodeImageFromList(img, (ui.Image img) {
      setState(() {
        isImageloaded = true;
      });
      return completer.complete(img);
    });
    return completer.future;
  }

  //verwijderd laadste lijn (undo)
  void undo() {
    //start bij drukken knop
    setState(() {
      if (lijnen!.length > 0) {
        lijnen!.removeLast();
      }
    });
  }

  //methode start als vinger beweegt
  void dragUpdate(DragUpdateDetails details) {
    setState(() {
      //print(details.globalPosition.dx.toString() + " , " + details.globalPosition.dy.toString());
      lijnen!.last.voegToe(Offset(
          details.globalPosition.dx, details.globalPosition.dy - offset));
      x++;
    });
  }

  //methode start als vinger op scherp drukt
  void dragStart(DragStartDetails details) {
    //start bij drukken vinger
    if (lijnen == null) {
      lijnen = [
        lijn(details.globalPosition.dx, details.globalPosition.dy - offset,
            kleur)
      ];
    } else {
      lijnen!.add(lijn(details.globalPosition.dx,
          details.globalPosition.dy - offset, kleur));
      //print("start lijn" + lijnen!.last.kleur.toString() + kleur.toString());
      x++;
    }
  }

  //methode start als vinger van scherm is
  void dragEnd(DragEndDetails details) {
    //start bij loslaten vinger
    setState(() {});//wanneer er op scherm geklikt wordt (geen schuif beweging) zal dragUpdate niet reageren
    //daarom moet dragEnd het scherm verversen zodat het getekend punt erop komt.
  }

  void veranderKleur(Color mijnKleur) {
    kleur = mijnKleur;
    //print(kleur.toString());
  }

  void draai(Size size, bool richting) {
    //men eerste idee was om de lijnen te draaien + de foto te draaien
    //ma nu denk ik dat het mss beter is om foto op te slagen en hele foto te draaien
    for (var lijn in lijnen!) {
      lijn.draaiLijn(size, richting);
    }
  }

  @override
  Widget build(BuildContext context) {
    final painter =
        MyPainter(mijnLijnen: lijnen, sizeScherm: MediaQuery.of(context).size);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Stack(
        children: <Widget>[
          Text(x.toString()),
          //later nog weg werken
          Column(
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 50,
                  color: Colors.lightBlue,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      for (var kleur in kleurtjes)
                        IconButton(
                            onPressed: () => veranderKleur(kleur),
                            color: kleur,
                            icon: const Icon(Icons.circle)),
                    ],
                  ),
                ),
              ),
              Align(
                alignment: Alignment.topLeft,
                child: CustomPaint(
                  painter: painter,
                ),
              )
            ],
          ),
          GestureDetector(
            onPanUpdate: dragUpdate,
            onPanEnd: dragEnd,
            onPanStart: dragStart,
          ),

          //moet er om vage rede bij omdat anders setstate ni werkt. later beter fixe
          Align(
            alignment: Alignment.bottomLeft,
            child: Container(
              color: Colors.lightBlue,
              width: MediaQuery.of(context)
                  .size
                  .width, //breedte menu balk onderaan
              height: 50, //hoogte menu balk onderaan
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  IconButton(onPressed: undo, icon: const Icon(Icons.undo)),
                  IconButton(
                      onPressed: undo,
                      icon: const Icon(Icons.add_a_photo_rounded)),
                  IconButton(
                      onPressed: fotoKiezen,
                      icon: const Icon(
                          IconData(58548, fontFamily: 'MaterialIcons'))),
                  IconButton(
                      onPressed: () => draai(MediaQuery.of(context).size, true),
                      icon: const Icon(
                          IconData(58688, fontFamily: 'MaterialIcons'))),
                  IconButton(
                      onPressed: () =>
                          draai(MediaQuery.of(context).size, false),
                      icon: const Icon(
                          IconData(58687, fontFamily: 'MaterialIcons'))),
                  IconButton(
                      onPressed: () => painter.slaagFotoOp(sizeFoto),
                      icon: const Icon(
                          IconData(58704, fontFamily: 'MaterialIcons'))),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
