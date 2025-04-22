part of 'product_bloc.dart';

abstract class ProductState {}

class ProductInitial extends ProductState {}

class ProductLoading extends ProductState {}

class ProductLoaded extends ProductState {
  final List<Product> products;
  final bool isLoadingMore;
  final bool isOffline;

  ProductLoaded(
      this.products, {
        this.isLoadingMore = false,
        this.isOffline = false,
      });
}


class ProductError extends ProductState {
  final String message;
  ProductError(this.message);
}

class ProductOfflineMessage extends ProductState {
  final String message;
  ProductOfflineMessage({this.message = AppString.offlineMessage});
}