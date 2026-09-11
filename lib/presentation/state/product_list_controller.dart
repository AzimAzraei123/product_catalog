import 'dart:async';
import 'package:flutter/foundation.dart';
import '../../data/models/product.dart';
import '../../data/repositories/product_repository.dart';

enum ViewStatus { loading, error, empty, success }

class ProductListController extends ChangeNotifier {
  final ProductRepository _repository;

  ProductListController({ProductRepository? repository})
      : _repository = repository ?? ProductRepository();

  ViewStatus status = ViewStatus.loading;
  List<Product> products = [];
  String errorMessage = '';

  int _skip = 0;
  bool _hasMore = true;
  bool _isLoadingMore = false;
  String _currentQuery = '';
  Timer? _debounce;

  bool get isLoadingMore => _isLoadingMore;
  bool get isSearching => _currentQuery.isNotEmpty;

  Future<void> loadInitial() async {
    status = ViewStatus.loading;
    _skip = 0;
    _hasMore = true;
    notifyListeners();

    try {
      final response = await _repository.getProducts(skip: _skip);
      products = response.products;
      _skip = response.skip + response.products.length;
      _hasMore = _repository.hasMore(response);
      status = products.isEmpty ? ViewStatus.empty : ViewStatus.success;
    } catch (e) {
      errorMessage = e.toString();
      status = ViewStatus.error;
    }
    notifyListeners();
  }

  Future<void> loadMore() async {
    if (_isLoadingMore || !_hasMore || isSearching) return;

    _isLoadingMore = true;
    notifyListeners();

    try {
      final response = await _repository.getProducts(skip: _skip);
      products = [...products, ...response.products];
      _skip = response.skip + response.products.length;
      _hasMore = _repository.hasMore(response);
    } catch (e) {
      // Silently keep existing list on pagination failure;
      // user can scroll again to retry (see README TODOs).
    }

    _isLoadingMore = false;
    notifyListeners();
  }

  void onSearchChanged(String query) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), () {
      _runSearch(query.trim());
    });
  }

  Future<void> _runSearch(String query) async {
    _currentQuery = query;

    if (query.isEmpty) {
      await loadInitial();
      return;
    }

    status = ViewStatus.loading;
    notifyListeners();

    try {
      final response = await _repository.search(query);
      products = response.products;
      status = products.isEmpty ? ViewStatus.empty : ViewStatus.success;
    } catch (e) {
      errorMessage = e.toString();
      status = ViewStatus.error;
    }
    notifyListeners();
  }

  Future<void> retry() async {
    if (isSearching) {
      await _runSearch(_currentQuery);
    } else {
      await loadInitial();
    }
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }
}