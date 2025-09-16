import 'package:flutter_riverpod/flutter_riverpod.dart';

class GlobalNavigationState {
  final int currentIndex;
  final List<int> indexStack;

  const GlobalNavigationState({
    this.currentIndex = 0,
    this.indexStack = const [0],
  });

  GlobalNavigationState copyWith({int? currentIndex, List<int>? indexStack}) {
    return GlobalNavigationState(
      currentIndex: currentIndex ?? this.currentIndex,
      indexStack: indexStack ?? this.indexStack,
    );
  }
}

class GlobalNavigationViewModel extends StateNotifier<GlobalNavigationState> {
  GlobalNavigationViewModel() : super(const GlobalNavigationState());

  void setIndex(int newIndex) {
    if (newIndex == state.currentIndex) return;
    final newStack = List<int>.from(state.indexStack)..add(newIndex);
    state = state.copyWith(currentIndex: newIndex, indexStack: newStack);
  }

  bool popIndexStack() {
    final newStack = List<int>.from(state.indexStack);
    if (newStack.length > 1) {
      newStack.removeLast();
      final prevIndex = newStack.last;
      state = state.copyWith(currentIndex: prevIndex, indexStack: newStack);
      return false; // we've handled the back by navigating to previous tab
    }
    return true; // nothing left to pop, allow app to exit
  }
}

final globalNavigationViewModelProvider =
    StateNotifierProvider<GlobalNavigationViewModel, GlobalNavigationState>(
      (ref) => GlobalNavigationViewModel(),
    );
