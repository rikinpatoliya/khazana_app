import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'watchlist_model.g.dart';

@JsonSerializable()
@HiveType(typeId: 1)
class WatchlistModel {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final List<String> fundIds;

  @HiveField(3)
  final DateTime createdAt;

  @HiveField(4)
  final DateTime updatedAt;

  WatchlistModel({
    required this.id,
    required this.name,
    required this.fundIds,
    required this.createdAt,
    required this.updatedAt,
  });

  factory WatchlistModel.fromJson(Map<String, dynamic> json) =>
      _$WatchlistModelFromJson(json);

  Map<String, dynamic> toJson() => _$WatchlistModelToJson(this);
}
