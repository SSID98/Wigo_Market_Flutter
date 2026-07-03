import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wigo_flutter/core/constants/app_colors.dart';

import 'core/local/app_lifecycle_handler.dart';
import 'core/local/local_user_controller.dart';
import 'core/local/secure_storage.dart';
import 'core/local/session_manager.dart';
import 'core/routes/app_router.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: ".env");
  final prefs = await SharedPreferences.getInstance();
  final storage = SecureStorage();
  final session = SessionManager(storage);
  await session.init();
  runApp(
    ProviderScope(
      overrides: [
        sessionManagerProvider.overrideWithValue(session),
        localUserControllerProvider.overrideWith(
          (ref) => LocalUserController(prefs),
        ),
      ],
      child: WigoApp(),
    ),
  );
}

class WigoApp extends ConsumerWidget {
  const WigoApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.read(appLifecycleProvider);
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Wigo',
      routerConfig: ref.watch(routerProvider),
      theme: ThemeData(
        fontFamily: 'Hind',
        scaffoldBackgroundColor: AppColors.backgroundLight,
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.radioBlue),
        useMaterial3: true,
        textSelectionTheme: const TextSelectionThemeData(
          cursorColor: AppColors.primaryDarkGreen,
        ),
        radioTheme: RadioThemeData(
          fillColor: WidgetStateColor.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return AppColors.primaryDarkGreen;
            }
            return AppColors.primaryDarkGreen;
          }),
        ),
      ),
    );
  }
}
