import 'package:flutter/material.dart';
import '../../core/theme.dart';

class DekkaAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final Widget? leading;
  final bool showUserMenu;
  final String userName;
  final String userEmail;
  final String userInitial;
  final VoidCallback? onUserTap;
  final VoidCallback? onProfileTap;
  final VoidCallback? onSettingsTap;
  final VoidCallback? onLogoutTap;

  const DekkaAppBar({
    super.key,
    required this.title,
    this.actions,
    this.leading,
    this.showUserMenu = true,
    this.userName = 'Administrador',
    this.userEmail = 'admin@dekkapos.com',
    this.userInitial = 'A',
    this.onUserTap,
    this.onProfileTap,
    this.onSettingsTap,
    this.onLogoutTap,
  });

  @override
  Size get preferredSize => const Size.fromHeight(60);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      leading: leading,
      actions: [
        ...?actions,
        if (showUserMenu) _UserMenuButton(
          userName: userName,
          userEmail: userEmail,
          userInitial: userInitial,
          onTap: onUserTap,
          onProfileTap: onProfileTap,
          onSettingsTap: onSettingsTap,
          onLogoutTap: onLogoutTap,
        ),
        const SizedBox(width: 8),
      ],
      flexibleSpace: Container(
        decoration: const BoxDecoration(
          gradient: AppTheme.sidebarGradient,
        ),
      ),
      elevation: 0,
      centerTitle: false,
    );
  }
}

class _UserMenuButton extends StatelessWidget {
  final String userName;
  final String userEmail;
  final String userInitial;
  final VoidCallback? onTap;
  final VoidCallback? onProfileTap;
  final VoidCallback? onSettingsTap;
  final VoidCallback? onLogoutTap;

  const _UserMenuButton({
    required this.userName,
    required this.userEmail,
    required this.userInitial,
    this.onTap,
    this.onProfileTap,
    this.onSettingsTap,
    this.onLogoutTap,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      offset: const Offset(0, 50),
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      onSelected: (value) {
        switch (value) {
          case 'profile':
            onProfileTap?.call();
            break;
          case 'settings':
            onSettingsTap?.call();
            break;
          case 'logout':
            onLogoutTap?.call();
            break;
        }
      },
      itemBuilder: (context) => [
        PopupMenuItem(
          value: 'profile',
          child: Row(
            children: [
              Icon(Icons.person, size: 20, color: AppTheme.primaryColor),
              const SizedBox(width: 12),
              Text(userName, style: const TextStyle(fontWeight: FontWeight.w600)),
            ],
          ),
        ),
        const PopupMenuItem(
          value: 'settings',
          child: Row(
            children: [
              Icon(Icons.settings, size: 20, color: AppTheme.primaryColor),
              SizedBox(width: 12),
              Text('Configuración'),
            ],
          ),
        ),
        const PopupMenuDivider(),
        const PopupMenuItem(
          value: 'logout',
          child: Row(
            children: [
              Icon(Icons.logout, size: 20, color: Colors.red),
              SizedBox(width: 12),
              Text('Cerrar sesi��n', style: TextStyle(color: Colors.red)),
            ],
          ),
        ),
      ],
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 16,
              backgroundColor: Colors.white,
              child: Text(
                userInitial,
                style: TextStyle(
                  color: AppTheme.primaryColor,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  userName,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                Text(
                  userEmail,
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.white.withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
            const SizedBox(width: 4),
            Icon(
              Icons.expand_more,
              size: 20,
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}