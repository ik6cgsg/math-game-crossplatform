import 'package:json_annotation/json_annotation.dart';
part 'game.g.dart';

@JsonSerializable()
class Game {
  final String firstName, lastName;
  final DateTime? dateOfBirth;

  Game({required this.firstName, required this.lastName, this.dateOfBirth});

  /// Connect the generated [_$GameFromJson] function to the `fromJson`
  /// factory.
  factory Game.fromJson(Map<String, dynamic> json) => _$GameFromJson(json);

  /// Connect the generated [_$GameToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$GameToJson(this);
}