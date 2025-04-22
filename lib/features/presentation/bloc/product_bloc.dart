import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

import '../../../core/constants/strings.dart';
import '../../../core/utils/sort_option.dart';
import '../../domain/entities/product.dart';
import '../../domain/usecases/get_products.dart';
import '../../domain/repositories/product_repository.dart';

part 'product_event.dart';
part 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final GetProducts getProducts;
  final ProductRepository repository;

  List<Product> allProducts = [];
  int _page = 1;
  bool _isLoadingMore = false;
  bool _hasFetched = false;

  ProductBloc({required this.getProducts, required this.repository}) : super(ProductInitial()) {
    on<FetchProducts>(_onFetchProducts);
    on<SearchProducts>(_onSearch);
    on<SortProducts>(_onSort);
    on<ToggleFavorite>(_onToggleFavorite);
    on<LoadMoreProducts>(_onLoadMoreProducts);
  }

  /// Fetch products from the API or local storage
  Future<void> _onFetchProducts(FetchProducts event, Emitter<ProductState> emit) async {
    if (_hasFetched) return;
    _hasFetched = true;

    print('Fetch products started...');
    emit(ProductLoading());

    try {
      final connectivity = await Connectivity().checkConnectivity();
      final isOffline = connectivity == ConnectivityResult.none;

      if (isOffline) {
        final cached = await repository.getProductsFromLocal();
        allProducts = cached;
        if (cached.isNotEmpty) {
          emit(ProductLoaded(cached, isOffline: true));
        } else {
          emit(ProductError(AppString.noInternetNoCashData));
        }
      } else {
        final products = await getProducts();
        allProducts = products;
        emit(ProductLoaded(products));
      }
    } catch (e) {
      print('Error fetching products: $e');
      try {
        final cached = await repository.getProductsFromLocal();
        if (cached.isNotEmpty) {
          allProducts = cached;
          emit(ProductLoaded(cached, isOffline: true));
          return;
        }
      } catch (_) {}
      emit(ProductError(AppString.somethingWentWrong));
    }
  }

  void _onSearch(SearchProducts event, Emitter<ProductState> emit) {
    final filtered = allProducts.where((p) => p.title.toLowerCase().contains(event.query.toLowerCase())).toList();
    emit(ProductLoaded(filtered));
  }

  /// Sort products based on the selected option
  void _onSort(SortProducts event, Emitter<ProductState> emit) {
    List<Product> sorted = List.from(allProducts);
    switch (event.option) {
      case SortOption.priceLowHigh:
        sorted.sort((a, b) => a.price.compareTo(b.price));
        break;
      case SortOption.priceHighLow:
        sorted.sort((a, b) => b.price.compareTo(a.price));
        break;
      case SortOption.rating:
        sorted.sort((a, b) => (b.rating?.rate ?? 0).compareTo(a.rating?.rate ?? 0));
        break;
    }
    emit(ProductLoaded(sorted));
  }

  /// Toggle the favorite status of a product
  Future<void> _onToggleFavorite(ToggleFavorite event, Emitter<ProductState> emit) async {
    try {
      await repository.toggleFavorite(event.productId, event.isFavorite);
      allProducts = allProducts.map((product) {
        if (product.id == event.productId) {
          return product.copyWith(isFavorite: event.isFavorite);
        }
        return product;
      }).toList();

      emit(ProductLoaded(allProducts));
    } catch (e) {
      print("Error toggling favorite: $e");
    }
  }

  /// Load more products when the user scrolls to the bottom of the list (pagination moc data)
  Future<void> _onLoadMoreProducts(LoadMoreProducts event, Emitter<ProductState> emit) async {
    if (_isLoadingMore) return;
    _isLoadingMore = true;

    try {
      emit(ProductLoaded(List.from(allProducts), isLoadingMore: true));
      await Future.delayed(const Duration(seconds: 1));
      final moreProducts = await getProducts();
      final duplicated = moreProducts.map((p) => p.copyWith(id: p.id + _page * 1000)).toList();
      allProducts.addAll(duplicated);
      _page++;

      emit(ProductLoaded(List.from(allProducts)));
    } catch (e) {
      print("Error loading more data: $e");
    } finally {
      _isLoadingMore = false;
    }
  }
}
