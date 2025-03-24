import 'package:go_router/go_router.dart';
import 'package:khazana_app/features/auth/presentation/screens/login_screen.dart';
import 'package:khazana_app/features/auth/presentation/screens/signup_screen.dart';
import 'package:khazana_app/features/auth/presentation/screens/splash_screen.dart';
import 'package:khazana_app/features/dashboard/presentation/screens/dashboard_screen.dart';
import 'package:khazana_app/features/mutual_funds/data/models/mutual_fund_model.dart';
import 'package:khazana_app/features/mutual_funds/presentation/screens/fund_detail_screen.dart';
import 'package:khazana_app/features/watchlist/presentation/screens/watchlist_screen.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: Routes.splashRoute,
  routes: [
    GoRoute(
      path: Routes.splashRoute,
      name: Routes.splashRoute,
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: Routes.loginRoute,
      name: Routes.loginRoute,
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: Routes.signupRoute,
      name: Routes.signupRoute,
      builder: (context, state) => const SignupScreen(),
    ),
    GoRoute(
      path: Routes.dashboardRoute,
      name: Routes.dashboardRoute,
      builder: (context, state) => const DashboardScreen(),
    ),
    GoRoute(
      path: Routes.fundDetailRoute,
      name: Routes.fundDetailRoute,
      builder: (context, state) {
        return FundDetailScreen(fund: state.extra as MutualFundModel);
      },
    ),
    GoRoute(
      path: Routes.watchlistRoute,
      name: Routes.watchlistRoute,
      builder: (context, state) => const WatchlistScreen(),
    ),
  ],
);

abstract class Routes {
  // Route Constants
  static const String splashRoute = '/';
  static const String loginRoute = '/login';
  static const String signupRoute = '/signup';
  static const String dashboardRoute = '/dashboard';
  static const String fundDetailRoute = '/fund-detail';
  static const String watchlistRoute = '/watchlist';
}
