import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../domain/repositories/provider_repository.dart';

class ProveedoresScreen extends StatelessWidget {
  const ProveedoresScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final repository = context.read<ProviderRepository>();
    final providers = repository.getAllProviders();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Proveedores'),
        actions: [
          ElevatedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.add),
            label: const Text('Nuevo Proveedor'),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: DataTable(
          columns: const [
            DataColumn(label: Text('ID', style: TextStyle(fontWeight: FontWeight.bold))),
            DataColumn(label: Text('Nombre', style: TextStyle(fontWeight: FontWeight.bold))),
            DataColumn(label: Text('Contacto', style: TextStyle(fontWeight: FontWeight.bold))),
            DataColumn(label: Text('Teléfono', style: TextStyle(fontWeight: FontWeight.bold))),
            DataColumn(label: Text('Email', style: TextStyle(fontWeight: FontWeight.bold))),
            DataColumn(label: Text('Acciones', style: TextStyle(fontWeight: FontWeight.bold))),
          ],
          rows: providers.map((p) => DataRow(cells: [
            DataCell(Text(p.id)),
            DataCell(Text(p.nombre)),
            DataCell(Text(p.contacto)),
            DataCell(Text(p.telefono)),
            DataCell(Text(p.email)),
            const DataCell(Row(
              children: [
                Icon(Icons.edit, size: 20, color: Colors.blue),
                SizedBox(width: 8),
                Icon(Icons.delete, size: 20, color: Colors.red),
              ],
            )),
          ])).toList(),
        ),
      ),
    );
  }
}