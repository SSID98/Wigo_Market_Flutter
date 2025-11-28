import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wigo_flutter/core/constants/app_colors.dart';

import 'core/routes/app_router.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  runApp(const ProviderScope(child: WigoApp()));
}

class WigoApp extends StatelessWidget {
  const WigoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Wigo',
      routerConfig: appRouter,
      theme: ThemeData(
        fontFamily: 'Hind',
        scaffoldBackgroundColor: AppColors.backgroundLight,
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.radioBlue),
        useMaterial3: true,
      ),
    );
  }
}
