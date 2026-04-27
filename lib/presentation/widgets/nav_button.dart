import 'package:flutter/material.dart';

import '../../core/theme.dart';

class NavButton extends StatefulWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const NavButton({
    super.key,
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  State<NavButton> createState() => _NavButtonState();
}

class _NavButtonState extends State<NavButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final color = widget.isSelected
        ? AppTheme.primaryColor
        : _isHovered
        ? Colors.white
        : Colors.white70;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 12),
      child: Material(
        color: widget.isSelected ? Colors.white : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
        child: InkWell(
          onTap: widget.onTap,
          onHover: (value) => setState(() => _isHovered = value),
          borderRadius: BorderRadius.circular(8),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(widget.icon, size: 24, color: color),
                const SizedBox(height: 4),
                Text(
                  widget.label,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: widget.isSelected
                        ? FontWeight.w600
                        : FontWeight.normal,
                    color: color,
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
