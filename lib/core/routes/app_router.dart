import 'package:go_router/go_router.dart';

import '../../features/rider/presentation/views/rider_welcome_screen.dart';
import '../../shared/screens/role_selection_screen.dart';

final appRouter = GoRouter(
  initialLocation: '/rider/welcome',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const RoleSelectionScreen(),
    ),
    GoRoute(
      path: '/rider/welcome',
      builder: (context, state) => const RiderWelcomeScreen(),
    ),
    // Add more routes later as needed
  ],
);
