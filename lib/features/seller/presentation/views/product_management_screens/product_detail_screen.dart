import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:video_player/video_player.dart';
import 'package:wigo_flutter/features/rider/presentation/widgets/switch.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/utils/context_extensions.dart';
import '../../../../../core/utils/helper_methods_classes.dart';
import '../../../../../gen/assets.gen.dart';
import '../../../../../shared/widgets/custom_button.dart';
import '../../../../../shared/widgets/custom_loading_overlay.dart';
import '../../../../../shared/widgets/shimmer_widget.dart';
import '../../../../rider/viewmodels/seller_product_detail_viewmodel.dart';
import '../../../models/seller_product_detail_state.dart';
import '../../../models/seller_product_model.dart';
import '../../../models/seller_product_task_state.dart';
import '../../widgets/product_status_container.dart';
import '../single_product_version_view/edit_product_screen.dart';

class ProductDetailScreen extends ConsumerWidget {
  final String productId;

  const ProductDetailScreen({super.key, required this.productId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isWeb = context.isWeb;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Row(
            children: [
              IconButton(
                icon: isWeb
                    ? AppAssets.icons.squareArrowBack.svg()
                    : AppAssets.icons.addproductBackArrow.svg(),
                onPressed: () => Navigator.of(context).pop(),
              ),
              Spacer(),
              Padding(
                padding: const EdgeInsets.only(right: 140.0),
                child: Text(
                  'Product Detail',
                  style: GoogleFonts.hind(
                    color: AppColors.textBlackGrey,
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                  ),
                ),
              ),
            ],
          ),
          Expanded(
            child: _buildBody(ref: ref, isWeb: isWeb, context: context),
          ),
        ],
      ),
    );
  }

  Widget _buildBody({
    required WidgetRef ref,
    required bool isWeb,
    required BuildContext context,
  }) {
    final state = ref.watch(sellerProductDetailProvider(productId));
    final vm = ref.read(sellerProductDetailProvider(productId).notifier);
    return RefreshIndicator(
      onRefresh: vm.refresh,
      color: AppColors.primaryDarkGreen,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.backgroundWhite,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Column(
            children: [
              if (state.status == ProductDetailStatus.loading)
                Expanded(child: _ProductDetailShimmer())
              else if (state.status == ProductDetailStatus.error)
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        state.errorMessage ?? 'Something went wrong',
                        style: GoogleFonts.hind(color: AppColors.textRed),
                      ),
                      const SizedBox(height: 16),
                      TextButton.icon(
                        onPressed: vm.refresh,
                        icon: const Icon(Icons.refresh),
                        label: const Text('Retry'),
                      ),
                    ],
                  ),
                )
              else if (state.product != null)
                Expanded(
                  child: Stack(
                    children: [
                      CustomScrollView(
                        slivers: [
                          SliverPadding(
                            padding: EdgeInsets.symmetric(vertical: 16),
                            sliver: SliverList(
                              delegate: SliverChildListDelegate([
                                _buildMobileHeader(
                                  context,
                                  state.product,
                                  vm,
                                  ref,
                                  isWeb,
                                ),
                                const SizedBox(height: 16),
                                _ProductOverviewCard(
                                  product: state.product!,
                                  isWeb: isWeb,
                                ),
                                const SizedBox(height: 16),
                                _MediaGallery(
                                  product: state.product!,
                                  isWeb: isWeb,
                                ),
                                const SizedBox(height: 16),
                                _ProductDescriptionCard(
                                  product: state.product!,
                                  isWeb: isWeb,
                                ),
                                const SizedBox(height: 16),
                                _PricingInventoryCard(
                                  product: state.product!,
                                  state: state,
                                  vm: vm,
                                  isWeb: isWeb,
                                  context: context,
                                  ref: ref,
                                ),
                                const SizedBox(height: 16),
                                _RatingReviewsCard(
                                  product: state.product!,
                                  state: state,
                                  vm: vm,
                                  isWeb: isWeb,
                                ),
                                const SizedBox(height: 80),
                              ]),
                            ),
                          ),
                        ],
                      ),
                      if (state.isUpdating)
                        LoadingOverlayWidget(visible: state.isUpdating),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMobileHeader(
    BuildContext context,
    SellerProduct? product,
    SellerProductDetailViewModel vm,
    WidgetRef ref,
    bool isWeb,
  ) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        image: DecorationImage(
          opacity: 0.4,
          image: AssetImage(AppAssets.images.productDetailBg.path),
          fit: BoxFit.cover,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 20, 0, 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: product == null
              ? []
              : [
                  Text(
                    product.title,
                    style: GoogleFonts.hind(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textDarkDarkerGreen,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      _CustomButton(
                        buttonColor: AppColors.primaryDarkGreen,
                        icon: AppAssets.icons.pencilEdit.svg(),
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                EditProductScreen(productId: product.id),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      _CustomButton(
                        buttonColor: AppColors.accentRed,
                        icon: AppAssets.icons.delete.svg(
                          colorFilter: ColorFilter.mode(
                            AppColors.accentWhite,
                            BlendMode.srcIn,
                          ),
                        ),
                        onTap: () => _confirmDelete(context, vm),
                      ),
                      const SizedBox(width: 12),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          border: Border.all(color: AppColors.primaryDarkGreen),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              AppAssets.icons.hideProduct.svg(),
                              const SizedBox(width: 4),
                              Text(
                                "Hide Product",
                                style: GoogleFonts.hind(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.textBlackGrey,
                                ),
                              ),
                              const SizedBox(width: 10),
                              CustomSwitch(
                                height: 22,
                                thumbDiameter: 16,
                                width: 42,
                                activeColor: AppColors.primaryDarkGreen,
                                borderColor: product.status == 'hidden'
                                    ? Colors.transparent
                                    : AppColors.borderColor,
                                thumbColour: product.status == 'hidden'
                                    ? AppColors.accentWhite
                                    : AppColors.borderColor1,
                                inactiveColor: AppColors.accentWhite,
                                value: product.status == 'hidden',
                                onChanged: (newValue) async {
                                  await vm.toggleHide(context);
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
        ),
      ),
    );
  }

  Future<void> _confirmDelete(
    BuildContext context,
    SellerProductDetailViewModel vm,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(
          'Delete Product',
          style: GoogleFonts.hind(fontWeight: FontWeight.w600),
        ),
        content: Text(
          'This permanently deletes the product and all its reviews. This cannot be undone.',
          style: GoogleFonts.hind(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(
              'Delete',
              style: GoogleFonts.hind(color: AppColors.accentRed),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      final success = await vm.delete(context);
      if (success && context.mounted) Navigator.of(context).pop();
    }
  }
}

class _CustomButton extends StatelessWidget {
  const _CustomButton({
    required this.buttonColor,
    required this.icon,
    required this.onTap,
  });

  final Color buttonColor;
  final Widget icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: buttonColor,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Padding(padding: const EdgeInsets.all(10.0), child: icon),
      ),
    );
  }
}

class _MediaGallery extends StatefulWidget {
  final SellerProduct product;
  final bool isWeb;

  const _MediaGallery({required this.product, required this.isWeb});

  @override
  State<_MediaGallery> createState() => _MediaGalleryState();
}

class _MediaGalleryState extends State<_MediaGallery> {
  int _selectedIndex = 0;
  VideoPlayerController? _videoController;
  bool _showingVideo = false;

  @override
  void dispose() {
    _videoController?.dispose();
    super.dispose();
  }

  void _selectImage(int index) {
    _videoController?.pause();
    setState(() {
      _selectedIndex = index;
      _showingVideo = false;
    });
  }

  Future<void> _selectVideo() async {
    final url = widget.product.video;
    if (url == null) return;
    if (_videoController == null) {
      _videoController = VideoPlayerController.networkUrl(Uri.parse(url));
      await _videoController!.initialize();
    }
    setState(() => _showingVideo = true);
    _videoController!.play();
  }

  @override
  Widget build(BuildContext context) {
    final images = widget.product.images;
    final hasVideo = widget.product.video != null;
    final allMedia = [...images, if (hasVideo) '__video__'];
    final mainHeight = widget.isWeb ? 300.0 : 260.0;

    return Column(
      children: [
        SizedBox(
          height: mainHeight,
          width: double.infinity,
          child: _showingVideo && _videoController != null
              ? Stack(
                  fit: StackFit.expand,
                  children: [
                    AspectRatio(
                      aspectRatio: _videoController!.value.aspectRatio,
                      child: VideoPlayer(_videoController!),
                    ),
                    Positioned(
                      bottom: 8,
                      right: 8,
                      child: IconButton(
                        icon: Icon(
                          _videoController!.value.isPlaying
                              ? Icons.pause_circle
                              : Icons.play_circle,
                          color: AppColors.backgroundWhite,
                          size: 36,
                        ),
                        onPressed: () => setState(() {
                          _videoController!.value.isPlaying
                              ? _videoController!.pause()
                              : _videoController!.play();
                        }),
                      ),
                    ),
                  ],
                )
              : images.isEmpty
              ? Container(
                  color: AppColors.backgroundLight,
                  child: const Icon(
                    Icons.image_not_supported,
                    size: 64,
                    color: AppColors.textIconGrey,
                  ),
                )
              : ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    images[_selectedIndex.clamp(0, images.length - 1)],
                    fit: BoxFit.contain,
                    errorBuilder: (_, __, ___) => Container(
                      color: AppColors.backgroundLight,
                      child: const Icon(
                        Icons.broken_image,
                        color: AppColors.textIconGrey,
                        size: 48,
                      ),
                    ),
                  ),
                ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 73,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: allMedia.length,
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemBuilder: (_, i) {
              final isVideo = allMedia[i] == '__video__';
              final isSelected = isVideo
                  ? _showingVideo
                  : (!_showingVideo && i == _selectedIndex);
              return GestureDetector(
                onTap: isVideo ? _selectVideo : () => _selectImage(i),
                child: Container(
                  width: 93,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: isSelected
                          ? AppColors.primaryDarkGreen
                          : Colors.transparent,
                      width: 1,
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: isVideo
                        ? Container(
                            color: AppColors.textBlack,
                            child: const Icon(
                              Icons.play_circle_outline,
                              color: AppColors.backgroundWhite,
                              size: 28,
                            ),
                          )
                        : Image.network(
                            allMedia[i],
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Container(
                              color: AppColors.backgroundLight,
                              child: const Icon(
                                Icons.broken_image,
                                size: 20,
                                color: AppColors.textIconGrey,
                              ),
                            ),
                          ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _ProductOverviewCard extends StatelessWidget {
  final SellerProduct product;
  final bool isWeb;

  const _ProductOverviewCard({required this.product, required this.isWeb});

  @override
  Widget build(BuildContext context) {
    final ov = product.overview;
    final dateStr = ov?.dateAdded != null
        ? DateFormat('MMMM d, yyyy').format(ov!.dateAdded!)
        : (product.createdAt != null
              ? DateFormat('MMMM d, yyyy').format(product.createdAt!)
              : '—');

    return _DetailCard(
      title: 'Product Overview',
      child: Padding(
        padding: const EdgeInsets.only(bottom: 15.0),
        child: Column(
          children: [
            _OverviewRow(
              label: 'Product Name',
              value: ov?.name ?? product.title,
            ),
            _OverviewRow(
              label: 'Product Category',
              value: ov?.categoryPath.isNotEmpty == true
                  ? ov!.categoryPath
                  : product.category?.displayPath ?? '—',
            ),
            if (ov?.sku != null || product.sku != null)
              _OverviewRow(label: 'SKU', value: ov?.sku ?? product.sku ?? '—'),
            _OverviewRow(label: 'Date Added', value: dateStr),
            _OverviewRow(
              label: 'Variant',
              value: '${ov?.variantCount ?? product.variantCount}',
              valueFontWeight: FontWeight.w600,
            ),
            _OverviewRow(
              label: 'Available for',
              value: ov?.availableForLabel ?? product.availableForLabel,
            ),
            _OverviewRow(
              label: 'Status',
              isStatus: true,
              productStatus: product.sellerProductStatus,
              value: '',
            ),
          ],
        ),
      ),
    );
  }
}

class _OverviewRow extends StatelessWidget {
  final String label;
  final String value;
  final double? labelFontSize;
  final double? valueFontSize;
  final FontWeight? valueFontWeight;
  final bool isStatus;
  final SellerProductStatus? productStatus;

  const _OverviewRow({
    required this.label,
    required this.value,
    this.isStatus = false,
    this.productStatus,
    this.labelFontSize = 14,
    this.valueFontSize = 14,
    this.valueFontWeight = FontWeight.w400,
  });

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 6),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "$label: ",
          style: GoogleFonts.hind(
            color: AppColors.textBlackGrey,
            fontSize: labelFontSize,
            fontWeight: FontWeight.w500,
          ),
        ),
        if (isStatus && productStatus != null)
          SizedBox(
            width: 75,
            child: ProductStatusContainer(productStatus: productStatus!),
          )
        else
          Expanded(
            child: Text(
              value,
              style: GoogleFonts.hind(
                color: AppColors.textBlackGrey,
                fontSize: valueFontSize,
                fontWeight: valueFontWeight,
              ),
            ),
          ),
      ],
    ),
  );
}

class _ProductDescriptionCard extends StatefulWidget {
  final SellerProduct product;
  final bool isWeb;

  const _ProductDescriptionCard({required this.product, required this.isWeb});

  @override
  State<_ProductDescriptionCard> createState() =>
      _ProductDescriptionCardState();
}

class _ProductDescriptionCardState extends State<_ProductDescriptionCard> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final desc = widget.product.description ?? '';
    final shouldTruncate = desc.length > 200 && !_expanded;

    return _DetailCard(
      title: 'Product Description',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            shouldTruncate ? '${desc.substring(0, 200)}…' : desc,
            style: GoogleFonts.hind(
              color: AppColors.textBodyText,
              fontSize: 14,
              fontWeight: FontWeight.w400,
              height: 1.6,
            ),
          ),
          if (desc.length > 200) ...[
            const SizedBox(height: 6),
            GestureDetector(
              onTap: () => setState(() => _expanded = !_expanded),
              child: Text(
                _expanded ? 'see less' : 'see more',
                style: GoogleFonts.hind(
                  color: AppColors.primaryDarkGreen,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _PricingInventoryCard extends StatelessWidget {
  final SellerProduct product;
  final SellerProductDetailState state;
  final SellerProductDetailViewModel vm;
  final bool isWeb;
  final BuildContext context;
  final WidgetRef ref;

  const _PricingInventoryCard({
    required this.product,
    required this.state,
    required this.vm,
    required this.isWeb,
    required this.context,
    required this.ref,
  });

  @override
  Widget build(BuildContext ctx) {
    final inv = product.inventory;
    final fmt = NumberFormat('#,##0', 'en_NG');

    return _DetailCard(
      title: 'Pricing & Inventory',
      trailing: product.isVariable
          ? _CustomButton(
              icon: AppAssets.icons.pencilEdit.svg(),
              onTap: () => _showEditVariantsSheet(ctx),
              buttonColor: AppColors.primaryDarkGreen,
            )
          : null,
      child: product.isVariable
          ? _buildVariableInventory(ctx, inv, fmt)
          : _buildSingleInventory(ctx, inv, fmt),
    );
  }

  Widget _buildSingleInventory(
    BuildContext ctx,
    ProductInventory? inv,
    NumberFormat fmt,
  ) {
    final price = inv?.price ?? product.price;
    final listed = inv?.listedPrice ?? product.listedPrice;
    final stock = inv?.availableStock ?? product.stock;
    final lastOrdered = inv?.lastOrderedAt;

    return Column(
      children: [
        _OverviewRow(
          label: 'Price',
          value: '₦${fmt.format(price)}',
          labelFontSize: 16,
        ),
        _OverviewRow(
          label: 'Discount Price',
          value: '₦${fmt.format(listed)}',
          labelFontSize: 16,
        ),
        _OverviewRow(
          label: 'Stock Available',
          value: '$stock units',
          labelFontSize: 16,
        ),
        _OverviewRow(
          label: 'Low Stock Alert',
          value: "ON (Threshold: 5 units)",
        ),
        _OverviewRow(
          label: 'Last Ordered',
          value: lastOrdered != null
              ? DateFormat('MMMM d, yyyy').format(lastOrdered)
              : '—',
        ),
      ],
    );
  }

  Widget _buildVariableInventory(
    BuildContext ctx,
    ProductInventory? inv,
    NumberFormat fmt,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Scrollbar(
          thumbVisibility: isWeb ? true : false,
          child: _VariantTable(inv: inv, fmt: fmt, product: product),
        ),
        const SizedBox(height: 25),
        if (inv != null) ...[
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
              side: const BorderSide(color: AppColors.borderColor, width: 1),
            ),
            elevation: 0,
            margin: EdgeInsets.zero,
            color: AppColors.backgroundWhite,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  _OverviewRow(
                    label: 'Total Stock',
                    value: '${inv.totalStock} unit',
                    valueFontSize: 16,
                    labelFontSize: 16,
                  ),
                  _OverviewRow(
                    label: 'Total Sold',
                    value: '${inv.totalSold} unit',
                    valueFontSize: 16,
                    labelFontSize: 16,
                  ),
                  _OverviewRow(
                    label: 'Available Stock',
                    value: '${inv.availableStock} unit',
                    valueFontSize: 16,
                    labelFontSize: 16,
                  ),
                  if (inv.lastOrderedAt != null)
                    _OverviewRow(
                      label: 'Last Ordered',
                      value: DateFormat(
                        'MMMM d, yyyy',
                      ).format(inv.lastOrderedAt!),
                      valueFontSize: 16,
                      labelFontSize: 16,
                    ),
                ],
              ),
            ),
          ),
        ],
      ],
    );
  }

  void _showEditVariantsSheet(BuildContext ctx) {
    showModalBottomSheet(
      context: ctx,
      isScrollControlled: true,
      backgroundColor: AppColors.backgroundWhite,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => _EditVariantsSheet(product: product, vm: vm),
    );
  }
}

class _VariantTable extends ConsumerWidget {
  const _VariantTable({
    required this.inv,
    required this.fmt,
    required this.product,
  });

  final SellerProduct product;
  final ProductInventory? inv;
  final NumberFormat fmt;

  TextStyle _getStyle({required bool isHeader, required Color color}) {
    return GoogleFonts.hind(
      fontSize: isHeader ? 16 : 14,
      fontWeight: FontWeight.w500,
      color: color,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isWeb = context.isWeb;
    final variants = inv?.variants.isNotEmpty == true
        ? inv!.variants
        : product.variants;
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Column(
        children: [
          Container(
            height: 50,
            decoration: BoxDecoration(color: AppColors.backgroundLight),
            child: Row(
              children: [
                SizedBox(
                  width: isWeb ? 180.0 : 130.0,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      'Variant',
                      style: _getStyle(
                        isHeader: true,
                        color: AppColors.textBlackGrey,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                SizedBox(
                  width: isWeb ? 180.0 : 130.0,
                  child: Text(
                    'Price (₦)',
                    style: _getStyle(
                      isHeader: true,
                      color: AppColors.textBlackGrey,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                SizedBox(
                  width: isWeb ? 200.0 : 150.0,
                  child: Text(
                    'Listed Price (₦)',
                    style: _getStyle(
                      isHeader: true,
                      color: AppColors.textBlackGrey,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                SizedBox(
                  width: isWeb ? 130.0 : 80.0,
                  child: Text(
                    "Stock",
                    style: _getStyle(
                      isHeader: true,
                      color: AppColors.textBlackGrey,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                SizedBox(
                  width: isWeb ? 130.0 : 80.0,
                  child: Text(
                    "Sold",
                    style: _getStyle(
                      isHeader: true,
                      color: AppColors.textBlackGrey,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                SizedBox(
                  width: isWeb ? 200.0 : 100.0,
                  child: Text(
                    "SKU",
                    style: _getStyle(
                      isHeader: true,
                      color: AppColors.textBlackGrey,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          ...variants.asMap().entries.map((entry) {
            var v = entry.value;
            return Container(
              height: 60,
              decoration: BoxDecoration(
                color: AppColors.backgroundWhite,
                border: Border(
                  bottom: BorderSide(
                    color: AppColors.textIconGrey.withValues(alpha: 0.2),
                    width: 1.0,
                  ),
                ),
              ),
              child: Row(
                children: [
                  SizedBox(
                    width: isWeb ? 180.0 : 130.0,
                    child: Text(
                      v.label,
                      style: _getStyle(
                        isHeader: false,
                        color: AppColors.textBodyText,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  SizedBox(
                    width: isWeb ? 180.0 : 130.0,
                    child: Text(
                      fmt.format(v.price),
                      style: _getStyle(
                        isHeader: false,
                        color: AppColors.textBodyText,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  SizedBox(
                    width: isWeb ? 200.0 : 150.0,
                    child: Text(
                      fmt.format(v.listedPrice),
                      style: _getStyle(
                        isHeader: false,
                        color: AppColors.textBodyText,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  SizedBox(
                    width: isWeb ? 130.0 : 80.0,
                    child: Text(
                      '${v.stock}',
                      style: _getStyle(
                        isHeader: false,
                        color: AppColors.textBodyText,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  SizedBox(
                    width: isWeb ? 130.0 : 80.0,
                    child: Text(
                      '${v.sold}',
                      style: _getStyle(
                        isHeader: false,
                        color: AppColors.textBodyText,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  SizedBox(
                    width: isWeb ? 200.0 : 100.0,
                    child: Text(
                      v.sku ?? '—',
                      style: GoogleFonts.notoSans(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textBodyText,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}

class _EditVariantsSheet extends StatefulWidget {
  final SellerProduct product;
  final SellerProductDetailViewModel vm;

  const _EditVariantsSheet({required this.product, required this.vm});

  @override
  State<_EditVariantsSheet> createState() => _EditVariantsSheetState();
}

class _EditVariantsSheetState extends State<_EditVariantsSheet> {
  late List<Map<String, TextEditingController>> _controllers;

  @override
  void initState() {
    super.initState();
    final variants =
        widget.product.inventory?.variants ?? widget.product.variants;
    _controllers = variants
        .map(
          (v) => {
            'price': TextEditingController(text: v.price.toStringAsFixed(0)),
            'stock': TextEditingController(text: v.stock.toString()),
            'sku': TextEditingController(text: v.sku ?? ''),
          },
        )
        .toList();
  }

  @override
  void dispose() {
    for (final m in _controllers) {
      for (final c in m.values) {
        c.dispose();
      }
    }
    super.dispose();
  }

  Future<void> _save() async {
    final variants =
        widget.product.inventory?.variants ?? widget.product.variants;
    final payload = <Map<String, dynamic>>[];

    for (var i = 0; i < variants.length; i++) {
      final v = variants[i];
      final price = double.tryParse(_controllers[i]['price']!.text) ?? v.price;
      final stock = int.tryParse(_controllers[i]['stock']!.text) ?? v.stock;
      final sku = _controllers[i]['sku']!.text.trim();
      payload.add({
        'id': v.id,
        'price': price,
        'quantity': stock,
        if (sku.isNotEmpty) 'sku': sku,
        'options': v.options.map((o) => o.toJson()).toList(),
      });
    }

    final success = await widget.vm.saveEdits(context, {'variants': payload});
    if (success) {
      if (mounted) {
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final variants =
        widget.product.inventory?.variants ?? widget.product.variants;

    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.75,
      maxChildSize: 0.95,
      builder: (_, scrollController) => Column(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 12, bottom: 8),
            width: 36,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.borderColor,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Edit Variants',
                  style: GoogleFonts.hind(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textBlackGrey,
                  ),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    'Cancel',
                    style: GoogleFonts.hind(
                      fontSize: 16,
                      color: AppColors.primaryDarkGreen,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: ListView.separated(
              controller: scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: variants.length,
              separatorBuilder: (_, __) => const SizedBox(height: 16),
              itemBuilder: (_, i) {
                final v = variants[i];
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      v.label,
                      style: GoogleFonts.hind(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        color: AppColors.textBlackGrey,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: _EditField(
                            label: 'Price (₦)',
                            controller: _controllers[i]['price']!,
                            keyboardType: TextInputType.number,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _EditField(
                            label: 'Stock',
                            controller: _controllers[i]['stock']!,
                            keyboardType: TextInputType.number,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _EditField(
                            label: 'SKU',
                            controller: _controllers[i]['sku']!,
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(
              16,
              8,
              16,
              MediaQuery.of(context).viewInsets.bottom + 16,
            ),
            child: CustomButton(
              text: 'Save Variants',
              onPressed: _save,
              height: 48,
              width: double.infinity,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _EditField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final TextInputType keyboardType;

  const _EditField({
    required this.label,
    required this.controller,
    this.keyboardType = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        label,
        style: GoogleFonts.hind(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: AppColors.textBodyText,
        ),
      ),
      const SizedBox(height: 4),
      TextField(
        controller: controller,
        keyboardType: keyboardType,
        style: GoogleFonts.hind(fontSize: 13),
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 10,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6),
            borderSide: const BorderSide(color: AppColors.borderColor),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6),
            borderSide: const BorderSide(color: AppColors.borderColor),
          ),
        ),
      ),
    ],
  );
}

class _RatingReviewsCard extends ConsumerWidget {
  final SellerProduct product;
  final SellerProductDetailState state;
  final SellerProductDetailViewModel vm;
  final bool isWeb;

  const _RatingReviewsCard({
    required this.product,
    required this.state,
    required this.vm,
    required this.isWeb,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final summary =
        state.product?.reviewSummary ??
        ProductReviewSummary(
          average: product.rating.average,
          count: product.rating.count,
          breakdown: ReviewBreakdown(
            one: 0,
            two: 0,
            three: 0,
            four: 0,
            five: 0,
          ),
        );

    return _DetailCard(
      title: 'Rating & Reviews',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: summary.average.toStringAsFixed(1),
                          style: GoogleFonts.hind(
                            fontSize: 50,
                            fontWeight: FontWeight.w500,
                            color: AppColors.textBlackGrey,
                          ),
                        ),
                        TextSpan(
                          text: '/ 5.0',
                          style: GoogleFonts.hind(
                            fontSize: 16,
                            color: AppColors.textBodyText,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${summary.count} Reviews',
                    style: GoogleFonts.hind(
                      fontSize: 12,
                      color: AppColors.textBodyText,
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 24),
              Expanded(
                child: Column(
                  children: [5, 4, 3, 2, 1].map((star) {
                    final count = _starCount(summary.breakdown, star);
                    final fraction = summary.count > 0
                        ? count / summary.count
                        : 0.0;
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2),
                      child: Row(
                        children: [
                          const Icon(Icons.star, size: 12, color: Colors.amber),
                          const SizedBox(width: 4),
                          Text(
                            '$star',
                            style: GoogleFonts.hind(
                              fontSize: 12,
                              color: AppColors.textBodyText,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: LinearProgressIndicator(
                                value: fraction,
                                backgroundColor: AppColors.backgroundLight,
                                color: AppColors.primaryDarkGreen,
                                minHeight: 8,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            decoration: BoxDecoration(
              color: AppColors.backgroundLight,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.borderColor),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          AppAssets.icons.sortBy.svg(),
                          const SizedBox(width: 6),
                          Text(
                            'Sort by:',
                            style: GoogleFonts.hind(
                              fontSize: 14,
                              color: AppColors.textBlackGrey,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 12),
                      MenuAnchor(
                        style: anchorMenuStyle(),
                        builder:
                            (
                              BuildContext context,
                              MenuController controller,
                              Widget? child,
                            ) {
                              return GestureDetector(
                                onTap: () {
                                  controller.isOpen
                                      ? controller.close()
                                      : controller.open();
                                },
                                child: Container(
                                  height: 35,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.borderColor1,
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        state.reviewSort.label,
                                        style: GoogleFonts.hind(fontSize: 13),
                                      ),
                                      const SizedBox(width: 4),
                                      const Icon(
                                        Icons.keyboard_arrow_down,
                                        size: 20,
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },

                        menuChildren: ReviewSort.values.map((sort) {
                          final isSelected = sort == state.reviewSort;

                          return MenuItemButton(
                            onPressed: () {
                              vm.changeReviewSort(sort);
                            },
                            style: ButtonStyle(
                              backgroundColor:
                                  WidgetStateProperty.resolveWith<Color?>((
                                    states,
                                  ) {
                                    if (isSelected) {
                                      return AppColors.tableHeader;
                                    }

                                    if (states.contains(WidgetState.hovered)) {
                                      return AppColors.tableHeader;
                                    }

                                    return Colors.transparent;
                                  }),
                              padding: const WidgetStatePropertyAll(
                                EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 8,
                                ),
                              ),
                            ),
                            child: Text(
                              sort.label,
                              style: GoogleFonts.hind(fontSize: 13),
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  if (state.reviewsLoading)
                    AppShimmer(
                      child: Column(
                        children: const [
                          ReviewItemShimmer(),
                          ReviewItemShimmer(),
                          ReviewItemShimmer(),
                        ],
                      ),
                    )
                  else if (state.reviews.isEmpty)
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        child: Text(
                          'No reviews yet',
                          style: GoogleFonts.hind(
                            color: AppColors.textBodyText,
                          ),
                        ),
                      ),
                    )
                  else
                    ...state.reviews.map((r) => _ReviewItemCard(review: r)),
                  if (state.reviewTotalPages > 1) ...[
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: state.reviewPage > 1
                              ? vm.prevReviewPage
                              : null,
                          child: AppAssets.icons.addproductBackArrow.svg(
                            height: 30,
                            width: 30,
                          ),
                        ),
                        Text(
                          '${state.reviewPage} / ${state.reviewTotalPages}',
                          style: GoogleFonts.hind(
                            fontSize: 13,
                            color: AppColors.textBodyText,
                          ),
                        ),
                        GestureDetector(
                          onTap: state.reviewPage < state.reviewTotalPages
                              ? vm.nextReviewPage
                              : null,
                          child: AppAssets.icons.addProductFrontArrow.svg(
                            height: 30,
                            width: 30,
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  int _starCount(ReviewBreakdown bd, int star) {
    switch (star) {
      case 1:
        return bd.one;
      case 2:
        return bd.two;
      case 3:
        return bd.three;
      case 4:
        return bd.four;
      case 5:
        return bd.five;
      default:
        return 0;
    }
  }
}

class _ReviewItemCard extends StatelessWidget {
  final ReviewItem review;

  const _ReviewItemCard({required this.review});

  @override
  Widget build(BuildContext context) {
    final timeAgo = _formatTimeAgo(review.createdAt);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                height: 32,
                width: 32,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  image: DecorationImage(
                    image: NetworkImage(
                      review.buyer.avatar != null || review.buyer.avatar != ''
                          ? review.buyer.avatar!
                          : '',
                    ),
                  ),
                ),
                child: review.buyer.avatar == null
                    ? Text(
                        review.buyer.name.isNotEmpty
                            ? review.buyer.name[0].toUpperCase()
                            : '?',
                        style: GoogleFonts.hind(
                          color: AppColors.primaryDarkGreen,
                          fontWeight: FontWeight.w700,
                        ),
                      )
                    : null,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      review.buyer.name,
                      style: GoogleFonts.hind(
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                        color: AppColors.textBlackGrey,
                      ),
                    ),
                    Row(
                      children: [
                        ...List.generate(
                          5,
                          (i) => Icon(
                            i < review.rating ? Icons.star : Icons.star_border,
                            size: 14,
                            color: Colors.amber,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Text(
                timeAgo,
                style: GoogleFonts.hind(
                  fontSize: 11,
                  color: AppColors.textBodyText,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
          if (review.comment?.isNotEmpty == true) ...[
            const SizedBox(height: 6),
            Text(
              review.comment!,
              style: GoogleFonts.hind(
                fontSize: 15,
                color: AppColors.textBodyText,
                height: 1.5,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ],
      ),
    );
  }

  String _formatTimeAgo(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inDays > 30) {
      return DateFormat('MMM d, yyyy').format(dt);
    } else if (diff.inDays > 0) {
      return '${diff.inDays} day${diff.inDays > 1 ? 's' : ''} ago';
    } else if (diff.inHours > 0) {
      return '${diff.inHours} hour${diff.inHours > 1 ? 's' : ''} ago';
    } else {
      return 'Just now';
    }
  }
}

class _DetailCard extends StatelessWidget {
  final String title;
  final Widget child;
  final Widget? trailing;

  const _DetailCard({required this.title, required this.child, this.trailing});

  @override
  Widget build(BuildContext context) => Card(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
      side: const BorderSide(color: AppColors.borderColor, width: 1),
    ),
    elevation: 0,
    margin: EdgeInsets.zero,
    color: AppColors.backgroundWhite,
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [_titleBox(title), if (trailing != null) trailing!],
          ),
          const SizedBox(height: 20),
          child,
        ],
      ),
    ),
  );

  _titleBox(String title) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
    decoration: BoxDecoration(
      color: AppColors.tableHeader,
      borderRadius: BorderRadius.circular(4),
    ),
    child: Text(
      title,
      style: GoogleFonts.hind(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: AppColors.textDarkDarkerGreen,
      ),
    ),
  );
}

class _ProductDetailShimmer extends StatelessWidget {
  const _ProductDetailShimmer();

  @override
  Widget build(BuildContext context) {
    final isWeb = context.isWeb;

    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(child: _ProductHeaderShimmer(isWeb: isWeb)),

        SliverPadding(
          padding: EdgeInsets.symmetric(vertical: 16),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              _DetailCardShimmer(
                titleWidth: 130,
                child: const _OverviewShimmer(),
              ),

              const SizedBox(height: 16),

              _MediaGalleryShimmer(isWeb: isWeb),

              const SizedBox(height: 16),

              _DetailCardShimmer(
                titleWidth: 150,
                child: const _DescriptionShimmer(),
              ),

              const SizedBox(height: 16),

              _DetailCardShimmer(
                titleWidth: 145,
                child: const _PricingInventoryShimmer(),
              ),

              const SizedBox(height: 16),

              _DetailCardShimmer(
                titleWidth: 135,
                child: const _RatingReviewsShimmer(),
              ),

              const SizedBox(height: 80),
            ]),
          ),
        ),
      ],
    );
  }
}

class _ProductHeaderShimmer extends StatelessWidget {
  final bool isWeb;

  const _ProductHeaderShimmer({required this.isWeb});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppShimmer(child: const Block(width: 210, height: 19, radius: 4)),

          const SizedBox(height: 14),

          Row(
            children: [
              AppShimmer(
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.borderColor),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Center(
                    child: Block(width: 18, height: 18, radius: 3),
                  ),
                ),
              ),

              const SizedBox(width: 10),

              AppShimmer(
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.borderColor),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Center(
                    child: Block(width: 18, height: 18, radius: 3),
                  ),
                ),
              ),

              const SizedBox(width: 12),

              AppShimmer(
                child: Container(
                  height: 40,
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.borderColor),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Row(
                    children: [
                      const Block(width: 18, height: 18, radius: 3),

                      const SizedBox(width: 6),

                      const Block(width: 75, height: 14, radius: 3),

                      const SizedBox(width: 10),

                      Container(
                        width: 42,
                        height: 22,
                        padding: const EdgeInsets.all(3),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: AppColors.backgroundWhite,
                        ),
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Container(
                            width: 16,
                            height: 16,
                            decoration: const BoxDecoration(
                              color: AppColors.backgroundWhite,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _DetailCardShimmer extends StatelessWidget {
  final double titleWidth;
  final Widget child;

  const _DetailCardShimmer({required this.titleWidth, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.backgroundWhite,
        border: Border.all(color: AppColors.borderColor),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppShimmer(
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 6),
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(4)),
              child: Block(width: titleWidth, height: 16),
            ),
          ),

          const SizedBox(height: 20),

          child,
        ],
      ),
    );
  }
}

class _OverviewShimmer extends StatelessWidget {
  const _OverviewShimmer();

  @override
  Widget build(BuildContext context) {
    return AppShimmer(
      child: Column(
        children: const [
          _ShimmerInfoRow(labelWidth: 105, valueWidth: 180),
          _ShimmerInfoRow(labelWidth: 120, valueWidth: 230),
          _ShimmerInfoRow(labelWidth: 35, valueWidth: 120),
          _ShimmerInfoRow(labelWidth: 75, valueWidth: 145),
          _ShimmerInfoRow(labelWidth: 55, valueWidth: 45),
          _ShimmerInfoRow(labelWidth: 75, valueWidth: 130),
          _ShimmerInfoRow(labelWidth: 50, valueWidth: 75, pill: true),
        ],
      ),
    );
  }
}

class _MediaGalleryShimmer extends StatelessWidget {
  final bool isWeb;

  const _MediaGalleryShimmer({required this.isWeb});

  @override
  Widget build(BuildContext context) {
    final mainHeight = isWeb ? 300.0 : 260.0;

    return AppShimmer(
      child: Column(
        children: [
          Block(width: double.infinity, height: mainHeight, radius: 10),

          const SizedBox(height: 12),

          SizedBox(
            height: 73,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: 5,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (_, index) {
                return const Block(width: 93, height: 73, radius: 10);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _DescriptionShimmer extends StatelessWidget {
  const _DescriptionShimmer();

  @override
  Widget build(BuildContext context) {
    return AppShimmer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Block(width: double.infinity, height: 14),
          SizedBox(height: 8),
          Block(width: double.infinity, height: 14),
          SizedBox(height: 8),
          Block(width: double.infinity, height: 14),
          SizedBox(height: 8),
          Block(width: 240, height: 14),
        ],
      ),
    );
  }
}

class _PricingInventoryShimmer extends StatelessWidget {
  const _PricingInventoryShimmer();

  @override
  Widget build(BuildContext context) {
    return AppShimmer(
      child: Column(
        children: const [
          _ShimmerInfoRow(labelWidth: 45, valueWidth: 110, large: true),
          _ShimmerInfoRow(labelWidth: 95, valueWidth: 125, large: true),
          _ShimmerInfoRow(labelWidth: 100, valueWidth: 100, large: true),
          _ShimmerInfoRow(labelWidth: 95, valueWidth: 155),
          _ShimmerInfoRow(labelWidth: 85, valueWidth: 135),
        ],
      ),
    );
  }
}

class _RatingReviewsShimmer extends StatelessWidget {
  const _RatingReviewsShimmer();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppShimmer(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: const [
                  Block(width: 62, height: 52),
                  SizedBox(height: 6),
                  Block(width: 45, height: 12),
                ],
              ),

              const SizedBox(width: 24),

              Expanded(
                child: Column(
                  children: List.generate(5, (index) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(vertical: 3),
                      child: Row(
                        children: [
                          Block(width: 10, height: 12),
                          SizedBox(width: 5),
                          Block(width: 12, height: 12),
                          SizedBox(width: 7),
                          Expanded(child: Block(height: 8, radius: 4)),
                        ],
                      ),
                    );
                  }),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 18),

        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.backgroundLight,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppColors.borderColor),
          ),
          child: AppShimmer(
            child: Column(
              children: const [
                Row(
                  children: [
                    Block(width: 18, height: 18, radius: 3),
                    SizedBox(width: 6),
                    Block(width: 55, height: 14),
                    SizedBox(width: 12),
                    Block(width: 105, height: 35, radius: 6),
                  ],
                ),

                SizedBox(height: 12),

                ReviewItemShimmer(),

                ReviewItemShimmer(),

                ReviewItemShimmer(),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _ShimmerInfoRow extends StatelessWidget {
  final double labelWidth;
  final double valueWidth;
  final bool large;
  final bool pill;

  const _ShimmerInfoRow({
    required this.labelWidth,
    required this.valueWidth,
    this.large = false,
    this.pill = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Block(width: labelWidth, height: large ? 16 : 14),

          const SizedBox(width: 20),

          if (pill)
            Block(width: valueWidth, height: 26, radius: 13)
          else
            Expanded(
              child: Block(width: valueWidth, height: large ? 16 : 14),
            ),
        ],
      ),
    );
  }
}

class ReviewItemShimmer extends StatelessWidget {
  const ReviewItemShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Block(width: 32, height: 32, isCircle: true),

              const SizedBox(width: 10),

              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Block(width: 100, height: 14),
                    SizedBox(height: 5),
                    Block(width: 70, height: 12),
                  ],
                ),
              ),

              const Block(width: 55, height: 11),
            ],
          ),

          const SizedBox(height: 8),

          const Block(width: double.infinity, height: 14),

          const SizedBox(height: 6),

          const Block(width: 220, height: 14),
        ],
      ),
    );
  }
}
