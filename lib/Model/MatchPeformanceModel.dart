import 'dart:convert';

MatchPerformance matchPerformanceFromJson(String str) =>
    MatchPerformance.fromJson(json.decode(str));

String matchPerformanceToJson(MatchPerformance data) =>
    json.encode(data.toJson());

class MatchPerformance {
  List<PlayerPerformance> data;

  MatchPerformance({
    required this.data,
  });

  factory MatchPerformance.fromRawJson(String str) =>
      MatchPerformance.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory MatchPerformance.fromJson(Map<String, dynamic> json) =>
      MatchPerformance(
        data: List<PlayerPerformance>.from(
            json["data"].map((x) => PlayerPerformance.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class PlayerPerformance {
  String id;
  String playerId;
  String matchId;
  BattingPerformance battingPerformance;
  BowlingPerformance bowlingPerformance;
  FieldingPerformance fieldingPerformance;
  TotalPoints totalPoints;
  String matchFormat;
  String player_name;
  String role;
  String playerimage;
  String team;

  int v;

  PlayerPerformance({
    required this.id,
    required this.playerId,
    required this.matchId,
    required this.battingPerformance,
    required this.bowlingPerformance,
    required this.fieldingPerformance,
    required this.totalPoints,
    required this.matchFormat,
    required this.player_name,
    required this.role,
    required this.playerimage,
    required this.team,
    required this.v,
  });

  factory PlayerPerformance.fromRawJson(String str) =>
      PlayerPerformance.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory PlayerPerformance.fromJson(Map<String, dynamic> json) =>
      PlayerPerformance(
        id: json["_id"],
        playerId: json["player_id"],
        matchId: json["match_id"],
        battingPerformance:
            BattingPerformance.fromJson(json["batting_performance"]),
        bowlingPerformance:
            BowlingPerformance.fromJson(json["bowling_performance"]),
        fieldingPerformance:
            FieldingPerformance.fromJson(json["fielding_performance"]),
        totalPoints: TotalPoints.fromJson(json["total_points"]),
        matchFormat: json["match_format"],
        player_name: json["player_name"],
        role: json["role"],
        playerimage: json["playerimage"],
        team: json["team"],
        v: json["__v"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "player_id": playerId,
        "match_id": matchId,
        "batting_performance": battingPerformance.toJson(),
        "bowling_performance": bowlingPerformance.toJson(),
        "fielding_performance": fieldingPerformance.toJson(),
        "total_points": totalPoints.toJson(),
        "match_format": matchFormat,
        "__v": v,
      };
}

class BattingPerformance {
  TotalPoints runsScored;
  TotalPoints boundariesScored;
  TotalPoints sixesScored;
  String id;

  BattingPerformance({
    required this.runsScored,
    required this.boundariesScored,
    required this.sixesScored,
    required this.id,
  });

  factory BattingPerformance.fromRawJson(String str) =>
      BattingPerformance.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory BattingPerformance.fromJson(Map<String, dynamic> json) =>
      BattingPerformance(
        runsScored: TotalPoints.fromJson(json["runs_scored"]),
        boundariesScored: TotalPoints.fromJson(json["boundaries_scored"]),
        sixesScored: TotalPoints.fromJson(json["sixes_scored"]),
        id: json["_id"],
      );

  Map<String, dynamic> toJson() => {
        "runs_scored": runsScored.toJson(),
        "boundaries_scored": boundariesScored.toJson(),
        "sixes_scored": sixesScored.toJson(),
        "_id": id,
      };
}

class TotalPoints {
  int score;
  int point;
  String id;

  TotalPoints({
    required this.score,
    required this.point,
    required this.id,
  });

  factory TotalPoints.fromRawJson(String str) =>
      TotalPoints.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory TotalPoints.fromJson(Map<String, dynamic> json) => TotalPoints(
        score: json["score"],
        point: json["point"],
        id: json["_id"],
      );

  Map<String, dynamic> toJson() => {
        "score": score,
        "point": point,
        "_id": id,
      };
}

class BowlingPerformance {
  TotalPoints wicketsTaken;
  TotalPoints maidenOversBowled;
  String id;

  BowlingPerformance({
    required this.wicketsTaken,
    required this.maidenOversBowled,
    required this.id,
  });

  factory BowlingPerformance.fromRawJson(String str) =>
      BowlingPerformance.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory BowlingPerformance.fromJson(Map<String, dynamic> json) =>
      BowlingPerformance(
        wicketsTaken: TotalPoints.fromJson(json["wickets_taken"]),
        maidenOversBowled: TotalPoints.fromJson(json["maiden_overs_bowled"]),
        id: json["_id"],
      );

  Map<String, dynamic> toJson() => {
        "wickets_taken": wicketsTaken.toJson(),
        "maiden_overs_bowled": maidenOversBowled.toJson(),
        "_id": id,
      };
}

class FieldingPerformance {
  TotalPoints catchesTaken;
  TotalPoints runOutsAsThrower;
  TotalPoints runOutsAsCatcher;
  TotalPoints stumpings;
  String id;

  FieldingPerformance({
    required this.catchesTaken,
    required this.runOutsAsThrower,
    required this.runOutsAsCatcher,
    required this.stumpings,
    required this.id,
  });

  factory FieldingPerformance.fromRawJson(String str) =>
      FieldingPerformance.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory FieldingPerformance.fromJson(Map<String, dynamic> json) =>
      FieldingPerformance(
        catchesTaken: TotalPoints.fromJson(json["catches_taken"]),
        runOutsAsThrower: TotalPoints.fromJson(json["run_outs_as_thrower"]),
        runOutsAsCatcher: TotalPoints.fromJson(json["run_outs_as_catcher"]),
        stumpings: TotalPoints.fromJson(json["stumpings"]),
        id: json["_id"],
      );

  Map<String, dynamic> toJson() => {
        "catches_taken": catchesTaken.toJson(),
        "run_outs_as_thrower": runOutsAsThrower.toJson(),
        "run_outs_as_catcher": runOutsAsCatcher.toJson(),
        "stumpings": stumpings.toJson(),
        "_id": id,
      };
}
