// WatchList Events
import 'package:equatable/equatable.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:khazana_app/features/mutual_funds/data/models/mutual_fund_model.dart';
import 'package:khazana_app/features/watchlist/data/models/watchlist_model.dart';

// WatchListEvent
abstract class WatchListEvent extends Equatable {
  const WatchListEvent();

  @override
  List<Object?> get props => [];
}

class WatchListLoadAllEvent extends WatchListEvent {}

class WatchListLoadByIdEvent extends WatchListEvent {
  final String id;

  const WatchListLoadByIdEvent(this.id);

  @override
  List<Object?> get props => [id];
}
//  ////////////////////////////////

class WatchListCreateEvent extends WatchListEvent {
  final String name;

  const WatchListCreateEvent(this.name);

  @override
  List<Object?> get props => [name];
}

class WatchListUpdateEvent extends WatchListEvent {
  final WatchListModel watchList;

  const WatchListUpdateEvent(this.watchList);

  @override
  List<Object?> get props => [watchList];
}

class WatchListDeleteEvent extends WatchListEvent {
  final String id;

  const WatchListDeleteEvent(this.id);

  @override
  List<Object?> get props => [id];
}

class WatchListAddFundEvent extends WatchListEvent {
  final String watchListId;
  final MutualFundModel fundId;

  const WatchListAddFundEvent(this.watchListId, this.fundId);

  @override
  List<Object?> get props => [watchListId, fundId];
}

class WatchListRemoveFundEvent extends WatchListEvent {
  final String watchListId;
  final String fundId;

  const WatchListRemoveFundEvent(this.watchListId, this.fundId);

  @override
  List<Object?> get props => [watchListId, fundId];
}

// WatchListState
abstract class WatchListState extends Equatable {
  const WatchListState();

  @override
  List<Object?> get props => [];
}

class WatchListLoadingState extends WatchListState {}

class WatchListDetailLoadedState extends WatchListState {
  final WatchListModel watchList;

  const WatchListDetailLoadedState(this.watchList);

  @override
  List<Object?> get props => [watchList];
}

class WatchListErrorState extends WatchListState {
  final String message;

  const WatchListErrorState(this.message);

  @override
  List<Object?> get props => [message];
}
