import 'package:flutter/foundation.dart';
import '../../data/daos/settings_dao.dart';

enum PaymentMethod { efectivo, tarjeta, pagoMovil, mixto }
enum InvoiceStatus { pagada, pendiente }

extension PaymentMethodExtension on PaymentMethod {
  String get label {
    switch (this) {
      case PaymentMethod.efectivo:
        return 'Efectivo';
      case PaymentMethod.tarjeta:
        return 'Tarjeta';
      case PaymentMethod.pagoMovil:
        return 'Pago Móvil';
      case PaymentMethod.mixto:
        return 'Mixto';
    }
  }

  String get value {
    switch (this) {
      case PaymentMethod.efectivo:
        return 'efectivo';
      case PaymentMethod.tarjeta:
        return 'tarjeta';
      case PaymentMethod.pagoMovil:
        return 'pago_movil';
      case PaymentMethod.mixto:
        return 'mixto';
    }
  }

  static PaymentMethod fromString(String v) {
    switch (v) {
      case 'tarjeta':
        return PaymentMethod.tarjeta;
      case 'pago_movil':
        return PaymentMethod.pagoMovil;
      case 'mixto':
        return PaymentMethod.mixto;
      default:
        return PaymentMethod.efectivo;
    }
  }
}

extension InvoiceStatusExtension on InvoiceStatus {
  String get label {
    switch (this) {
      case InvoiceStatus.pagada:
        return 'Pagada';
      case InvoiceStatus.pendiente:
        return 'Pendiente';
    }
  }

  String get value {
    switch (this) {
      case InvoiceStatus.pagada:
        return 'pagada';
      case InvoiceStatus.pendiente:
        return 'pendiente';
    }
  }

  static InvoiceStatus fromString(String v) {
    switch (v) {
      case 'pagada':
        return InvoiceStatus.pagada;
      default:
        return InvoiceStatus.pendiente;
    }
  }
}

class SettingsProvider extends ChangeNotifier {
  final SettingsDao _settingsDao = SettingsDao();
  
  int? _additionalCurrency1Id;
  int? _additionalCurrency2Id;
  double _taxRate = 16.0;
  bool _isLoading = false;

  int? get additionalCurrency1Id => _additionalCurrency1Id;
  int? get additionalCurrency2Id => _additionalCurrency2Id;
  double get taxRate => _taxRate;
  bool get isLoading => _isLoading;

  Future<void> loadSettings() async {
    _isLoading = true;
    notifyListeners();

    final currency1 = await _settingsDao.getValue('additional_currency_1');
    final currency2 = await _settingsDao.getValue('additional_currency_2');
    final taxRate = await _settingsDao.getValue('tax_rate');

    _additionalCurrency1Id = currency1 != null ? int.tryParse(currency1) : null;
    _additionalCurrency2Id = currency2 != null ? int.tryParse(currency2) : null;
    _taxRate = taxRate != null ? double.tryParse(taxRate) ?? 16.0 : 16.0;

    _isLoading = false;
    notifyListeners();
  }

  Future<void> setAdditionalCurrency1(int? id) async {
    _additionalCurrency1Id = id;
    await _settingsDao.setValue('additional_currency_1', id?.toString() ?? '');
    notifyListeners();
  }

  Future<void> setAdditionalCurrency2(int? id) async {
    _additionalCurrency2Id = id;
    await _settingsDao.setValue('additional_currency_2', id?.toString() ?? '');
    notifyListeners();
  }

  Future<void> setTaxRate(double rate) async {
    _taxRate = rate;
    await _settingsDao.setValue('tax_rate', rate.toString());
    notifyListeners();
  }
}