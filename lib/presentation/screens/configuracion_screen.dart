import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../domain/entities/currency.dart';
import '../../domain/entities/exchange_rate.dart';
import '../providers/currency_provider.dart';
import '../providers/exchange_rate_provider.dart';
import '../providers/settings_provider.dart';
import '../widgets/dekka_app_bar.dart';

class ConfiguracionScreen extends StatefulWidget {
  const ConfiguracionScreen({super.key});

  @override
  State<ConfiguracionScreen> createState() => _ConfiguracionScreenState();
}

class _ConfiguracionScreenState extends State<ConfiguracionScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CurrencyProvider>().loadCurrencies();
      context.read<ExchangeRateProvider>().loadExchangeRates();
      context.read<SettingsProvider>().loadSettings();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: const DekkaAppBar(
        title: 'Configuración',
        userName: 'Administrador',
        userEmail: 'admin@dekkapos.com',
        userInitial: 'A',
      ),
      body: Column(
        children: [
          Container(
            color: colorScheme.surfaceContainerHighest,
            child: TabBar(
              controller: _tabController,
              tabs: const [
                Tab(icon: Icon(Icons.attach_money), text: 'Monedas'),
                Tab(icon: Icon(Icons.currency_exchange), text: 'Tasas'),
                Tab(icon: Icon(Icons.receipt_long), text: 'Facturas'),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: const [
                _MonedasTab(),
                _TasasTab(),
                _FacturasConfigTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MonedasTab extends StatelessWidget {
  const _MonedasTab();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showCurrencyDialog(context),
        icon: const Icon(Icons.add),
        label: const Text('Nueva'),
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
      ),
      body: Consumer<CurrencyProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          final currencies = provider.currencies;

          if (currencies.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.attach_money,
                    size: 64,
                    color: Colors.grey.shade400,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No hay monedas',
                    style: TextStyle(fontSize: 18, color: Colors.grey.shade600),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton.icon(
                    onPressed: () => _showCurrencyDialog(context),
                    icon: const Icon(Icons.add),
                    label: const Text('Agregar moneda'),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: currencies.length,
            itemBuilder: (context, index) {
              final c = currencies[index];
              return Card(
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: colorScheme.primaryContainer,
                    child: Text(
                      c.symbol,
                      style: TextStyle(
                        color: colorScheme.onPrimaryContainer,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  title: Row(
                    children: [
                      Text(c.name),
                      if (c.isBase) ...[
                        const SizedBox(width: 8),
                        Chip(
                          label: const Text(
                            'BASE',
                            style: TextStyle(fontSize: 10),
                          ),
                          backgroundColor: colorScheme.primaryContainer,
                          labelStyle: TextStyle(
                            color: colorScheme.onPrimaryContainer,
                            fontSize: 10,
                          ),
                          padding: EdgeInsets.zero,
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                        ),
                      ],
                    ],
                  ),
                  subtitle: Text('Código: ${c.code}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        c.symbol,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.edit, color: colorScheme.primary),
                        onPressed: () =>
                            _showCurrencyDialog(context, currency: c),
                      ),
                      IconButton(
                        icon: Icon(Icons.delete, color: colorScheme.error),
                        onPressed: () => _confirmDelete(context, c.id!, c.name),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _showCurrencyDialog(BuildContext context, {Currency? currency}) {
    showDialog(
      context: context,
      builder: (context) => _CurrencyFormDialog(currency: currency),
    );
  }

  void _confirmDelete(BuildContext context, int id, String name) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar moneda'),
        content: Text('¿Eliminar "$name"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              context.read<CurrencyProvider>().delete(id);
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
  }
}

class _CurrencyFormDialog extends StatefulWidget {
  final Currency? currency;
  const _CurrencyFormDialog({super.key, this.currency});

  @override
  State<_CurrencyFormDialog> createState() => __CurrencyFormDialogState();
}

class __CurrencyFormDialogState extends State<_CurrencyFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _codeController;
  late final TextEditingController _symbolController;
  late final TextEditingController _nameController;
  late bool _isBase;

  bool get isEditing => widget.currency != null;

  @override
  void initState() {
    super.initState();
    _codeController = TextEditingController(text: widget.currency?.code ?? '');
    _symbolController = TextEditingController(
      text: widget.currency?.symbol ?? '',
    );
    _nameController = TextEditingController(text: widget.currency?.name ?? '');
    _isBase = widget.currency?.isBase ?? false;
  }

  @override
  void dispose() {
    _codeController.dispose();
    _symbolController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(isEditing ? 'Editar moneda' : 'Nueva moneda'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _codeController,
              decoration: const InputDecoration(
                labelText: 'Código * (ej: USD)',
              ),
              validator: (v) => v?.isEmpty == true ? 'Requerido' : null,
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _symbolController,
              decoration: const InputDecoration(
                labelText: 'Símbolo * (ej: \$)',
              ),
              validator: (v) => v?.isEmpty == true ? 'Requerido' : null,
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Nombre * (ej: Dólar)',
              ),
              validator: (v) => v?.isEmpty == true ? 'Requerido' : null,
            ),
            const SizedBox(height: 12),
            SwitchListTile(
              title: const Text('Moneda base'),
              subtitle: const Text('Usar como moneda predeterminada'),
              value: _isBase,
              onChanged: (value) => setState(() => _isBase = value),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: _save,
          child: Text(isEditing ? 'Guardar' : 'Crear'),
        ),
      ],
    );
  }

  void _save() async {
    if (!_formKey.currentState!.validate()) return;
    final provider = context.read<CurrencyProvider>();
    final currency = Currency(
      id: widget.currency?.id,
      code: _codeController.text,
      symbol: _symbolController.text,
      name: _nameController.text,
      isBase: _isBase,
    );
    if (_isBase) {
      await provider.setBaseCurrency(currency.id ?? 0);
    }
    if (isEditing) {
      await provider.update(currency);
    } else {
      await provider.create(currency);
    }
    if (mounted) Navigator.pop(context);
  }
}

class _TasasTab extends StatelessWidget {
  const _TasasTab();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showExchangeRateDialog(context),
        icon: const Icon(Icons.add),
        label: const Text('Nueva'),
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
      ),
      body: Consumer2<ExchangeRateProvider, CurrencyProvider>(
        builder: (context, rateProvider, currencyProvider, _) {
          if (rateProvider.isLoading || currencyProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          final rates = rateProvider.exchangeRates;
          final currencies = currencyProvider.currencies;

          if (currencies.length < 2) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.currency_exchange,
                    size: 64,
                    color: Colors.grey.shade400,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Se necesitan al menos 2 monedas',
                    style: TextStyle(fontSize: 18, color: Colors.grey.shade600),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Agrega más monedas en la pestaña Monedas',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          if (rates.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.currency_exchange,
                    size: 64,
                    color: Colors.grey.shade400,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No hay tasas de cambio',
                    style: TextStyle(fontSize: 18, color: Colors.grey.shade600),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton.icon(
                    onPressed: () => _showExchangeRateDialog(context),
                    icon: const Icon(Icons.add),
                    label: const Text('Agregar tasa'),
                  ),
                ],
              ),
            );
          }

          String getCurrencyName(int id) {
            final c = currencies.where((x) => x.id == id).firstOrNull;
            return c != null ? '${c.code} (${c.symbol})' : 'Desconocida';
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: rates.length,
            itemBuilder: (context, index) {
              final r = rates[index];
              return Card(
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: colorScheme.secondaryContainer,
                    child: Icon(
                      Icons.swap_horiz,
                      color: colorScheme.onSecondaryContainer,
                    ),
                  ),
                  title: Text(
                    '${getCurrencyName(r.fromId)} → ${getCurrencyName(r.toId)}',
                  ),
                  subtitle: Text('Actualizado: ${_formatDate(r.updatedAt)}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        r.value.toStringAsFixed(4),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.edit, color: colorScheme.primary),
                        onPressed: () =>
                            _showExchangeRateDialog(context, exchangeRate: r),
                      ),
                      IconButton(
                        icon: Icon(Icons.delete, color: colorScheme.error),
                        onPressed: () => _confirmDelete(context, r.id!),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }

  void _showExchangeRateDialog(
    BuildContext context, {
    ExchangeRate? exchangeRate,
  }) {
    showDialog(
      context: context,
      builder: (context) => _ExchangeRateFormDialog(exchangeRate: exchangeRate),
    );
  }

  void _confirmDelete(BuildContext context, int id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar tasa'),
        content: const Text('¿Eliminar esta tasa de cambio?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              context.read<ExchangeRateProvider>().delete(id);
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
  }
}

class _ExchangeRateFormDialog extends StatefulWidget {
  final ExchangeRate? exchangeRate;
  const _ExchangeRateFormDialog({super.key, this.exchangeRate});

  @override
  State<_ExchangeRateFormDialog> createState() =>
      __ExchangeRateFormDialogState();
}

class __ExchangeRateFormDialogState extends State<_ExchangeRateFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _valueController;
  int? _fromCurrencyId;
  int? _toCurrencyId;

  bool get isEditing => widget.exchangeRate != null;

  @override
  void initState() {
    super.initState();
    _valueController = TextEditingController(
      text: widget.exchangeRate?.value.toString() ?? '1.0',
    );
    _fromCurrencyId = widget.exchangeRate?.fromId;
    _toCurrencyId = widget.exchangeRate?.toId;
  }

  @override
  void dispose() {
    _valueController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currencies = context.read<CurrencyProvider>().currencies;

    return AlertDialog(
      title: Text(isEditing ? 'Editar tasa' : 'Nueva tasa'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<int>(
              initialValue: _fromCurrencyId,
              decoration: const InputDecoration(labelText: 'De moneda'),
              items: currencies.map((c) {
                return DropdownMenuItem(
                  value: c.id,
                  child: Text('${c.code} - ${c.name}'),
                );
              }).toList(),
              onChanged: (value) => setState(() => _fromCurrencyId = value),
              validator: (v) => v == null ? 'Requerido' : null,
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<int>(
              initialValue: _toCurrencyId,
              decoration: const InputDecoration(labelText: 'A moneda'),
              items: currencies.map((c) {
                return DropdownMenuItem(
                  value: c.id,
                  child: Text('${c.code} - ${c.name}'),
                );
              }).toList(),
              onChanged: (value) => setState(() => _toCurrencyId = value),
              validator: (v) => v == null ? 'Requerido' : null,
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _valueController,
              decoration: const InputDecoration(labelText: 'Valor de cambio *'),
              keyboardType: TextInputType.number,
              validator: (v) => v?.isEmpty == true ? 'Requerido' : null,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: _save,
          child: Text(isEditing ? 'Guardar' : 'Crear'),
        ),
      ],
    );
  }

  void _save() async {
    if (!_formKey.currentState!.validate()) return;
    if (_fromCurrencyId == _toCurrencyId) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Las monedas deben ser diferentes')),
      );
      return;
    }
    final provider = context.read<ExchangeRateProvider>();
    final exchangeRate = ExchangeRate(
      id: widget.exchangeRate?.id,
      fromId: _fromCurrencyId!,
      toId: _toCurrencyId!,
      value: double.parse(_valueController.text),
      updatedAt: DateTime.now(),
    );
    if (isEditing) {
      await provider.update(exchangeRate);
    } else {
      await provider.create(exchangeRate);
    }
    if (mounted) Navigator.pop(context);
  }
}

class _FacturasConfigTab extends StatelessWidget {
  const _FacturasConfigTab();

  @override
  Widget build(BuildContext context) {
    return Consumer2<SettingsProvider, CurrencyProvider>(
      builder: (context, settings, currencies, _) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Monedas para Facturas',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Selecciona las monedas adicionales que aparecerán en las facturas',
                        style: TextStyle(color: Colors.grey),
                      ),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<int?>(
                        initialValue:
                            currencies.currencies.indexWhere(
                                  (c) => c.id == settings.additionalCurrency1Id,
                                ) !=
                                -1
                            ? settings.additionalCurrency1Id
                            : null,
                        decoration: const InputDecoration(
                          labelText: 'Moneda adicional 1',
                          prefixIcon: Icon(Icons.attach_money),
                        ),
                        items: [
                          const DropdownMenuItem(
                            value: null,
                            child: Text('Ninguna'),
                          ),
                          ...currencies.currencies.where((c) => !c.isBase).map((
                            c,
                          ) {
                            return DropdownMenuItem(
                              value: c.id,
                              child: Text('${c.code} - ${c.name}'),
                            );
                          }),
                        ],
                        onChanged: (value) =>
                            settings.setAdditionalCurrency1(value),
                      ),
                      const SizedBox(height: 12),
                      DropdownButtonFormField<int?>(
                        initialValue:
                            currencies.currencies.indexWhere(
                                  (c) => c.id == settings.additionalCurrency2Id,
                                ) !=
                                -1
                            ? settings.additionalCurrency2Id
                            : null,
                        decoration: const InputDecoration(
                          labelText: 'Moneda adicional 2',
                          prefixIcon: Icon(Icons.attach_money),
                        ),
                        items: [
                          const DropdownMenuItem(
                            value: null,
                            child: Text('Ninguna'),
                          ),
                          ...currencies.currencies.where((c) => !c.isBase).map((
                            c,
                          ) {
                            return DropdownMenuItem(
                              value: c.id,
                              child: Text('${c.code} - ${c.name}'),
                            );
                          }),
                        ],
                        onChanged: (value) =>
                            settings.setAdditionalCurrency2(value),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Impuesto',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Porcentaje de impuesto que se aplicará a las facturas',
                        style: TextStyle(color: Colors.grey),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              initialValue: settings.taxRate.toString(),
                              decoration: const InputDecoration(
                                labelText: 'Tasa de Impuesto (%)',
                                prefixIcon: Icon(Icons.percent),
                              ),
                              keyboardType: TextInputType.number,
                              onChanged: (value) {
                                final rate = double.tryParse(value);
                                if (rate != null) {
                                  settings.setTaxRate(rate);
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Ejemplo: 16 para 16% IVA',
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
