class AppConstants {
  // API Constants
  static const String baseUrl = 'https://api.example.com';

  // Route Constants
  static const String splashRoute = '/';
  static const String loginRoute = '/login';
  static const String signupRoute = '/signup';
  static const String dashboardRoute = '/dashboard';
  static const String fundDetailRoute = '/fund-detail';
  static const String watchlistRoute = '/watchlist';

  // Asset Constants
  static const String logoPath = 'assets/images/logo.svg';
  static const String mutualFundsDataPath = 'assets/data/mutual_funds.json';

  // Hive Constants
  static const String watchlistBox = 'watchlist_box';
  static const String userBox = 'user_box';

  // Shared Preferences Keys
  static const String userTokenKey = 'user_token';
  static const String userIdKey = 'user_id';
  static const String isLoggedInKey = 'is_logged_in';

  // Error Messages
  static const String networkErrorMessage =
      'Network error. Please check your connection.';
  static const String authErrorMessage =
      'Authentication failed. Please try again.';
  static const String generalErrorMessage =
      'Something went wrong. Please try again later.';
}
