import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../domain/entities/invoice.dart';
import '../../domain/entities/invoice_item.dart';
import '../../domain/entities/product.dart';
import '../providers/invoice_provider.dart';
import '../providers/currency_provider.dart';
import '../providers/exchange_rate_provider.dart';
import '../providers/settings_provider.dart';
import '../providers/product_provider.dart';
import '../widgets/dekka_app_bar.dart';

class FacturasScreen extends StatefulWidget {
  const FacturasScreen({super.key});

  @override
  State<FacturasScreen> createState() => _FacturasScreenState();
}

class _FacturasScreenState extends State<FacturasScreen> {
  String _filterStatus = 'todos';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<InvoiceProvider>().loadInvoices();
      context.read<CurrencyProvider>().loadCurrencies();
      context.read<SettingsProvider>().loadSettings();
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: const DekkaAppBar(
        title: 'Facturas',
        userName: 'Administrador',
        userEmail: 'admin@dekkapos.com',
        userInitial: 'A',
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            color: colorScheme.surfaceContainerHighest,
            child: Row(
              children: [
                const Text('Filtrar: ', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(width: 8),
                ChoiceChip(
                  label: const Text('Todas'),
                  selected: _filterStatus == 'todos',
                  onSelected: (selected) {
                    setState(() => _filterStatus = 'todos');
                    context.read<InvoiceProvider>().loadInvoices();
                  },
                ),
                const SizedBox(width: 8),
                ChoiceChip(
                  label: const Text('Pagadas'),
                  selected: _filterStatus == 'pagada',
                  onSelected: (selected) {
                    setState(() => _filterStatus = 'pagada');
                    context.read<InvoiceProvider>().loadInvoicesByStatus('pagada');
                  },
                ),
                const SizedBox(width: 8),
                ChoiceChip(
                  label: const Text('Pendientes'),
                  selected: _filterStatus == 'pendiente',
                  onSelected: (selected) {
                    setState(() => _filterStatus = 'pendiente');
                    context.read<InvoiceProvider>().loadInvoicesByStatus('pendiente');
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: Consumer2<InvoiceProvider, CurrencyProvider>(
              builder: (context, invoiceProvider, currencyProvider, _) {
                if (invoiceProvider.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                final invoices = invoiceProvider.invoices;

                if (invoices.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.receipt_long, size: 64, color: Colors.grey.shade400),
                        const SizedBox(height: 16),
                        Text('No hay facturas', style: TextStyle(fontSize: 18, color: Colors.grey.shade600)),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: invoices.length,
                  itemBuilder: (context, index) {
                    final invoice = invoices[index];
                    final baseCurrency = currencyProvider.currencies.where((c) => c.id == invoice.baseCurrencyId).firstOrNull;
                    
                    return Card(
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: invoice.status == 'pagada' 
                              ? Colors.green.shade100 
                              : Colors.orange.shade100,
                          child: Icon(
                            invoice.status == 'pagada' ? Icons.check_circle : Icons.pending,
                            color: invoice.status == 'pagada' ? Colors.green : Colors.orange,
                          ),
                        ),
                        title: Text('Factura #${invoice.numero}'),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(_formatDate(invoice.fecha)),
                            Text(
                              invoice.status == 'pagada' ? 'Pagada' : 'Pendiente',
                              style: TextStyle(
                                color: invoice.status == 'pagada' ? Colors.green : Colors.orange,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        trailing: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              '${baseCurrency?.symbol ?? ''} ${invoice.total.toStringAsFixed(2)}',
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            Text(invoice.metodoPago, style: const TextStyle(fontSize: 12)),
                          ],
                        ),
                        onTap: () => _showInvoiceDetail(context, invoice),
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

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }

  void _showInvoiceDetail(BuildContext context, Invoice invoice) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.9,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        expand: false,
        builder: (context, scrollController) => _InvoiceDetailSheet(
          invoice: invoice,
          scrollController: scrollController,
        ),
      ),
    );
  }
}

class _InvoiceDetailSheet extends StatefulWidget {
  final Invoice invoice;
  final ScrollController scrollController;

  const _InvoiceDetailSheet({
    required this.invoice,
    required this.scrollController,
  });

  @override
  State<_InvoiceDetailSheet> createState() => _InvoiceDetailSheetState();
}

class _InvoiceDetailSheetState extends State<_InvoiceDetailSheet> {
  List<InvoiceItem> _items = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadItems();
  }

  Future<void> _loadItems() async {
    final items = await context.read<InvoiceProvider>().getItemsByInvoiceId(widget.invoice.id!);
    setState(() {
      _items = items;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: colorScheme.primaryContainer,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Factura #${widget.invoice.numero}',
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      Text(_formatDate(widget.invoice.fecha)),
                    ],
                  ),
                ),
                Chip(
                  label: Text(widget.invoice.status == 'pagada' ? 'Pagada' : 'Pendiente'),
                  backgroundColor: widget.invoice.status == 'pagada' 
                      ? Colors.green.shade100 
                      : Colors.orange.shade100,
                ),
              ],
            ),
          ),
          Expanded(
            child: _loading
                ? const Center(child: CircularProgressIndicator())
                : ListView(
                    controller: widget.scrollController,
                    padding: const EdgeInsets.all(16),
                    children: [
                      _buildTotalsSection(),
                      const SizedBox(height: 16),
                      _buildItemsSection(),
                      const SizedBox(height: 16),
                      _buildActionsSection(),
                    ],
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildTotalsSection() {
    final currencyProvider = context.read<CurrencyProvider>();
    final settings = context.read<SettingsProvider>();
    
    final baseCurrency = currencyProvider.currencies.where((c) => c.id == widget.invoice.baseCurrencyId).firstOrNull;
    final additionalCurrency1 = settings.additionalCurrency1Id != null 
        ? currencyProvider.currencies.where((c) => c.id == settings.additionalCurrency1Id).firstOrNull 
        : null;
    final additionalCurrency2 = settings.additionalCurrency2Id != null 
        ? currencyProvider.currencies.where((c) => c.id == settings.additionalCurrency2Id).firstOrNull 
        : null;

    final snapshot = widget.invoice.totalSnapshot;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Totales', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const Divider(),
            _buildTotalRow('Subtotal', widget.invoice.subtotal, baseCurrency?.symbol, baseCurrency?.code),
            _buildTotalRow('Impuesto (${settings.taxRate}%)', widget.invoice.tax, baseCurrency?.symbol, baseCurrency?.code),
            _buildTotalRow('Descuento', -widget.invoice.discount, baseCurrency?.symbol, baseCurrency?.code),
            const Divider(),
            _buildTotalRow('TOTAL', widget.invoice.total, baseCurrency?.symbol, baseCurrency?.code, isBold: true),
            if (snapshot != null) ...[
              const SizedBox(height: 8),
              if (additionalCurrency1 != null && snapshot.containsKey('currency_${additionalCurrency1.id}'))
                _buildTotalRow(
                  'Total ${additionalCurrency1.code}', 
                  snapshot['currency_${additionalCurrency1.id}']!, 
                  additionalCurrency1.symbol, 
                  additionalCurrency1.code,
                ),
              if (additionalCurrency2 != null && snapshot.containsKey('currency_${additionalCurrency2.id}'))
                _buildTotalRow(
                  'Total ${additionalCurrency2.code}', 
                  snapshot['currency_${additionalCurrency2.id}']!, 
                  additionalCurrency2.symbol, 
                  additionalCurrency2.code,
                ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildTotalRow(String label, double amount, String? symbol, String? code, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
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
            '${symbol ?? ''} ${amount.toStringAsFixed(2)}',
            style: TextStyle(
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              fontSize: isBold ? 18 : 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItemsSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Items', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const Divider(),
            if (_items.isEmpty)
              const Text('No hay items')
            else
              ..._items.map((item) => _buildItemRow(item)),
          ],
        ),
      ),
    );
  }

  Widget _buildItemRow(InvoiceItem item) {
    final productProvider = context.read<ProductProvider>();
    final product = productProvider.products.where((p) => p.id == item.productoId).firstOrNull;
    
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(product?.name ?? 'Producto #${item.productoId}'),
          ),
          Expanded(
            child: Text('x${item.cantidad.toStringAsFixed(0)}', textAlign: TextAlign.center),
          ),
          Expanded(
            child: Text(item.subtotal.toStringAsFixed(2), textAlign: TextAlign.right),
          ),
        ],
      ),
    );
  }

  Widget _buildActionsSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Acciones', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            if (widget.invoice.status == 'pendiente')
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () async {
                    await context.read<InvoiceProvider>().updateStatus(widget.invoice.id!, 'pagada');
                    if (mounted) {
                      Navigator.pop(context);
                      context.read<InvoiceProvider>().loadInvoices();
                    }
                  },
                  icon: const Icon(Icons.check),
                  label: const Text('Marcar como Pagada'),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white),
                ),
              ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () async {
                  await context.read<InvoiceProvider>().delete(widget.invoice.id!);
                  if (mounted) {
                    Navigator.pop(context);
                  }
                },
                icon: const Icon(Icons.delete),
                label: const Text('Eliminar Factura'),
                style: OutlinedButton.styleFrom(foregroundColor: Colors.red),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }
}