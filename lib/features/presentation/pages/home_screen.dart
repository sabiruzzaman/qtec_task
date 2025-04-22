import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qtec_task/features/presentation/widgets/app_search_bar.dart';
import '../../../core/constants/strings.dart';
import '../bloc/product_bloc.dart';
import '../widgets/app_snack_bar.dart';
import '../widgets/filter_bottom_sheet.dart';
import '../widgets/product_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _ProductListPageState();
}

class _ProductListPageState extends State<HomeScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    context.read<ProductBloc>().add(FetchProducts());
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 300) {
      context.read<ProductBloc>().add(LoadMoreProducts());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: AppSearchBar(
          onChanged: (query) {
            context.read<ProductBloc>().add(SearchProducts(query));
          },
        ),
        actions: [
          IconButton(icon: const Icon(Icons.filter_list), onPressed: () => FilterBottomSheet.show(context)),
        ],
      ),
      body: BlocConsumer<ProductBloc, ProductState>(
        listener: (context, state) {
          // error handling
          if (state is ProductError) {
            AppSnackBar.showErrorSnackBar(context, state.message);
          }
          // offline message
          if (state is ProductLoaded && state.isOffline) {
            AppSnackBar.showInfoSnackBar(context, AppString.offlineMessage);
          }
        },
        // loading state
        builder: (context, state) {
          if (state is ProductLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is ProductLoaded) {
            final products = state.products;
            return Column(
              children: [
                Expanded(
                  child: GridView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(8),
                    itemCount: products.length,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                      childAspectRatio: 0.7,
                    ),
                    itemBuilder: (context, index) => ProductCard(product: products[index]),
                  ),
                ),
                if (state.isLoadingMore)
                  const Padding(
                    padding: EdgeInsets.only(top: 12, bottom: 24),
                    child: Center(child: CircularProgressIndicator()),
                  ),
              ],
            );
          }

          return const Center(child: Text(AppString.somethingWentWrong));
        },
      ),
    );
  }
}
