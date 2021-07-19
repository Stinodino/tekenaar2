import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class lijn {

  //variables
  List<Offset> punten = [Offset(0, 0)];//brol punt voor null ding
  Color kleur=Colors.red;

  //constructor
  lijn(double x,double y, mijnKleur){
    punten[0]=Offset(x,y);
    kleur = mijnKleur;
    print(kleur.toString());
  }

  //functies
  void voegToe(Offset punt){
    if (punten[0]==Offset(0,0))
      punten[0] = punt;//brol punt overschrijven
    else
      punten.add(punt);//punt toevoegen
  }
}
