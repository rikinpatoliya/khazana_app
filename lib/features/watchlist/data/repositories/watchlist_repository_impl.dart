import 'package:hive/hive.dart';
import 'package:khazana_app/core/constants/app_constants.dart';
import 'package:khazana_app/features/watchlist/data/models/watchlist_model.dart';
import 'package:khazana_app/features/watchlist/domain/repositories/watchlist_repository.dart';
import 'package:uuid/uuid.dart';

class WatchlistRepositoryImpl implements WatchlistRepository {
  final Box<WatchlistModel> _watchlistBox;
  final Uuid _uuid = const Uuid();

  WatchlistRepositoryImpl(this._watchlistBox);

  @override
  Future<List<WatchlistModel>> getAllWatchlists() async {
    return _watchlistBox.values.toList();
  }

  @override
  Future<WatchlistModel?> getWatchlistById(String id) async {
    try {
      return _watchlistBox.values.firstWhere((watchlist) => watchlist.id == id);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<WatchlistModel> createWatchlist(String name) async {
    final watchlist = WatchlistModel(
      id: _uuid.v4(),
      name: name,
      fundIds: [],
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    await _watchlistBox.put(watchlist.id, watchlist);
    return watchlist;
  }

  @override
  Future<WatchlistModel> updateWatchlist(WatchlistModel watchlist) async {
    final updatedWatchlist = WatchlistModel(
      id: watchlist.id,
      name: watchlist.name,
      fundIds: watchlist.fundIds,
      createdAt: watchlist.createdAt,
      updatedAt: DateTime.now(),
    );

    await _watchlistBox.put(updatedWatchlist.id, updatedWatchlist);
    return updatedWatchlist;
  }

  @override
  Future<void> deleteWatchlist(String id) async {
    await _watchlistBox.delete(id);
  }

  @override
  Future<WatchlistModel> addFundToWatchlist(
    String watchlistId,
    String fundId,
  ) async {
    final watchlist = await getWatchlistById(watchlistId);
    if (watchlist == null) {
      throw Exception('Watchlist not found');
    }

    if (watchlist.fundIds.contains(fundId)) {
      return watchlist; // Fund already in watchlist
    }

    final updatedFundIds = List<String>.from(watchlist.fundIds)..add(fundId);
    final updatedWatchlist = WatchlistModel(
      id: watchlist.id,
      name: watchlist.name,
      fundIds: updatedFundIds,
      createdAt: watchlist.createdAt,
      updatedAt: DateTime.now(),
    );

    await _watchlistBox.put(updatedWatchlist.id, updatedWatchlist);
    return updatedWatchlist;
  }

  @override
  Future<WatchlistModel> removeFundFromWatchlist(
    String watchlistId,
    String fundId,
  ) async {
    final watchlist = await getWatchlistById(watchlistId);
    if (watchlist == null) {
      throw Exception('Watchlist not found');
    }

    if (!watchlist.fundIds.contains(fundId)) {
      return watchlist; // Fund not in watchlist
    }

    final updatedFundIds = List<String>.from(watchlist.fundIds)..remove(fundId);
    final updatedWatchlist = WatchlistModel(
      id: watchlist.id,
      name: watchlist.name,
      fundIds: updatedFundIds,
      createdAt: watchlist.createdAt,
      updatedAt: DateTime.now(),
    );

    await _watchlistBox.put(updatedWatchlist.id, updatedWatchlist);
    return updatedWatchlist;
  }
}
