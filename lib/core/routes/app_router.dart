import 'package:go_router/go_router.dart';
import 'package:wigo_flutter/features/rider/presentation/views/rider_onboarding_screen.dart';

import '../../features/rider/presentation/views/rider_welcome_screen.dart';
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
  ],
);
