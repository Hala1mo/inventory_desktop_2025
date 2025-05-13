import 'package:flutter/material.dart';
import '../models/Product.dart';

class ProductsListProvider extends ChangeNotifier {
  List<Product> _products = [];
  List<Product> filteredProducts = [];

  String currentStatus = 'All';
  String currentCategory = 'All Stock';
  double? currentMinPrice;
  double? currentMaxPrice;
  String sortAlphabetically = 'A-Z';
  String timeSort = 'Newest';
  String lastSortType = 'none';

  void setProducts(List<Product> products) {
    _products = products;
    filteredProducts = List.from(products);
    notifyListeners();
  }

  void removeProduct(Product product) {
    _products.removeWhere((p) => p.id == product.id);
    filterProducts();
  }

  void addProduct(Product product) {
    _products.add(product);
    filterProducts();
  }

  void updateLocation(Product updatedProduct) {
    final productIndex = _products.indexWhere((p) => p.id == updatedProduct.id);
    final filteredIndex =
        filteredProducts.indexWhere((p) => p.id == updatedProduct.id);

    if (productIndex != -1) {
      _products[productIndex] = updatedProduct;
    }

    if (filteredIndex != -1) {
      filteredProducts[filteredIndex] = updatedProduct;
    }

    notifyListeners();
  }

  List<Product> get all => _products;

  List<Product> get active =>
      _products.where((p) => p.status == ProductStatus.ACTIVE).toList();

  List<Product> get inactive =>
      _products.where((p) => p.status == ProductStatus.INACTIVE).toList();

  List<Product> get draft =>
      _products.where((p) => p.status == ProductStatus.DRAFT).toList();

  int get allCount => _products.length;

  int get activeCount => active.length;

  int get inactiveCount => inactive.length;

  int get draftCount => draft.length;

  void filterProducts({
    String? status,
    String? category,
    double? minPrice,
    double? maxPrice,
    String? sortAlpha,
    String? sortTime,
  }) {
    if (status != null) currentStatus = status;
    if (category != null) currentCategory = category;
    if (minPrice != null) currentMinPrice = minPrice;
    if (maxPrice != null) currentMaxPrice = maxPrice;

    // Track which sort was changed
    if (sortAlpha != null) {
      sortAlphabetically = sortAlpha;
      lastSortType = 'alpha';
    }
    if (sortTime != null) {
      timeSort = sortTime;
      lastSortType = 'time';
    }

    filteredProducts = _products.where((product) {
      bool matchesStatus = currentStatus == 'All' ||
          product.status.name.toLowerCase() == currentStatus.toLowerCase();
      bool matchesCategory = currentCategory == 'All Stock' ||
          product.category.name.toLowerCase() == currentCategory.toLowerCase();
      bool matchesMinPrice =
          currentMinPrice == null || product.price >= currentMinPrice!;
      bool matchesMaxPrice =
          currentMaxPrice == null || product.price <= currentMaxPrice!;
      return matchesStatus &&
          matchesCategory &&
          matchesMinPrice &&
          matchesMaxPrice;
    }).toList();

    if (lastSortType == 'alpha') {
      if (sortAlphabetically == 'A-Z') {
        filteredProducts.sort(
            (a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
      } else if (sortAlphabetically == 'Z-A') {
        filteredProducts.sort(
            (a, b) => b.name.toLowerCase().compareTo(a.name.toLowerCase()));
      }
    } else if (lastSortType == 'time') {
      if (timeSort == 'Newest') {
        filteredProducts.sort((a, b) => b.createdAt!.compareTo(a.createdAt!));
      } else if (timeSort == 'Oldest') {
        filteredProducts.sort((a, b) => a.createdAt!.compareTo(b.createdAt!));
      }
    }

    notifyListeners();
  }

  void clearFilters() {
    currentStatus = 'All';
    currentCategory = 'All Stock';
    currentMinPrice = null;
    currentMaxPrice = null;
    sortAlphabetically = 'A-Z';
    timeSort = 'Newest';
    lastSortType = 'none';
    filteredProducts = List.from(_products);
    notifyListeners();
  }
}
