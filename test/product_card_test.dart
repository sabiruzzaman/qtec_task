import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:qtec_task/features/domain/entities/product.dart';
import 'package:qtec_task/features/presentation/bloc/product_bloc.dart';
import 'package:qtec_task/features/presentation/widgets/product_card.dart';
import 'package:qtec_task/features/products/data/models/product_model.dart';

class MockProductBloc extends Mock implements ProductBloc {}

void main() {
  late Product testProduct;
  late ProductBloc mockBloc;

  setUp(() {
    testProduct = Product(
      id: 1,
      title: 'Test Product',
      price: 20.0,
      description: 'Test Description',
      category: 'Test Category',
      image: 'https://via.placeholder.com/150',
      isFavorite: false,
      isOutOfStock: false,
      rating: Rating(rate: 4.5, count: 10),
      ratingCount: 10,
    );
    mockBloc = MockProductBloc();
  });

  testWidgets('renders ProductCard with product data', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider<ProductBloc>.value(
          value: mockBloc,
          child: Material(
            child: ProductCard(product: testProduct),
          ),
        ),
      ),
    );
    expect(find.text('Test Product'), findsOneWidget);
    expect(find.text('\$20.0'), findsOneWidget);
    expect(find.byIcon(Icons.favorite_border), findsOneWidget);
    expect(find.byIcon(Icons.star), findsOneWidget);
    expect(find.text('4.5'), findsOneWidget);
    expect(find.text('(10)'), findsOneWidget);

    expect(find.byType(Image), findsOneWidget);


  });
}
