import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:khazana_app/features/mutual_funds/data/models/mutual_fund_model.dart';

part 'watchlist_model.g.dart';

@JsonSerializable()
@HiveType(typeId: 1)
class WatchListModel {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final List<MutualFundModel> fundIds;

  @HiveField(3)
  final DateTime createdAt;

  @HiveField(4)
  final DateTime updatedAt;

  WatchListModel({
    required this.id,
    required this.name,
    required this.fundIds,
    required this.createdAt,
    required this.updatedAt,
  });

  factory WatchListModel.fromJson(Map<String, dynamic> json) =>
      _$WatchListModelFromJson(json);

  Map<String, dynamic> toJson() => _$WatchListModelToJson(this);
}
