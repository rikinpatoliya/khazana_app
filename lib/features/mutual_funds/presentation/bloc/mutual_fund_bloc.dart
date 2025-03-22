import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:khazana_app/features/mutual_funds/data/models/mutual_fund_model.dart';
import 'package:khazana_app/features/mutual_funds/domain/repositories/mutual_fund_repository.dart';

// Events
abstract class MutualFundEvent extends Equatable {
  const MutualFundEvent();

  @override
  List<Object?> get props => [];
}

class MutualFundLoadAllEvent extends MutualFundEvent {}

class MutualFundLoadByIdEvent extends MutualFundEvent {
  final String id;

  const MutualFundLoadByIdEvent(this.id);

  @override
  List<Object?> get props => [id];
}

class MutualFundLoadByCategoryEvent extends MutualFundEvent {
  final String category;

  const MutualFundLoadByCategoryEvent(this.category);

  @override
  List<Object?> get props => [category];
}

class MutualFundSearchEvent extends MutualFundEvent {
  final String query;

  const MutualFundSearchEvent(this.query);

  @override
  List<Object?> get props => [query];
}

// States
abstract class MutualFundState extends Equatable {
  const MutualFundState();

  @override
  List<Object?> get props => [];
}

class MutualFundInitialState extends MutualFundState {}

class MutualFundLoadingState extends MutualFundState {}

class MutualFundLoadedState extends MutualFundState {
  final List<MutualFundModel> funds;

  const MutualFundLoadedState(this.funds);

  @override
  List<Object?> get props => [funds];
}

class MutualFundDetailLoadedState extends MutualFundState {
  final MutualFundModel fund;

  const MutualFundDetailLoadedState(this.fund);

  @override
  List<Object?> get props => [fund];
}

class MutualFundErrorState extends MutualFundState {
  final String message;

  const MutualFundErrorState(this.message);

  @override
  List<Object?> get props => [message];
}

// BLoC
class MutualFundBloc extends Bloc<MutualFundEvent, MutualFundState> {
  final MutualFundRepository _mutualFundRepository;

  MutualFundBloc(this._mutualFundRepository) : super(MutualFundInitialState()) {
    on<MutualFundLoadAllEvent>(_onLoadAll);
    on<MutualFundLoadByIdEvent>(_onLoadById);
    on<MutualFundLoadByCategoryEvent>(_onLoadByCategory);
    on<MutualFundSearchEvent>(_onSearch);
  }

  Future<void> _onLoadAll(
    MutualFundLoadAllEvent event,
    Emitter<MutualFundState> emit,
  ) async {
    emit(MutualFundLoadingState());
    try {
      final funds = await _mutualFundRepository.getAllMutualFunds();
      emit(MutualFundLoadedState(funds));
    } catch (e) {
      emit(MutualFundErrorState(e.toString()));
    }
  }

  Future<void> _onLoadById(
    MutualFundLoadByIdEvent event,
    Emitter<MutualFundState> emit,
  ) async {
    emit(MutualFundLoadingState());
    try {
      final fund = await _mutualFundRepository.getMutualFundById(event.id);
      if (fund != null) {
        emit(MutualFundDetailLoadedState(fund));
      } else {
        emit(const MutualFundErrorState('Fund not found'));
      }
    } catch (e) {
      emit(MutualFundErrorState(e.toString()));
    }
  }

  Future<void> _onLoadByCategory(
    MutualFundLoadByCategoryEvent event,
    Emitter<MutualFundState> emit,
  ) async {
    emit(MutualFundLoadingState());
    try {
      final funds = await _mutualFundRepository.getMutualFundsByCategory(
        event.category,
      );
      emit(MutualFundLoadedState(funds));
    } catch (e) {
      emit(MutualFundErrorState(e.toString()));
    }
  }

  Future<void> _onSearch(
    MutualFundSearchEvent event,
    Emitter<MutualFundState> emit,
  ) async {
    emit(MutualFundLoadingState());
    try {
      final funds = await _mutualFundRepository.searchMutualFunds(event.query);
      emit(MutualFundLoadedState(funds));
    } catch (e) {
      emit(MutualFundErrorState(e.toString()));
    }
  }
}
