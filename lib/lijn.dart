import 'dart:math';

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

  void draaiLijn(Size size,bool richting){
    //richting=true=rechts
    //richting=false=links

    for (var i=0;i<punten.length;i++){
      double r=sqrt(punten[i].dx*punten[i].dx+punten[i].dy*punten[i].dy);
      double hoek=atan(punten[i].dy/punten[i].dx);

      double teken=-1;
      if(richting)
        teken=1;

      double draaihoek = (pi/40)*teken;

      punten[i]=Offset(r*cos(hoek+draaihoek),r*sin(hoek+draaihoek));
      //punten[i]=Offset((-r*cos((pi/4)-hoek))+size.width,r*sin((pi/4)-hoek));
      print (punten[i]);
    }
    print(punten);
  }

}
