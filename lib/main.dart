import 'dart:ui';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'core/theme/app_theme.dart';
import 'providers/favorites_provider.dart';
import 'providers/harathi_provider.dart';
import 'providers/pooja_provider.dart';
import 'providers/theme_provider.dart';
import 'screens/home/home_screen.dart';
import 'services/firebase_service.dart';
import 'services/notification_service.dart';
import 'services/offline_cache_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Set preferred orientations
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // 1. Initialize Hive Offline Local Box Storage
  await OfflineCacheService().init();

  // 2. Initialize Firebase (graceful handling if offline or awaiting config)
  try {
    await Firebase.initializeApp();
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
    PlatformDispatcher.instance.onError = (error, stack) {
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
      return true;
    };
    await FirebaseService().signInAnonymously();
    await NotificationService().init();
  } catch (e) {
    debugPrint('Firebase not initialized in local standalone mode: $e');
  }

  final firebaseService = FirebaseService();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => FavoritesProvider()),
        ChangeNotifierProvider(
          create: (_) => HarathiProvider(firebaseService)..load(),
        ),
        ChangeNotifierProvider(
          create: (_) => PoojaProvider(firebaseService)..load(),
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
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, _) {
        return MaterialApp(
          title: 'వినాయక మిత్ర (Vinayaka Mitra)',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.light(),
          darkTheme: AppTheme.dark(),
          themeMode: themeProvider.mode,
          home: const HomeScreen(),
        );
      },
    );
  }
}
