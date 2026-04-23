import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../domain/repositories/client_repository.dart';

class ClientesScreen extends StatelessWidget {
  const ClientesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final repository = context.read<ClientRepository>();
    final clients = repository.getAllClients();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Clientes'),
        actions: [
          ElevatedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.add),
            label: const Text('Nuevo Cliente'),
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
            DataColumn(label: Text('Cédula', style: TextStyle(fontWeight: FontWeight.bold))),
            DataColumn(label: Text('Teléfono', style: TextStyle(fontWeight: FontWeight.bold))),
            DataColumn(label: Text('Acciones', style: TextStyle(fontWeight: FontWeight.bold))),
          ],
          rows: clients.map((c) => DataRow(cells: [
            DataCell(Text(c.id)),
            DataCell(Text(c.nombre)),
            DataCell(Text(c.cedula)),
            DataCell(Text(c.telefono)),
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