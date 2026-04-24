import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/client_provider.dart';

class ClientCard extends StatelessWidget {
  const ClientCard({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
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
                  backgroundColor: colorScheme.primaryContainer,
                  child: Icon(Icons.person, size: 24, color: colorScheme.onPrimaryContainer),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        client?.nombre ?? 'Sin cliente',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: colorScheme.onSurface),
                      ),
                      Text(
                        client?.cedula ?? 'Seleccione un cliente',
                        style: TextStyle(fontSize: 12, color: colorScheme.onSurfaceVariant),
                      ),
                      Text(
                        client?.telefono ?? '',
                        style: TextStyle(fontSize: 11, color: colorScheme.onSurfaceVariant),
                      ),
                    ],
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.edit, size: 16),
                  label: const Text('Cambiar'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colorScheme.secondary,
                    foregroundColor: colorScheme.onSecondary,
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