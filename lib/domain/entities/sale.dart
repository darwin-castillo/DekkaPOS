import 'client.dart';
import 'cart_item.dart';

class Sale {
  final String id;
  final Client client;
  final List<CartItem> items;
  final DateTime fecha;
  final double totalBs;
  final double totalUsd;

  const Sale({
    required this.id,
    required this.client,
    required this.items,
    required this.fecha,
    required this.totalBs,
    required this.totalUsd,
  });
}