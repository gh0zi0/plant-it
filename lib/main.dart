import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plantit/screens/splash_screen.dart';
import 'package:theme_mode_builder/theme_mode_builder.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await ThemeModeBuilderConfig.ensureInitialized();
  runApp(ThemeModeBuilder(
    builder: (BuildContext context, ThemeMode themeMode) {
      return GetMaterialApp(
        themeMode: themeMode,
        theme: ThemeData(
            brightness: Brightness.light,
            primaryColor: Colors.green,
            primarySwatch: Colors.green),
        darkTheme: ThemeData(
            brightness: Brightness.dark,
            primaryColor: Colors.green,
            primarySwatch: Colors.green),
        debugShowCheckedModeBanner: false,
        home: const MyApp(),
      );
    },
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const SplashScreen();
  }
}
