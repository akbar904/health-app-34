import 'package:flutter/material.dart';
import 'package:my_app/core/constants/app_colors.dart';
import 'package:my_app/core/constants/app_text_styles.dart';
import 'package:my_app/widgets/custom_button.dart';
import 'package:stacked_services/stacked_services.dart';

class SortSheet extends StatelessWidget {
  final SheetRequest request;
  final Function(SheetResponse) completer;

  const SortSheet({
    Key? key,
    required this.request,
    required this.completer,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final currentSort = request.data as String;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            request.title ?? 'Sort By',
            style: AppTextStyles.h5,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          _buildSortOption(
            'Date',
            'date',
            currentSort,
            Icons.calendar_today_outlined,
          ),
          const SizedBox(height: 12),
          _buildSortOption(
            'Status',
            'status',
            currentSort,
            Icons.check_circle_outline,
          ),
          const SizedBox(height: 24),
          CustomButton(
            text: 'Apply',
            onPressed: () => completer(
              SheetResponse(confirmed: true, data: currentSort),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSortOption(
    String title,
    String value,
    String currentSort,
    IconData icon,
  ) {
    final isSelected = value == currentSort;

    return InkWell(
      onTap: () => completer(SheetResponse(confirmed: true, data: value)),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary.withOpacity(0.1) : null,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.border,
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected ? AppColors.primary : AppColors.textSecondary,
            ),
            const SizedBox(width: 12),
            Text(
              title,
              style: AppTextStyles.body1.copyWith(
                color: isSelected ? AppColors.primary : AppColors.textPrimary,
              ),
            ),
            const Spacer(),
            if (isSelected)
              Icon(
                Icons.check,
                color: AppColors.primary,
              ),
          ],
        ),
      ),
    );
  }
}
