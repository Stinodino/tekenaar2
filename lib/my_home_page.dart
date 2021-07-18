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
List<lijn> lijnen = [lijn(0.0, 0.0)];
File? fileGalerij;
ui.Image? imageGalerij;
ui.Image? imageAssets;

class _MyHomePageState extends State<MyHomePage> {
  //variables homepage
  PickedFile? pickedFile;
  double x = 0;
  double offset = 90;

  bool isImageloaded = false;

  //foto uit galerij halen
  void fotoKiezen() async {
    final pickedFile =
        await ImagePicker().getImage(source: ImageSource.gallery);
    setState(() {
      //is deze setstate ni nutloos?
      fileGalerij = File(pickedFile!.path);
    });
    Uint8List bytes = fileGalerij!.readAsBytesSync();

    imageGalerij = await loadImage(Uint8List.view(bytes.buffer));

  }

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
      if (lijnen.length > 1) {
        lijnen.removeLast();
      }
    });
  }

  //methode start als vinger beweegt
  void dragUpdate(DragUpdateDetails details) {
    //start bij bewegen vinger
    setState(() {
      print(details.globalPosition.dx.toString() +
          " , " +
          details.globalPosition.dy.toString());
      lijnen.last.voegToe(Offset(
          details.globalPosition.dx, details.globalPosition.dy - offset));
      x++;
    });
  }

  //methode start als vinger op scherp drukt
  void dragStart(DragStartDetails details) {
    //start bij drukken vinger
    setState(() {
      if (lijnen[0] == lijn(0, 0)) //als brol lijn is (eerste lijn)
        lijnen[0] = (lijn(details.globalPosition.dx,
            details.globalPosition.dy - offset)); //brol lijn overschrijven
      else
        lijnen.add(lijn(
            details.globalPosition.dx, details.globalPosition.dy - offset));
      print("start lijn");
      x++;
    });
  }

  //methode start als vinger van scherm is
  void dragEnd(DragEndDetails details) {
    //start bij loslaten vinger
    setState(() {
      print("lijn gedaan");
      x++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Stack(
        children: <Widget>[
          CustomPaint(
            painter: MyPainter(mijnLijnen: lijnen),
          ),
          GestureDetector(
            onPanUpdate: dragUpdate,
            onPanEnd: dragEnd,
            onPanStart: dragStart,
          ),
          Text(x.toString()),
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
                      onPressed: undo,
                      icon: const Icon(
                          IconData(63692, fontFamily: 'MaterialIcons'))),
                  IconButton(
                      onPressed: undo,
                      icon: const Icon(
                          IconData(57724, fontFamily: 'MaterialIcons'))),
                ],
              ),
            ),
          ),
        ],
      ),
      /*floatingActionButton: FloatingActionButton(
        onPressed: undo,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),*/ // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
