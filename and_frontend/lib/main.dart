import 'package:flutter/material.dart';
import 'package:helpcivic/app/router.dart';
import 'package:helpcivic/app/theme.dart';
import 'package:helpcivic/features/auth/screens/login_screen.dart';
import 'package:helpcivic/mongodb.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  MongoDatabase.connect();
  runApp(const SmartCivicApp());
}

class SmartCivicApp extends StatelessWidget {
  const SmartCivicApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smart Civic App',
      theme: AppTheme.lightTheme,
      debugShowCheckedModeBanner: false,
      // Our router will handle all navigation
      onGenerateRoute: AppRouter.generateRoute,
      // The first screen the user sees is the Login Screen
      home: const LoginScreen(),
    );
  }
}