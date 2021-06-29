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
  var x=0;
  double offset = 90;
  //teken widget
  CustomPaint tekenaar = CustomPaint(size: Size(300, 300), painter: MyPainter(),);

  void knop() {//start bij drukken knop
    setState(() {});
  }

  void dragUpdate(DragUpdateDetails details){//start bij bewegen vinger
    print(details.globalPosition.dx.toString()+" , " + details.globalPosition.dy.toString());


    setState(() {lijnen.last.voegToe(Offset(details.globalPosition.dx,details.globalPosition.dy-offset));});//zorgt ervoor dat hij tekend
    x++;
  }

  void dragStart(DragStartDetails details){//start bij drukken vinger
    if (lijnen[0]==lijn(0, 0))//als brol lijn is (eerste lijn)
      lijnen[0] =(lijn(details.globalPosition.dx,details.globalPosition.dy-offset));//brol lijn overschrijven
    else
      lijnen.add(lijn(details.globalPosition.dx,details.globalPosition.dy-offset));
    print("start lijn");
    setState(() {});//zorgt ervoor dat hij tekend
  }

  void dragEnd(DragEndDetails details){//start bij loslaten vinger
    print("lijn gedaan");
    setState(() {});//zorgt ervoor dat hij tekend
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Stack(
          children: <Widget>[
            Text(x.toString()),//moet er om vage rede bij omdat anders setstate ni werkt. later beter fixe
            tekenaar,
            GestureDetector(
              onPanUpdate: dragUpdate,
              onPanEnd: dragEnd,
              onPanStart: dragStart,
              onTap: knop,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: knop,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}






class MyPainter extends CustomPainter { //         <-- CustomPainter class
  @override
  void paint(Canvas canvas, Size size) {
    //                                             <-- Insert your painting code here.
    //ui.Image test = ui.Image.file(foto);
    Paint verf = Paint();

    for (var lijn in lijnen){
      for (int i = 0; i < lijn.punten.length-1; i++) {
        canvas.drawLine(lijn.punten[i], lijn.punten[i+1], verf);
      }
    }
  }
  @override
  bool shouldRepaint(CustomPainter old) {//functie die altijd false returnt. geen idee waarom da erbij moet
    return false;
  }

  void verf(Canvas canvas, Size size,lijnen){
    Paint verf = Paint();

    for (var lijn in lijnen){
      for (int i = 0; i < lijn.punten.length-1; i++) {
        canvas.drawLine(lijn.punten[i], lijn.punten[i+1], verf);
      }
    }

  }



}




