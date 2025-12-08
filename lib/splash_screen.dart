// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:go_router/go_router.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// import 'core/local/local_storage_service.dart';
//
// class SplashScreen extends ConsumerStatefulWidget {
//   const SplashScreen({super.key});
//
//   @override
//   ConsumerState<SplashScreen> createState() => _SplashScreenState();
// }
//
// class _SplashScreenState extends ConsumerState<SplashScreen> {
//   @override
//   void initState() {
//     super.initState();
//     _checkFlow();
//   }
//
//   Future<void> _checkFlow() async {
//     final prefs = await SharedPreferences.getInstance();
//     final storage = LocalStorageService(prefs);
//
//     await Future.delayed(const Duration(seconds: 2)); // Fake splash delay
//
//     if (!storage.hasCompletedRoleSelection) {
//       if (!mounted) return;
//       context.go('/');
//     } else if (!storage.hasCompletedOnboarding) {
//       if (!mounted) return;
//       context.go('/rider/onboarding');
//     } else if (!storage.hasCompletedAccountCreation) {
//       if (!mounted) return;
//       context.go('/rider/account');
//     } else {
//       if (!mounted) return;
//       context.go('/login'); // or /main if logged in
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(body: Center(child: CircularProgressIndicator()));
//   }
// }
