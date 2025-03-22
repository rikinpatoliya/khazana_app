// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mutual_fund_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MutualFundModel _$MutualFundModelFromJson(Map<String, dynamic> json) =>
    MutualFundModel(
      id: json['id'] as String,
      name: json['name'] as String,
      category: json['category'] as String,
      amc: json['amc'] as String,
      nav: (json['nav'] as num).toDouble(),
      aum: (json['aum'] as num).toDouble(),
      expenseRatio: (json['expense_ratio'] as num).toDouble(),
      riskLevel: json['risk_level'] as String,
      returns: Returns.fromJson(json['returns'] as Map<String, dynamic>),
      navHistory: (json['nav_history'] as List<dynamic>)
          .map((e) => NavHistory.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$MutualFundModelToJson(MutualFundModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'category': instance.category,
      'amc': instance.amc,
      'nav': instance.nav,
      'aum': instance.aum,
      'expense_ratio': instance.expenseRatio,
      'risk_level': instance.riskLevel,
      'returns': instance.returns.toJson(),
      'nav_history': instance.navHistory.map((e) => e.toJson()).toList(),
    };

Returns _$ReturnsFromJson(Map<String, dynamic> json) => Returns(
      oneYear: (json['1y'] as num).toDouble(),
      threeYear: (json['3y'] as num).toDouble(),
      fiveYear: (json['5y'] as num).toDouble(),
    );

Map<String, dynamic> _$ReturnsToJson(Returns instance) => <String, dynamic>{
      '1y': instance.oneYear,
      '3y': instance.threeYear,
      '5y': instance.fiveYear,
    };

NavHistory _$NavHistoryFromJson(Map<String, dynamic> json) => NavHistory(
      date: json['date'] as String,
      value: (json['value'] as num).toDouble(),
    );

Map<String, dynamic> _$NavHistoryToJson(NavHistory instance) =>
    <String, dynamic>{
      'date': instance.date,
      'value': instance.value,
    };
