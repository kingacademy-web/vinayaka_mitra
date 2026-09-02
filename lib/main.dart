import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'core/theme/app_theme.dart';
import 'providers/favorites_provider.dart';
import 'providers/harathi_provider.dart';
import 'providers/language_provider.dart';
import 'providers/pooja_provider.dart';
import 'providers/theme_provider.dart';
import 'screens/home/home_screen.dart';
import 'screens/onboarding/language_selection_screen.dart';
import 'services/firebase_service.dart';
import 'services/mandali_service.dart';
import 'services/offline_cache_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Set preferred orientations safely
  try {
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  } catch (_) {}

  // Initialize Hive Offline Local Storage safely
  try {
    await OfflineCacheService().init();
  } catch (e) {
    debugPrint('Offline cache initialization error: $e');
  }

  // Initialize Mandali Service (Hive boxes for Chanda, Expenses, Schedule, etc.)
  try {
    await MandaliService().init();
  } catch (e) {
    debugPrint('MandaliService initialization error: $e');
  }

  final dataService = FirebaseService();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => LanguageProvider()),
        ChangeNotifierProvider(create: (_) => FavoritesProvider()),
        ChangeNotifierProvider(create: (_) => MandaliService()),
        ChangeNotifierProvider(
          create: (_) => HarathiProvider(dataService)..load(),
        ),
        ChangeNotifierProvider(
          create: (_) => PoojaProvider(dataService)..load(),
        ),
      ],
      child: const VinayakaMitraApp(),
    ),
  );
}

class VinayakaMitraApp extends StatelessWidget {
  const VinayakaMitraApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    final langProvider = context.watch<LanguageProvider>();

    return MaterialApp(
      title: langProvider.t('appName'),
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: themeProvider.mode,
      home: langProvider.hasChosenLanguage
          ? const HomeScreen()
          : const LanguageSelectionScreen(isFromSettings: false),
    );
  }
}
