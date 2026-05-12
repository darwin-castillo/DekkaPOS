import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

// ─────────────────────────────────────────
// SideMenuBar
// Renders the left sidebar with nav items,
// logo, brand label and user avatar.
// ─────────────────────────────────────────
class SideMenuBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onItemSelected;

  const SideMenuBar({
    super.key,
    required this.selectedIndex,
    required this.onItemSelected,
  });

  static const _navItems = <_NavEntry>[
    _NavEntry(label: 'Ventas', icon: Icons.desktop_mac_outlined),
    _NavEntry(label: 'Prod.', icon: Icons.inventory_2_outlined),
    _NavEntry(label: 'Clientes', icon: Icons.group_outlined),
    _NavEntry(label: 'Proveed.', icon: Icons.local_shipping_outlined),
    _NavEntry(label: 'Reportes', icon: Icons.bar_chart_rounded),
    _NavEntry(label: 'Facturas', icon: Icons.receipt_long_outlined),
    _NavEntry(label: 'Ajustes', icon: Icons.settings_outlined),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      color: AppColors.sidebarBg,
      child: Column(
        children: [
          // ── Logo ──────────────────────────
          _SidebarLogo(),
          const SizedBox(height: 4),
          // ── Brand label ───────────────────
          const Text('DEKKA', style: AppTextStyles.sidebarLabel),
          const SizedBox(height: 8),
          // ── Nav items ─────────────────────
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(vertical: 4),
              itemCount: _navItems.length,
              separatorBuilder: (_, __) => const SizedBox(height: 2),
              itemBuilder: (context, i) => _NavTile(
                entry: _navItems[i],
                isActive: selectedIndex == i,
                onTap: () => onItemSelected(i),
              ),
            ),
          ),
          // ── User avatar ───────────────────
          _UserAvatar(),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────
// _SidebarLogo
// ─────────────────────────────────────────
class _SidebarLogo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 72,
      height: 64,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        border: Border(
          bottom: BorderSide(color: Colors.white.withOpacity(0.07), width: 0.5),
        ),
      ),
      child: Center(
        child: Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.all(6),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _LogoBar(width: double.infinity, color: AppColors.accentMid),
              _LogoBar(width: 14, color: AppColors.accent),
              _LogoBar(width: 8, color: AppColors.accentDark),
            ],
          ),
        ),
      ),
    );
  }
}

class _LogoBar extends StatelessWidget {
  final double width;
  final Color color;
  const _LogoBar({required this.width, required this.color});

  @override
  Widget build(BuildContext context) => Container(
    width: width,
    height: 3,
    decoration: BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(2),
    ),
  );
}

// ─────────────────────────────────────────
// _NavTile
// ─────────────────────────────────────────
class _NavTile extends StatelessWidget {
  final _NavEntry entry;
  final bool isActive;
  final VoidCallback onTap;

  const _NavTile({
    required this.entry,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          width: 52,
          height: 52,
          decoration: BoxDecoration(
            color: isActive
                ? AppColors.accent.withOpacity(0.25)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Stack(
            children: [
              // Active dot indicator
              if (isActive)
                Positioned(
                  right: 20,
                  top: 0,
                  bottom: 0,
                  child: Center(
                    child: Container(
                      width: 4,
                      height: 4,
                      decoration: const BoxDecoration(
                        color: AppColors.accentMid,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ),
              // Icon + label
              SizedBox(
                width: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      entry.icon,
                      size: 20,
                      color: isActive ? Colors.white : Colors.white54,
                    ),
                    const SizedBox(height: 3),
                    Text(
                      entry.label,
                      style: AppTextStyles.navLabel.copyWith(
                        color: isActive ? Colors.white : Colors.white54,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────
// _UserAvatar
// ─────────────────────────────────────────
class _UserAvatar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF7C63F5), AppColors.accentDark],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: const Center(
        child: Text(
          'A',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

class _NavEntry {
  final String label;
  final IconData icon;
  const _NavEntry({required this.label, required this.icon});
}
