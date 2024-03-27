import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:sarafy/provider/crypto_data_provider.dart';
import 'package:sarafy/provider/market_view_provider.dart';
import 'package:sarafy/provider/theme_provider.dart';
import 'package:sarafy/provider/user_data_provider.dart';
import 'package:sarafy/ui/screens/sign_up_screen.dart';

import 'package:sarafy/ui/ui_helper/main_wrapper.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
        ChangeNotifierProvider(create: (context) => MarketViewProvider()),
        ChangeNotifierProvider(create: (context) => CryptoDataProvider()),
        ChangeNotifierProvider(create: (context) => UserDataProvider()),
      ],
      child: const Application(),
    ),
  );
}

class Application extends StatefulWidget {
  const Application({super.key});

  @override
  State<Application> createState() => _ApplicationState();
}

class _ApplicationState extends State<Application> {
  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: ((context, themeProvider, child) {
        return MaterialApp(
          themeMode: themeProvider.themeMode,
          theme: MyThemes.lightTheme,
          darkTheme: MyThemes.darkTheme,
          debugShowCheckedModeBanner: false,
          home: FutureBuilder<SharedPreferences>(
            future: SharedPreferences.getInstance(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                SharedPreferences sharedPreferences = snapshot.data!;
                var loggedInState =
                    sharedPreferences.getBool("LoggedIn") ?? false;

                if (loggedInState) {
                  return const mainWrapper();
                } else {
                  return const SignUpScreen();
                }
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          ),
        );
      }),
    );
  }
}
