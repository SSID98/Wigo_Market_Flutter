import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wigo_flutter/features/seller/services/seller_api_service.dart';

import '../models/category_node.dart';

final categoriesProvider = FutureProvider<List<CategoryNode>>((ref) async {
  final api = ref.read(sellerApiServiceProvider);
  final result = await api.getCategories();

  debugPrint('=== CATEGORIES API ===');
  debugPrint('isSuccess: ${result.isSuccess}');
  debugPrint('data type: ${result.data?.runtimeType}');
  debugPrint('data value: ${result.data}');
  debugPrint('error: ${result.errorDescription}');

  if (!result.isSuccess) {
    throw Exception(
      result.errorDescription?.toString() ??
          'Categories API returned failure. Check auth token and endpoint.',
    );
  }

  if (result.data == null) {
    throw Exception('Categories API returned null data.');
  }

  try {
    final raw = result.data as Map<String, dynamic>;

    List<dynamic> list;
    if (raw.containsKey('categories')) {
      // Format A: result.data is already the inner data object
      // {"categories": [...]}
      list = raw['categories'] as List<dynamic>? ?? [];
    } else if (raw.containsKey('data')) {
      // Format B: result.data is the full response body
      // {"success": true, "data": {"categories": [...]}}
      final inner = raw['data'] as Map<String, dynamic>? ?? {};
      list = inner['categories'] as List<dynamic>? ?? [];
    } else {
      debugPrint('Unexpected response shape: $raw');
      throw Exception(
        'Unexpected categories response shape. Keys found: ${raw.keys.toList()}',
      );
    }

    debugPrint('Parsed ${list.length} categories');

    return list
        .map((e) => CategoryNode.fromJson(e as Map<String, dynamic>))
        .toList();
  } catch (e) {
    debugPrint('Categories parse error: $e');
    rethrow;
  }
});

List<CategoryNode> filterCategoryNodes(List<CategoryNode> all, String query) {
  if (query.isEmpty) return all;
  final lower = query.toLowerCase();
  final results = <CategoryNode>[];

  for (final cat in all) {
    if (cat.name.toLowerCase().contains(lower)) {
      results.add(cat);
    } else {
      final matchingChildren = cat.children
          .where((sub) => sub.name.toLowerCase().contains(lower))
          .toList();
      if (matchingChildren.isNotEmpty) {
        results.add(
          CategoryNode(
            id: cat.id,
            name: cat.name,
            image: cat.image,
            specSchema: cat.specSchema,
            children: matchingChildren,
          ),
        );
      }
    }
  }
  return results;
}
