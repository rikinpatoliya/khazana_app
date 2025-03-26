import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'mutual_fund_model.g.dart';

@JsonSerializable(explicitToJson: true)
@HiveType(typeId: 2)
class MutualFundModel {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String name;
  @HiveField(2)
  final String category;
  @HiveField(3)
  final String amc;
  @HiveField(4)
  final double nav;
  @HiveField(5)
  final double aum;
  @HiveField(6)
  @JsonKey(name: 'expense_ratio')
  final double expenseRatio;
  @HiveField(7)
  @JsonKey(name: 'risk_level')
  final String riskLevel;
  @HiveField(8)
  @JsonKey(name: 'invested_amount')
  final double investedAmount;
  @HiveField(9)
  @JsonKey(name: 'current_value')
  final double currentValue;
  @HiveField(10)
  @JsonKey(name: 'total_gain')
  final double totalGain;
  @HiveField(11)
  @JsonKey(name: 'total_change_percent')
  final double totalChangePercent;
  @HiveField(12)
  final Returns returns;
  @HiveField(13)
  @JsonKey(name: 'nav_history')
  final List<NavHistory> navHistory;

  MutualFundModel({
    required this.id,
    required this.name,
    required this.category,
    required this.amc,
    required this.nav,
    required this.aum,
    required this.expenseRatio,
    required this.riskLevel,
    required this.currentValue,
    required this.investedAmount,
    required this.totalGain,
    required this.totalChangePercent,
    required this.returns,
    required this.navHistory,
  });

  factory MutualFundModel.fromJson(Map<String, dynamic> json) =>
      _$MutualFundModelFromJson(json);

  Map<String, dynamic> toJson() => _$MutualFundModelToJson(this);
}

@JsonSerializable()
@HiveType(typeId: 3)
class Returns {
  @HiveField(0)
  @JsonKey(name: '1y')
  final double oneYear;
  @HiveField(1)
  @JsonKey(name: '3y')
  final double threeYear;
  @HiveField(2)
  @JsonKey(name: '5y')
  final double fiveYear;

  Returns({
    required this.oneYear,
    required this.threeYear,
    required this.fiveYear,
  });

  factory Returns.fromJson(Map<String, dynamic> json) =>
      _$ReturnsFromJson(json);

  Map<String, dynamic> toJson() => _$ReturnsToJson(this);
}

@JsonSerializable()
@HiveType(typeId: 4)
class NavHistory {
  @HiveField(0)
  final String date;
  @HiveField(1)
  final double value;

  NavHistory({required this.date, required this.value});

  factory NavHistory.fromJson(Map<String, dynamic> json) =>
      _$NavHistoryFromJson(json);

  Map<String, dynamic> toJson() => _$NavHistoryToJson(this);
}
