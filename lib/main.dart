import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'app/routes/app_pages.dart';
import 'app/routes/app_routes.dart';
import 'app/themes/app_theme.dart';
import 'data/providers/hive_provider.dart';
import 'data/services/storage_service.dart';
import 'data/services/auth_service.dart';
import 'data/services/api_service.dart';
import 'data/services/chat_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Configure status bar
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );

  // Lock portrait orientation
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Init Hive
  await HiveProvider.init();

  // Register core services
  final storageService = await Get.putAsync<StorageService>(
    () async {
      final service = StorageService();
      await service.onInit();
      return service;
    },
    permanent: true,
  );

  Get.put<ApiService>(ApiService(), permanent: true);
  Get.put<AuthService>(AuthService(), permanent: true);
  Get.put<ChatService>(ChatService(), permanent: true);

  final isDarkMode = storageService.isDarkMode;

  runApp(MedicalGptApp(isDarkMode: isDarkMode));
}

class MedicalGptApp extends StatelessWidget {
  final bool isDarkMode;
  const MedicalGptApp({super.key, required this.isDarkMode});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'MedicalGPT',
      debugShowCheckedModeBanner: false,

      // Themes
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,

      // Navigation
      initialRoute: AppRoutes.splash,
      getPages: AppPages.pages,
      defaultTransition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 300),

      // Locale
      locale: const Locale('en', 'US'),

      // UI
      builder: (context, child) {
        return GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: child!,
        );
      },
    );
  }
}
