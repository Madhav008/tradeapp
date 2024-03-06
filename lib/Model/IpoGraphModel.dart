import 'dart:convert';

List<GraphModel> graphModelFromJson(String str) =>
    List<GraphModel>.from(json.decode(str).map((x) => GraphModel.fromJson(x)));

String graphModelToJson(List<GraphModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class GraphModel {
  String date;
  int premium;

  GraphModel({
    required this.date,
    required this.premium,
  });

  factory GraphModel.fromJson(Map<String, dynamic> json) => GraphModel(
        date: json["date"],
        premium: json["premium"],
      );

  Map<String, dynamic> toJson() => {
        "date": date,
        "premium": premium,
      };
}
