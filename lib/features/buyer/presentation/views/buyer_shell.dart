import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../gen/assets.gen.dart';
import '../../../../shared/widgets/custom_search_field.dart';
import '../../../../shared/widgets/dashboard_widgets/custom_app_bar.dart';
import '../../viewmodels/buyer_home_viewmodel.dart';
import '../widgets/custom_dropdown_menu.dart';
import '../widgets/search_suggestions_dropdown.dart';
import '../widgets/user_dropdown_menu.dart';
import 'footer_section.dart';

class BuyerShell extends ConsumerStatefulWidget {
  final Widget child;

  const BuyerShell({super.key, required this.child});

  @override
  ConsumerState<BuyerShell> createState() => _BuyerShellState();
}

class _BuyerShellState extends ConsumerState<BuyerShell> {
  OverlayEntry? _overlayEntry;
  bool _showingCategories = false;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      ref
          .read(buyerHomeViewModelProvider.notifier)
          .updateSearchQuery(_searchController.text.trim());
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _submitSearch(String query) {
    if (query.trim().isEmpty) return;

    ref.read(buyerHomeViewModelProvider.notifier).resetSearch();
    _searchController.clear();

    context.push('/buyer/search', extra: query);
  }

  void _showDropdownMenu(bool isMenu) {
    final overlay = Overlay.of(context);

    _overlayEntry = OverlayEntry(
      builder:
          (context) => Stack(
            children: [
              isMenu
                  ? Positioned.fill(
                    child: GestureDetector(
                      onTap: _closeDropdownMenu,
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 6.0, sigmaY: 6.0),
                        child: Container(
                          color: Colors.black.withValues(alpha: 0.02),
                        ),
                      ),
                    ),
                  )
                  : Positioned.fill(
                    child: GestureDetector(
                      onTap: _closeDropdownMenu,
                      child: Container(color: Colors.transparent),
                    ),
                  ),

              Positioned(
                top: isMenu ? 60 : 90,
                right: isMenu ? 16 : 120,
                child: StatefulBuilder(
                  builder: (context, setState) {
                    return isMenu
                        ? CustomDropdownMenu(
                          onClose: _closeDropdownMenu,
                          onCategoriesPress: () {
                            setState(() {
                              _showingCategories = !_showingCategories;
                            });
                          },
                          showCategories: _showingCategories,
                        )
                        : UserDropDownMenu(onAction: _closeDropdownMenu);
                  },
                ),
              ),
            ],
          ),
    );

    overlay.insert(_overlayEntry!);
  }

  void _closeDropdownMenu() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(buyerHomeViewModelProvider);
    final vmNotifier = ref.read(buyerHomeViewModelProvider.notifier);
    final isWeb = MediaQuery.of(context).size.width > 600;
    final isSearching = state.searchQuery.isNotEmpty;
    final suggestions = ref
        .read(buyerHomeViewModelProvider.notifier)
        .searchSuggestions(state.searchQuery);

    return Stack(
      children: [
        Scaffold(
          backgroundColor: AppColors.backgroundWhite,
          appBar: CustomAppBar(
            isWeb: isWeb,
            isBuyer: true,
            onUserPress: () {
              _showDropdownMenu(false);
            },
            onMobileMenuPress: () {
              _showDropdownMenu(true);
            },
            onMobileSearchPress: () {
              vmNotifier.toggleSearchFieldVisibility();
              if (!state.isSearchFieldVisible) {
                _searchController.clear();
              }
            },
            onLoginPress: () {
              context.push('/login');
            },
          ),
          body: Stack(
            children: [
              SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  key: const ValueKey('home-content'),
                  children: [
                    if (isWeb) _webHeader(isWeb),
                    if (state.isSearchFieldVisible) const SizedBox(height: 40),
                    widget.child,
                    const SizedBox(height: 30),
                    FooterSection(),
                  ],
                ),
              ),
              if (state.isSearchFieldVisible)
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: CustomSearchField(
                      searchController: _searchController,
                      backgroundColor: AppColors.backgroundWhite,
                      onSubmitted: (value) {
                        if (value.trim().isEmpty) return;
                        _submitSearch(value.trim());
                      },
                      trailing: <Widget>[
                        if (isSearching && _searchController.text.isNotEmpty)
                          IconButton(
                            icon: const Icon(
                              Icons.cancel,
                              size: 20,
                              color: AppColors.textIconGrey,
                            ),
                            onPressed: () {
                              vmNotifier.toggleSearchFieldVisibility();
                              if (!state.isSearchFieldVisible) {
                                _searchController.clear();
                              }
                            },
                            tooltip: 'Clear search',
                          ),
                      ],
                    ),
                  ),
                ),
              if (state.isSearchFieldVisible && suggestions.isNotEmpty)
                Positioned(
                  top: 40,
                  left: 16,
                  right: 16,
                  child: SearchSuggestionsDropdown(
                    suggestions: suggestions,
                    onSelect: (value) {
                      _searchController.text = value;
                      _submitSearch(value);
                    },
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _webHeader(bool isWeb) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildTextProperties('Latest', isWeb, isBottomText: false),
        Row(
          children: [
            _buildTextProperties('Categories', isWeb, isBottomText: false),
            const SizedBox(width: 5),
            AppAssets.icons.arrowDown.svg(),
          ],
        ),
        _buildTextProperties('Support', isWeb, isBottomText: false),
        _buildTextProperties('Become a Seller', isWeb, isBottomText: false),
        _buildTextProperties('For Riders', isWeb, isBottomText: false),
      ],
    );
  }

  Widget _buildTextProperties(
    String text,
    bool isWeb, {
    bool isBottomText = true,
    bool isBodyText = false,
  }) {
    return Text(
      text,
      style: GoogleFonts.hind(
        fontWeight: FontWeight.w400,
        fontSize:
            isWeb
                ? isBottomText
                    ? 16
                    : 18
                : 14,
        color:
            isBottomText
                ? isBodyText
                    ? AppColors.textBodyText
                    : AppColors.textBlackGrey
                : AppColors.textBlack,
      ),
    );
  }
}
