import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/theme.dart';
import 'data/datasources/datasources.dart';
import 'data/repositories/repositories.dart';
import 'domain/repositories/repositories.dart';
import 'presentation/providers/providers.dart';
import 'presentation/screens/main_screen.dart';

void main() {
  runApp(const POSApp());
}

class POSApp extends StatelessWidget {
  const POSApp({super.key});

  @override
  Widget build(BuildContext context) {
    final productDataSource = LocalProductDataSource();
    final clientDataSource = LocalClientDataSource();
    final providerDataSource = LocalProviderDataSource();

    final productRepository = ProductRepositoryImpl(productDataSource);
    final clientRepository = ClientRepositoryImpl(clientDataSource);
    final providerRepository = ProviderRepositoryImpl(providerDataSource);

    return MultiProvider(
      providers: [
        Provider<ProductRepository>.value(value: productRepository),
        Provider<ClientRepository>.value(value: clientRepository),
        Provider<ProviderRepository>.value(value: providerRepository),
        ChangeNotifierProvider(create: (_) => ProductProvider(productRepository)),
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => ClientProvider(clientRepository)),
        ChangeNotifierProvider(create: (_) => NavigationProvider()),
      ],
      child: MaterialApp(
        title: 'Punto de Venta',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        home: const MainScreen(),
      ),
    );
  }
}