import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:wigo_flutter/core/routes/router_notifier.dart';
import 'package:wigo_flutter/features/buyer/presentation/views/buyer_account_screen.dart';
import 'package:wigo_flutter/features/buyer/presentation/views/cart_details_screen/buyer_cart_screen.dart';
import 'package:wigo_flutter/features/buyer/presentation/views/cart_details_screen/customer_info_screen.dart';
import 'package:wigo_flutter/features/buyer/presentation/views/cart_details_screen/delivery_details_screen.dart';
import 'package:wigo_flutter/features/buyer/presentation/views/cart_details_screen/order_confirmation_screen.dart';
import 'package:wigo_flutter/features/buyer/presentation/views/delivery_policy_screen.dart';
import 'package:wigo_flutter/features/buyer/presentation/views/orders_screens/order_tracking_screen.dart';
import 'package:wigo_flutter/features/buyer/presentation/views/orders_screens/orders_screen.dart';
import 'package:wigo_flutter/features/buyer/presentation/views/privacy_policy_screen.dart';
import 'package:wigo_flutter/features/buyer/presentation/views/refund_policy_screen.dart';
import 'package:wigo_flutter/features/buyer/presentation/views/saved_product_view.dart';
import 'package:wigo_flutter/features/buyer/presentation/views/search_results_view.dart';
import 'package:wigo_flutter/features/seller/presentation/views/business_info_screen.dart';
import 'package:wigo_flutter/shared/screens/support_screen.dart';

import '../../features/buyer/models/product_model.dart';
import '../../features/buyer/presentation/views/buyer_homepage_screens/buyer_home_screen.dart';
import '../../features/buyer/presentation/views/buyer_product_details_screens/product_details_screen.dart';
import '../../features/buyer/presentation/views/buyer_shell.dart';
import '../../features/rider/presentation/views/main_screen.dart';
import '../../features/rider/presentation/views/rider_account_setup_screens/rider_account_nin_verification_screen.dart';
import '../../features/rider/presentation/views/rider_settings_screens/rider_settings_main_screen.dart';
import '../../shared/screens/account_creation_screen.dart';
import '../../shared/screens/change_password_screen.dart';
import '../../shared/screens/creation_successful_screen.dart';
import '../../shared/screens/email_verification_screen.dart';
import '../../shared/screens/login_screen.dart';
import '../../shared/screens/onboarding_screen.dart';
import '../../shared/screens/payment_method_setup_screen.dart';
import '../../shared/screens/reset_password_email_verification_screen.dart';
import '../../shared/screens/reset_password_enter_email_screen.dart';
import '../../shared/screens/role_selection_screen.dart';
import '../../shared/screens/welcome_screen.dart';
import '../auth/auth_state.dart';
import '../constants/url.dart';
import '../local/local_user_controller.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final routerNotifier = ref.watch(routerNotifierProvider);
  return GoRouter(
    initialLocation: '/seller/businessInfo',
    refreshListenable: routerNotifier,
    redirect: (context, state) {
      if (kDevMode) return null;
      final status = routerNotifier.authStatus;
      final local = routerNotifier.localUserState;
      if (status == AuthStatus.loading) return null;
      final loc = state.uri.toString();

      final loggedIn = status == AuthStatus.loggedIn;

      debugPrint('--- GO ROUTER REDIRECT ---');
      debugPrint('Location: $loc');
      debugPrint('AuthStatus: $status');
      if (local == null) return null;
      debugPrint('Local role: ${local.role}');
      debugPrint('Active stage: ${local.stage}');
      debugPrint('Email: ${local.email}');
      debugPrint('Has onboarded: ${local.hasOnboarded}');

      // 1️⃣ Create a list of "Public" routes that don't require login
      final isPublicRoute =
          loc == '/' ||
              loc == '/welcome' ||
              loc == '/onboarding' ||
              loc == '/accountCreation';

      // 2️⃣ Allow users to stay on public routes if they aren't logged in
      if (!loggedIn) {
        // 🚫 No role yet → only allow public landing pages
        if (local.role == null) {
          if (isPublicRoute) return null;
          return '/';
        }
      }

      // 3️⃣ If logged in and at a public/login page, send them to their dashboard
      if (loggedIn && (isPublicRoute || loc == '/login')) {
        if (local.role == 'buyer') return '/buyerHomeScreen';
        if (local.role == 'dispatch') return '/riderMainScreen';
      }

      debugPrint('Router decision role = ${local.role}');
      // 4️⃣ Finished onboarding BUT NOT logged in → force login
      if (!loggedIn &&
          local.hasOnboarded &&
          local.stage == OnboardingStage.completed &&
          loc != '/login') {
        debugPrint('Redirect: onboarded but logged out → login');
        return local.role == 'buyer' ? '/buyerHomeScreen' : '/login';
      }

      // 5️⃣ Logged in but onboarding incomplete
      switch (local.stage) {
        case OnboardingStage.onboarding:
          return '/onboarding';
        case OnboardingStage.registration:
          return '/accountCreation';
        case OnboardingStage.otp:
          return '/verification';
        case OnboardingStage.ninVerification:
          return '/rider/verification';
        case OnboardingStage.businessInfo:
          return '/seller/businessInfo';
        case OnboardingStage.bankSetup:
          return '/account/setup';
        case OnboardingStage.success:
          return '/successful';
        default:
          return null;
      }
    },
    routes: [
      //general routes
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
        builder: (context, state) {
          return Consumer(
            builder: (context, ref, _) {
              final local = ref.read(localUserControllerProvider);

              if (local.email == null) {
                return const Center(child: Text('Email not found.'));
              }

              return EmailVerificationScreen(email: local.email!);
            },
          );
        },
      ),
      GoRoute(
        path: '/account/setup',
        builder: (context, state) => const PaymentMethodSetupScreen(),
      ),
      GoRoute(
        path: '/successful',
        builder: (context, state) => const CreationSuccessfulScreen(),
      ),
      GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
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

      //rider routes
      GoRoute(
        path: '/rider/verification',
        builder: (context, state) => const RiderAccountNinVerificationScreen(),
      ),
      GoRoute(
        path: '/riderMainScreen',
        builder: (context, state) => RiderMainScreen(),
      ),
      GoRoute(
        path: '/riderSettingsMainScreen',
        builder: (context, state) => RiderSettingsMainScreen(),
      ),

      //buyer routes
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
          GoRoute(
            path: '/buyer/refundPolicy',
            builder: (context, state) => RefundPolicyScreen(),
          ),
          GoRoute(
            path: '/buyer/deliveryPolicy',
            builder: (context, state) => DeliveryPolicyScreen(),
          ),
          GoRoute(
            path: '/buyer/privacyPolicy',
            builder: (context, state) => PrivacyPolicyScreen(),
          ),
          GoRoute(
            path: '/buyer/SavedItems',
            builder: (context, state) => SavedProductsView(),
          ),
          GoRoute(
            path: '/buyer/support',
            builder: (context, state) => SupportScreen(isBuyer: true),
          ),
          GoRoute(
            path: '/buyer/Account',
            builder: (context, state) => BuyerAccountScreen(),
          ),
        ],
      ),

      //seller routes
      GoRoute(
        path: '/seller/businessInfo',
        builder: (context, state) => BusinessInfoScreen(),
      ),
    ],
  );
});
