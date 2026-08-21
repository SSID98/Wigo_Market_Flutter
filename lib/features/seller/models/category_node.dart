class CategoryNode {
  final String id;
  final String name;
  final String? image;
  final String? specSchema;
  final List<CategoryNode> children;

  const CategoryNode({
    required this.id,
    required this.name,
    this.image,
    this.specSchema,
    this.children = const [],
  });

  bool get hasChildren => children.isNotEmpty;

  factory CategoryNode.fromJson(Map<String, dynamic> json) => CategoryNode(
    id: json['_id']?.toString() ?? '',
    name: json['name']?.toString() ?? '',
    image: json['image'] as String?,
    specSchema: json['specSchema'] as String?,
    children: (json['children'] as List<dynamic>? ?? [])
        .map((c) => CategoryNode.fromJson(c as Map<String, dynamic>))
        .toList(),
  );
}
