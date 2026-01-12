import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wigo_flutter/core/constants/app_colors.dart';

class SearchSuggestionsDropdown extends StatelessWidget {
  final List<String> suggestions;
  final ValueChanged<String> onSelect;

  const SearchSuggestionsDropdown({
    super.key,
    required this.suggestions,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    final isWeb = MediaQuery.of(context).size.width > 600;
    if (suggestions.isEmpty) return const SizedBox.shrink();

    return Material(
      elevation: 3,
      color: AppColors.backgroundWhite,
      borderRadius: BorderRadius.circular(8),
      child: ListView.builder(
        shrinkWrap: true,
        padding: EdgeInsets.zero,
        itemCount: suggestions.length,
        itemBuilder: (context, index) {
          final suggestion = suggestions[index];

          return ListTile(
            minTileHeight: 3,
            title: Text(
              suggestion,
              style: GoogleFonts.hind(
                fontWeight: FontWeight.w500,
                fontSize: isWeb ? 18 : 14,
                color: AppColors.textBlackGrey,
              ),
            ),
            onTap: () => onSelect(suggestion),
          );
        },
      ),
    );
  }
}
