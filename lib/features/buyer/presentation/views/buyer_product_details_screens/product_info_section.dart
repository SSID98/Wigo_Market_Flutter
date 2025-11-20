import 'package:dotted_decoration/dotted_decoration.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wigo_flutter/shared/widgets/custom_button.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../gen/assets.gen.dart';
import '../../widgets/icon_text_row.dart';

class ProductInfoSection extends StatefulWidget {
  final String productName;
  final String price;
  final String categoryName;

  const ProductInfoSection({
    super.key,
    required this.productName,
    required this.price,
    required this.categoryName,
  });

  @override
  State<ProductInfoSection> createState() => _ProductInfoSectionState();
}

class _ProductInfoSectionState extends State<ProductInfoSection> {
  int quantity = 1;
  int selectedColor = 0;
  int selectedSize = 2;

  final List<Color> colors = [
    Colors.white,
    Colors.pinkAccent,
    Colors.lightGreen,
    Colors.green,
    Colors.yellowAccent,
    Colors.red,
    Colors.cyan,
    Colors.purple,
    Colors.cyanAccent,
    Colors.black,
  ];

  final List<String> sizes = ["XXS", "XS", "S", "M", "L", "XL", "XXL", 'XXXL'];

  @override
  Widget build(BuildContext context) {
    final isWeb = MediaQuery.of(context).size.width > 600;
    final textStyle = GoogleFonts.hind(
      fontSize: isWeb ? 14 : 12,
      fontWeight: FontWeight.w500,
      color: AppColors.textIconGrey.withValues(alpha: 0.7),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Text(
            widget.categoryName,
            style: GoogleFonts.hind(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppColors.textIconGrey.withValues(alpha: 0.7),
            ),
          ),
        ),
        const SizedBox(height: 10),
        GridView.builder(
          padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: 2,
          gridDelegate: _gridDelegate(isWeb, 25),
          itemBuilder: (context, index) {
            switch (index) {
              case 0:
                return Text(
                  widget.productName,
                  style: GoogleFonts.hind(
                    fontSize: isWeb ? 24 : 18,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textBlack,
                  ),
                );
              case 1:
                return IconTextRow(
                  text: " 4.0 (2)",
                  icon: AppAssets.icons.star.svg(height: 19),
                  fontSize: isWeb ? 20 : 16,
                  isRating: false,
                  textBlack: true,
                  textPadding: 3,
                  padding: EdgeInsets.zero,
                );
              default:
                return const SizedBox.shrink();
            }
          },
        ),
        GridView.builder(
          padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: 2,
          gridDelegate: _gridDelegate(isWeb, 30),
          itemBuilder: (context, index) {
            switch (index) {
              case 0:
                return Text(
                  "#${widget.price}",
                  style: GoogleFonts.hind(
                    fontSize: isWeb ? 32 : 18,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textBlack,
                  ),
                );
              case 1:
                return Padding(
                  padding: const EdgeInsets.only(right: 230.0),
                  child: Container(
                    margin: EdgeInsets.zero,
                    padding: EdgeInsets.zero,
                    decoration: BoxDecoration(
                      color:
                          isWeb
                              ? AppColors.backgroundLightPink
                              : AppColors.backgroundLightYellow,
                      borderRadius: BorderRadius.circular(48),
                    ),
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        "5 left in Stock",
                        style: GoogleFonts.hind(
                          fontSize: isWeb ? 14 : 12,
                          fontWeight: FontWeight.w400,
                          color: AppColors.textBlack,
                        ),
                      ),
                    ),
                  ),
                );
              default:
                return const SizedBox.shrink();
            }
          },
        ),
        Container(
          decoration: DottedDecoration(
            shape: Shape.line,
            linePosition: LinePosition.bottom,
            color: AppColors.borderColor1,
            dash: const <int>[6, 6],
          ),
        ),
        const SizedBox(height: 20),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Choose a Color", style: textStyle),
              const SizedBox(height: 10),
              Wrap(
                spacing: 6,
                children: List.generate(colors.length, (i) {
                  return GestureDetector(
                    onTap: () => setState(() => selectedColor = i),
                    child: Container(
                      width: isWeb ? 30 : 25,
                      height: isWeb ? 30 : 25,
                      decoration: BoxDecoration(
                        color: colors[i],
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(
                          color:
                              selectedColor == i
                                  ? AppColors.textIconGrey
                                  : Colors.transparent,
                          width: 1,
                        ),
                      ),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 15),
              Text("Quantity", style: textStyle),
              const SizedBox(height: 2),
              Row(
                children: [
                  _qtyButton(Icons.remove, () {
                    if (quantity > 1) setState(() => quantity--);
                  }, isWeb),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Text(
                      "$quantity",
                      style: GoogleFonts.hind(
                        color: AppColors.textNeutral950,
                        fontWeight: FontWeight.w400,
                        fontSize: isWeb ? 20 : 16,
                      ),
                    ),
                  ),
                  _qtyButton(
                    Icons.add,
                    () => setState(() => quantity++),
                    isWeb,
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Text("Choose Size", style: textStyle),
              const SizedBox(height: 5),
              Wrap(
                spacing: 6,
                children: List.generate(sizes.length, (i) {
                  return GestureDetector(
                    onTap: () => setState(() => selectedSize = i),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color:
                            selectedSize == i
                                ? AppColors.clampBgColor
                                : Colors.transparent,
                        borderRadius: BorderRadius.circular(4),
                        // border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: Text(
                        sizes[i],
                        style: GoogleFonts.inter(
                          color:
                              selectedSize == i
                                  ? AppColors.textNeutral950
                                  : AppColors.textIconGrey,
                          fontSize: isWeb ? 16 : 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
        Container(
          decoration: DottedDecoration(
            shape: Shape.line,
            linePosition: LinePosition.bottom,
            color: AppColors.borderColor1,
            dash: const <int>[6, 6],
          ),
        ),
        const SizedBox(height: 45),
        Row(
          mainAxisAlignment:
              isWeb ? MainAxisAlignment.start : MainAxisAlignment.spaceBetween,
          children: [
            CustomButton(
              text: 'Add to Cart',
              fontSize: 16,
              fontWeight: FontWeight.w600,
              borderRadius: 16,
              height: 50,
              width: isWeb ? 269 : 180,
              onPressed: () {},
            ),
            if (isWeb) const SizedBox(width: 14),
            CustomButton(
              text: 'Save for Later',
              fontSize: 16,
              fontWeight: FontWeight.w600,
              textColor: AppColors.textVidaLocaGreen,
              buttonColor: Colors.transparent,
              prefixIcon: AppAssets.icons.greenHeart.svg(height: 15.81),

              borderRadius: 16,
              borderColor: AppColors.primaryDarkGreen,
              height: 50,
              width: isWeb ? 269 : 180,
              onPressed: () {},
            ),
          ],
        ),
      ],
    );
  }

  Widget _qtyButton(IconData icon, VoidCallback onTap, bool isWeb) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: isWeb ? 45 : 35,
        height: isWeb ? 45 : 35,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: AppColors.borderColor),
        ),
        child: Icon(icon, size: isWeb ? 25 : 22),
      ),
    );
  }

  SliverGridDelegateWithFixedCrossAxisCount _gridDelegate(
    bool isWeb,
    double? mainAxisExtent,
  ) {
    return SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: isWeb ? 2 : 1,
      crossAxisSpacing: isWeb ? 13 : 0,
      mainAxisSpacing: 5,
      mainAxisExtent: isWeb ? 95 : mainAxisExtent,
    );
  }
}
