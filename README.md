# Khazana - Mutual Fund Watchlist & Performance Analytics App

A Flutter application for tracking and analyzing mutual fund investments with advanced performance analytics.

## Features

### Authentication
- User registration and login using Supabase authentication
- Secure session management
- Profile management

### Mutual Fund Exploration
- Browse comprehensive list of mutual funds
- Detailed fund information (NAV, AUM, expense ratio, etc.)
- Performance metrics and historical data
- Risk assessment indicators

### Advanced Analytics
- Interactive performance charts using FL Chart
- Historical NAV tracking
- Return analysis (1M, 3M, 6M, 1Y, All-time)
- Performance comparison

### Watchlist Management
- Create multiple watchlists
- Add/remove funds from watchlists
- Track performance of favorite funds
- Quick access to detailed fund information

### Offline Support
- Local data persistence using Hive
- Cached mutual fund data
- Offline watchlist management

## Architecture

The app follows a clean architecture approach with the following layers:

- **Presentation Layer**: UI components, screens, and BLoC state management
- **Domain Layer**: Business logic and use cases
- **Data Layer**: Repositories, data sources, and models

### Project Structure
```
lib/
  ├── core/            # Core utilities, constants, and shared components
  │   ├── constants/   # App-wide constants
  │   ├── di/          # Dependency injection
  │   ├── resources/   # Shared resources
  │   ├── router/      # Navigation routing
  │   ├── theme/       # App theme and styling
  │   └── utils/       # Utility functions
  ├── data/            # Data layer components
  └── features/        # Feature modules
      ├── auth/        # Authentication feature
      ├── dashboard/   # Main dashboard
      ├── mutual_funds/# Mutual fund listings and details
      ├── watchlist/   # Watchlist management
      └── widgets/     # Shared widgets
```

## Tech Stack

- **Flutter**: UI framework
- **BLoC Pattern**: State management
- **Supabase**: Backend as a Service for authentication
- **Hive**: Local database for offline support
- **FL Chart**: Interactive charts for fund performance
- **Go Router**: Navigation and routing
- **Get It**: Dependency injection
- **Equatable**: Value equality
- **Freezed**: Code generation for immutable classes

## Getting Started

### Prerequisites
- Flutter SDK (^3.7.0)
- Dart SDK (^3.0.0)
- Android Studio / VS Code

### Installation

1. Clone the repository
   ```
   git clone https://github.com/yourusername/khazana_app.git
   ```

2. Navigate to the project directory
   ```
   cd khazana_app
   ```

3. Install dependencies
   ```
   flutter pub get
   ```

4. Run the app
   ```
   flutter run
   ```

## State Management

The app uses the BLoC (Business Logic Component) pattern for state management:

- **Blocs**: Handle business logic and state transitions
- **Events**: Trigger state changes
- **States**: Represent the UI state at any given time

This approach ensures a unidirectional data flow and separation of concerns.

## Data Persistence

- **Supabase**: Remote data storage and authentication
- **Hive**: Local NoSQL database for offline capabilities
- **Shared Preferences**: Simple key-value storage for app settings

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is licensed under the MIT License - see the LICENSE file for details.
