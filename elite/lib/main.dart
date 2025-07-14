import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'pages/welcome_page.dart';
import 'pages/dashboard_page.dart';
import 'pages/login_page.dart';
import 'pages/registration_page.dart';
import 'pages/booking_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: 'AIzaSyDnpvGzEVXLKn6whmvrAf0AvNlZwyYJMc8',
      appId: '1:490796151726:android:58783b0ee5fe3e30598e3f',
      messagingSenderId: '490796151726',
      projectId: 'elite-resort-943b8',
      storageBucket: 'elite-resort-943b8.firebasestorage.app',
    ),
  );
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Elite Resort',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const DashboardPage(),
        '/login': (context) => const LoginPage(),
        '/register': (context) => const RegistrationPage(),
        '/booking': (context) => const BookingPage(),
      },
    );
  }
}

