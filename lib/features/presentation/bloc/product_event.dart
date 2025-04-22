part of 'product_bloc.dart';

abstract class ProductEvent {}

class FetchProducts extends ProductEvent {}

class LoadMoreProducts extends ProductEvent {}

class SearchProducts extends ProductEvent {
  final String query;
  SearchProducts(this.query);
}

class SortProducts extends ProductEvent {
  final SortOption option;
  SortProducts(this.option);
}

class ToggleFavorite extends ProductEvent {
  final int productId;
  final bool isFavorite;
  ToggleFavorite({required this.productId, required this.isFavorite});
}

