import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'features/domain/usecases/get_products.dart';
import 'features/presentation/bloc/product_bloc.dart';
import 'features/presentation/pages/home_screen.dart';
import 'features/products/data/datasources/product_local_data_source.dart';
import 'features/products/data/datasources/product_remote_data_source.dart';
import 'features/products/data/repositories/product_repository_impl.dart';

void main() {
  final remote = ProductRemoteDataSource();
  final local = ProductLocalDataSource();
  final repository = ProductRepositoryImpl(remoteDataSource: remote, localDataSource: local);
  final getProducts = GetProducts(repository);

  runApp(MyApp(repository: repository, getProducts: getProducts));
}

class MyApp extends StatelessWidget {
  final ProductRepositoryImpl repository;
  final GetProducts getProducts;

  const MyApp({super.key, required this.repository, required this.getProducts});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: BlocProvider(
        create: (_) => ProductBloc(getProducts: getProducts, repository: repository)..add(FetchProducts()),
        child: HomeScreen(),
      ),
    );
  }
}
