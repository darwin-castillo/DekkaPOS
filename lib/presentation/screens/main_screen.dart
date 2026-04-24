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
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      body: Row(
        children: [
          _SideMenu(),
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
  static const _navItems = [
    _NavData(icon: Icons.point_of_sale, label: 'Ventas'),
    _NavData(icon: Icons.inventory_2, label: 'Productos'),
    _NavData(icon: Icons.people, label: 'Clientes'),
    _NavData(icon: Icons.local_shipping, label: 'Proveed.'),
    _NavData(icon: Icons.analytics, label: 'Reportes'),
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
              Container(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Icon(Icons.storefront, size: 40, color: Colors.white),
                    const SizedBox(height: 8),
                    Text(
                      'DekkaPOS',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Divider(color: Colors.white24, indent: 24, endIndent: 24),
              const SizedBox(height: 8),
              Expanded(
                child: Column(
                  children: List.generate(_navItems.length, (index) {
                    final isSelected = nav.selectedIndex == index;
                    return _NavButton(
                      icon: _navItems[index].icon,
                      label: _navItems[index].label,
                      isSelected: isSelected,
                      onTap: () => nav.setIndex(index),
                    );
                  }),
                ),
              ),
              Divider(color: Colors.white24, indent: 24, endIndent: 24),
              _NavButton(
                icon: Icons.settings,
                label: 'Ajustes',
                isSelected: false,
                onTap: () {},
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavData {
  final IconData icon;
  final String label;
  const _NavData({required this.icon, required this.label});
}

class _NavButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _NavButton({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 12),
      child: Material(
        color: isSelected ? Colors.white : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(8),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  icon,
                  size: 24,
                  color: isSelected ? AppTheme.primaryColor : Colors.white70,
                ),
                const SizedBox(height: 4),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: isSelected
                        ? FontWeight.w600
                        : FontWeight.normal,
                    color: isSelected ? AppTheme.primaryColor : Colors.white70,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
