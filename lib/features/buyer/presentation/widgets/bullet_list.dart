import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/constants/app_colors.dart';

class BulletList extends StatelessWidget {
  final List<String> items;
  final bool isWeb;
  final bool isImportant;

  const BulletList({
    super.key,
    this.isImportant = false,
    required this.items,
    required this.isWeb,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children:
          items.map((item) {
            return Padding(
              padding: const EdgeInsets.only(top: 8, left: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('•  '),
                  Expanded(
                    child: Text(
                      item,
                      style: GoogleFonts.hind(
                        fontSize: isWeb ? 18 : 14,
                        fontWeight:
                            isImportant ? FontWeight.w600 : FontWeight.w400,
                        color: AppColors.textBlackGrey,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
    );
  }
}

class IndentedBulletList extends StatelessWidget {
  final List<String> items;
  final bool isWeb;

  const IndentedBulletList({
    super.key,
    required this.items,
    required this.isWeb,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 26),
      child: BulletList(items: items, isWeb: isWeb),
    );
  }
}
