import 'package:flutter/material.dart';
import '../widgets/dekka_app_bar.dart';

class ClientesScreen extends StatelessWidget {
  const ClientesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const DekkaAppBar(
        title: 'Clientes',
        userName: 'Administrador',
        userEmail: 'admin@dekkapos.com',
        userInitial: 'A',
      ),
      body: const Center(
        child: Text('Módulo de clientes en desarrollo'),
      ),
    );
  }
}