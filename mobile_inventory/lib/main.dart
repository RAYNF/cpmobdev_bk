import 'package:flutter/material.dart';
import 'package:mobile_inventory/presentation/pages/add_categori_screen.dart';
import 'package:mobile_inventory/presentation/pages/add_product_screen.dart';
import 'package:mobile_inventory/presentation/pages/dashboard_screen.dart';
import 'package:mobile_inventory/presentation/pages/detail_product_screen.dart';
import 'package:mobile_inventory/presentation/pages/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Inventory Apps',
      initialRoute: '/splash',
      routes: {
        '/splash': (context) => SplashScreen(),
        '/dashboard': (context) => DashboardScreen(),
        '/addproduct': (context) => AddproductScreen(),
        '/detail': (context) => DetailproductScreen(),
        '/addkategori': (context) => AddcategoriScreen()
      },
    );
  }
}
