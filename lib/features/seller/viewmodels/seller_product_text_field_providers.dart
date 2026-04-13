import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wigo_flutter/features/seller/viewmodels/single_product_viewmodel.dart';

import 'mulitple_products_viewmodel.dart';

final singleProductTextControllersProvider =
    Provider.autoDispose<Map<String, TextEditingController>>((ref) {
      final state = ref.read(singleProductProvider);

      return {
        "productName": TextEditingController(text: state.productName),
        "productId": TextEditingController(text: state.productId),
        "oS": TextEditingController(text: state.oS ?? ''),
        "processorType": TextEditingController(text: state.processorType ?? ''),
        "rom": TextEditingController(text: state.rom ?? ''),
        "displayResolution": TextEditingController(
          text: state.displayResolution ?? '',
        ),
        "screenSize": TextEditingController(text: state.screenSize ?? ''),
        "dimensions": TextEditingController(text: state.dimensions ?? ''),
        "graphicsCard": TextEditingController(text: state.graphicsCard ?? ''),
        "battery": TextEditingController(text: state.battery ?? ''),
        "stockQuantity": TextEditingController(text: state.stockQuantity),
        "sellingPrice": TextEditingController(text: state.sellingPrice),
        "productDescription": TextEditingController(
          text: state.productDescription,
        ),
      };
    });

final multipleProductTextControllersProvider =
    Provider.autoDispose<Map<String, TextEditingController>>((ref) {
      final state = ref.read(multipleProductsProvider);

      return {
        "productName": TextEditingController(text: state.productName),
        "productId": TextEditingController(text: state.productId),
        "stockQuantity": TextEditingController(text: state.stockQuantity),
        "sellingPrice": TextEditingController(text: state.sellingPrice),
        "productDescription": TextEditingController(
          text: state.productDescription,
        ),
      };
    });
