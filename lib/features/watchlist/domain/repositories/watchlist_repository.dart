import 'package:khazana_app/features/watchlist/data/models/watchlist_model.dart';

abstract class WatchlistRepository {
  Future<List<WatchlistModel>> getAllWatchlists();
  Future<WatchlistModel?> getWatchlistById(String id);
  Future<WatchlistModel> createWatchlist(String name);
  Future<WatchlistModel> updateWatchlist(WatchlistModel watchlist);
  Future<void> deleteWatchlist(String id);
  Future<WatchlistModel> addFundToWatchlist(String watchlistId, String fundId);
  Future<WatchlistModel> removeFundFromWatchlist(
    String watchlistId,
    String fundId,
  );
}
