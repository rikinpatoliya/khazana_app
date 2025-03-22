import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:khazana_app/core/constants/app_constants.dart';
import 'package:khazana_app/core/theme/app_theme.dart';
import 'package:khazana_app/features/auth/data/models/user_model.dart';
import 'package:khazana_app/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:khazana_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:khazana_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:khazana_app/features/auth/presentation/screens/login_screen.dart';
import 'package:khazana_app/features/dashboard/presentation/screens/dashboard_screen.dart';
import 'package:khazana_app/features/mutual_funds/data/repositories/mutual_fund_repository_impl.dart';
import 'package:khazana_app/features/mutual_funds/domain/repositories/mutual_fund_repository.dart';
import 'package:khazana_app/features/mutual_funds/presentation/bloc/mutual_fund_bloc.dart';
import 'package:khazana_app/features/watchlist/data/models/watchlist_model.dart';
import 'package:khazana_app/features/watchlist/data/repositories/watchlist_repository_impl.dart';
import 'package:khazana_app/features/watchlist/domain/repositories/watchlist_repository.dart';
import 'package:khazana_app/features/watchlist/presentation/bloc/watchlist_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Supabase
  await supabase.Supabase.initialize(
    url: 'YOUR_SUPABASE_URL', // Replace with your Supabase URL
    anonKey: 'YOUR_SUPABASE_ANON_KEY', // Replace with your Supabase Anon Key
  );

  // Initialize Hive
  await Hive.initFlutter();

  // Register Hive adapters
  Hive.registerAdapter(UserModelAdapter());
  Hive.registerAdapter(WatchlistModelAdapter());

  // Open Hive boxes
  await Hive.openBox<WatchlistModel>(AppConstants.watchlistBox);
  await Hive.openBox<UserModel>(AppConstants.userBox);

  // Get SharedPreferences instance
  final sharedPreferences = await SharedPreferences.getInstance();

  runApp(MyApp(sharedPreferences: sharedPreferences));
}

class MyApp extends StatelessWidget {
  final SharedPreferences sharedPreferences;

  const MyApp({super.key, required this.sharedPreferences});

  @override
  Widget build(BuildContext context) {
    // Get Supabase client
    final supabaseClient = supabase.Supabase.instance.client;

    // Get Hive boxes
    final watchlistBox = Hive.box<WatchlistModel>(AppConstants.watchlistBox);

    // Initialize repositories
    final AuthRepository authRepository = AuthRepositoryImpl(
      supabaseClient,
      sharedPreferences,
    );

    final MutualFundRepository mutualFundRepository =
        MutualFundRepositoryImpl();

    final WatchlistRepository watchlistRepository = WatchlistRepositoryImpl(
      watchlistBox,
    );

    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create:
              (context) =>
                  AuthBloc(authRepository)..add(AuthCheckStatusEvent()),
        ),
        BlocProvider<MutualFundBloc>(
          create: (context) => MutualFundBloc(mutualFundRepository),
        ),
        BlocProvider<WatchlistBloc>(
          create: (context) => WatchlistBloc(watchlistRepository),
        ),
      ],
      child: MaterialApp(
        title: 'Khazana - Mutual Fund Analytics',
        theme: AppTheme.lightTheme,
        debugShowCheckedModeBanner: false,
        initialRoute: AppConstants.splashRoute,
        routes: {
          AppConstants.splashRoute:
              (context) => BlocBuilder<AuthBloc, AuthState>(
                builder: (context, state) {
                  if (state is AuthLoadingState) {
                    return const Scaffold(
                      body: Center(child: CircularProgressIndicator()),
                    );
                  } else if (state is AuthAuthenticatedState) {
                    return const DashboardScreen();
                  } else {
                    return const LoginScreen();
                  }
                },
              ),
          AppConstants.loginRoute: (context) => const LoginScreen(),
          AppConstants.dashboardRoute: (context) => const DashboardScreen(),
        },
      ),
    );
  }
}
