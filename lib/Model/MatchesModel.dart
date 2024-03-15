// To parse this JSON data, do
//
//     final match = matchFromJson(jsonString);

import 'dart:convert';

Match matchFromJson(String str) => Match.fromJson(json.decode(str));

String matchToJson(Match data) => json.encode(data.toJson());

class Match {
  List<MatchElement> matches;

  Match({
    required this.matches,
  });

  factory Match.fromJson(Map<String, dynamic> json) => Match(
        matches: List<MatchElement>.from(
            json["matches"].map((x) => MatchElement.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "matches": List<dynamic>.from(matches.map((x) => x.toJson())),
      };

  // Method to sort matches based on start date
  void sortMatchesByStartDate() {
    matches.sort((a, b) => a.startDate.compareTo(b.startDate));
  }
}

class MatchElement {
  String matchId;
  String seriesname;
  String resultStatus;
  String playing11Status;
  String status;
  String format;
  String finalStatus;
  String team1Display;
  String team2Display;
  String team1Logo;
  String team2Logo;
  String matchkey;
  String popupUrl;
  DateTime startDate;
  String matchTime;
  String success;
  String matchDiscount;
  String matchStatus;

  MatchElement({
    required this.matchId,
    required this.seriesname,
    required this.resultStatus,
    required this.playing11Status,
    required this.status,
    required this.format,
    required this.finalStatus,
    required this.team1Display,
    required this.team2Display,
    required this.team1Logo,
    required this.team2Logo,
    required this.matchkey,
    required this.popupUrl,
    required this.startDate,
    required this.matchTime,
    required this.success,
    required this.matchDiscount,
    required this.matchStatus,
  });

  factory MatchElement.fromJson(Map<String, dynamic> json) => MatchElement(
        matchId: json["id"],
        seriesname: json["seriesname"],
        resultStatus: json["result_status"],
        playing11Status: json["playing11_status"],
        status: json["status"],
        format: json["format"],
        finalStatus: json["final_status"],
        team1Display: json["team1display"],
        team2Display: json["team2display"],
        team1Logo: json["team1logo"],
        team2Logo: json["team2logo"],
        matchkey: json["matchkey"],
        popupUrl: json["popup_url"],
        startDate: DateTime.parse(json["start_date"]),
        matchTime: json["match_time"],
        success: json["success"],
        matchDiscount: json["match_discount"],
        matchStatus: json["match_status"],
      );

  Map<String, dynamic> toJson() => {
        "id": matchId,
        "seriesname": seriesname,
        "result_status": resultStatus,
        "playing11_status": playing11Status,
        "status": status,
        "format": format,
        "final_status": finalStatus,
        "team1display": team1Display,
        "team2display": team2Display,
        "team1logo": team1Logo,
        "team2logo": team2Logo,
        "matchkey": matchkey,
        "popup_url": popupUrl,
        "start_date": startDate.toIso8601String(),
        "match_time": matchTime,
        "success": success,
        "match_discount": matchDiscount,
        "match_status": matchStatus,
      };
}
