import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:wigo_flutter/core/auth/auth_state_notifier.dart';
import 'package:wigo_flutter/features/buyer/presentation/views/cart_details_screen/buyer_cart_screen.dart';
import 'package:wigo_flutter/features/buyer/presentation/views/cart_details_screen/customer_info_screen.dart';
import 'package:wigo_flutter/features/buyer/presentation/views/cart_details_screen/delivery_details_screen.dart';
import 'package:wigo_flutter/features/buyer/presentation/views/cart_details_screen/order_confirmation_screen.dart';
import 'package:wigo_flutter/features/buyer/presentation/views/orders_screens/order_tracking_screen.dart';
import 'package:wigo_flutter/features/buyer/presentation/views/orders_screens/orders_screen.dart';
import 'package:wigo_flutter/features/buyer/presentation/views/search_results_view.dart';

import '../../features/buyer/models/product_model.dart';
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
import '../local/local_user_controller.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authStateProvider);
  final local = ref.watch(localUserControllerProvider);
  return GoRouter(
    initialLocation: '/buyerHomeScreen',
    redirect: (context, state) {
      if (kDevMode) return null;

      if (authState.status == AuthStatus.loading) return null;

      bool isOnboardingRoute(String loc) {
        return loc.startsWith('/onboarding') ||
            loc.startsWith('/accountCreation') ||
            loc.startsWith('/verification') ||
            loc.startsWith('/rider/verification') ||
            loc.startsWith('/rider/account/setup') ||
            loc.startsWith('/successful');
      }

      final loggedIn = authState.status == AuthStatus.loggedIn;
      final role = local.role; // e.g., 'buyer', 'rider', null
      final stage = local.stage;
      final hasOnboarded = local.hasOnboarded;

      final loc = state.uri.toString();

      // ----------------------------
      // 1. ABSOLUTE FIRST LAUNCH / Role Selection
      // ----------------------------
      // If no role is selected, force them to the root role selection screen (/)
      if (role == null && loc != '/') {
        return '/';
      }

      // ----------------------------
      // 2. GUARD: BLOCK completed users from accessing old routes
      // ----------------------------
      if (hasOnboarded && isOnboardingRoute(loc)) {
        // If fully onboarded, redirect based on role (see sections 3 & 4 for targets)
        if (role == 'buyer') {
          return '/buyerHomeScreen';
        } else if (role == 'rider') {
          return '/riderMainScreen';
        }
        // Fallback if role is completed but unknown
        return '/';
      }

      // ----------------------------
      // 3. INCOMPLETE ONBOARDING → RECOVERY
      // ----------------------------
      if (!hasOnboarded && role != null) {
        switch (stage) {
          case OnboardingStage.none:
            // User chose a role but didn't proceed to the first screen
            return '/onboarding';
          case OnboardingStage.onboarding:
            // Ensure they are on the correct recovery route
            if (loc != '/onboarding') return '/onboarding';
            break; // Allow navigation to continue if already on /onboarding
          case OnboardingStage.registration:
            if (loc != '/accountCreation') return '/accountCreation';
            break;
          case OnboardingStage.otp:
            if (loc != '/verification') return '/verification';
            break;
          case OnboardingStage.ninVerification:
            if (loc != '/rider/verification') return '/rider/verification';
            break;
          case OnboardingStage.bankSetup:
            if (loc != '/rider/account/setup') return '/rider/account/setup';
            break;
          case OnboardingStage.success:
            if (loc != '/successful') return '/successful';
            break;
          case OnboardingStage.completed:
            // Should be caught by the hasOnboarded check above, but as a safeguard:
            return (role == 'buyer') ? '/buyerHomeScreen' : '/login';
        }

        // If the user is currently on the correct stage route, allow them to proceed
        // This return null means "allow the requested navigation"
        return null;
      }

      // ----------------------------
      // 4. AUTHENTICATION & PRIMARY ROLE FLOWS (Only runs if onboarding is complete or irrelevant)
      // ----------------------------

      // Buyer Logic (No login requirement)
      if (role == 'buyer') {
        // If a buyer tries to go to login, send them home
        if (loc == '/login' && loggedIn) {
          return '/buyerHomeScreen';
        }
        // If a buyer is on the login screen but not logged in (e.g., they chose buyer
        // but the token expired), let them login or proceed. In your initial logic,
        // you assumed they don't need login, so let's stick to that:
        if (loc == '/login' && !loggedIn) {
          return '/buyerHomeScreen';
        }
      }

      // Rider Logic (Requires Login)
      if (role == 'rider') {
        // Force unauthenticated riders to the login screen
        if (!loggedIn && loc != '/login') {
          return '/login';
        }
        // If logged in, prevent access to the login screen
        if (loggedIn && loc == '/login') {
          return '/riderMainScreen';
        }
      }

      // Allow navigation for all other cases (e.g., user is a logged-in Rider trying
      // to access /riderMainScreen, or a Buyer trying to access /buyerHomeScreen)
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
          GoRoute(
            path: '/buyerHomeScreen',
            builder: (context, state) => BuyerHomeScreen(),
          ),
          GoRoute(
            path: '/buyer/product-details',
            builder: (context, state) {
              final args = state.extra as Map<String, dynamic>?;

              if (args == null) {
                return const Center(child: Text('Product not found.'));
              }

              return ProductDetailsPage(product: args['product'] as Product);
            },
          ),
          GoRoute(
            path: '/buyer/trackOrder',
            builder: (context, state) {
              final args = state.extra as Map<String, dynamic>?;

              if (args == null) {
                return const Center(child: Text('Product not found.'));
              }

              return OrdersTrackingScreen(productName: args['productName']);
            },
          ),
          GoRoute(path: '/buyer/cart', builder: (context, state) => CartPage()),
          GoRoute(
            path: '/buyer/search',
            builder: (context, state) {
              final query = state.extra as String;
              return SearchResultsView(searchQuery: query);
            },
          ),
          GoRoute(
            path: '/buyer/customerInfo',
            builder: (context, state) => CustomerInfoScreen(),
          ),
          GoRoute(
            path: '/buyer/deliveryDetails',
            builder: (context, state) => BuyerDeliveryDetailsScreen(),
          ),
          GoRoute(
            path: '/buyer/orderConfirmation',
            builder: (context, state) => OrderConfirmationScreen(),
          ),
          GoRoute(
            path: '/buyer/Orders',
            builder: (context, state) => OrdersScreen(),
          ),
        ],
      ),
    ],
  );
});
