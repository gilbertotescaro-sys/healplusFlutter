import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:go_router/go_router.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';
import 'package:sqflite/sqflite.dart';
import 'database/database_helper.dart';
import 'screens/welcome_screen.dart';
import 'screens/home_screen.dart';
import 'screens/wound_assessment_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/wound_list_screen.dart';
import 'screens/analysis_screen.dart';
import 'screens/reports_screen.dart';
import 'theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Configurar sqflite para web
  if (kIsWeb) {
    databaseFactory = databaseFactoryFfiWeb;
  }
  
  // Inicializar banco de dados
  try {
    await DatabaseHelper.instance.database;
  } catch (e) {
    debugPrint('Erro ao inicializar banco de dados: $e');
    // Continuar mesmo se houver erro
  }
  
  // Configurar orientação preferencial (apenas mobile)
  if (!kIsWeb) {
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }
  
  runApp(const HealPlusApp());
}

final GoRouter _router = GoRouter(
  initialLocation: '/welcome',
  routes: [
    GoRoute(
      path: '/welcome',
      builder: (context, state) => const WelcomeScreen(),
    ),
    GoRoute(
      path: '/home',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/wound-assessment',
      builder: (context, state) => const WoundAssessmentScreen(),
    ),
    GoRoute(
      path: '/wound-assessment/:id',
      builder: (context, state) {
        final id = state.pathParameters['id'];
        return WoundAssessmentScreen(woundId: id);
      },
    ),
    GoRoute(
      path: '/wound-list',
      builder: (context, state) => const WoundListScreen(),
    ),
    GoRoute(
      path: '/settings',
      builder: (context, state) => const SettingsScreen(),
    ),
    GoRoute(
      path: '/analysis',
      builder: (context, state) => const AnalysisScreen(),
    ),
    GoRoute(
      path: '/reports',
      builder: (context, state) => const ReportsScreen(),
    ),
  ],
);

class HealPlusApp extends StatelessWidget {
  const HealPlusApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Heal+',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      routerConfig: _router,
    );
  }
}

