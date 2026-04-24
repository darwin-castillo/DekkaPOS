import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/theme.dart';
import 'data/database_helper.dart';
import 'presentation/providers/product_provider.dart';
import 'presentation/providers/cart_provider.dart';
import 'presentation/providers/client_provider.dart';
import 'presentation/providers/navigation_provider.dart';
import 'presentation/screens/main_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  final dbHelper = DatabaseHelper();
  await dbHelper.database;
  
  runApp(const DekkaPOS());
}

class DekkaPOS extends StatelessWidget {
  const DekkaPOS({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ProductProvider()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => ClientProvider()),
        ChangeNotifierProvider(create: (_) => NavigationProvider()),
      ],
      child: MaterialApp(
        title: 'DekkaPOS',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        home: const MainScreen(),
      ),
    );
  }
}