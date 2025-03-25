import 'package:khazana_app/features/watchlist/data/models/watchlist_model.dart';

abstract class WatchListRepository {
  Future<List<WatchListModel>> getAllWatchLists();
  Future<WatchListModel?> getWatchListById(String id);
  Future<WatchListModel> createWatchList(String name);
  Future<WatchListModel> updateWatchList(WatchListModel watchlist);
  Future<void> deleteWatchList(String id);
  Future<WatchListModel> addFundToWatchList(String watchlistId, String fundId);
  Future<WatchListModel> removeFundFromWatchList(
    String watchlistId,
    String fundId,
  );
}
