import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RiderAccountSetupViewmodel extends ChangeNotifier {
  final formKey = GlobalKey<FormState>();
}

final riderAccountSetupViewmodelProvider =
    ChangeNotifierProvider<RiderAccountSetupViewmodel>((ref) {
      return RiderAccountSetupViewmodel();
    });
