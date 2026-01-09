import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nectar_bot/presentation/routes/app_routes.dart';
import 'presentation/routes/app_pages.dart';
import 'core/theme/app_theme.dart';
import 'dependency_injection.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  DependencyInjection.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Nectar Support',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      themeMode: ThemeMode.dark,
      initialRoute: Routes.SPLASH,
      getPages: AppPages.routes,
    );
  }
}