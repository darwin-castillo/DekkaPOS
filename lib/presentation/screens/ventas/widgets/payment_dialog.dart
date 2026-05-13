import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../domain/entities/invoice.dart' show Invoice;
import '../../../../domain/entities/invoice_item.dart';
import '../../../providers/cart_provider.dart';
import '../../../providers/currency_provider.dart';
import '../../../providers/exchange_rate_provider.dart';
import '../../../providers/invoice_provider.dart';
import '../../../providers/settings_provider.dart';

class PaymentDialog extends StatefulWidget {
  const PaymentDialog();

  @override
  State<PaymentDialog> createState() => _PaymentDialogState();
}

class _PaymentDialogState extends State<PaymentDialog> {
  String _metodoPago = 'efectivo';

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Completar Venta'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('Método de pago:'),
          const SizedBox(height: 8),
          ...PaymentMethod.values.map(
            (m) => RadioListTile<String>(
              title: Text(m.label),
              value: m.value,
              groupValue: _metodoPago,
              onChanged: (v) => setState(() => _metodoPago = v!),
            ),
          ),
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
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Debe configurar una moneda base')),
      );
      return;
    }

    final taxRate = settings.taxRate;
    final subtotal = cart.totalBs;
    final tax = subtotal * taxRate / 100;
    final total = subtotal + tax;

    final rates = context.read<ExchangeRateProvider>().exchangeRates;
    final snapshot = <String, double>{};

    if (settings.additionalCurrency1Id != null) {
      final rate = rates
          .where(
            (r) =>
                r.fromId == baseCurrency.id &&
                r.toId == settings.additionalCurrency1Id,
          )
          .firstOrNull;
      if (rate != null) {
        snapshot['currency_${settings.additionalCurrency1Id}'] =
            total * rate.value;
      }
    }

    if (settings.additionalCurrency2Id != null) {
      final rate = rates
          .where(
            (r) =>
                r.fromId == baseCurrency.id &&
                r.toId == settings.additionalCurrency2Id,
          )
          .firstOrNull;
      if (rate != null) {
        snapshot['currency_${settings.additionalCurrency2Id}'] =
            total * rate.value;
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

    final items = cart.items
        .map(
          (item) => InvoiceItem(
            invoiceId: 0,
            productoId: item.productId,
            cantidad: item.cantidad,
            precioUnitario: item.precio,
            discount: item.discount,
            subtotal: item.total,
          ),
        )
        .toList();

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
