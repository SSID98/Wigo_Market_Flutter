import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wigo_flutter/core/local/local_user_controller.dart';
import 'package:wigo_flutter/main.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Buyer can add product to cart and update quantity', (
    WidgetTester tester,
  ) async {
    // Launch app
    final prefs = await SharedPreferences.getInstance();
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          localUserControllerProvider.overrideWithValue(
            LocalUserController(prefs),
          ),
        ],
        child: WigoApp(),
      ),
    );
    await tester.pumpAndSettle();

    // ---- ASSUMPTIONS ----
    // 1. You have a product tile with text "Nintendo Gaming Console"
    // 2. Add-to-cart button has an Icon(Icons.add_shopping_cart)
    // 3. Cart icon navigates to cart screen

    // Find product
    expect(find.text('Nintendo Gaming Console'), findsOneWidget);

    // Tap add to cart
    await tester.tap(find.byKey(const Key('cart_add_button')));
    await tester.pumpAndSettle();

    // Open cart
    await tester.tap(find.byKey(const Key('cart_button')));
    await tester.pumpAndSettle();

    // Product appears in cart
    expect(find.text('Nintendo Gaming Console'), findsOneWidget);
    expect(find.text('1'), findsOneWidget);

    // Increase quantity
    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();

    // Quantity updated
    expect(find.text('2'), findsOneWidget);

    // Optional: verify subtotal text exists
    expect(find.textContaining('#'), findsWidgets);
  });
}
