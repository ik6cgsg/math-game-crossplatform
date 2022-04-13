import 'package:json_annotation/json_annotation.dart';
part 'game_data.g.dart';

@JsonSerializable()
class Game {
  final String code;

  Game(this.code);

  factory Game.fromJson(Map<String, dynamic> json) => _$GameFromJson(json);
  Map<String, dynamic> toJson() => _$GameToJson(this);
}