import 'package:json_annotation/json_annotation.dart';

part 'mutual_fund_model.g.dart';

@JsonSerializable(explicitToJson: true)
class MutualFundModel {
  final String id;
  final String name;
  final String category;
  final String amc;
  final double nav;
  final double aum;
  @JsonKey(name: 'expense_ratio')
  final double expenseRatio;
  @JsonKey(name: 'risk_level')
  final String riskLevel;
  final Returns returns;
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
    required this.returns,
    required this.navHistory,
  });

  factory MutualFundModel.fromJson(Map<String, dynamic> json) =>
      _$MutualFundModelFromJson(json);

  Map<String, dynamic> toJson() => _$MutualFundModelToJson(this);
}

@JsonSerializable()
class Returns {
  @JsonKey(name: '1y')
  final double oneYear;
  @JsonKey(name: '3y')
  final double threeYear;
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
class NavHistory {
  final String date;
  final double value;

  NavHistory({required this.date, required this.value});

  factory NavHistory.fromJson(Map<String, dynamic> json) =>
      _$NavHistoryFromJson(json);

  Map<String, dynamic> toJson() => _$NavHistoryToJson(this);
}
