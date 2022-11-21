import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plantit/screens/intro_screen.dart';
import 'package:plantit/screens/splash_screen.dart';
import 'package:plantit/services/restart_app.dart';
import 'package:plantit/translations/codegen_loader.g.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:theme_mode_builder/theme_mode_builder.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await EasyLocalization.ensureInitialized();
  await ThemeModeBuilderConfig.ensureInitialized();
  runApp(EasyLocalization(
    path: 'assets/translations/',
    supportedLocales: const [Locale('en'), Locale('ar')],
    fallbackLocale: const Locale('en'),
    assetLoader: const CodegenLoader(),
    child: RestartWidget(
      child: ThemeModeBuilder(
        builder: (BuildContext context, ThemeMode themeMode) {
          return GetMaterialApp(
            themeMode: themeMode,
            localizationsDelegates: context.localizationDelegates,
            supportedLocales: context.supportedLocales,
            locale: context.locale,
            theme: ThemeData(
                textTheme:
                    const TextTheme(titleSmall: TextStyle(color: Colors.black)),
                iconTheme: const IconThemeData(color: Colors.black),
                brightness: Brightness.light,
            
                primaryColor: const Color(0xFF009345),
                floatingActionButtonTheme: const FloatingActionButtonThemeData(
                    backgroundColor: Color(0xFF009345)),
                primarySwatch: Colors.green),
            darkTheme: ThemeData(
                textTheme:
                    const TextTheme(titleSmall: TextStyle(color: Colors.white)),
                iconTheme: const IconThemeData(color: Colors.white),
                brightness: Brightness.dark,
                floatingActionButtonTheme: const FloatingActionButtonThemeData(
                    backgroundColor: Color(0xFF009345)),
                primaryColor: const Color(0xFF009345),
                primarySwatch: Colors.green),
            debugShowCheckedModeBanner: false,
            home: const MyApp(),
          );
        },
      ),
    ),
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
  }
}
