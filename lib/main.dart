import 'package:flutter/material.dart';
import 'package:inventory_desktop/providers/LocationListProvider.dart';
import 'package:inventory_desktop/providers/ProductsListProvider.dart';
import 'package:inventory_desktop/providers/dashboardProvider.dart';
import 'package:provider/provider.dart';

import 'providers/MovementListProvider.dart';
import 'screens/DashboardPage.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ProductsListProvider()),
        ChangeNotifierProvider(create: (_) => LocationListProvider()),
        ChangeNotifierProvider(create: (_) => MovementListProvider()),
        ChangeNotifierProvider(create: (_) => DashboardProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsFlutterBinding.ensureInitialized();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: const DashboardPage(),
    );
  }
}
