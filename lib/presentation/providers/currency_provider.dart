import 'package:flutter/foundation.dart';
import '../../data/daos/currency_dao.dart';
import '../../data/daos/settings_dao.dart';
import '../../domain/entities/currency.dart';

class CurrencyProvider extends ChangeNotifier {
  final CurrencyDao _currencyDao = CurrencyDao();
  final SettingsDao _settingsDao = SettingsDao();
  
  List<Currency> _currencies = [];
  bool _isLoading = false;

  List<Currency> get currencies => List.unmodifiable(_currencies);
  Currency? get baseCurrency => _currencies.where((c) => c.isBase).firstOrNull;
  bool get isLoading => _isLoading;

  Future<void> loadCurrencies() async {
    _isLoading = true;
    notifyListeners();
    
    _currencies = await _currencyDao.getAll();
    
    _isLoading = false;
    notifyListeners();
  }

  Future<Currency?> getById(int id) async {
    return await _currencyDao.getById(id);
  }

  Future<Currency?> getByCode(String code) async {
    return await _currencyDao.getByCode(code);
  }

  Future<Currency?> getBaseCurrency() async {
    return await _currencyDao.getBaseCurrency();
  }

  Future<int> setBaseCurrency(int id) async {
    final idResult = await _currencyDao.setBaseCurrency(id);
    await _settingsDao.setValue('additional_currency_1', '');
    await _settingsDao.setValue('additional_currency_2', '');
    await loadCurrencies();
    return idResult;
  }

  Future<int> create(Currency currency) async {
    final id = await _currencyDao.create(currency);
    await loadCurrencies();
    return id;
  }

  Future<void> update(Currency currency) async {
    await _currencyDao.update(currency);
    await loadCurrencies();
  }

  Future<void> delete(int id) async {
    await _currencyDao.delete(id);
    await loadCurrencies();
  }
}