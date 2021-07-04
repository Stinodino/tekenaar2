import 'package:flutter/material.dart';
import 'my_painter.dart';
import 'lijn.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

//globeale variables
List<lijn> lijnen = [lijn(0.0, 0.0)];

class _MyHomePageState extends State<MyHomePage> {
  //variables homepage

  double x = 0;
  double offset = 90;

  //teken widget
  CustomPaint tekenaar = CustomPaint(
      size: Size(3000, 3000), painter: MyPainter(mijnLijnen: lijnen));

  void undo() {
    //start bij drukken knop
    setState(() {
      if (lijnen.length > 1) {
        lijnen.removeLast();
      }
    });
  }

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
          GestureDetector(
            onPanUpdate: dragUpdate,
            onPanEnd: dragEnd,
            onPanStart: dragStart,
            child:
                tekenaar, //mag ook in stack ipv child. beide manieren gaan toch ni werken als Text() er ni is
          ),
          Text(x.toString()),
          //moet er om vage rede bij omdat anders setstate ni werkt. later beter fixe
          Align(
              alignment: Alignment.bottomLeft,
              child: Container(
                color: Colors.lightBlue,
                width: MediaQuery. of(context). size. width,
                height: 50,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    IconButton(onPressed: undo, icon: const Icon(Icons.undo)),
                    IconButton(onPressed: undo, icon: const Icon(Icons.add_a_photo_rounded)),
                    IconButton(onPressed: undo, icon: const Icon(IconData(58548, fontFamily: 'MaterialIcons'))),
                    IconButton(onPressed: undo, icon: const Icon(IconData(63692, fontFamily: 'MaterialIcons'))),
                    IconButton(onPressed: undo, icon: const Icon(IconData(57724, fontFamily: 'MaterialIcons'))),
                  ],
                ),
              ))
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
