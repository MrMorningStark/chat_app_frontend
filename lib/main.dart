import 'package:WhatsApp/constant.dart';
import 'package:WhatsApp/enumeration.dart';
import 'package:WhatsApp/firebase_options.dart';
import 'package:WhatsApp/pages/home_page.dart';
import 'package:WhatsApp/styles/theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:localstorage/localstorage.dart';

void main() {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  runApp(const ProviderScope(child: MainApp()));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Future.wait([
        Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        ),
        initLocalStorage()
      ]),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          FlutterNativeSplash.remove();
        }
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: "WhatsApp",
          theme: lightTheme,
          darkTheme: darkTheme,
          themeMode: ThemeMode.system,
          navigatorKey: navigatorKey,
          home: snapshot.hasError
              ? const Scaffold(
                  body: Center(child: Text("Something went wrong!")))
              : snapshot.connectionState == ConnectionState.done
                  ? const HomePage()
                  : const Scaffold(
                      body: Center(child: CircularProgressIndicator())),
          routes: Routes.getRoutes(context: context),
        );
      },
    );
  }
}
