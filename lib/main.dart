import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plantit/screens/home_screen.dart';
import 'package:plantit/screens/intro_screen.dart';
import 'package:plantit/screens/splash_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
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

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool first = true;

  checkData() async {
    final pref = await SharedPreferences.getInstance();
    setState(() {
      first = pref.getBool('intro') ?? true;
    });
  }

  @override
  void initState() {
    checkData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return first ? const IntroScreen() : const SplashScreen();
    // return HomeScreen();
  }
}
