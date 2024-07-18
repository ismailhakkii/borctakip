import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'screens/debt_tracker_home_page.dart';

void main() {
  runApp(const DebtTrackerApp());
}

class DebtTrackerApp extends StatefulWidget {
  const DebtTrackerApp({super.key});

  @override
  _DebtTrackerAppState createState() => _DebtTrackerAppState();
}

class _DebtTrackerAppState extends State<DebtTrackerApp> {
  ThemeMode _themeMode = ThemeMode.light;
  Locale _locale = const Locale('tr', 'TR');

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Borç Takip Uygulaması',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      darkTheme: ThemeData.dark(),
      themeMode: _themeMode,
      locale: _locale,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en', 'US'),
        Locale('tr', 'TR'),
      ],
      home: DebtTrackerHomePage(
        onThemeModeChanged: (ThemeMode mode) {
          setState(() {
            _themeMode = mode;
          });
        },
        onLocaleChanged: (Locale locale) {
          setState(() {
            _locale = locale;
          });
        },
      ),
    );
  }
}
