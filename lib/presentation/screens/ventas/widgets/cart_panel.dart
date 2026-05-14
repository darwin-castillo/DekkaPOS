import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../domain/entities/client.dart';
import '../../../../domain/entities/product.dart';
import '../../../providers/cart_provider.dart';
import '../../../providers/client_provider.dart';
import '../../../providers/currency_provider.dart';
import '../../../providers/exchange_rate_provider.dart';
import '../../../providers/settings_provider.dart';
import '../../../widgets/common_pill.dart';
import 'payment_dialog.dart';

class CartPanel extends StatefulWidget {
  const CartPanel();

  @override
  State<CartPanel> createState() => _CartPanelState();
}

class _CartPanelState extends State<CartPanel> {
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
          _TableHeader(),

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
                        ? clientProvider.clients
                              .where((c) => c.id == clienteId)
                              .firstOrNull!
                        : null;
                    return InkWell(
                      onTap: () =>
                          _showClientSelector(context, clientProvider.clients),
                      child: Row(
                        children: [
                          Icon(
                            Icons.person,
                            color: colorScheme.onPrimaryContainer,
                          ),
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
                                      color: colorScheme.onPrimaryContainer
                                          .withValues(alpha: 0.7),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          Icon(
                            Icons.edit,
                            color: colorScheme.onPrimaryContainer,
                          ),
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
            const Text(
              'Seleccionar Cliente',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            ListTile(
              leading: const Icon(Icons.person_off),
              title: const Text('Sin cliente'),
              onTap: () {
                context.read<CartProvider>().setClienteId(null);
                Navigator.pop(ctx);
              },
            ),
            ...clients.map(
              (c) => ListTile(
                leading: const Icon(Icons.person),
                title: Text(c.nombre),
                subtitle: Text(c.telefono),
                onTap: () {
                  context.read<CartProvider>().setClienteId(c.id!);
                  Navigator.pop(ctx);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildItemsList() {
    return Consumer4<
      CartProvider,
      CurrencyProvider,
      ExchangeRateProvider,
      SettingsProvider
    >(
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
            ? currencyProvider.currencies
                  .where((c) => c.id == settings.additionalCurrency1Id)
                  .firstOrNull
            : null;
        final additional2 = settings.additionalCurrency2Id != null
            ? currencyProvider.currencies
                  .where((c) => c.id == settings.additionalCurrency2Id)
                  .firstOrNull
            : null;

        double? getConvertedPrice(double price, int toCurrencyId) {
          if (baseCurrency == null) return null;
          final rate = rates
              .where(
                (r) => r.fromId == baseCurrency.id && r.toId == toCurrencyId,
              )
              .firstOrNull;
          return rate != null ? price * rate.value : null;
        }

        return ListView.builder(
          itemCount: cart.items.length,
          itemBuilder: (context, index) {
            final item = cart.items[index];
            final isKg = item.unit == SaleUnit.kilogramo;
            final total1 = additional1 != null
                ? getConvertedPrice(item.total, additional1.id!)
                : null;
            final total2 = additional2 != null
                ? getConvertedPrice(item.total, additional2.id!)
                : null;

            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
              ),
              child: Row(
                children: [
                  Expanded(
                    flex: 12,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          item.code,
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Container(
                      child: TextPill(text: isKg ? ' kilogramo' : ' unidad'),
                    ),
                  ),
                  Expanded(
                    flex: 5,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '${baseCurrency?.symbol ?? 'Bs'} ${item.precio.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                        if (additional1 != null && additional1.id != 0)
                          Text(
                            '${additional1.symbol} ${getConvertedPrice(item.precio, additional1.id!)?.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontSize: 9,
                              color: Colors.grey,
                            ),
                          ),
                        if (additional2 != null && additional2.id != 0)
                          Text(
                            '${additional2.symbol} ${getConvertedPrice(item.precio, additional2.id!)?.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontSize: 9,
                              color: Colors.grey,
                            ),
                          ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 4,
                    child: Text(
                      item.cantidad.toStringAsFixed(isKg ? 3 : 0),
                      style: const TextStyle(fontSize: 11),
                      textAlign: TextAlign.right,
                    ),
                  ),
                  Expanded(
                    flex: 4,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '${baseCurrency?.symbol ?? 'Bs'} ${item.total.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                        if (total1 != null)
                          Text(
                            '${additional1!.symbol} ${total1.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontSize: 9,
                              color: Colors.grey,
                            ),
                          ),
                        if (total2 != null)
                          Text(
                            '${additional2!.symbol} ${total2.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontSize: 9,
                              color: Colors.grey,
                            ),
                          ),
                      ],
                    ),
                  ),

                  Expanded(
                    flex: 2,
                    child: IconButton(
                      icon: const Icon(
                        Icons.delete,
                        size: 18,
                        color: Colors.red,
                      ),
                      onPressed: () => cart.removeItem(index),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildTotals(BuildContext context) {
    return Consumer4<
      CartProvider,
      CurrencyProvider,
      ExchangeRateProvider,
      SettingsProvider
    >(
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
            ? currencyProvider.currencies
                  .where((c) => c.id == settings.additionalCurrency1Id)
                  .firstOrNull
            : null;
        final additional2 = settings.additionalCurrency2Id != null
            ? currencyProvider.currencies
                  .where((c) => c.id == settings.additionalCurrency2Id)
                  .firstOrNull
            : null;

        double? getConvertedPrice(double price, int toCurrencyId) {
          final rate = rates
              .where(
                (r) => r.fromId == baseCurrency.id && r.toId == toCurrencyId,
              )
              .firstOrNull;
          return rate != null ? price * rate.value : null;
        }

        final converted1 = additional1 != null
            ? getConvertedPrice(total, additional1.id!)
            : null;
        final converted2 = additional2 != null
            ? getConvertedPrice(total, additional2.id!)
            : null;

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
                _buildTotalRow(
                  'Total ${additional1!.code}',
                  converted1,
                  additional1.symbol,
                ),
              if (converted2 != null)
                _buildTotalRow(
                  'Total ${additional2!.code}',
                  converted2,
                  additional2.symbol,
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTotalRow(
    String label,
    double amount,
    String symbol, {
    bool isBold = false,
  }) {
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
    showDialog(context: context, builder: (ctx) => const PaymentDialog());
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
          _TH('Producto/Código', flex: 12, align: CrossAxisAlignment.start),

          _TH('Unidad', flex: 3, align: CrossAxisAlignment.center),
          _TH('P. Unit.', flex: 5, align: CrossAxisAlignment.end),
          _TH('Cantidad', flex: 4, align: CrossAxisAlignment.end),
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
