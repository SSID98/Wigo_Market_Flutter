// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:wigo_flutter/features/seller/presentation/views/single_product_version_view/laptops_desktop_specs_screen.dart';
// import 'package:wigo_flutter/features/seller/presentation/views/single_product_version_view/mobile_specs_screen.dart';
// import 'package:wigo_flutter/features/seller/presentation/views/single_product_version_view/single_product_info_screen.dart';
// import 'package:wigo_flutter/features/seller/presentation/views/single_product_version_view/single_product_upload_screen.dart';
//
// class SingleProductFlowEntry extends ConsumerStatefulWidget {
//   const SingleProductFlowEntry({super.key});
//
//   @override
//   ConsumerState<SingleProductFlowEntry> createState() =>
//       _SingleProductFlowEntryState();
// }
//
// class _SingleProductFlowEntryState
//     extends ConsumerState<SingleProductFlowEntry> {
//   int currentStep = 0;
//
//   @override
//   Widget build(BuildContext context) {
//     return IndexedStack(
//       index: currentStep,
//       children: const [
//         SingleProductInfoScreen(),
//         SingleProductUploadScreen(),
//         MobileSpecsScreen(),
//         LaptopsAndDesktopSpecsScreen(),
//       ],
//     );
//   }
// }
