import 'package:flutter_riverpod/flutter_riverpod.dart';

final expandedIdProvider = StateProvider<String?>((ref) => null);
final submenuOpenProvider = StateProvider<bool>((ref) => false);
