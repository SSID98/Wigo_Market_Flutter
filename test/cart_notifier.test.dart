import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wigo_flutter/features/buyer/models/cart_model.dart';
import 'package:wigo_flutter/features/buyer/models/product_model.dart';
import 'package:wigo_flutter/features/buyer/viewmodels/buyer_cart_viewmodel.dart';

void main() {
  late ProviderContainer container;
  late CartNotifier cartNotifier;

  final testProduct = Product(
    imageUrl: 'test.png',
    productName: 'Nintendo Console',
    price: 100.0,
    slashedAmount: '120',
    rating: 4.0,
    reviews: 10,
    categoryName: 'Gaming',
    stock: 5,
  );

  CartState createCartItem({int quantity = 1}) {
    return CartState(
      product: testProduct,
      quantity: quantity,
      size: 'M',
      colorName: 'Black',
    );
  }

  setUp(() {
    container = ProviderContainer();
    cartNotifier = container.read(cartProvider.notifier);
  });

  tearDown(() {
    container.dispose();
  });

  test('addItem adds a product to cart', () {
    cartNotifier.addItem(createCartItem());

    final cart = container.read(cartProvider);

    expect(cart.length, 1);
    expect(cart.first.product.productName, testProduct.productName);
    expect(cart.first.quantity, 1);
  });

  test('addItem does not add duplicate products', () {
    cartNotifier.addItem(createCartItem());
    cartNotifier.addItem(createCartItem());

    final cart = container.read(cartProvider);

    expect(cart.length, 1);
  });

  test('updateQuantity updates item quantity', () {
    cartNotifier.addItem(createCartItem());

    cartNotifier.updateQuantity(testProduct.productName, 3);

    final cart = container.read(cartProvider);

    expect(cart.first.quantity, 3);
  });

  test('updateQuantity removes item if quantity <= 0', () {
    cartNotifier.addItem(createCartItem());

    cartNotifier.updateQuantity(testProduct.productName, 0);

    final cart = container.read(cartProvider);

    expect(cart, isEmpty);
  });

  test('removeItem removes product from cart', () {
    cartNotifier.addItem(createCartItem());

    cartNotifier.removeItem(testProduct.productName);

    final cart = container.read(cartProvider);

    expect(cart, isEmpty);
  });

  test('subtotal returns correct total', () {
    cartNotifier.addItem(createCartItem(quantity: 2));

    final subtotal = container.read(cartSubtotalProvider);

    expect(subtotal, 200.0);
  });

  test('cartCountProvider returns number of cart items', () {
    cartNotifier.addItem(createCartItem());

    final count = container.read(cartCountProvider);

    expect(count, 1);
  });

  test('isInCartProvider returns true if product exists', () {
    cartNotifier.addItem(createCartItem());

    final isInCart = container.read(isInCartProvider(testProduct.productName));

    expect(isInCart, true);
  });

  test('isInCartProvider returns false if product does not exist', () {
    final isInCart = container.read(isInCartProvider(testProduct.productName));

    expect(isInCart, false);
  });
}
