import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:wigo_flutter/core/auth/auth_state_notifier.dart';

import '../../features/buyer/presentation/views/buyer_homepage_screens/buyer_home_screen.dart';
import '../../features/buyer/presentation/views/buyer_product_details_screens/product_details_screen.dart';
import '../../features/buyer/presentation/views/buyer_shell.dart';
import '../../features/rider/presentation/views/main_screen.dart';
import '../../features/rider/presentation/views/rider_account_setup_screens/rider_account_nin_verification_screen.dart';
import '../../features/rider/presentation/views/rider_account_setup_screens/rider_payment_method_setup_screen.dart';
import '../../features/rider/presentation/views/rider_settings_screens/rider_settings_main_screen.dart';
import '../../shared/screens/account_creation_screen.dart';
import '../../shared/screens/change_password_screen.dart';
import '../../shared/screens/creation_successful_screen.dart';
import '../../shared/screens/email_verification_screen.dart';
import '../../shared/screens/login_screen.dart';
import '../../shared/screens/onboarding_screen.dart';
import '../../shared/screens/reset_password_email_verification_screen.dart';
import '../../shared/screens/reset_password_enter_email_screen.dart';
import '../../shared/screens/role_selection_screen.dart';
import '../../shared/screens/welcome_screen.dart';
import '../auth/auth_state.dart';
import '../constants/url.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authStateProvider);
  return GoRouter(
    initialLocation: '/buyerHomeScreen',
    redirect: (context, state) {
      if (kDevMode) return null;

      if (authState.status == AuthStatus.loading) return null;

      final loggedIn = authState.status == AuthStatus.loggedIn;
      final role = authState.role;
      final hasOnboarded = authState.hasOnboarded;

      final isLogin = state.uri.toString() == '/login';
      final isRoleSelection = state.uri.toString() == '/';

      // 1️⃣ FIRST TIME OPEN → ALWAYS ROLE SELECTION
      if (!hasOnboarded) {
        if (!isRoleSelection) return '/';
        return null;
      }

      // 2️⃣ USER IS BUYER (logged out allowed)
      if (role == 'buyer') {
        if (!loggedIn && isLogin) return '/buyerHomeScreen';
        return null;
      }

      // 3️⃣ USER IS RIDER → requires login
      if (role == 'rider') {
        if (!loggedIn && !isLogin) return '/login';
        if (loggedIn && isLogin) return '/riderMainScreen';
        return null;
      }

      // TEMP fallback until seller logic decided
      return null;
    },
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const RoleSelectionScreen(),
      ),
      GoRoute(
        path: '/welcome',
        builder: (context, state) => const WelcomeScreen(),
      ),
      GoRoute(
        path: '/onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: '/accountCreation',
        builder: (context, state) => const AccountCreationScreen(),
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
        path: '/successful',
        builder: (context, state) => const CreationSuccessfulScreen(),
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
      ShellRoute(
        builder: (context, state, child) => BuyerShell(child: child),
        routes: [
          // 1. Buyer Home Screen (Base of the Shell)
          GoRoute(
            path: '/buyerHomeScreen',
            builder: (context, state) => BuyerHomeScreen(),
          ),

          // 2. Product Details Page (Nested under the Shell)
          // The persistent AppBar will appear on this page too!
          GoRoute(
            path: '/buyer/product-details',
            builder: (context, state) {
              // Extract parameters passed from the product card onTap
              final args = state.extra as Map<String, dynamic>?;

              if (args == null) {
                // Handle case where no product data is passed (e.g., redirect or error)
                return const Center(child: Text('Product not found.'));
              }

              return ProductDetailsPage(
                productName: args['productName'] as String,
                imageUrl: args['imageUrl'] as String,
                price: args['price'] as String,
                categoryName: args['categoryName'] as String,
              );
            },
          ),
        ],
      ),
    ],
  );
});
