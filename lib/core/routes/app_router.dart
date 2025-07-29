import 'package:go_router/go_router.dart';

import '../../shared/screens/role_selection_screen.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const RoleSelectionScreen(),
    ),
    // Add more routes later as needed
  ],
);
