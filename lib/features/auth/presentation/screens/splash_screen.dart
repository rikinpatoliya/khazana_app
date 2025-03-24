import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:khazana_app/core/constants/app_constants.dart';
import 'package:khazana_app/core/router/app_router.dart';
import 'package:khazana_app/core/theme/app_theme.dart';
import 'package:khazana_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:khazana_app/core/utils/snackbar_utils.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthErrorState) {
            SnackBarUtils.showSnackBar(state.message);
          } else if (state is AuthAuthenticatedState) {
            context.goNamed(Routes.dashboardRoute);
          } else if (state is AuthUnauthenticatedState) {
            context.goNamed(Routes.loginRoute);
          }
        },
        builder: (context, state) {
          return Container(
            width: double.infinity,
            height: double.infinity,
            alignment: Alignment.center,
            child: SvgPicture.asset(AppConstants.logoPath),
          );
        },
      ),
    );
  }
}
