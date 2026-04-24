import 'package:flutter/material.dart';
import '../widgets/dekka_app_bar.dart';

class ProveedoresScreen extends StatelessWidget {
  const ProveedoresScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const DekkaAppBar(
        title: 'Proveedores',
        userName: 'Administrador',
        userEmail: 'admin@dekkapos.com',
        userInitial: 'A',
      ),
      body: const Center(
        child: Text('Módulo de proveedores en desarrollo'),
      ),
    );
  }
}