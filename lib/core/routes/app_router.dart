import 'package:go_router/go_router.dart';
import 'package:wigo_flutter/features/rider/presentation/views/main_screen.dart';
import 'package:wigo_flutter/features/rider/presentation/views/rider_settings_screens/rider_settings_main_screen.dart';
import 'package:wigo_flutter/shared/screens/email_verification_screen.dart';
import 'package:wigo_flutter/shared/screens/login_screen.dart';
import 'package:wigo_flutter/shared/screens/reset_password_email_verification_screen.dart';
import 'package:wigo_flutter/shared/screens/reset_password_enter_email_screen.dart';

import '../../features/rider/presentation/views/rider_account_setup_screens/rider_account_creation_screen.dart';
import '../../features/rider/presentation/views/rider_account_setup_screens/rider_account_nin_verification_screen.dart';
import '../../features/rider/presentation/views/rider_account_setup_screens/rider_creation_successful_screen.dart';
import '../../features/rider/presentation/views/rider_account_setup_screens/rider_onboarding_screen.dart';
import '../../features/rider/presentation/views/rider_account_setup_screens/rider_payment_method_setup_screen.dart';
import '../../features/rider/presentation/views/rider_welcome_screen.dart';
import '../../shared/screens/change_password_screen.dart';
import '../../shared/screens/role_selection_screen.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const RoleSelectionScreen(),
    ),
    GoRoute(
      path: '/rider/welcome',
      builder: (context, state) => const RiderWelcomeScreen(),
    ),
    GoRoute(
      path: '/rider/onboarding',
      builder: (context, state) => const RiderOnboardingScreen(),
    ),
    GoRoute(
      path: '/rider/account',
      builder: (context, state) => const RiderAccountCreationScreen(),
    ),
    GoRoute(
      path: '/verification',
      builder: (context, state) => const EmailVerificationScreen(email: ''),
    ),
    GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
    GoRoute(
      path: '/rider/verification',
      builder: (context, state) => const RiderAccountNinVerificationScreen(),
    ),
    GoRoute(
      path: '/rider/account/setup',
      builder: (context, state) => const RiderPaymentMethodSetupScreen(),
    ),
    GoRoute(
      path: '/rider/successful',
      builder: (context, state) => const RiderCreationSuccessfulScreen(),
    ),
    GoRoute(
      path: '/resetPassword/verification',
      builder:
          (context, state) =>
      const ResetPasswordEmailVerificationScreen(email: ''),
    ),
    GoRoute(
      path: '/resetPassword/enterEmail',
      builder: (context, state) => const ResetPasswordEnterEmailScreen(),
    ),
    GoRoute(
      path: '/changePassword',
      builder: (context, state) => const ChangePasswordScreen(),
    ),
    GoRoute(
      path: '/riderMainScreen',
      builder: (context, state) => RiderMainScreen(),
    ),
    GoRoute(
      path: '/riderSettingsMainScreen',
      builder: (context, state) => RiderSettingsMainScreen(),
    ),
  ],
);
