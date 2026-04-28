import 'package:flutter/foundation.dart';
import '../../data/daos/invoice_dao.dart';
import '../../data/daos/invoice_item_dao.dart';
import '../../domain/entities/invoice.dart';
import '../../domain/entities/invoice_item.dart';

class InvoiceProvider extends ChangeNotifier {
  final InvoiceDao _invoiceDao = InvoiceDao();
  final InvoiceItemDao _invoiceItemDao = InvoiceItemDao();
  
  List<Invoice> _invoices = [];
  bool _isLoading = false;

  List<Invoice> get invoices => List.unmodifiable(_invoices);
  bool get isLoading => _isLoading;

  Future<void> loadInvoices() async {
    _isLoading = true;
    notifyListeners();
    
    _invoices = await _invoiceDao.getAll();
    
    _isLoading = false;
    notifyListeners();
  }

  Future<void> loadInvoicesByStatus(String status) async {
    _isLoading = true;
    notifyListeners();
    
    _invoices = await _invoiceDao.getByStatus(status);
    
    _isLoading = false;
    notifyListeners();
  }

  Future<Invoice?> getById(int id) async {
    return await _invoiceDao.getById(id);
  }

  Future<Invoice?> getByNumero(String numero) async {
    return await _invoiceDao.getByNumero(numero);
  }

  Future<List<InvoiceItem>> getItemsByInvoiceId(int invoiceId) async {
    return await _invoiceItemDao.getByInvoiceId(invoiceId);
  }

  Future<int> create(Invoice invoice, List<InvoiceItem> items) async {
    final invoiceId = await _invoiceDao.create(invoice);
    
    for (final item in items) {
      await _invoiceItemDao.create(item.copyWith(invoiceId: invoiceId));
    }
    
    await loadInvoices();
    return invoiceId;
  }

  Future<void> update(Invoice invoice, List<InvoiceItem> items) async {
    await _invoiceDao.update(invoice);
    await _invoiceItemDao.deleteByInvoiceId(invoice.id!);
    
    for (final item in items) {
      await _invoiceItemDao.create(item.copyWith(invoiceId: invoice.id!));
    }
    
    await loadInvoices();
  }

  Future<void> updateStatus(int id, String status) async {
    await _invoiceDao.updateStatus(id, status);
    await loadInvoices();
  }

  Future<void> delete(int id) async {
    await _invoiceItemDao.deleteByInvoiceId(id);
    await _invoiceDao.delete(id);
    await loadInvoices();
  }

  Future<String> getNextNumero() async {
    return await _invoiceDao.getNextNumero();
  }
}