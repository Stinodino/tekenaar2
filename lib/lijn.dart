import 'package:flutter/cupertino.dart';

class lijn {

  //variables
  List<Offset> punten = [Offset(0, 0)];//brol punt voor null ding

  //constructor
  lijn(double x,double y){
    punten[0]=Offset(x,y);
  }

  //functies
  void voegToe(Offset punt){
    if (punten[0]==Offset(0,0))
      punten[0] = punt;//brol punt overschrijven
    else
      punten.add(punt);//punt toevoegen
  }
}
