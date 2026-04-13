import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wigo_flutter/features/seller/models/multiple_products_state.dart';
import 'package:wigo_flutter/shared/widgets/custom_button.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/utils/helper_methods.dart';
import '../../../viewmodels/mulitple_products_viewmodel.dart';

Future<void> showColorPalette({
  required BuildContext context,
  required WidgetRef ref,
  required bool isWeb,
  required Function(String hex) onColorPicked,
}) async {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (dialogContext) {
      Color tempColor = AppColors.primaryDarkGreen;
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        backgroundColor: AppColors.backgroundWhite,
        titlePadding: EdgeInsets.only(top: 16, left: 16),
        insetPadding: EdgeInsets.symmetric(horizontal: 16),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Pick a Color",
              style: GoogleFonts.hind(
                fontSize: 22,
                fontWeight: FontWeight.w500,
                color: AppColors.textBlackGrey,
              ),
            ),
            IconButton(
              padding: EdgeInsets.only(right: isWeb ? 0 : 25),
              icon: const Icon(Icons.close),
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
            ),
          ],
        ),
        contentPadding: EdgeInsets.only(left: 16, right: 16, bottom: 40),
        content: SingleChildScrollView(
          child: ColorPicker(
            pickerColor: AppColors.primaryDarkGreen,
            onColorChanged: (color) => tempColor = color,
          ),
        ),
        actions: [
          CustomButton(
            text: "Cancel",
            fontSize: 16,
            fontWeight: FontWeight.w500,
            onPressed: () => Navigator.of(dialogContext).pop(),
            height: 40,
            borderColor: AppColors.primaryDarkGreen,
            buttonColor: Colors.transparent,
            textColor: AppColors.textVidaLocaGreen,
          ),
          const SizedBox(width: 5),
          CustomButton(
            text: "Select Color",
            fontSize: 16,
            fontWeight: FontWeight.w500,
            height: 40,
            elevation: 1,
            onPressed: () {
              onColorPicked;
              final hex =
                  '#${tempColor.toARGB32().toRadixString(16).padLeft(8, '0').substring(2).toUpperCase()}';
              onColorPicked(hex);
              Navigator.of(dialogContext).pop(); // Close dialog
            },
          ),
        ],
      );
    },
  );
}

