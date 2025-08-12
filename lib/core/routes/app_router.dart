import 'package:go_router/go_router.dart';
import 'package:wigo_flutter/features/rider/presentation/views/rider_account_screen.dart';
import 'package:wigo_flutter/features/rider/presentation/views/rider_account_setup_screen.dart';
import 'package:wigo_flutter/features/rider/presentation/views/rider_account_verification_screen.dart';
import 'package:wigo_flutter/features/rider/presentation/views/rider_onboarding_screen.dart';
import 'package:wigo_flutter/shared/screens/email_verification_screen.dart';
import 'package:wigo_flutter/shared/screens/login_screen.dart';

import '../../features/rider/presentation/views/rider_welcome_screen.dart';
import '../../shared/screens/role_selection_screen.dart';

final appRouter = GoRouter(
  initialLocation: '/rider/account/setup',
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
      builder: (context, state) => const RiderAccountScreen(),
    ),
    GoRoute(
      path: '/verification',
      builder: (context, state) => const EmailVerificationScreen(),
    ),
    GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
    GoRoute(
      path: '/rider/verification',
      builder: (context, state) => const RiderAccountVerificationScreen(),
    ),
    GoRoute(
      path: '/rider/account/setup',
      builder: (context, state) => const RiderAccountSetupScreen(),
    ),
  ],
);
