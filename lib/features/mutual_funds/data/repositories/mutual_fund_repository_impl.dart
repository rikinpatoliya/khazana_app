import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:khazana_app/core/constants/app_constants.dart';
import 'package:khazana_app/features/mutual_funds/data/models/mutual_fund_model.dart';
import 'package:khazana_app/features/mutual_funds/domain/repositories/mutual_fund_repository.dart';

class MutualFundRepositoryImpl implements MutualFundRepository {
  List<MutualFundModel>? _cachedFunds;

  @override
  Future<List<MutualFundModel>> getAllMutualFunds() async {
    if (_cachedFunds != null) {
      return _cachedFunds!;
    }

    try {
      final String jsonString = await rootBundle.loadString(
        AppConstants.mutualFundsDataPath,
      );
      final List<dynamic> jsonList = json.decode(jsonString) as List<dynamic>;
      _cachedFunds =
          jsonList
              .map(
                (json) =>
                    MutualFundModel.fromJson(json as Map<String, dynamic>),
              )
              .toList();
      return _cachedFunds!;
    } catch (e) {
      throw Exception('Failed to load mutual funds data: ${e.toString()}');
    }
  }

  @override
  Future<MutualFundModel?> getMutualFundById(String id) async {
    final funds = await getAllMutualFunds();
    try {
      return funds.firstWhere((fund) => fund.id == id);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<List<MutualFundModel>> getMutualFundsByCategory(
    String category,
  ) async {
    final funds = await getAllMutualFunds();
    return funds
        .where((fund) => fund.category.toLowerCase() == category.toLowerCase())
        .toList();
  }

  @override
  Future<List<MutualFundModel>> searchMutualFunds(String query) async {
    if (query.isEmpty) {
      return getAllMutualFunds();
    }

    final funds = await getAllMutualFunds();
    final lowercaseQuery = query.toLowerCase();

    return funds.where((fund) {
      return fund.name.toLowerCase().contains(lowercaseQuery) ||
          fund.category.toLowerCase().contains(lowercaseQuery) ||
          fund.amc.toLowerCase().contains(lowercaseQuery);
    }).toList();
  }
}
