import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wigo_flutter/features/buyer/models/product_model.dart';
import 'package:wigo_flutter/features/buyer/viewmodels/buyer_home_viewmodel.dart';

// --- MOCKS ---
class MockRef extends Mock implements Ref {}

class MockBuildContext extends Mock implements BuildContext {}

class MockStateController<T> extends Mock implements StateController<T> {}

void main() {
  late ProviderContainer container;
  late BuyerHomeViewModel viewModel;

  setUp(() {
    container = ProviderContainer(
      overrides: [
        buyerHomeViewModelProvider.overrideWith(
          // StateNotifierProvider<BuyerHomeViewModel, BuyerHomeState>(
          (ref) => BuyerHomeViewModel(
            initialProducts: [
              Product(
                imageUrl: 'test.png',
                productName: 'Nintendo Gaming Console',
                price: 100,
                slashedAmount: '120',
                rating: 4.0,
                reviews: 10,
                categoryName: 'Gaming',
                stock: 3,
              ),
              Product(
                imageUrl: 'test.png',
                productName: 'Quartz Wrist Watch',
                price: 200,
                slashedAmount: '250',
                rating: 4.5,
                reviews: 20,
                categoryName: 'Jewelry',
                stock: 5,
              ),
            ],
          ),
        ),
        // ),
      ],
    );

    viewModel = container.read(buyerHomeViewModelProvider.notifier);
  });

  tearDown(() {
    container.dispose();
  });

  test('searchSuggestions returns matching product names', () {
    // Test with a query that definitely exists in the mock
    final results = viewModel.searchSuggestions('Gaming');

    expect(results, isNotEmpty);

    // Verify that the result returned is the one we expect
    expect(results, contains('Nintendo Gaming Console'));
  });

  test('searchSuggestions handles partial matches', () {
    final results = viewModel.searchSuggestions('game');

    expect(results, isNotEmpty);
    expect(results.first, 'Nintendo Gaming Console');
  });

  test('searchSuggestions returns empty list for empty query', () {
    final results = viewModel.searchSuggestions('');

    expect(results, isEmpty);
  });

  test('searchSuggestions is case-insensitive', () {
    final lower = viewModel.searchSuggestions('nintendo');
    final upper = viewModel.searchSuggestions('NINTENDO');

    expect(lower, upper);
  });

  test('searchProducts returns matching products', () {
    final products = viewModel.searchProducts('watch');

    expect(products.length, 1);
    expect(products.first.productName, contains('Watch'));
  });

  test('searchProducts returns empty list when no match', () {
    final products = viewModel.searchProducts('does-not-exist');

    expect(products, isEmpty);
  });

  test('searchProducts returns empty list for empty query', () {
    final products = viewModel.searchProducts('');

    expect(products, isEmpty);
  });

  test('updateSearchQuery updates state after debounce', () async {
    viewModel.updateSearchQuery('nin');

    // Immediately — should still be empty
    expect(container.read(buyerHomeViewModelProvider).searchQuery, '');

    // Wait longer than debounce
    await Future.delayed(const Duration(milliseconds: 350));

    expect(container.read(buyerHomeViewModelProvider).searchQuery, 'nin');
  });

  test('updateSearchQuery cancels previous debounce', () async {
    viewModel.updateSearchQuery('nin');
    await Future.delayed(const Duration(milliseconds: 100));

    viewModel.updateSearchQuery('nintendo');

    await Future.delayed(const Duration(milliseconds: 350));

    expect(container.read(buyerHomeViewModelProvider).searchQuery, 'nintendo');
  });

  test('toggleSearchFieldVisibility shows search field', () {
    viewModel.toggleSearchFieldVisibility();

    final state = container.read(buyerHomeViewModelProvider);

    expect(state.isSearchFieldVisible, true);
    expect(state.shouldClearSearch, false);
  });

  test('toggleSearchFieldVisibility hides search field and clears query', () {
    viewModel.updateSearchQuery('phone');

    viewModel.toggleSearchFieldVisibility(); // show
    viewModel.toggleSearchFieldVisibility(); // hide

    final state = container.read(buyerHomeViewModelProvider);

    expect(state.isSearchFieldVisible, false);
    expect(state.searchQuery, '');
    expect(state.shouldClearSearch, true);
  });
  test('resetSearch hides search field and clears query', () {
    viewModel.toggleSearchFieldVisibility();
    viewModel.updateSearchQuery('honey');

    viewModel.resetSearch();

    final state = container.read(buyerHomeViewModelProvider);

    expect(state.isSearchFieldVisible, false);
    expect(state.searchQuery, '');
  });
}
