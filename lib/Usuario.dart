import 'package:flutter/material.dart';
import 'colores.dart';


void actualizarUsuario(context, getConnect, user) async {
  final res = await getConnect.post('${EnlaceApp.enlaceBase}/api/user/verify', {},
    headers: {
      "Authorization": user.token,
    },
  );

  if (res.body['status'] == 'error') {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(res.body['message'], textAlign: TextAlign.center,),
      ),
    );
  } else {
    User NewUser = User(
        id: res.body['user']['_id'],
        nick: res.body['user']['nick'],
        name: res.body['user']['name'],
        surname: res.body['user']['surname'],
        email: res.body['user']['email'],
        password: res.body['user']['password'],
        rol: res.body['user']['rol'],
        tournaments: [],
        coins: res.body['user']['coins'].toInt(),
        avatars: [],
        rugs: [],
        cards: [],
        token: res.body['token']);

    // Bucle para agregar cada avatar a la lista de avatares del usuario
    for (var tournamentData in res.body['user']['tournaments']) {
      NewUser.tournaments.add(TournamentEntry(
        tournament: tournamentData['tournament'],
        round: tournamentData['position'],
      ));
    }

    // Bucle para agregar cada avatar a la lista de avatares del usuario
    for (var avatarData in res.body['user']['avatars']) {
      NewUser.avatars.add(AvatarEntry(
        avatar: avatarData['avatar'],
        current: avatarData['current'],
      ));
    }

    // Bucle para agregar cada avatar a la lista de avatares del usuario
    for (var rugData in res.body['user']['rugs']) {
      NewUser.rugs.add(RugEntry(
        rug: rugData['rug'],
        current: rugData['current'],
      ));
    }

    // Bucle para agregar cada avatar a la lista de avatares del usuario
    for (var cardData in res.body['user']['cards']) {
      NewUser.cards.add(CardEntry(
        card: cardData['card'],
        current: cardData['current'],
      ));
    }
    user = NewUser;
  }
}

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
