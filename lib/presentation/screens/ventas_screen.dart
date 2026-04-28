import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../domain/entities/product.dart';
import '../../domain/entities/client.dart';
import '../../domain/entities/invoice.dart';
import '../../domain/entities/invoice_item.dart';
import '../providers/product_provider.dart';
import '../providers/cart_provider.dart';
import '../providers/client_provider.dart';
import '../providers/currency_provider.dart';
import '../providers/exchange_rate_provider.dart';
import '../providers/settings_provider.dart';
import '../providers/invoice_provider.dart';
import 'package:dekkapos/presentation/widgets/dekka_app_bar.dart';

class VentasScreen extends StatelessWidget {
  const VentasScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const DekkaAppBar(
        title: 'Punto de Venta',
        userName: 'Administrador',
        userEmail: 'admin@dekkapos.com',
        userInitial: 'A',
      ),
      body: Row(
        children: [
          const Expanded(
            flex: 2,
            child: _ProductPanel(),
          ),
          Container(width: 1, color: Colors.grey.shade300),
          const Expanded(
            flex: 3,
            child: _CartPanel(),
          ),
        ],
      ),
    );
  }
}

class _ProductPanel extends StatelessWidget {
  const _ProductPanel();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      color: colorScheme.surfaceContainerHighest,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.inventory_2, color: colorScheme.primary),
              const SizedBox(width: 8),
              const Text(
                'Productos',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Consumer<ProductProvider>(
            builder: (context, provider, _) => TextField(
              decoration: const InputDecoration(
                hintText: 'Buscar producto...',
                prefixIcon: Icon(Icons.search),
                isDense: true,
              ),
              onChanged: provider.search,
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: Consumer<ProductProvider>(
              builder: (context, provider, _) {
                final products = provider.filteredProducts.isEmpty 
                    ? provider.products 
                    : provider.filteredProducts;
                if (products.isEmpty) {
                  return const Center(child: Text('No hay productos'));
                }
                return GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    childAspectRatio: 1.2,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                  ),
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    final p = products[index];
                    final isKg = p.unit == SaleUnit.kilogramo;
                    return _ProductCard(product: p, isKg: isKg);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _ProductCard extends StatelessWidget {
  final Product product;
  final bool isKg;

  const _ProductCard({required this.product, required this.isKg});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Card(
      child: InkWell(
        onTap: () => context.read<CartProvider>().addProduct(product),
        onLongPress: isKg ? () => _showWeightDialog(context, product) : null,
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                isKg ? Icons.scale : Icons.shopping_bag,
                size: 32,
                color: colorScheme.primary,
              ),
              const SizedBox(height: 4),
              Text(
                product.name,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text(
                'Bs ${product.price.toStringAsFixed(2)}',
                style: TextStyle(color: colorScheme.primary, fontWeight: FontWeight.bold),
              ),
              if (isKg) Text(
                'kg',
                style: TextStyle(fontSize: 10, color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showWeightDialog(BuildContext context, Product product) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(product.name),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: 'Peso (kg)',
            hintText: '0.500',
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              final peso = double.tryParse(controller.text);
              if (peso != null && peso > 0) {
                context.read<CartProvider>().addProductByWeight(product, peso);
              }
              Navigator.pop(ctx);
            },
            child: const Text('Agregar'),
          ),
        ],
      ),
    );
  }
}

class _CartPanel extends StatefulWidget {
  const _CartPanel();

  @override
  State<_CartPanel> createState() => _CartPanelState();
}

class _CartPanelState extends State<_CartPanel> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CurrencyProvider>().loadCurrencies();
      context.read<ExchangeRateProvider>().loadExchangeRates();
      context.read<SettingsProvider>().loadSettings();
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          _buildHeader(context, colorScheme),
          Expanded(child: _buildItemsList()),
          _buildTotals(context),
          _buildActions(context, colorScheme),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, ColorScheme colorScheme) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.primaryContainer,
        border: Border(bottom: BorderSide(color: Colors.grey.shade300)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Consumer<CartProvider>(
              builder: (context, cart, _) {
                final clienteId = cart.clienteId;
                return Consumer<ClientProvider>(
                  builder: (context, clientProvider, _) {
                    final cliente = clienteId != null
                        ? clientProvider.clients.where((c) => c.id == clienteId).firstOrNull
                        : null;
                    return InkWell(
                      onTap: () => _showClientSelector(context, clientProvider.clients),
                      child: Row(
                        children: [
                          Icon(Icons.person, color: colorScheme.onPrimaryContainer),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  cliente?.nombre ?? 'Sin cliente',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: colorScheme.onPrimaryContainer,
                                  ),
                                ),
                                if (cliente != null)
                                  Text(
                                    cliente.telefono,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: colorScheme.onPrimaryContainer.withValues(alpha: 0.7),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          Icon(Icons.edit, color: colorScheme.onPrimaryContainer),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showClientSelector(BuildContext context, List<Client> clients) {
    showModalBottomSheet(
      context: context,
      builder: (ctx) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Seleccionar Cliente', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            ListTile(
              leading: const Icon(Icons.person_off),
              title: const Text('Sin cliente'),
              onTap: () {
                context.read<CartProvider>().setClienteId(null);
                Navigator.pop(ctx);
              },
            ),
            ...clients.map((c) => ListTile(
              leading: const Icon(Icons.person),
              title: Text(c.nombre),
              subtitle: Text(c.telefono),
              onTap: () {
                context.read<CartProvider>().setClienteId(c.id);
                Navigator.pop(ctx);
              },
            )),
          ],
        ),
      ),
    );
  }

  Widget _buildItemsList() {
    return Consumer4<CartProvider, CurrencyProvider, ExchangeRateProvider, SettingsProvider>(
      builder: (context, cart, currencyProvider, rateProvider, settings, _) {
        if (cart.items.isEmpty) {
          return const Center(
            child: Text(
              'Carrito vacío\nSeleccione productos',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
          );
        }

        final baseCurrency = currencyProvider.baseCurrency;
        final rates = rateProvider.exchangeRates;
        final additional1 = settings.additionalCurrency1Id != null
            ? currencyProvider.currencies.where((c) => c.id == settings.additionalCurrency1Id).firstOrNull
            : null;
        final additional2 = settings.additionalCurrency2Id != null
            ? currencyProvider.currencies.where((c) => c.id == settings.additionalCurrency2Id).firstOrNull
            : null;

        double? getConvertedPrice(double price, int toCurrencyId) {
          if (baseCurrency == null) return null;
          final rate = rates.where((r) => r.fromId == baseCurrency.id && r.toId == toCurrencyId).firstOrNull;
          return rate != null ? price * rate.value : null;
        }

        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            columnSpacing: 12,
            headingRowColor: WidgetStateProperty.all(Colors.grey.shade200),
            columns: [
              const DataColumn(label: Text('Código', style: TextStyle(fontWeight: FontWeight.bold))),
              const DataColumn(label: Text('Producto', style: TextStyle(fontWeight: FontWeight.bold))),
              const DataColumn(label: Text('Cant.', style: TextStyle(fontWeight: FontWeight.bold)), numeric: true),
              DataColumn(label: Text('P.Unit.', style: TextStyle(fontWeight: FontWeight.bold)), numeric: true),
              if (additional1 != null) DataColumn(label: Text('Total ${additional1.code}', style: const TextStyle(fontWeight: FontWeight.bold)), numeric: true),
              if (additional2 != null) DataColumn(label: Text('Total ${additional2.code}', style: const TextStyle(fontWeight: FontWeight.bold)), numeric: true),
              DataColumn(label: Text('Total', style: TextStyle(fontWeight: FontWeight.bold)), numeric: true),
              const DataColumn(label: Text('')),
            ],
            rows: List.generate(cart.items.length, (index) {
              final item = cart.items[index];
              final isKg = item.unit == SaleUnit.kilogramo;

              final total1 = additional1 != null ? getConvertedPrice(item.total, additional1.id!) : null;
              final total2 = additional2 != null ? getConvertedPrice(item.total, additional2.id!) : null;

              return DataRow(
                cells: [
                  DataCell(Text(item.code, style: const TextStyle(fontSize: 11))),
                  DataCell(Text(item.name, style: const TextStyle(fontSize: 11), overflow: TextOverflow.ellipsis, maxLines: 1)),
                  DataCell(Text(isKg ? item.cantidad.toStringAsFixed(3) : item.cantidad.toStringAsFixed(0))),
                  DataCell(Text('${baseCurrency?.symbol ?? 'Bs'} ${item.precio.toStringAsFixed(2)}')),
                  if (additional1 != null) DataCell(Text(total1 != null ? '${additional1.symbol} ${total1.toStringAsFixed(2)}' : '-')),
                  if (additional2 != null) DataCell(Text(total2 != null ? '${additional2.symbol} ${total2.toStringAsFixed(2)}' : '-')),
                  DataCell(Text('${baseCurrency?.symbol ?? 'Bs'} ${item.total.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.bold))),
                  DataCell(IconButton(
                    icon: const Icon(Icons.delete, size: 18, color: Colors.red),
                    onPressed: () => cart.removeItem(index),
                  )),
                ],
              );
            }),
          ),
        );
      },
    );
  }

  Widget _buildTotals(BuildContext context) {
    return Consumer4<CartProvider, CurrencyProvider, ExchangeRateProvider, SettingsProvider>(
      builder: (context, cart, currencyProvider, rateProvider, settings, _) {
        final baseCurrency = currencyProvider.baseCurrency;
        if (baseCurrency == null) {
          return const SizedBox.shrink();
        }

        final subtotal = cart.totalBs;
        final taxRate = settings.taxRate;
        final tax = subtotal * taxRate / 100;
        final total = subtotal + tax;

        final rates = rateProvider.exchangeRates;
        final additional1 = settings.additionalCurrency1Id != null
            ? currencyProvider.currencies.where((c) => c.id == settings.additionalCurrency1Id).firstOrNull
            : null;
        final additional2 = settings.additionalCurrency2Id != null
            ? currencyProvider.currencies.where((c) => c.id == settings.additionalCurrency2Id).firstOrNull
            : null;

        double? getConvertedPrice(double price, int toCurrencyId) {
          final rate = rates.where((r) => r.fromId == baseCurrency.id && r.toId == toCurrencyId).firstOrNull;
          return rate != null ? price * rate.value : null;
        }

        final converted1 = additional1 != null ? getConvertedPrice(total, additional1.id!) : null;
        final converted2 = additional2 != null ? getConvertedPrice(total, additional2.id!) : null;

        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            border: Border(top: BorderSide(color: Colors.grey.shade300)),
          ),
          child: Column(
            children: [
              _buildTotalRow('Subtotal', subtotal, baseCurrency.symbol),
              _buildTotalRow('Impuesto ($taxRate%)', tax, baseCurrency.symbol),
              const Divider(),
              _buildTotalRow('TOTAL', total, baseCurrency.symbol, isBold: true),
              if (converted1 != null)
                _buildTotalRow('Total ${additional1!.code}', converted1, additional1.symbol),
              if (converted2 != null)
                _buildTotalRow('Total ${additional2!.code}', converted2, additional2.symbol),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTotalRow(String label, double amount, String symbol, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              fontSize: isBold ? 16 : 14,
            ),
          ),
          Text(
            '$symbol ${amount.toStringAsFixed(2)}',
            style: TextStyle(
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              fontSize: isBold ? 18 : 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActions(BuildContext context, ColorScheme colorScheme) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton.icon(
              onPressed: () => context.read<CartProvider>().clear(),
              icon: const Icon(Icons.close),
              label: const Text('CANCELAR'),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            flex: 2,
            child: ElevatedButton.icon(
              onPressed: () => _showPaymentDialog(context),
              icon: const Icon(Icons.check_circle),
              label: const Text('COBRAR'),
              style: ElevatedButton.styleFrom(
                backgroundColor: colorScheme.primary,
                foregroundColor: colorScheme.onPrimary,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showPaymentDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => const _PaymentDialog(),
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
          const Text('Método de pago:'),
          const SizedBox(height: 8),
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
      final rate = rates.where((r) =>
          r.fromId == baseCurrency.id && r.toId == settings.additionalCurrency1Id).firstOrNull;
      if (rate != null) {
        snapshot['currency_${settings.additionalCurrency1Id}'] = total * rate.value;
      }
    }

    if (settings.additionalCurrency2Id != null) {
      final rate = rates.where((r) =>
          r.fromId == baseCurrency.id && r.toId == settings.additionalCurrency2Id).firstOrNull;
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