import 'package:flutter/material.dart';

class ReportesScreen extends StatelessWidget {
  const ReportesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reportes'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Row(
          children: [
            Expanded(
              child: Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      Icon(Icons.attach_money, size: 60, color: Colors.green.shade700),
                      const SizedBox(height: 16),
                      const Text('Ventas del Día', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      Text('\$1,250.00', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.green)),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      Icon(Icons.shopping_cart, size: 60, color: Colors.orange.shade700),
                      const SizedBox(height: 16),
                      const Text('Productos Vendidos', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      Text('85', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.orange)),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      Icon(Icons.people, size: 60, color: Colors.blue.shade700),
                      const SizedBox(height: 16),
                      const Text('Nuevos Clientes', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      Text('12', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.blue)),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}