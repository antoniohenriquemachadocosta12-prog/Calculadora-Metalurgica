import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';
import 'screens/project_list_screen.dart';
import 'theme/app_theme.dart';

class MetalCalcApp extends StatelessWidget {
  const MetalCalcApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MetalCalc Pro',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.theme,
      initialRoute: '/',
      routes: {
        '/': (_) => const SplashScreen(),
        '/projetos': (_) => const ProjectListScreen(),
      },
    );
  }
}
