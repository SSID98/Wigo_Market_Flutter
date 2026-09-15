import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:wigo_flutter/core/utils/context_extensions.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../gen/assets.gen.dart';
import '../../../../../shared/widgets/custom_button.dart';
import '../../../../../shared/widgets/custom_text_field.dart';
import '../../../../rider/viewmodels/seller_product_detail_viewmodel.dart';

class EditProductScreen extends HookConsumerWidget {
  final String productId;

  const EditProductScreen({super.key, required this.productId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(sellerProductDetailProvider(productId));
    final product = state.product;
    final isWeb = context.isWeb;
    final initialized = useRef(false);

    final titleCtrl = useTextEditingController();
    final descCtrl = useTextEditingController();
    final brandCtrl = useTextEditingController();
    final skuCtrl = useTextEditingController();
    final priceCtrl = useTextEditingController();
    final quantityCtrl = useTextEditingController();

    if (product != null && !initialized.value) {
      titleCtrl.text = product.title;
      descCtrl.text = product.description ?? '';
      brandCtrl.text = product.brand ?? '';
      skuCtrl.text = product.sku ?? '';
      priceCtrl.text = product.isSingle ? product.price.toStringAsFixed(0) : '';
      quantityCtrl.text = product.isSingle ? product.stock.toString() : '';

      initialized.value = true;
    }

    Future<void> save() async {
      if (product == null) return;

      final payload = <String, dynamic>{
        'title': titleCtrl.text.trim(),
        if (descCtrl.text.trim().isNotEmpty)
          'description': descCtrl.text.trim(),
        if (brandCtrl.text.trim().isNotEmpty) 'brand': brandCtrl.text.trim(),
        'sku': skuCtrl.text.trim().isEmpty ? null : skuCtrl.text.trim(),
      };

      if (product.isSingle) {
        final price = double.tryParse(priceCtrl.text.trim());
        final qty = int.tryParse(quantityCtrl.text.trim());
        if (price != null) payload['price'] = price;
        if (qty != null) payload['quantity'] = qty;
      }

      final vm = ref.read(sellerProductDetailProvider(productId).notifier);
      final success = await vm.saveEdits(context, payload);

      if (!context.mounted) return;
      if (success) {
        Navigator.of(context).pop();
      }
    }

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        centerTitle: true,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: IconButton(
            icon: isWeb
                ? AppAssets.icons.squareArrowBack.svg()
                : AppAssets.icons.addproductBackArrow.svg(),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        title: Text(
          'Edit Product',
          style: GoogleFonts.hind(
            color: AppColors.textBlackGrey,
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
      ),
      body: product == null
          ? const Center(child: CircularProgressIndicator())
          : Stack(
              children: [
                SingleChildScrollView(
                  padding: EdgeInsets.symmetric(
                    horizontal: isWeb ? 24 : 16,
                    vertical: 16,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _SectionCard(
                        title: 'Basic Information',
                        child: Column(
                          children: [
                            CustomTextField(
                              label: 'Product Title',
                              hintText: 'e.g., Wireless Bluetooth Speaker',
                              controller: titleCtrl,
                              onChanged: (_) {},
                              contentPadding: const EdgeInsets.only(left: 10),
                            ),
                            const SizedBox(height: 16),
                            CustomTextField(
                              label: 'Brand (optional)',
                              hintText: 'e.g., Sony',
                              controller: brandCtrl,
                              onChanged: (_) {},
                              contentPadding: const EdgeInsets.only(left: 10),
                            ),
                            const SizedBox(height: 16),
                            if (product.sku != null)
                              CustomTextField(
                                label: 'SKU (optional)',
                                hintText: 'Unique code — leave blank to clear',
                                controller: skuCtrl,
                                onChanged: (_) {},
                                contentPadding: const EdgeInsets.only(left: 10),
                              ),
                            const SizedBox(height: 16),
                            CustomTextField(
                              label: 'Description',
                              hintText: 'Describe your product in detail',
                              controller: descCtrl,
                              onChanged: (_) {},
                              contentPadding: const EdgeInsets.all(10),
                              minLines: 5,
                              maxLines: 10,
                            ),
                          ],
                        ),
                      ),
                      if (product.isSingle) ...[
                        const SizedBox(height: 16),
                        _SectionCard(
                          title: 'Pricing & Stock',
                          child: Column(
                            children: [
                              CustomTextField(
                                label: 'Selling Price (₦)',
                                hintText: 'e.g., 4500',
                                controller: priceCtrl,
                                onChanged: (_) {},
                                contentPadding: const EdgeInsets.only(left: 10),
                                keyboardType: TextInputType.number,
                              ),
                              const SizedBox(height: 16),
                              CustomTextField(
                                label: 'Stock Quantity',
                                hintText: 'e.g., 20',
                                controller: quantityCtrl,
                                onChanged: (_) {},
                                contentPadding: const EdgeInsets.only(left: 10),
                                keyboardType: TextInputType.number,
                              ),
                            ],
                          ),
                        ),
                      ],
                      if (product.isVariable)
                        Padding(
                          padding: const EdgeInsets.only(top: 16),
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: AppColors.backgroundLight,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: AppColors.borderColor),
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.info_outline,
                                  size: 18,
                                  color: AppColors.textBodyText,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    'To edit pricing and stock for a variable product, use the "Edit Variant" button in the Product Detail screen.',
                                    style: GoogleFonts.hind(
                                      fontSize: 13,
                                      color: AppColors.textBodyText,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      const SizedBox(height: 80),
                    ],
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    color: AppColors.backgroundWhite,
                    padding: const EdgeInsets.all(16),
                    child: CustomButton(
                      text: state.isUpdating ? 'Saving…' : 'Save Changes',
                      onPressed: state.isUpdating ? null : save,
                      height: 48,
                      width: double.infinity,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final String title;
  final Widget child;

  const _SectionCard({required this.title, required this.child});

  @override
  Widget build(BuildContext context) => Card(
    elevation: 0,
    color: AppColors.backgroundWhite,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.hind(
              fontWeight: FontWeight.w700,
              fontSize: 15,
              color: AppColors.textBlackGrey,
            ),
          ),
          const Divider(height: 20),
          child,
        ],
      ),
    ),
  );
}
