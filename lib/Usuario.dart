import 'package:flutter/material.dart';

class User {
  String id;
  String nick;
  String name;
  String surname;
  String email;
  String password;
  String rol;
  List<TournamentEntry> tournaments;
  int coins;
  List<AvatarEntry> avatars;
  List<RugEntry> rugs;
  List<CardEntry> cards;
  String token;

  User({
    required this.id,
    required this.nick,
    required this.name,
    required this.surname,
    required this.email,
    required this.password,
    this.rol = "user",
    this.tournaments = const [],
    required this.coins,
    this.avatars = const [],
    this.rugs = const [],
    this.cards = const [],
    required this.token,
  });
}

class TournamentEntry {
  String tournament;
  int round;

  TournamentEntry({
    required this.tournament,
    this.round = 8,
  });
}

class AvatarEntry {
  String avatar;
  bool current;

  AvatarEntry({
    required this.avatar,
    this.current = false,
  });
}

class RugEntry {
  String rug;
  bool current;

  RugEntry({
    required this.rug,
    this.current = false,
  });
}

class CardEntry {
  String card;
  bool current;

  CardEntry({
    required this.card,
    this.current = false,
  });
}
