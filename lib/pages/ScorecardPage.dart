// ignore_for_file: prefer_const_constructors

import 'package:fanxange/Model/PlayerModel.dart';
import 'package:fanxange/appwrite/database_api.dart';
import 'package:fanxange/appwrite/performance_provider.dart';
import 'package:fanxange/components/PlayerListTile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Scorecard extends StatelessWidget {
  static String routeName = "/scorecard";

  const Scorecard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final performanceApi = context.watch<PerformanceProvider>();
    final databaseAPI = context.watch<DatabaseAPI>();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Fantasy Scorecard",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: [
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(0.0), // Radius for the top corners
                bottom: Radius.circular(0.0), // Radius for the bottom corners
              ),
            ),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("PLAYER"), // Player name on the left
                  Text("POINTS"), // Points on the right
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: performanceApi.matchPerformance.data?.length,
              itemBuilder: (BuildContext context, int index) {
                var playerData = performanceApi.matchPerformance.data?[index];
                var teamname = '';

                if (playerData?.team == 'team1') {
                  teamname = databaseAPI.matchdata.team1Display;
                } else {
                  teamname = databaseAPI.matchdata.team2Display;
                }
                Player player = Player(
                    matchkey: playerData!.matchId,
                    playerkey: playerData.playerId,
                    buyRate: '0',
                    image: playerData.playerimage,
                    isDisableBuy: false,
                    isDisableSell: false,
                    isPremium: '0',
                    name: playerData.player_name,
                    playerRate: '0',
                    role: playerData.role,
                    sellRate: '0',
                    team: playerData.team,
                    teamname: teamname);
                return PlayerListTile(
                  playersdata: player,
                  showButtons: false,
                  points: playerData.totalPoints.point.toString(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
