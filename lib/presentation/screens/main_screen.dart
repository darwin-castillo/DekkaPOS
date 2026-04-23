import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/navigation_provider.dart';
import 'ventas_screen.dart';
import 'productos_screen.dart';
import 'clientes_screen.dart';
import 'proveedores_screen.dart';
import 'reportes_screen.dart';
import '../../core/theme.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  static final _screens = <Widget>[
    const VentasScreen(),
    const ProductosScreen(),
    const ClientesScreen(),
    const ProveedoresScreen(),
    const ReportesScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Consumer<NavigationProvider>(
            builder: (context, nav, _) => NavigationRail(
              selectedIndex: nav.selectedIndex,
              onDestinationSelected: nav.setIndex,
              labelType: NavigationRailLabelType.all,
              backgroundColor: AppTheme.primaryColor,
              destinations: const [
                NavigationRailDestination(
                  icon: Icon(Icons.point_of_sale, size: 32, color: Colors.white70),
                  selectedIcon: Icon(Icons.point_of_sale, size: 32, color: Colors.white),
                  label: Text('Ventas', style: TextStyle(color: Colors.white)),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.inventory_2, size: 32, color: Colors.white70),
                  selectedIcon: Icon(Icons.inventory_2, size: 32, color: Colors.white),
                  label: Text('Productos', style: TextStyle(color: Colors.white)),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.people, size: 32, color: Colors.white70),
                  selectedIcon: Icon(Icons.people, size: 32, color: Colors.white),
                  label: Text('Clientes', style: TextStyle(color: Colors.white)),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.local_shipping, size: 32, color: Colors.white70),
                  selectedIcon: Icon(Icons.local_shipping, size: 32, color: Colors.white),
                  label: Text('Proveedores', style: TextStyle(color: Colors.white)),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.analytics, size: 32, color: Colors.white70),
                  selectedIcon: Icon(Icons.analytics, size: 32, color: Colors.white),
                  label: Text('Reportes', style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ),
          const VerticalDivider(thickness: 1, width: 1),
          Expanded(
            child: Consumer<NavigationProvider>(
              builder: (context, nav, _) => _screens[nav.selectedIndex],
            ),
          ),
        ],
      ),
    );
  }
}