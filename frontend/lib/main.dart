import 'package:flutter/material.dart';
import 'package:frontend/core/res/styles/colours.dart';
import 'package:frontend/core/services/injection_container.dart';
import 'package:frontend/core/services/router.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = ThemeData(
        colorScheme:
            ColorScheme.fromSeed(seedColor: Colours.lightThemePrimaryColour),
        fontFamily: 'Switzer',
        scaffoldBackgroundColor: Colours.lightThemeTiniStockColour,
        appBarTheme: const AppBarTheme(
            backgroundColor: Colours.lightThemeTiniStockColour,
            foregroundColor: Colours.lightThemePrimaryTextColour),
        useMaterial3: true);
    return MaterialApp.router(
      title: "E-Commerce App",
      routerConfig: router,
      themeMode: ThemeMode.system,
      theme: theme,
      darkTheme: theme.copyWith(
          scaffoldBackgroundColor: Colours.darkThemeBGDark,
          appBarTheme: const AppBarTheme(
              backgroundColor: Colours.darkThemeBGDark,
              foregroundColor: Colours.lightThemeWhiteColour)),
    );
  }
}
