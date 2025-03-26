// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mutual_fund_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MutualFundModelAdapter extends TypeAdapter<MutualFundModel> {
  @override
  final int typeId = 2;

  @override
  MutualFundModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MutualFundModel(
      id: fields[0] as String,
      name: fields[1] as String,
      category: fields[2] as String,
      amc: fields[3] as String,
      nav: fields[4] as double,
      aum: fields[5] as double,
      expenseRatio: fields[6] as double,
      riskLevel: fields[7] as String,
      currentValue: fields[9] as double,
      investedAmount: fields[8] as double,
      totalGain: fields[10] as double,
      totalChangePercent: fields[11] as double,
      returns: fields[12] as Returns,
      navHistory: (fields[13] as List).cast<NavHistory>(),
    );
  }

  @override
  void write(BinaryWriter writer, MutualFundModel obj) {
    writer
      ..writeByte(14)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.category)
      ..writeByte(3)
      ..write(obj.amc)
      ..writeByte(4)
      ..write(obj.nav)
      ..writeByte(5)
      ..write(obj.aum)
      ..writeByte(6)
      ..write(obj.expenseRatio)
      ..writeByte(7)
      ..write(obj.riskLevel)
      ..writeByte(8)
      ..write(obj.investedAmount)
      ..writeByte(9)
      ..write(obj.currentValue)
      ..writeByte(10)
      ..write(obj.totalGain)
      ..writeByte(11)
      ..write(obj.totalChangePercent)
      ..writeByte(12)
      ..write(obj.returns)
      ..writeByte(13)
      ..write(obj.navHistory);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MutualFundModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ReturnsAdapter extends TypeAdapter<Returns> {
  @override
  final int typeId = 3;

  @override
  Returns read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Returns(
      oneYear: fields[0] as double,
      threeYear: fields[1] as double,
      fiveYear: fields[2] as double,
    );
  }

  @override
  void write(BinaryWriter writer, Returns obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.oneYear)
      ..writeByte(1)
      ..write(obj.threeYear)
      ..writeByte(2)
      ..write(obj.fiveYear);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ReturnsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class NavHistoryAdapter extends TypeAdapter<NavHistory> {
  @override
  final int typeId = 4;

  @override
  NavHistory read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return NavHistory(
      date: fields[0] as String,
      value: fields[1] as double,
    );
  }

  @override
  void write(BinaryWriter writer, NavHistory obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.date)
      ..writeByte(1)
      ..write(obj.value);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NavHistoryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

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
      currentValue: (json['current_value'] as num).toDouble(),
      investedAmount: (json['invested_amount'] as num).toDouble(),
      totalGain: (json['total_gain'] as num).toDouble(),
      totalChangePercent: (json['total_change_percent'] as num).toDouble(),
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
      'invested_amount': instance.investedAmount,
      'current_value': instance.currentValue,
      'total_gain': instance.totalGain,
      'total_change_percent': instance.totalChangePercent,
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
