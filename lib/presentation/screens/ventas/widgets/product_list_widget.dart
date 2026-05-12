import 'package:flutter/material.dart';
import '../../domain/entities/product.dart';
import '../../../core/theme/app_theme.dart';

// ─────────────────────────────────────────
// ProductListWidget
// Scrollable list of product tiles.
// Emits onProductTap when a tile is tapped.
// ─────────────────────────────────────────
class ProductListWidget extends StatelessWidget {
  final List<Product> products;
  final ValueChanged<Product> onProductTap;

  const ProductListWidget({
    super.key,
    required this.products,
    required this.onProductTap,
  });

  @override
  Widget build(BuildContext context) {
    if (products.isEmpty) {
      return const Center(
        child: Text(
          'Sin resultados',
          style: TextStyle(fontSize: 12, color: AppColors.textMuted),
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      itemCount: products.length,
      separatorBuilder: (_, __) => const SizedBox(height: 2),
      itemBuilder: (context, i) => ProductTile(
        product: products[i],
        onTap: () => onProductTap(products[i]),
      ),
    );
  }
}

// ─────────────────────────────────────────
// ProductTile
// Single product row with emoji thumb,
// name, code, price and unit tag.
// ─────────────────────────────────────────
class ProductTile extends StatefulWidget {
  final Product product;
  final VoidCallback onTap;

  const ProductTile({super.key, required this.product, required this.onTap});

  @override
  State<ProductTile> createState() => _ProductTileState();
}

class _ProductTileState extends State<ProductTile> {
  bool _flashing = false;

  void _handleTap() {
    setState(() => _flashing = true);
    Future.delayed(const Duration(milliseconds: 280), () {
      if (mounted) setState(() => _flashing = false);
    });
    widget.onTap();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 9),
        decoration: BoxDecoration(
          color: _flashing ? AppColors.accentLight : Colors.transparent,
          border: Border.all(
            color: _flashing
                ? AppColors.accent.withOpacity(0.35)
                : Colors.transparent,
            width: 0.5,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            // Emoji thumbnail
            // _ProductThumb(emoji: widget.product.emoji),
            const SizedBox(width: 10),
            // Name + code
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.product.name,
                    style: AppTextStyles.productName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '# ${widget.product.code}',
                    style: AppTextStyles.productCode,
                  ),
                ],
              ),
            ),
            // Price + unit tag
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  'Bs ${widget.product.price.toStringAsFixed(2)}',
                  style: AppTextStyles.productPrice,
                ),
                const SizedBox(height: 3),
                UnitTag(unit: widget.product.unit.name),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────
// _ProductThumb
// Square emoji container
// ─────────────────────────────────────────
class _ProductThumb extends StatelessWidget {
  final String emoji;
  const _ProductThumb({required this.emoji});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: AppColors.mainBg,
        border: Border.all(color: AppColors.divider, width: 0.5),
        borderRadius: BorderRadius.circular(9),
      ),
      child: Center(child: Text(emoji, style: const TextStyle(fontSize: 18))),
    );
  }
}

// ─────────────────────────────────────────
// UnitTag
// Reusable pill: "kg" / "und"
// Exported for use in cart table too.
// ─────────────────────────────────────────
class UnitTag extends StatelessWidget {
  final String unit;
  const UnitTag({super.key, required this.unit});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
      decoration: BoxDecoration(
        color: AppColors.tagBg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        unit,
        style: const TextStyle(
          fontSize: 9,
          fontWeight: FontWeight.w600,
          color: AppColors.tagText,
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────
// ProductListHeader
// Panel header with icon, title and count.
// ─────────────────────────────────────────
class ProductListHeader extends StatelessWidget {
  final int count;
  const ProductListHeader({super.key, required this.count});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
      decoration: const BoxDecoration(
        color: AppColors.panelBg,
        border: Border(
          bottom: BorderSide(color: AppColors.divider, width: 0.5),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: AppColors.accentLight,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Center(
              child: Icon(
                Icons.inventory_2_outlined,
                size: 15,
                color: AppColors.accent,
              ),
            ),
          ),
          const SizedBox(width: 9),
          const Text('Productos', style: AppTextStyles.panelTitle),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: AppColors.accent.withOpacity(0.10),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '$count items',
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: AppColors.accent,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
