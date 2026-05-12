import 'package:flutter/material.dart';
import '../../domain/entities/product.dart';
import '../../../core/theme/app_theme.dart';

import 'product_list_widget.dart';

// ─────────────────────────────────────────
// CartItem model
// ─────────────────────────────────────────
class CartItem {
  final Product product;
  int qty;

  CartItem({required this.product, this.qty = 1});

  double get lineTotal => product.price * qty;
}

// ─────────────────────────────────────────
// ShoppingCartWidget
// Full cart panel: header (customer),
// DataTable body, and totals footer.
// ─────────────────────────────────────────
class ShoppingCartWidget extends StatelessWidget {
  final List<CartItem> items;
  final String customerName;
  final VoidCallback onAssignCustomer;
  final ValueChanged<CartItem> onIncrement;
  final ValueChanged<CartItem> onDecrement;
  final ValueChanged<CartItem> onRemove;
  final VoidCallback onClear;
  final VoidCallback onCheckout;

  const ShoppingCartWidget({
    super.key,
    required this.items,
    required this.customerName,
    required this.onAssignCustomer,
    required this.onIncrement,
    required this.onDecrement,
    required this.onRemove,
    required this.onClear,
    required this.onCheckout,
  });

  double get _subtotal => items.fold(0, (sum, it) => sum + it.lineTotal);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // ── Customer header ───────────────
        CartCustomerHeader(
          customerName: customerName,
          onAssign: onAssignCustomer,
          sessionId: '#0042',
        ),
        // ── Table / empty state ───────────
        Expanded(
          child: items.isEmpty
              ? const CartEmptyState()
              : CartDataTable(
                  items: items,
                  onIncrement: onIncrement,
                  onDecrement: onDecrement,
                  onRemove: onRemove,
                ),
        ),
        // ── Footer ────────────────────────
        CartFooter(
          subtotal: _subtotal,
          itemCount: items.length,
          totalQty: items.fold(0, (s, it) => s + it.qty),
          onClear: onClear,
          onCheckout: onCheckout,
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────
// CartCustomerHeader
// Shows customer name, session tag and
// edit pencil button.
// ─────────────────────────────────────────
class CartCustomerHeader extends StatelessWidget {
  final String customerName;
  final VoidCallback onAssign;
  final String sessionId;

  const CartCustomerHeader({
    super.key,
    required this.customerName,
    required this.onAssign,
    required this.sessionId,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
      decoration: const BoxDecoration(
        color: AppColors.panelBg,
        border: Border(
          bottom: BorderSide(color: AppColors.divider, width: 0.5),
        ),
      ),
      child: Row(
        children: [
          // Icon
          Container(
            width: 26,
            height: 26,
            decoration: BoxDecoration(
              color: AppColors.mainBg,
              border: Border.all(color: AppColors.divider, width: 0.5),
              borderRadius: BorderRadius.circular(7),
            ),
            child: const Center(
              child: Icon(
                Icons.person_outline,
                size: 14,
                color: AppColors.textMuted,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            customerName,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: AppColors.textSecondary,
            ),
          ),
          const Spacer(),
          // Session tag
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
            decoration: BoxDecoration(
              color: AppColors.mainBg,
              border: Border.all(color: AppColors.divider, width: 0.5),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              sessionId,
              style: const TextStyle(
                fontSize: 9,
                fontWeight: FontWeight.w600,
                color: AppColors.textMuted,
                fontFamily: 'monospace',
              ),
            ),
          ),
          const SizedBox(width: 8),
          // Edit button
          GestureDetector(
            onTap: onAssign,
            child: Container(
              width: 26,
              height: 26,
              decoration: BoxDecoration(
                color: AppColors.mainBg,
                border: Border.all(color: AppColors.divider, width: 0.5),
                borderRadius: BorderRadius.circular(7),
              ),
              child: const Center(
                child: Icon(
                  Icons.edit_outlined,
                  size: 13,
                  color: AppColors.textMuted,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────
// CartEmptyState
// Shown when cart has no items.
// ─────────────────────────────────────────
class CartEmptyState extends StatelessWidget {
  const CartEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.panelBg,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: AppColors.mainBg,
                border: Border.all(color: AppColors.divider, width: 0.5),
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Center(
                child: Text('🛒', style: TextStyle(fontSize: 24)),
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Carrito vacío',
              style: TextStyle(fontSize: 12, color: AppColors.textMuted),
            ),
            const SizedBox(height: 4),
            const Text(
              'Seleccione productos de la lista',
              style: TextStyle(fontSize: 10, color: AppColors.textMuted),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────
// CartDataTable
// Sticky-header data table with columns:
// Producto | Código | Unidad | P.Unit | Qty | Total | ×
// ─────────────────────────────────────────
class CartDataTable extends StatelessWidget {
  final List<CartItem> items;
  final ValueChanged<CartItem> onIncrement;
  final ValueChanged<CartItem> onDecrement;
  final ValueChanged<CartItem> onRemove;

  const CartDataTable({
    super.key,
    required this.items,
    required this.onIncrement,
    required this.onDecrement,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.panelBg,
      child: Column(
        children: [
          // Sticky header
          _TableHeader(),
          // Scrollable rows
          Expanded(
            child: ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, i) => CartTableRow(
                item: items[i],
                isEven: i.isEven,
                onIncrement: () => onIncrement(items[i]),
                onDecrement: () => onDecrement(items[i]),
                onRemove: () => onRemove(items[i]),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────
// _TableHeader
// ─────────────────────────────────────────
class _TableHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.tableHeader,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      child: Row(
        children: const [
          _TH('Producto', flex: 8, align: CrossAxisAlignment.start),
          _TH('Código', flex: 4, align: CrossAxisAlignment.start),
          _TH('Unidad', flex: 3, align: CrossAxisAlignment.center),
          _TH('P. Unit.', flex: 4, align: CrossAxisAlignment.end),
          _TH('Cantidad', flex: 5, align: CrossAxisAlignment.center),
          _TH('Total', flex: 4, align: CrossAxisAlignment.end),
          _TH('', flex: 2, align: CrossAxisAlignment.center),
        ],
      ),
    );
  }
}

class _TH extends StatelessWidget {
  final String label;
  final int flex;
  final CrossAxisAlignment align;
  const _TH(this.label, {required this.flex, required this.align});

  @override
  Widget build(BuildContext context) => Expanded(
    flex: flex,
    child: Align(
      alignment: align == CrossAxisAlignment.start
          ? Alignment.centerLeft
          : align == CrossAxisAlignment.end
          ? Alignment.centerRight
          : Alignment.center,
      child: Text(label, style: AppTextStyles.tableHeader),
    ),
  );
}

// ─────────────────────────────────────────
// CartTableRow
// Single row in the cart datatable.
// ─────────────────────────────────────────
class CartTableRow extends StatelessWidget {
  final CartItem item;
  final bool isEven;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final VoidCallback onRemove;

  const CartTableRow({
    super.key,
    required this.item,
    required this.isEven,
    required this.onIncrement,
    required this.onDecrement,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: isEven ? AppColors.tableRowEven : AppColors.panelBg,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      child: Row(
        children: [
          // Product name + emoji
          Expanded(
            flex: 8,
            child: Row(
              children: [
                Text("-", style: const TextStyle(fontSize: 15)),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    item.product.name,
                    style: AppTextStyles.tableCell,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          // Code
          Expanded(
            flex: 4,
            child: Text(item.product.code, style: AppTextStyles.tableCellMono),
          ),
          // Unit tag
          Expanded(
            flex: 3,
            child: Center(child: UnitTag(unit: item.product.unit.code)),
          ),
          // Unit price
          Expanded(
            flex: 4,
            child: Align(
              alignment: Alignment.centerRight,
              child: Text(
                'Bs ${item.product.price.toStringAsFixed(2)}',
                style: AppTextStyles.tableCellPrice,
              ),
            ),
          ),
          // Qty stepper
          Expanded(
            flex: 5,
            child: Center(
              child: QtyStepper(
                qty: item.qty,
                onIncrement: onIncrement,
                onDecrement: onDecrement,
              ),
            ),
          ),
          // Line total
          Expanded(
            flex: 4,
            child: Align(
              alignment: Alignment.centerRight,
              child: Text(
                'Bs ${item.lineTotal.toStringAsFixed(2)}',
                style: AppTextStyles.tableCellPrice,
              ),
            ),
          ),
          // Delete
          Expanded(
            flex: 2,
            child: Center(child: _DeleteButton(onTap: onRemove)),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────
// QtyStepper
// −  N  + controls for quantity.
// ─────────────────────────────────────────
class QtyStepper extends StatelessWidget {
  final int qty;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;

  const QtyStepper({
    super.key,
    required this.qty,
    required this.onIncrement,
    required this.onDecrement,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _StepBtn(icon: Icons.remove, onTap: onDecrement),
        const SizedBox(width: 5),
        SizedBox(
          width: 20,
          child: Text(
            '$qty',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
              fontFamily: 'monospace',
            ),
          ),
        ),
        const SizedBox(width: 5),
        _StepBtn(icon: Icons.add, onTap: onIncrement),
      ],
    );
  }
}

class _StepBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _StepBtn({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 20,
        height: 20,
        decoration: BoxDecoration(
          color: AppColors.mainBg,
          border: Border.all(color: AppColors.divider, width: 0.5),
          borderRadius: BorderRadius.circular(5),
        ),
        child: Center(
          child: Icon(icon, size: 13, color: AppColors.textSecondary),
        ),
      ),
    );
  }
}

class _DeleteButton extends StatelessWidget {
  final VoidCallback onTap;
  const _DeleteButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 20,
        height: 20,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(5)),
        child: const Center(
          child: Icon(Icons.close, size: 12, color: AppColors.textMuted),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────
// CartFooter
// Summary rows, currency pills, cancel/pay.
// ─────────────────────────────────────────
class CartFooter extends StatelessWidget {
  final double subtotal;
  final int itemCount;
  final int totalQty;
  final VoidCallback onClear;
  final VoidCallback onCheckout;

  static const double _copRate = 1050;
  static const double _usdRate = 36.5;

  const CartFooter({
    super.key,
    required this.subtotal,
    required this.itemCount,
    required this.totalQty,
    required this.onClear,
    required this.onCheckout,
  });

  @override
  Widget build(BuildContext context) {
    final cop = subtotal * _copRate;
    final usd = subtotal / _usdRate;

    return Container(
      color: AppColors.panelBg,
      padding: const EdgeInsets.fromLTRB(18, 12, 18, 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Item count strip
          if (itemCount > 0) ...[
            Row(
              children: [
                _CountPill(label: '$itemCount ítems'),
                const Spacer(),
                GestureDetector(
                  onTap: onClear,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.divider, width: 0.5),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Text(
                      'Limpiar todo',
                      style: TextStyle(
                        fontSize: 10,
                        color: AppColors.textMuted,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
          ],
          // Subtotal
          _TotalRow(
            label: 'Subtotal',
            value: 'Bs ${subtotal.toStringAsFixed(2)}',
          ),
          const SizedBox(height: 4),
          _TotalRow(label: 'Impuesto (0.0%)', value: 'Bs 0.00'),
          const Divider(height: 14, thickness: 0.5, color: AppColors.divider),
          // Grand total
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('TOTAL', style: AppTextStyles.grandTotalLabel),
              Text(
                'Bs ${subtotal.toStringAsFixed(2)}',
                style: AppTextStyles.grandTotalValue,
              ),
            ],
          ),
          const SizedBox(height: 10),
          // Currency pills
          Row(
            children: [
              Expanded(
                child: _CurrencyPill(
                  label: 'COP',
                  value: cop.toStringAsFixed(0),
                ),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: _CurrencyPill(
                  label: 'USD',
                  value: usd.toStringAsFixed(2),
                ),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: _CurrencyPill(label: 'Ítems', value: '$totalQty'),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Action buttons
          CartActionButtons(
            subtotal: subtotal,
            onCancel: onClear,
            onCheckout: onCheckout,
          ),
        ],
      ),
    );
  }
}

class _TotalRow extends StatelessWidget {
  final String label;
  final String value;
  const _TotalRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) => Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(label, style: AppTextStyles.totalLabel),
      Text(value, style: AppTextStyles.totalValue),
    ],
  );
}

class _CountPill extends StatelessWidget {
  final String label;
  const _CountPill({required this.label});

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
    decoration: BoxDecoration(
      color: AppColors.accentLight,
      borderRadius: BorderRadius.circular(20),
    ),
    child: Text(
      label,
      style: const TextStyle(
        fontSize: 10,
        fontWeight: FontWeight.w600,
        color: AppColors.tagText,
      ),
    ),
  );
}

class _CurrencyPill extends StatelessWidget {
  final String label;
  final String value;
  const _CurrencyPill({required this.label, required this.value});

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
    decoration: BoxDecoration(
      color: AppColors.mainBg,
      border: Border.all(color: AppColors.divider, width: 0.5),
      borderRadius: BorderRadius.circular(8),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyles.currencyLabel),
        const SizedBox(height: 1),
        Text(value, style: AppTextStyles.currencyValue),
      ],
    ),
  );
}

// ─────────────────────────────────────────
// CartActionButtons
// Cancel + Checkout row
// ─────────────────────────────────────────
class CartActionButtons extends StatelessWidget {
  final double subtotal;
  final VoidCallback onCancel;
  final VoidCallback onCheckout;

  const CartActionButtons({
    super.key,
    required this.subtotal,
    required this.onCancel,
    required this.onCheckout,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Cancel
        OutlinedButton.icon(
          onPressed: onCancel,
          icon: const Icon(Icons.close, size: 14),
          label: const Text('Cancelar'),
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.textSecondary,
            side: const BorderSide(color: AppColors.divider, width: 0.5),
            backgroundColor: AppColors.mainBg,
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
            textStyle: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
        const SizedBox(width: 8),
        // Checkout
        Expanded(
          child: ElevatedButton.icon(
            onPressed: onCheckout,
            icon: const Icon(
              Icons.check_circle_outline,
              size: 16,
              color: Colors.white,
            ),
            label: Text(
              subtotal > 0
                  ? 'COBRAR  Bs ${subtotal.toStringAsFixed(2)}'
                  : 'COBRAR',
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: Colors.white,
                letterSpacing: 0.3,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.accent,
              padding: const EdgeInsets.symmetric(vertical: 12),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
