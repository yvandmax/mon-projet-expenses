// lib/main.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:expense_tracker_app/providers/auth_provider.dart';
import 'package:expense_tracker_app/providers/expense_provider.dart';
import 'package:expense_tracker_app/providers/income_provider.dart';
import 'package:expense_tracker_app/providers/category_provider.dart';
import 'package:expense_tracker_app/providers/budget_provider.dart';
import 'package:expense_tracker_app/providers/bank_account_provider.dart';
import 'package:expense_tracker_app/providers/alert_provider.dart';
import 'package:expense_tracker_app/screens/auth/login_screen.dart';
import 'package:expense_tracker_app/screens/dashboard/dashboard_screen.dart';
import 'package:expense_tracker_app/config/app_theme.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => ExpenseProvider()),
        ChangeNotifierProvider(create: (_) => IncomeProvider()),
        ChangeNotifierProvider(create: (_) => CategoryProvider()),
        ChangeNotifierProvider(create: (_) => BudgetProvider()),
        ChangeNotifierProvider(create: (_) => BankAccountProvider()),
        ChangeNotifierProvider(create: (_) => AlertProvider()),
      ],
      child: Consumer<AuthProvider>(
        builder: (context, authProvider, _) {
          return MaterialApp(
            title: 'Finance Tracker',
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: ThemeMode.system,
            home: FutureBuilder<bool>(
              future: authProvider.isLoggedIn(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Scaffold(body: Center(child: CircularProgressIndicator()));
                }

                final bool isLoggedIn = snapshot.data ?? false;
                return isLoggedIn ? DashboardScreen() : LoginScreen();
              },
            ),
            routes: {
              '/login': (context) => LoginScreen(),
              '/dashboard': (context) => DashboardScreen(),
              // Ajoute les autres routes ici
            },
          );
        },
      ),
    );
  }
}