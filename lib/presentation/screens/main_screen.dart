import 'package:dekkapos/presentation/widgets/nav_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/navigation_provider.dart';
import 'ventas_screen.dart';
import 'productos_screen.dart';
import 'clientes_screen.dart';
import 'proveedores_screen.dart';
import 'reportes_screen.dart';
import 'facturas_screen.dart';
import 'configuracion_screen.dart';
import '../../core/theme.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  static final _screens = <Widget>[
    const VentasScreen(),
    const ProductosScreen(),
    const ClientesScreen(),
    const ProveedoresScreen(),
    const ReportesScreen(),
    const FacturasScreen(),
    const ConfiguracionScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      body: Row(
        children: [
          const _SideMenu(),
          Container(width: 1, color: colorScheme.outlineVariant),
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

class _SideMenu extends StatelessWidget {
  const _SideMenu();

  static const _navItems = [
    _NavData(icon: Icons.point_of_sale, label: 'Ventas'),
    _NavData(icon: Icons.inventory_2, label: 'Productos'),
    _NavData(icon: Icons.people, label: 'Clientes'),
    _NavData(icon: Icons.local_shipping, label: 'Proveed.'),
    _NavData(icon: Icons.analytics, label: 'Reportes'),
    _NavData(icon: Icons.receipt_long, label: 'Facturas'),
    _NavData(icon: Icons.settings, label: 'Ajustes'),
  ];

  @override
  Widget build(BuildContext context) {
    return Consumer<NavigationProvider>(
      builder: (context, nav, _) => Container(
        width: 140,
        decoration: const BoxDecoration(gradient: AppTheme.sidebarGradient),
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 16),
              const _Logo(),
              const SizedBox(height: 8),
              const Divider(color: Colors.white24, indent: 24, endIndent: 24),
              const SizedBox(height: 8),
              ...List.generate(
                _navItems.length,
                (index) => NavButton(
                  icon: _navItems[index].icon,
                  label: _navItems[index].label,
                  isSelected: nav.selectedIndex == index,
                  onTap: () => nav.setIndex(index),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}

class _Logo extends StatelessWidget {
  const _Logo();

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Icon(Icons.storefront, size: 40, color: Colors.white),
        SizedBox(height: 8),
        Text(
          'DekkaPOS',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

class _NavData {
  final IconData icon;
  final String label;
  const _NavData({required this.icon, required this.label});
}
