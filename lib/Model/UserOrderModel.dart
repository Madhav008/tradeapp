import 'package:fanxange/Model/MatchesModel.dart';
import 'package:fanxange/Model/PlayerModel.dart';
import 'package:fanxange/appwrite/database_api.dart';

class UserOrder {
  MatchElement match;
  List<PlayerOrder> playerOrders;

  UserOrder({
    required this.match,
    required this.playerOrders,
  });

  factory UserOrder.fromJson(Map<String, dynamic> json) {
    // Assuming 'match' and 'players' keys are present in the JSON
    return UserOrder(
      match: MatchElement.fromJson(json['match']),
      playerOrders: List<PlayerOrder>.from(
        (json['players'] as List).map(
          (playerInfo) => PlayerOrder.fromJson(playerInfo),
        ),
      ),
    );
  }
}

class PlayerOrder {
  Player player;
  List<Order> orders;

  PlayerOrder({
    required this.player,
    required this.orders,
  });

  factory PlayerOrder.fromJson(Map<String, dynamic> json) {
    return PlayerOrder(
      player: Player.fromJson(json['playerInfo']),
      orders: List<Order>.from(
        (json['orders'] as List).map(
          (orderInfo) => Order.fromJson(orderInfo),
        ),
      ),
    );
  }
}
