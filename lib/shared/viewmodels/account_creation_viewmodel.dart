import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/location_data.dart';

class AccountCreationViewModel extends ChangeNotifier {
  String? selectedState;
  String? selectedCity;
  List<String> filteredCities = [];

  void setStateValue(String? value) {
    if (value != null) {
      selectedState = value;
      filteredCities = nigeriaStatesAndCities[value] ?? [];
      selectedCity = null;
    } else {
      selectedState = null;
      filteredCities = [];
    }
    selectedCity = null;
    notifyListeners();
  }

  void setCityValue(String? value) {
    selectedCity = value;
    notifyListeners();
  }
}

final riderAccountViewModelProvider = ChangeNotifierProvider(
  (ref) => AccountCreationViewModel(),
);