Future<void> showEditVariantDialog(
  BuildContext context,
  WidgetRef ref,
  int index,
  bool isWeb,
) async {
  final variant = ref.read(multipleProductsProvider).variants[index];
  String localColorName = variant.colorName;
  String localColorHex = variant.colorHex;
  String localSize = variant.size;
  final priceController = TextEditingController(text: variant.price);
  final stockController = TextEditingController(text: variant.stock);
  final skuController = TextEditingController(text: variant.sku);
  final sizeController = TextEditingController(text: variant.size);
  final state = ref.watch(multipleProductsProvider);
  bool localIsCustomSize = false;
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (dialogContext) => StatefulBuilder(
      builder: (dialogContext, setDialogState) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          backgroundColor: AppColors.backgroundWhite,
          titlePadding: EdgeInsets.only(top: 16, left: 16),
          insetPadding: EdgeInsets.symmetric(horizontal: 16),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Enter the new information for this Variant",
                style: GoogleFonts.hind(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textBlackGrey,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.pop(dialogContext),
              ),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              children: [
                //color
                MenuAnchor(
                  builder: (context, controller, child) {
                    return GestureDetector(
                      onTap: () => controller.isOpen
                          ? controller.close()
                          : controller.open(),
                      child: AbsorbPointer(
                        child: _dialogRow(
                          label: "Color",
                          value: localColorName,
                          state: state,
                          colorPreview: Container(
                            width: 20,
                            height: 20,
                            decoration: BoxDecoration(
                              color: Color(
                                int.parse(
                                  localColorHex.replaceFirst('#', '0xFF'),
                                ),
                              ),
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                  style: anchorMenuStyle(),
                  menuChildren: [
                    colorVariant(
                      ref: ref,
                      context: context,
                      isWeb: isWeb,
                      onSelect: (name, hex) {
                        //Update the LOCAL dialog state
                        setDialogState(() {
                          localColorName = name;
                          localColorHex = hex;
                        });
                      },
                    ),
                  ],
                ),

                //size
                if (!localIsCustomSize) ...[
                  MenuAnchor(
                    builder: (context, controller, child) {
                      return GestureDetector(
                        onTap: () => controller.isOpen
                            ? controller.close()
                            : controller.open(),
                        child: AbsorbPointer(
                          child: _dialogRow(
                            label: "Size",
                            value: localSize,
                            state: state,
                          ),
                        ),
                      );
                    },
                    style: anchorMenuStyle(),
                    menuChildren: [
                      sizeVariant(
                        ref: ref,
                        onSelect: (size) =>
                            setDialogState(() => localSize = size),
                        onCustomSize: () =>
                            setDialogState(() => localIsCustomSize = true),
                      ),
                    ],
                  ),
                ] else ...[
                  _dialogInputRow("Custom Size", sizeController),
                ],
                _dialogInputRow("Price (₦)", priceController),
                _dialogInputRow("Stock Qty", stockController),
                _dialogInputRow("SKU", skuController),

                const SizedBox(height: 20),
                CustomButton(
                  text: "Submit",
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  height: 48,
                  width: double.infinity,
                  onPressed: () {
                    final finalSize = localIsCustomSize
                        ? sizeController.text
                        : localSize;
                    final updated = variant.copyWith(
                      price: priceController.text,
                      stock: stockController.text,
                      sku: skuController.text,
                      colorName: localColorName,
                      colorHex: localColorHex,
                      size: finalSize,
                      isSelected: false,
                    );
                    ref
                        .read(multipleProductsProvider.notifier)
                        .updateVariant(index, updated);
                    Navigator.pop(dialogContext);
                  },
                ),
              ],
            ),
          ),
        );
      },
    ),
  );
}

Widget _dialogRow({
  required String label,
  required String value,
  Widget? colorPreview,
  required MultipleProductsState state,
}) {
  return IntrinsicHeight(
    child: Container(
      height: 49,
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.borderColor),
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: double.infinity,
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.backgroundLight,
                border: Border(right: BorderSide(color: AppColors.borderColor)),
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 15.0),
                child: Align(
                  alignment: AlignmentGeometry.centerStart,
                  child: Text(
                    label,
                    style: GoogleFonts.hind(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textBlackGrey,
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Row(
              children: [
                if (colorPreview != null) ...[colorPreview, SizedBox(width: 8)],
                Text(
                  value,
                  style: GoogleFonts.hind(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textBodyText,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

Widget _dialogInputRow(String label, TextEditingController controller) {
  return IntrinsicHeight(
    child: Container(
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.borderColor),
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: double.infinity,
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.backgroundLight,
                border: Border(right: BorderSide(color: AppColors.borderColor)),
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 15.0),
                child: Align(
                  alignment: AlignmentGeometry.centerStart,
                  child: Text(
                    label,
                    style: GoogleFonts.hind(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textBlackGrey,
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: TextField(
              controller: controller,
              decoration: const InputDecoration(border: InputBorder.none),
            ),
          ),
        ],
      ),
    ),
  );
}

Widget sizeVariant({
  required WidgetRef ref,
  required Function(String size) onSelect,
  required VoidCallback onCustomSize,
}) {
  final List<String> defaultSizes = [
    "Small",
    "Medium",
    "Large",
    "Extra Large",
    "XXL",
  ];
  return Column(
    children: [
      ...defaultSizes.map(
        (size) => MenuItemButton(
          onPressed: () => onSelect(size),
          // onPressed: () => vm.updateSelectedSize(size),
          child: Text(
            size,
            style: GoogleFonts.hind(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: AppColors.textBlackGrey,
            ),
          ),
        ),
      ),
      MenuItemButton(
        onPressed: onCustomSize,
        child: Row(
          children: [
            Text(
              "Custom Size",
              style: GoogleFonts.hind(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: AppColors.textBlackGrey,
              ),
            ),
            const SizedBox(width: 8),
            Icon(
              Icons.keyboard_arrow_right_rounded,
              color: AppColors.textIconGrey,
            ),
          ],
        ),
      ),
    ],
  );
}

Widget colorVariant({
  required WidgetRef ref,
  required BuildContext context,
  required bool isWeb,
  required Function(String name, String hex) onSelect,
}) {
  final Map<String, String> defaultColors = {
    "Black": "#000000",
    "White": "#FFFFFF",
    "Red": "#FF0000",
    "Blue": "#0000FF",
    "Green": "#008000",
    "Grey": "#808080",
    "Pink": "#FFE91E63",
    "Yellow": "#FFFFEB3B",
    "Purple": "#FF9C27B0",
  };
  return Column(
    children: [
      ...defaultColors.entries.map(
        (entry) => MenuItemButton(
          onPressed: () => onSelect(entry.key, entry.value),
          child: Row(
            children: [
              Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  color: Color(
                    int.parse(entry.value.replaceFirst('#', '0xFF')),
                  ),
                  border: Border.all(
                    color: AppColors.borderColor.withValues(alpha: 0.5),
                  ),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 10),
              Text(
                entry.key,
                style: GoogleFonts.hind(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textBlackGrey,
                ),
              ),
            ],
          ),
        ),
      ),
      MenuItemButton(
        onPressed: () => showColorPalette(
          context: context,
          ref: ref,
          isWeb: isWeb,
          onColorPicked: (hex) {
            onSelect("Custom", hex);
          },
        ),
        child: Row(
          children: [
            Text(
              "Add Custom Color",
              style: GoogleFonts.hind(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: AppColors.textBlackGrey,
              ),
            ),
            SizedBox(width: 10),
            Icon(
              Icons.keyboard_arrow_right_rounded,
              color: AppColors.textIconGrey,
            ),
          ],
        ),
      ),
    ],
  );
}
