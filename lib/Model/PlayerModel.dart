// To parse this JSON data, do
//
//     final player = playerFromJson(jsonString);

import 'dart:convert';

List<Player> playerFromJson(String str) =>
    List<Player>.from(json.decode(str).map((x) => Player.fromJson(x)));

String playerToJson(List<Player> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Player {
  String matchkey;
  String playerkey;
  String buyRate;
  String image;
  bool isDisableBuy;
  bool isDisableSell;
  String isPremium;
  String name;
  String playerRate;
  String role;
  String sellRate;
  String team;
  String teamname;

  Player({
    required this.matchkey,
    required this.playerkey,
    required this.buyRate,
    required this.image,
    required this.isDisableBuy,
    required this.isDisableSell,
    required this.isPremium,
    required this.name,
    required this.playerRate,
    required this.role,
    required this.sellRate,
    required this.team,
    required this.teamname,
  });

  factory Player.fromJson(Map<String, dynamic> json) => Player(
        matchkey: json["matchkey"],
        playerkey: json["playerkey"],
        buyRate: json["buy_rate"],
        image: json["image"],
        isDisableBuy: json["is_disable_buy"],
        isDisableSell: json["is_disable_sell"],
        isPremium: json["is_premium"],
        name: json["name"],
        playerRate: json["player_rate"],
        role: json["role"],
        sellRate: json["sell_rate"],
        team: json["team"],
        teamname: json["teamname"],
      );

  Map<String, dynamic> toJson() => {
        "matchkey": matchkey,
        "playerkey": playerkey,
        "buy_rate": buyRate,
        "image": image,
        "is_disable_buy": isDisableBuy,
        "is_disable_sell": isDisableSell,
        "is_premium": isPremium,
        "name": name,
        "player_rate": playerRate,
        "role": role,
        "sell_rate": sellRate,
        "team": team,
        "teamname": teamname,
      };
}
