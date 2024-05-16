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

class ResultadosMano {
  String userId;
  String userNick;
  dynamic cartas = [];
  List<dynamic> total = [];
  int totalTorneo = 0;
  int totalBanca = 0;
  List<dynamic> coinsEarned = [];
  int currentCoins;
  double vidas = 4;

  ResultadosMano({
    this.userId = "",
    this.userNick = "",
    this.cartas = const [],
    this.total = const [],
    this.coinsEarned = const [],
    this.currentCoins = 0,
  });


  void initResultadoMano(_userId,_nick,_cartas,_total,_coinsEarned,_currentCoins){
    this.userId = _userId;
    this.userNick = _nick;
    this.cartas = _cartas;
    this.total = _total;
    this.coinsEarned = _coinsEarned;
    this.currentCoins = _currentCoins;
  }

  void initResultadoManoBanca(_userId,_nick,_cartas,_total){
    this.userId = _userId;
    this.userNick = _nick;
    this.cartas = _cartas;
    this.totalBanca = _total;
  }

  void initResultadoManoTorneos(_userId,_nick,_cartas,_total, _vidas){
    print("MI userId ------------------");
    this.userId = _userId;
    print("MI userNick ------------------");
    this.userNick = _nick;
    print("MI cartas ------------------");
    this.cartas = _cartas;
    print("MI total ------------------");
    this.totalTorneo = _total;
    print("MI vidas ------------------");
    this.vidas = double.parse(_vidas.toString());
  }


}
