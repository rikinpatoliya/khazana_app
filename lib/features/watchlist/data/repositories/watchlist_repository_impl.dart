import 'package:hive/hive.dart';
import 'package:khazana_app/features/watchlist/data/models/watchlist_model.dart';
import 'package:khazana_app/features/watchlist/domain/repositories/watchlist_repository.dart';
import 'package:uuid/uuid.dart';

class WatchlistRepositoryImpl implements WatchListRepository {
  final Box<WatchListModel> _watchListBox;
  final Uuid _uuid = const Uuid();

  WatchlistRepositoryImpl(this._watchListBox);

  @override
  Future<List<WatchListModel>> getAllWatchLists() async {
    return _watchListBox.values.toList();
  }

  @override
  Future<WatchListModel?> getWatchListById(String id) async {
    try {
      return _watchListBox.values.firstWhere((watchlist) => watchlist.id == id);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<WatchListModel> createWatchList(String name) async {
    final watchList = WatchListModel(
      id: _uuid.v4(),
      name: name,
      fundIds: [],
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    await _watchListBox.put(watchList.id, watchList);
    return watchList;
  }

  @override
  Future<WatchListModel> updateWatchList(WatchListModel watchList) async {
    final updatedWatchList = WatchListModel(
      id: watchList.id,
      name: watchList.name,
      fundIds: watchList.fundIds,
      createdAt: watchList.createdAt,
      updatedAt: DateTime.now(),
    );

    await _watchListBox.put(updatedWatchList.id, updatedWatchList);
    return updatedWatchList;
  }

  @override
  Future<void> deleteWatchList(String id) async {
    await _watchListBox.delete(id);
  }

  @override
  Future<WatchListModel> addFundToWatchList(
    String watchListId,
    String fundId,
  ) async {
    final watchList = await getWatchListById(watchListId);
    if (watchList == null) {
      throw Exception('WatchList not found');
    }

    if (watchList.fundIds.contains(fundId)) {
      return watchList; // Fund already in watchlist
    }

    final updatedFundIds = List<String>.from(watchList.fundIds)..add(fundId);
    final updatedWatchList = WatchListModel(
      id: watchList.id,
      name: watchList.name,
      fundIds: updatedFundIds,
      createdAt: watchList.createdAt,
      updatedAt: DateTime.now(),
    );

    await _watchListBox.put(updatedWatchList.id, updatedWatchList);
    return updatedWatchList;
  }

  @override
  Future<WatchListModel> removeFundFromWatchList(
    String watchListId,
    String fundId,
  ) async {
    final watchList = await getWatchListById(watchListId);
    if (watchList == null) {
      throw Exception('WatchList not found');
    }

    if (!watchList.fundIds.contains(fundId)) {
      return watchList; // Fund not in watchlist
    }

    final updatedFundIds = List<String>.from(watchList.fundIds)..remove(fundId);
    final updatedWatchList = WatchListModel(
      id: watchList.id,
      name: watchList.name,
      fundIds: updatedFundIds,
      createdAt: watchList.createdAt,
      updatedAt: DateTime.now(),
    );

    await _watchListBox.put(updatedWatchList.id, updatedWatchList);
    return updatedWatchList;
  }
}
