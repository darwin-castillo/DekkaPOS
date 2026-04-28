import 'package:flutter/foundation.dart';
import '../../data/daos/exchange_rate_dao.dart';
import '../../domain/entities/exchange_rate.dart';

class ExchangeRateProvider extends ChangeNotifier {
  final ExchangeRateDao _exchangeRateDao = ExchangeRateDao();
  
  List<ExchangeRate> _exchangeRates = [];
  bool _isLoading = false;

  List<ExchangeRate> get exchangeRates => List.unmodifiable(_exchangeRates);
  bool get isLoading => _isLoading;

  Future<void> loadExchangeRates() async {
    _isLoading = true;
    notifyListeners();
    
    _exchangeRates = await _exchangeRateDao.getAll();
    
    _isLoading = false;
    notifyListeners();
  }

  Future<ExchangeRate?> getById(int id) async {
    return await _exchangeRateDao.getById(id);
  }

  Future<ExchangeRate?> getByCurrencyPair(int fromId, int toId) async {
    return await _exchangeRateDao.getByCurrencyPair(fromId, toId);
  }

  Future<int> create(ExchangeRate exchangeRate) async {
    final id = await _exchangeRateDao.create(exchangeRate);
    await loadExchangeRates();
    return id;
  }

  Future<void> update(ExchangeRate exchangeRate) async {
    await _exchangeRateDao.update(exchangeRate);
    await loadExchangeRates();
  }

  Future<void> delete(int id) async {
    await _exchangeRateDao.delete(id);
    await loadExchangeRates();
  }
}