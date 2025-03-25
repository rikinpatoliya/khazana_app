import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:khazana_app/core/constants/app_constants.dart';
import 'package:khazana_app/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:khazana_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:khazana_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:khazana_app/features/mutual_funds/data/repositories/mutual_fund_repository_impl.dart';
import 'package:khazana_app/features/mutual_funds/domain/repositories/mutual_fund_repository.dart';
import 'package:khazana_app/features/mutual_funds/presentation/bloc/mutual_fund_bloc.dart';
import 'package:khazana_app/features/watchlist/data/models/watchlist_model.dart';
import 'package:khazana_app/features/watchlist/data/repositories/watchlist_repository_impl.dart';
import 'package:khazana_app/features/watchlist/domain/repositories/watchlist_repository.dart';
import 'package:khazana_app/features/watchlist/presentation/bloc/watchlist_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final GetIt sl = GetIt.instance;

Future<void> initServiceLocator() async {
  // External Dependencies
  final supabaseClient = Supabase.instance.client;
  final sharedPreferences = await SharedPreferences.getInstance();
  final watchlistBox = Hive.box<WatchListModel>(AppConstants.watchlistBox);

  // Repositories
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(supabaseClient, sharedPreferences),
  );

  sl.registerLazySingleton<MutualFundRepository>(
    () => MutualFundRepositoryImpl(),
  );

  sl.registerLazySingleton<WatchListRepository>(
    () => WatchlistRepositoryImpl(watchlistBox),
  );

  // Blocs
  sl.registerFactory(() => AuthBloc(sl<AuthRepository>()));

  sl.registerFactory(() => MutualFundBloc(sl<MutualFundRepository>()));

  sl.registerFactory(() => WatchListBloc(sl<WatchListRepository>()));
}
