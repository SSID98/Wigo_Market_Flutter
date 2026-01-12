import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/location_data.dart';

class LocationState {
  final String selectedState;
  final String selectedCity;
  final List<String> availableCities;

  LocationState({
    this.selectedState = '',
    this.selectedCity = '',
    this.availableCities = const [],
  });

  LocationState copyWith({
    String? selectedState,
    String? selectedCity,
    List<String>? availableCities,
    bool clearCity = false,
  }) {
    return LocationState(
      selectedState: selectedState ?? this.selectedState,
      selectedCity: clearCity ? '' : (selectedCity ?? this.selectedCity),
      availableCities: availableCities ?? this.availableCities,
    );
  }
}

class LocationNotifier extends StateNotifier<LocationState> {
  LocationNotifier() : super(LocationState());

  void setStateValue(String? value) {
    if (value != null) {
      final newFilteredCities = nigeriaStatesAndCities[value] ?? [];
      state = state.copyWith(
        selectedState: value,
        availableCities: newFilteredCities,
        clearCity: true,
      );
    } else {
      state = state.copyWith(
        selectedState: '',
        availableCities: [],
        clearCity: true,
      );
    }
  }

  void updateResidentialState(String value) =>
      state = state.copyWith(selectedState: value, selectedCity: '');

  void updateCity(String? value) =>
      state = state.copyWith(selectedCity: value ?? '');
}

final locationProvider = StateNotifierProvider<LocationNotifier, LocationState>(
  (ref) => LocationNotifier(),
);
