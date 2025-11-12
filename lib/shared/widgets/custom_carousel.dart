import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';

class CustomCarouselWidget<T> extends StatefulWidget {
  final List<T> items;
  final Widget Function(T item) itemBuilder;
  final Color? dotColor;
  final double? viewportFraction, pageViewBuilderHeight;
  final num visibleItemsPerPage;

  const CustomCarouselWidget({
    super.key,
    required this.items,
    required this.itemBuilder,
    this.dotColor,
    this.viewportFraction,
    this.pageViewBuilderHeight,
    this.visibleItemsPerPage = 2,
  });

  @override
  State<CustomCarouselWidget<T>> createState() =>
      _CustomCarouselWidgetState<T>();
}

class _CustomCarouselWidgetState<T> extends State<CustomCarouselWidget<T>> {
  late final PageController _pageController;
  int _currentPage = 0;

  // int visibleItemsPerPage = 2;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(
      viewportFraction: widget.viewportFraction ?? 0.50,
      initialPage: 0,
    );

    _pageController.addListener(() {
      double page = _pageController.page ?? 0;
      int nextP = (page / widget.visibleItemsPerPage).floor();
      if (_currentPage != nextP) {
        setState(() {
          _currentPage = nextP;
        });
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    int totalPages = (widget.items.length / widget.visibleItemsPerPage).ceil();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: widget.pageViewBuilderHeight ?? 225,
          child: Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: PageView.builder(
              controller: _pageController,
              itemCount: widget.items.length,
              scrollDirection: Axis.horizontal,
              padEnds: false,
              itemBuilder: (context, index) {
                final item = widget.items[index];
                return Padding(
                  padding: const EdgeInsets.only(right: 16.0),
                  child: widget.itemBuilder(item),
                );
              },
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(totalPages, (index) {
            return AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              margin: const EdgeInsets.symmetric(horizontal: 4.0),
              height: 8.0,
              width: _currentPage == index ? 24.0 : 8.0,
              decoration: BoxDecoration(
                color:
                    _currentPage == index
                        ? widget.dotColor ?? AppColors.textOrange
                        : AppColors.accentWhite,
                borderRadius: BorderRadius.circular(4),
              ),
            );
          }),
        ),
      ],
    );
  }
}
