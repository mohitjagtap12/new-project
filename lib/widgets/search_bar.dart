import 'package:flutter/material.dart';
import '../core/theme/app_theme.dart';

class AgroSearchBar extends StatelessWidget {
  final String hintText;
  final ValueChanged<String>? onChanged;
  final TextEditingController? controller;
  final VoidCallback? onFilterTap;
  final bool showFilter;

  const AgroSearchBar({
    Key? key,
    this.hintText = 'Search here...',
    this.onChanged,
    this.controller,
    this.onFilterTap,
    this.showFilter = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AgroColors.border),
            ),
            child: TextField(
              controller: controller,
              onChanged: onChanged,
              decoration: InputDecoration(
                hintText: hintText,
                prefixIcon: const Icon(Icons.search, color: AgroColors.textMuted),
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              ),
            ),
          ),
        ),
        if (showFilter) ...[
          const SizedBox(width: 8),
          Container(
            decoration: BoxDecoration(
              color: AgroColors.primaryContainer,
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              icon: const Icon(Icons.filter_list, color: AgroColors.primaryDark),
              onPressed: onFilterTap,
              tooltip: 'Filter',
            ),
          ),
        ],
      ],
    );
  }
}
