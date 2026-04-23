import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/client_provider.dart';
import '../../core/theme.dart';

class ClientCard extends StatelessWidget {
  const ClientCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ClientProvider>(
      builder: (context, provider, _) {
        final client = provider.currentClient;
        
        return Card(
          elevation: 4,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 22,
                  backgroundColor: AppTheme.primaryColor.withValues(alpha: 0.1),
                  child: const Icon(Icons.person, size: 24, color: AppTheme.primaryColor),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        client?.nombre ?? 'Sin cliente',
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                      Text(
                        client?.cedula ?? 'Seleccione un cliente',
                        style: const TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                      Text(
                        client?.telefono ?? '',
                        style: const TextStyle(fontSize: 11, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.edit, size: 16),
                  label: const Text('Cambiar'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}