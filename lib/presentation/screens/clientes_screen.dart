import 'package:flutter/material.dart';
import '../../domain/entities/client.dart';
import '../../data/daos/client_dao.dart';
import '../widgets/dekka_app_bar.dart';

class ClientesScreen extends StatefulWidget {
  const ClientesScreen({super.key});

  @override
  State<ClientesScreen> createState() => _ClientesScreenState();
}

class _ClientesScreenState extends State<ClientesScreen> {
  final ClientDao _clientDao = ClientDao();
  final _searchController = TextEditingController();
  List<Client> _clients = [];
  String _searchQuery = '';
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadClients();
  }

  Future<void> _loadClients() async {
    setState(() => _isLoading = true);
    _clients = await _clientDao.getAll();
    setState(() => _isLoading = false);
  }

  List<Client> get _filteredClients {
    if (_searchQuery.isEmpty) return _clients;
    final query = _searchQuery.toLowerCase();
    return _clients.where((c) {
      return c.nombre.toLowerCase().contains(query) ||
          c.cedula.toLowerCase().contains(query) ||
          c.telefono.toLowerCase().contains(query) ||
          (c.email?.toLowerCase().contains(query) ?? false);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: const DekkaAppBar(
        title: 'Clientes',
        userName: 'Administrador',
        userEmail: 'admin@dekkapos.com',
        userInitial: 'A',
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showClientDialog(context),
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
                hintText: 'Buscar clientes...',
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
                : _filteredClients.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.people_outline, size: 64, color: Colors.grey.shade400),
                            const SizedBox(height: 16),
                            Text(
                              _searchQuery.isEmpty ? 'No hay clientes' : 'Sin resultados',
                              style: TextStyle(fontSize: 18, color: Colors.grey.shade600),
                            ),
                            const SizedBox(height: 8),
                            ElevatedButton.icon(
                              onPressed: () => _showClientDialog(context),
                              icon: const Icon(Icons.add),
                              label: const Text('Agregar cliente'),
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
                              DataColumn(label: Text('Cédula')),
                              DataColumn(label: Text('Teléfono')),
                              DataColumn(label: Text('Email')),
                              DataColumn(label: Text('Dirección')),
                              DataColumn(label: Text('Acciones')),
                            ],
                            rows: _filteredClients.map((c) {
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
                                            Icons.person,
                                            size: 14,
                                            color: colorScheme.onSecondaryContainer,
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Text(c.nombre),
                                      ],
                                    ),
                                  ),
                                  DataCell(Text(c.cedula)),
                                  DataCell(Text(c.telefono)),
                                  DataCell(Text(c.email ?? '-')),
                                  DataCell(Text(c.direccion ?? '-')),
                                  DataCell(
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        IconButton(
                                          icon: Icon(Icons.edit, color: colorScheme.primary),
                                          onPressed: () => _showClientDialog(context, client: c),
                                        ),
                                        IconButton(
                                          icon: Icon(Icons.delete, color: colorScheme.error),
                                          onPressed: () => _confirmDelete(context, c.id!, c.nombre),
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

  void _showClientDialog(BuildContext context, {Client? client}) {
    showDialog(
      context: context,
      builder: (context) => ClientFormDialog(client: client, onSaved: _loadClients),
    );
  }

  void _confirmDelete(BuildContext context, int id, String nombre) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Eliminar cliente'),
        content: Text('¿Eliminar "$nombre"?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(dialogContext), child: const Text('Cancelar')),
          ElevatedButton(
            onPressed: () async {
              final navigator = Navigator.of(dialogContext);
              await _clientDao.delete(id);
              navigator.pop();
              _loadClients();
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

class ClientFormDialog extends StatefulWidget {
  final Client? client;
  final Future<void> Function() onSaved;

  const ClientFormDialog({super.key, this.client, required this.onSaved});

  @override
  State<ClientFormDialog> createState() => _ClientFormDialogState();
}

class _ClientFormDialogState extends State<ClientFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nombreController;
  late final TextEditingController _cedulaController;
  late final TextEditingController _telefonoController;
  late final TextEditingController _direccionController;
  late final TextEditingController _emailController;
  final ClientDao _clientDao = ClientDao();

  bool get isEditing => widget.client != null;

  @override
  void initState() {
    super.initState();
    _nombreController = TextEditingController(text: widget.client?.nombre ?? '');
    _cedulaController = TextEditingController(text: widget.client?.cedula ?? '');
    _telefonoController = TextEditingController(text: widget.client?.telefono ?? '');
    _direccionController = TextEditingController(text: widget.client?.direccion ?? '');
    _emailController = TextEditingController(text: widget.client?.email ?? '');
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _cedulaController.dispose();
    _telefonoController.dispose();
    _direccionController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(isEditing ? 'Editar cliente' : 'Nuevo cliente'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _nombreController,
                decoration: const InputDecoration(labelText: 'Nombre *'),
                validator: (v) => v?.isEmpty == true ? 'Requerido' : null,
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _cedulaController,
                decoration: const InputDecoration(labelText: 'Cédula *'),
                validator: (v) => v?.isEmpty == true ? 'Requerido' : null,
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _telefonoController,
                decoration: const InputDecoration(labelText: 'Teléfono *'),
                validator: (v) => v?.isEmpty == true ? 'Requerido' : null,
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _direccionController,
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
    final client = Client(
      id: widget.client?.id,
      nombre: _nombreController.text,
      cedula: _cedulaController.text,
      telefono: _telefonoController.text,
      direccion: _direccionController.text.isEmpty ? null : _direccionController.text,
      email: _emailController.text.isEmpty ? null : _emailController.text,
    );
    if (isEditing) {
      await _clientDao.update(client);
    } else {
      await _clientDao.create(client);
    }
    await widget.onSaved();
    if (mounted) Navigator.pop(context);
  }
}