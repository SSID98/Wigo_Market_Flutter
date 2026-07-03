import 'package:flutter_riverpod/legacy.dart';

final expandedIdProvider = StateProvider<String?>((ref) => null);
final submenuOpenProvider = StateProvider<bool>((ref) => false);
