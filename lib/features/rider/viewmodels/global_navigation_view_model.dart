import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// 1. Define the State for global navigation
class GlobalNavigationState {
  final int currentIndex;
  final List<int> indexStack; // To manage navigation history for PopScope
  final bool canLeaveApp;

  const GlobalNavigationState({
    this.currentIndex = 0,
    this.indexStack = const [0], // Start with the first page
    this.canLeaveApp = false,
  });

  GlobalNavigationState copyWith({
    int? currentIndex,
    List<int>? indexStack,
    bool? canLeaveApp,
  }) {
    return GlobalNavigationState(
      currentIndex: currentIndex ?? this.currentIndex,
      indexStack: indexStack ?? this.indexStack,
      canLeaveApp: canLeaveApp ?? this.canLeaveApp,
    );
  }
}

// 2. Define the StateNotifier for global navigation logic
class GlobalNavigationViewModel extends StateNotifier<GlobalNavigationState> {
  GlobalNavigationViewModel() : super(const GlobalNavigationState());

  // Update the current index and manage the stack
  void updateIndex(int newIndex) {
    if (newIndex == state.currentIndex) return; // No change needed

    final newStack = List<int>.from(state.indexStack);
    if (newStack.contains(newIndex)) {
      // If the page is already in the stack, remove it and add it to the top
      newStack.remove(newIndex);
    }
    newStack.add(newIndex);

    state = state.copyWith(
      currentIndex: newIndex,
      indexStack: newStack,
      canLeaveApp: newStack.length <= 1, // Can leave if only one item in stack
    );
  }

  // Handle back button presses (for PopScope)
  void popIndexStack(BuildContext context) {
    final newStack = List<int>.from(state.indexStack);
    if (newStack.length > 1) {
      newStack.removeLast(); // Remove the current page
      final previousIndex = newStack.last; // Get the previous page
      state = state.copyWith(
        currentIndex: previousIndex,
        indexStack: newStack,
        canLeaveApp: newStack.length <= 1,
      );
    } else {
      // If only one page left, allow the app to exit
      state = state.copyWith(canLeaveApp: true);
      Navigator.of(context).pop(); // Perform actual pop to exit
    }
  }

  // Explicitly set whether the app can be left (used by PopScope)
  void setCanLeaveApp(bool value) {
    state = state.copyWith(canLeaveApp: value);
  }
}

// 3. Create the Riverpod provider
final globalNavigationViewModelProvider =
    StateNotifierProvider<GlobalNavigationViewModel, GlobalNavigationState>((
      ref,
    ) {
      return GlobalNavigationViewModel();
    });
