import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:khazana_app/core/constants/app_constants.dart';
import 'package:khazana_app/core/di/service_locator.dart';
import 'package:khazana_app/core/router/app_router.dart';
import 'package:khazana_app/core/theme/app_theme.dart';
import 'package:khazana_app/core/utils/snackbar_utils.dart';
import 'package:khazana_app/features/auth/data/models/user_model.dart';
import 'package:khazana_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:khazana_app/features/mutual_funds/data/models/mutual_fund_model.dart';
import 'package:khazana_app/features/mutual_funds/presentation/bloc/mutual_fund_bloc.dart';
import 'package:khazana_app/features/watchlist/data/models/watchlist_model.dart';
import 'package:khazana_app/features/watchlist/presentation/bloc/watchlist_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Supabase
  await supabase.Supabase.initialize(
    url:
        'https://fnekhxxwmrspndkmqrow.supabase.co', // Replace with your Supabase URL
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImZuZWtoeHh3bXJzcG5ka21xcm93Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDI4MDU1MTUsImV4cCI6MjA1ODM4MTUxNX0.EkScuPnYGx2dLE6EVIrcBZxNyFrB7X0cl_0TwAn6m5w', // Replace with your Supabase Anon Key
  );

  // Initialize Hive
  await Hive.initFlutter();

  // Register Hive adapters
  Hive.registerAdapter(UserModelAdapter());
  Hive.registerAdapter(WatchListModelAdapter());
  Hive.registerAdapter(MutualFundModelAdapter());
  Hive.registerAdapter(ReturnsAdapter());
  Hive.registerAdapter(NavHistoryAdapter());

  // Open Hive boxes
  await Hive.openBox<WatchListModel>(AppConstants.watchlistBox);
  await Hive.openBox<MutualFundModel>(AppConstants.mutualFundBox);
  await Hive.openBox<UserModel>(AppConstants.userBox);

  // Initialize service locator
  await initServiceLocator();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (context) => sl<AuthBloc>()..add(AuthCheckStatusEvent()),
        ),
        BlocProvider<MutualFundBloc>(create: (context) => sl<MutualFundBloc>()),
        BlocProvider<WatchListBloc>(create: (context) => sl<WatchListBloc>()),
      ],
      child: MaterialApp.router(
        scaffoldMessengerKey: SnackBarUtils.scaffoldMessengerKey,
        title: 'Khazana - Mutual Fund Analytics',
        theme: AppTheme.darkTheme,
        debugShowCheckedModeBanner: false,
        routerConfig: appRouter,
        /*  builder:
            (context, child) => BlocBuilder<AuthBloc, AuthState>(
              builder: (context, state) {
                if (state is AuthLoadingState) {
                  return const Scaffold(
                    body: Center(child: CircularProgressIndicator()),
                  );
                }
                return child!;
              },
            ), */
      ),
    );
  }
}
