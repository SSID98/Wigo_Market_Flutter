import 'package:flutter_riverpod/flutter_riverpod.dart';

final expandedStatusIdProvider = StateProvider<String?>((ref) => null);
final submenuOpenProvider = StateProvider<bool>((ref) => false);
final mobileFilterExpansionProvider = StateProvider<String?>((ref) => null);
