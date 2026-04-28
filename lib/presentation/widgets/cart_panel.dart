import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../domain/entities/product.dart';
import '../../domain/entities/invoice.dart';
import '../../domain/entities/invoice_item.dart';
import '../providers/cart_provider.dart';
import '../providers/invoice_provider.dart';
import '../providers/currency_provider.dart';
import '../providers/exchange_rate_provider.dart';
import '../providers/settings_provider.dart';
import 'client_card.dart';
import '../../core/theme.dart';

class CartPanel extends StatelessWidget {
  const CartPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
            child: Column(
              children: [
                const ClientCard(),
                const SizedBox(height: 12),
                Consumer<CartProvider>(
                  builder: (context, cart, _) {
                    final colorScheme = Theme.of(context).colorScheme;
                    return Card(
                      elevation: 4,
                      color: colorScheme.primary,
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Column(
                              children: [
                                Text(
                                  'TOTAL FACTURA',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: colorScheme.onPrimary.withValues(
                                      alpha: 0.7,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Bs ${cart.totalBs.toStringAsFixed(2)}',
                                  style: TextStyle(
                                    fontSize: 32,
                                    fontWeight: FontWeight.bold,
                                    color: colorScheme.onPrimary,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Builder(
              builder: (context) {
                final colorScheme = Theme.of(context).colorScheme;
                return Row(
                  children: [
                    const Text(
                      'Detalle de Venta',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    ElevatedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.person_add, size: 18),
                      label: const Text('Cliente'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: colorScheme.secondary,
                        foregroundColor: colorScheme.onSecondary,
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          const Expanded(child: CartItemsList()),
          const CartActions(),
        ],
      ),
    );
  }
}

class CartItemsList extends StatelessWidget {
  const CartItemsList({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Consumer<CartProvider>(
      builder: (context, cart, _) {
        if (cart.items.isEmpty) {
          return const Center(
            child: Text(
              'Carrito vacío\nAñada productos',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
          );
        }

        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 12),
          width: double.infinity,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(8),
          ),
          child: DataTable(
            columnSpacing: 12,
            columns: const [
              DataColumn(
                label: Text(
                  'Código',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                ),
              ),
              DataColumn(
                label: Text(
                  'Producto',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                ),
              ),
              DataColumn(
                label: Text(
                  'Cant.',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                ),
              ),
              DataColumn(
                label: Text(
                  'Total',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                ),
              ),
              DataColumn(label: Text('')),
            ],
            rows: List.generate(cart.items.length, (index) {
              final item = cart.items[index];
              final esPeso = item.unit == SaleUnit.kilogramo;
              return DataRow(
                cells: [
                  DataCell(
                    Text(item.code, style: const TextStyle(fontSize: 11)),
                  ),
                  DataCell(
                    Text(
                      item.name,
                      style: const TextStyle(fontSize: 11),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  DataCell(
                    Text(
                      esPeso
                          ? item.cantidad.toStringAsFixed(3)
                          : item.cantidad.toStringAsFixed(0),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: esPeso ? colorScheme.tertiary : null,
                      ),
                    ),
                  ),
                  DataCell(
                    Text(
                      'Bs ${item.total.toStringAsFixed(0)}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 11,
                      ),
                    ),
                  ),
                  DataCell(
                    IconButton(
                      icon: Icon(
                        Icons.delete,
                        size: 18,
                        color: colorScheme.error,
                      ),
                      onPressed: () => cart.removeItem(index),
                    ),
                  ),
                ],
              );
            }),
          ),
        );
      },
    );
  }
}

class CartActions extends StatelessWidget {
  const CartActions({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Expanded(
            child: _ActionButton(
              icon: Icons.close,
              label: 'CANCELAR',
              onPressed: () => context.read<CartProvider>().clear(),
              isPrimary: false,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            flex: 2,
            child: _ActionButton(
              icon: Icons.check_circle_outline,
              label: 'COBRAR',
              onPressed: () => _showPaymentDialog(context),
              isPrimary: true,
            ),
          ),
        ],
      ),
    );
  }

  void _showPaymentDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const _PaymentDialog(),
    );
  }
}

class _PaymentDialog extends StatefulWidget {
  const _PaymentDialog();

  @override
  State<_PaymentDialog> createState() => __PaymentDialogState();
}

class __PaymentDialogState extends State<_PaymentDialog> {
  String _metodoPago = 'efectivo';

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Completar Venta'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('Seleccione método de pago:'),
          const SizedBox(height: 16),
          ...PaymentMethod.values.map((m) => RadioListTile<String>(
            title: Text(m.label),
            value: m.value,
            groupValue: _metodoPago,
            onChanged: (v) => setState(() => _metodoPago = v!),
          )),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: () => _completeSale(context),
          child: const Text('Completar'),
        ),
      ],
    );
  }

  Future<void> _completeSale(BuildContext context) async {
    final cart = context.read<CartProvider>();
    if (cart.items.isEmpty) {
      Navigator.pop(context);
      return;
    }

    final invoiceProvider = context.read<InvoiceProvider>();
    final currencyProvider = context.read<CurrencyProvider>();
    final settings = context.read<SettingsProvider>();

    final baseCurrency = currencyProvider.baseCurrency;
    if (baseCurrency == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Debe configurar una moneda base')),
        );
      }
      return;
    }

    await settings.loadSettings();

    final taxRate = settings.taxRate;
    final subtotal = cart.totalBs;
    final tax = subtotal * taxRate / 100;
    final total = subtotal + tax;

    final rates = context.read<ExchangeRateProvider>().exchangeRates;
    final snapshot = <String, double>{};
    
    if (settings.additionalCurrency1Id != null) {
      final rate = rates.where((r) => 
        r.fromId == baseCurrency.id && r.toId == settings.additionalCurrency1Id
      ).firstOrNull;
      if (rate != null) {
        snapshot['currency_${settings.additionalCurrency1Id}'] = total * rate.value;
      }
    }
    
    if (settings.additionalCurrency2Id != null) {
      final rate = rates.where((r) => 
        r.fromId == baseCurrency.id && r.toId == settings.additionalCurrency2Id
      ).firstOrNull;
      if (rate != null) {
        snapshot['currency_${settings.additionalCurrency2Id}'] = total * rate.value;
      }
    }

    final invoice = Invoice(
      numero: await invoiceProvider.getNextNumero(),
      fecha: DateTime.now(),
      clienteId: cart.clienteId,
      subtotal: subtotal,
      tax: tax,
      discount: 0,
      total: total,
      baseCurrencyId: baseCurrency.id!,
      metodoPago: _metodoPago,
      status: 'pagada',
      totalSnapshot: snapshot.isNotEmpty ? snapshot : null,
    );

    final items = cart.items.map((item) => InvoiceItem(
      invoiceId: 0,
      productoId: item.productId,
      cantidad: item.cantidad,
      precioUnitario: item.precio,
      discount: item.discount,
      subtotal: item.total,
    )).toList();

    await invoiceProvider.create(invoice, items);
    cart.clear();

    if (mounted) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Factura #${invoice.numero} creada')),
      );
    }
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onPressed;
  final bool isPrimary;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onPressed,
    required this.isPrimary,
  });

  @override
  Widget build(BuildContext context) {
    if (isPrimary) {
      return Container(
        decoration: BoxDecoration(
          gradient: AppTheme.primaryButtonGradient,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onPressed,
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(icon, size: 20, color: Colors.white),
                  const SizedBox(width: 8),
                  Text(
                    label,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 20, color: Colors.grey.shade600),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
