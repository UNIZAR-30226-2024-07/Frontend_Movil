import 'package:flutter/material.dart';
import 'colores.dart';

class Mano {
  String userId;
  List<dynamic> cartas = [];
  int totalCards;
  bool myDefeat;
  bool plantado;
  bool myBlackjack;
  bool firstHand;

  Mano({
  this.userId = "",
  this.cartas = const [],
  this.totalCards = 0,
  this.myDefeat = false,
  this.plantado = false,
  this.myBlackjack = false,
  this.firstHand = true,
  });

  void initMano(_userId,_cartas,_totalCards,_myDefeat,_plantado,_myBlackjack,_firstHand){
    this.userId = _userId;
    this.cartas = _cartas;
    this.totalCards = _totalCards;
    this.myDefeat = _myDefeat;
    this.plantado = _plantado;
    this.myBlackjack = _myBlackjack;
    this.firstHand = _firstHand;
  }
}
