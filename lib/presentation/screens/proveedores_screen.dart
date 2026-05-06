import 'package:flutter/material.dart';
import '../../domain/entities/provider.dart' as entity;
import '../../data/daos/provider_dao.dart';
import '../widgets/dekka_app_bar.dart';

class ProveedoresScreen extends StatefulWidget {
  const ProveedoresScreen({super.key});

  @override
  State<ProveedoresScreen> createState() => _ProveedoresScreenState();
}

class _ProveedoresScreenState extends State<ProveedoresScreen> {
  final ProviderDao _providerDao = ProviderDao();
  final _searchController = TextEditingController();
  List<entity.Provider> _providers = [];
  String _searchQuery = '';
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadProviders();
  }

  Future<void> _loadProviders() async {
    setState(() => _isLoading = true);
    _providers = await _providerDao.getAll();
    setState(() => _isLoading = false);
  }

  List<entity.Provider> get _filteredProviders {
    if (_searchQuery.isEmpty) return _providers;
    return _providers.where((p) {
      return p.name.toLowerCase().contains(_searchQuery) ||
          (p.description?.toLowerCase().contains(_searchQuery) ?? false) ||
          (p.phone?.toLowerCase().contains(_searchQuery) ?? false);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: const DekkaAppBar(
        title: 'Proveedores',
        userName: 'Administrador',
        userEmail: 'admin@dekkapos.com',
        userInitial: 'A',
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showProviderDialog(context),
        icon: const Icon(Icons.add),
        label: const Text('Nuevo'),
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Buscar proveedores...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          setState(() => _searchQuery = '');
                        },
                      )
                    : null,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                filled: true,
                fillColor: colorScheme.surfaceContainerHighest.withAlpha(50),
              ),
              onChanged: (value) => setState(() => _searchQuery = value.toLowerCase()),
            ),
          ),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _filteredProviders.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.local_shipping_outlined, size: 64, color: Colors.grey.shade400),
                            const SizedBox(height: 16),
                            Text(
                              _searchQuery.isEmpty ? 'No hay proveedores' : 'Sin resultados',
                              style: TextStyle(fontSize: 18, color: Colors.grey.shade600),
                            ),
                            const SizedBox(height: 8),
                            ElevatedButton.icon(
                              onPressed: () => _showProviderDialog(context),
                              icon: const Icon(Icons.add),
                              label: const Text('Agregar proveedor'),
                            ),
                          ],
                        ),
                      )
                    : SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: SingleChildScrollView(
                          child: DataTable(
                            headingRowColor: WidgetStateProperty.all(colorScheme.primaryContainer.withAlpha(100)),
                            columns: const [
                              DataColumn(label: Text('Nombre')),
                              DataColumn(label: Text('Descripción')),
                              DataColumn(label: Text('Teléfono')),
                              DataColumn(label: Text('Dirección')),
                              DataColumn(label: Text('Acciones')),
                            ],
                            rows: _filteredProviders.map((p) {
                              return DataRow(
                                cells: [
                                  DataCell(
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        CircleAvatar(
                                          radius: 12,
                                          backgroundColor: colorScheme.secondaryContainer,
                                          child: Icon(
                                            Icons.business,
                                            size: 14,
                                            color: colorScheme.onSecondaryContainer,
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Text(p.name),
                                      ],
                                    ),
                                  ),
                                  DataCell(Text(p.description ?? '-')),
                                  DataCell(Text(p.phone ?? '-')),
                                  DataCell(Text(p.address ?? '-')),
                                  DataCell(
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        IconButton(
                                          icon: Icon(Icons.edit, color: colorScheme.primary),
                                          onPressed: () => _showProviderDialog(context, provider: p),
                                        ),
                                        IconButton(
                                          icon: Icon(Icons.delete, color: colorScheme.error),
                                          onPressed: () => _confirmDelete(context, p.id!, p.name),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              );
                            }).toList(),
                          ),
                        ),
                      ),
          ),
        ],
      ),
    );
  }

  void _showProviderDialog(BuildContext context, {entity.Provider? provider}) {
    showDialog(
      context: context,
      builder: (context) => ProviderFormDialog(provider: provider, onSaved: _loadProviders),
    );
  }

  void _confirmDelete(BuildContext context, int id, String name) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Eliminar proveedor'),
        content: Text('¿Eliminar "$name"?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(dialogContext), child: const Text('Cancelar')),
          ElevatedButton(
            onPressed: () async {
              final navigator = Navigator.of(dialogContext);
              await _providerDao.delete(id);
              navigator.pop();
              _loadProviders();
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}

class ProviderFormDialog extends StatefulWidget {
  final entity.Provider? provider;
  final Future<void> Function() onSaved;

  const ProviderFormDialog({super.key, this.provider, required this.onSaved});

  @override
  State<ProviderFormDialog> createState() => _ProviderFormDialogState();
}

class _ProviderFormDialogState extends State<ProviderFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _phoneController;
  late final TextEditingController _addressController;
  final ProviderDao _providerDao = ProviderDao();

  bool get isEditing => widget.provider != null;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.provider?.name ?? '');
    _descriptionController = TextEditingController(text: widget.provider?.description ?? '');
    _phoneController = TextEditingController(text: widget.provider?.phone ?? '');
    _addressController = TextEditingController(text: widget.provider?.address ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(isEditing ? 'Editar proveedor' : 'Nuevo proveedor'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Nombre *'),
                validator: (v) => v?.isEmpty == true ? 'Requerido' : null,
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Descripción'),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(labelText: 'Teléfono'),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _addressController,
                decoration: const InputDecoration(labelText: 'Dirección'),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
        ElevatedButton(onPressed: _save, child: Text(isEditing ? 'Guardar' : 'Crear')),
      ],
    );
  }

  void _save() async {
    if (!_formKey.currentState!.validate()) return;
    final provider = entity.Provider(
      id: widget.provider?.id,
      name: _nameController.text,
      description: _descriptionController.text.isEmpty ? null : _descriptionController.text,
      phone: _phoneController.text.isEmpty ? null : _phoneController.text,
      address: _addressController.text.isEmpty ? null : _addressController.text,
    );
    if (isEditing) {
      await _providerDao.update(provider);
    } else {
      await _providerDao.create(provider);
    }
    await widget.onSaved();
    if (mounted) Navigator.pop(context);
  }
}