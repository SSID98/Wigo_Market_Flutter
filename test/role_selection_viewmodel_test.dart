import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wigo_flutter/core/providers/role_selection_provider.dart';
import 'package:wigo_flutter/shared/models/user_role.dart';
import 'package:wigo_flutter/shared/viewmodels/role_selection_view_model.dart';

// --- MOCKS ---
class MockRef extends Mock implements Ref {}

// Mocks for BuildContext and StateController (used in ref.read(provider.notifier))
class MockBuildContext extends Mock implements BuildContext {}

class MockStateController<T> extends Mock implements StateController<T> {}

// Assuming these imports are correctly set up in your project
// -----------------

void main() {
  // 1. Register fallback values for methods that take complex, non-primitive types.
  setUpAll(() {
    registerFallbackValue(UserRole.rider);
  });

  group('RoleSelectionViewModel', () {
    late RoleSelectionViewModel viewModel;
    late MockRef mockRef;
    late MockStateController<UserRole?> mockUserRoleController;

    setUp(() {
      mockRef = MockRef();
      mockUserRoleController = MockStateController<UserRole?>();

      // Stub Ref: Whenever 'userRoleProvider.notifier' is read, return the mock controller.
      when(
        () => mockRef.read(userRoleProvider.notifier),
      ).thenReturn(mockUserRoleController);

      // Create the ViewModel
      viewModel = RoleSelectionViewModel(mockRef);
    });

    // --- Test: selectRole ---
    test('selectRole updates the userRoleProvider state correctly', () async {
      const selectedRole = UserRole.buyer;

      viewModel.selectRole(selectedRole);

      // Verify that the state was set on the mocked controller with the selected role
      verify(() => mockUserRoleController.state = selectedRole).called(1);
    });

    // --- Test: confirmSelection (No role selected) ---
    test('confirmSelection does nothing if no role is selected', () async {
      final mockContext = MockBuildContext();

      // Stub Ref: Return null when 'userRoleProvider' is read
      when(() => mockRef.read(userRoleProvider)).thenReturn(null);

      await viewModel.confirmSelection(mockContext);

      // Verify that context.mounted was *never* checked (it should exit early)
      verifyNever(() => mockContext.mounted);
    });

    // --- Test: confirmSelection (Role selected, Not Mounted) ---
    test(
      'confirmSelection exits after delay if role is selected but context is NOT mounted',
      () async {
        final mockContext = MockBuildContext();
        const selectedRole = UserRole.rider;

        // Stub Ref: Return a selected role
        when(() => mockRef.read(userRoleProvider)).thenReturn(selectedRole);

        // Stub Context: Return false for the mounted check after the delay
        when(() => mockContext.mounted).thenReturn(false);

        await viewModel.confirmSelection(mockContext);

        // Verify that the logic flow ran correctly: the mounted check was performed.
        verify(() => mockContext.mounted).called(1);

        // Verify that no navigation was attempted (since context.mounted was false)
        // (Verification of push would be here if it was mockable)
      },
    );
  });
}
