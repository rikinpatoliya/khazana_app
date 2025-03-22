import 'package:khazana_app/features/mutual_funds/data/models/mutual_fund_model.dart';

abstract class MutualFundRepository {
  Future<List<MutualFundModel>> getAllMutualFunds();
  Future<MutualFundModel?> getMutualFundById(String id);
  Future<List<MutualFundModel>> getMutualFundsByCategory(String category);
  Future<List<MutualFundModel>> searchMutualFunds(String query);
}
