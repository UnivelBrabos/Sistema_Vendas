import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'app_module.dart';
import 'core/app_colors.dart';
import 'store/settings_store.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();

  print('→ Variáveis de ambiente carregadas (.env)');
  print('SUPABASE_URL: ${dotenv.env['SUPABASE_URL']}');
  print('SUPABASE_KEY: ${dotenv.env['SUPABASE_KEY']}');
  print('MIDDLEWARE_URL: ${dotenv.env['MIDDLEWARE_URL']}');

  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL']!,
    anonKey: dotenv.env['SUPABASE_KEY']!,
  );

  runApp(
    ModularApp(
      module: AppModule(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Recupera o SettingsStore
    final settings = Modular.get<SettingsStore>();

    return Observer(builder: (_) {
      return MaterialApp.router(
        title: 'Trabalho Vendas Univel – Spark',
        debugShowCheckedModeBanner: false,

        // escolhe tema claro ou escuro conforme a store
        themeMode: settings.isDarkMode ? ThemeMode.dark : ThemeMode.light,

        // Tema claro
        theme: ThemeData(
          primaryColor: AppColors.primaryColor,
          scaffoldBackgroundColor: AppColors.background,
          colorScheme: ColorScheme.light(
            primary: AppColors.primaryColor,
            secondary: AppColors.danger,
            background: AppColors.background,
            surface: AppColors.background,
            error: AppColors.danger,
            onPrimary: Colors.white,
            onSecondary: Colors.white,
            onBackground: Colors.black87,
            onSurface: Colors.black87,
            onError: Colors.white,
          ),
          textTheme: const TextTheme(
            bodyLarge: TextStyle(color: Colors.black87),
            bodyMedium: TextStyle(color: Colors.black54),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryColor,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),

        // Tema escuro
        darkTheme: ThemeData.dark().copyWith(
          primaryColor: AppColors.primaryColor,
          scaffoldBackgroundColor: Colors.black,
          colorScheme: ColorScheme.dark(
            primary: AppColors.primaryColor,
            secondary: AppColors.danger,
            background: Colors.black,
            surface: Colors.grey[850]!,
            error: AppColors.danger,
            onPrimary: Colors.white,
            onSecondary: Colors.white,
            onBackground: Colors.white70,
            onSurface: Colors.white70,
            onError: Colors.white,
          ),
          textTheme: const TextTheme(
            bodyLarge: TextStyle(color: Colors.white70),
            bodyMedium: TextStyle(color: Colors.white54),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryColor,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),

        routeInformationParser: Modular.routeInformationParser,
        routerDelegate: Modular.routerDelegate,
      );
    });
  }
}
