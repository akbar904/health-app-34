import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_app/core/constants/app_colors.dart';
import 'package:my_app/core/constants/app_text_styles.dart';
import 'package:my_app/widgets/custom_button.dart';
import 'package:stacked_services/stacked_services.dart';

class FilterSheet extends StatefulWidget {
  final SheetRequest request;
  final Function(SheetResponse) completer;

  const FilterSheet({
    Key? key,
    required this.request,
    required this.completer,
  }) : super(key: key);

  @override
  State<FilterSheet> createState() => _FilterSheetState();
}

class _FilterSheetState extends State<FilterSheet> {
  late String _status;
  late DateTime? _startDate;
  late DateTime? _endDate;

  @override
  void initState() {
    super.initState();
    final data = widget.request.data as Map<String, dynamic>;
    _status = data['status'] as String;
    _startDate = data['startDate'] as DateTime?;
    _endDate = data['endDate'] as DateTime?;
  }

  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isStartDate
          ? (_startDate ?? DateTime.now())
          : (_endDate ?? DateTime.now()),
      firstDate: DateTime(2000),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (picked != null) {
      setState(() {
        if (isStartDate) {
          _startDate = picked;
          if (_endDate != null && _endDate!.isBefore(_startDate!)) {
            _endDate = null;
          }
        } else {
          _endDate = picked;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            widget.request.title ?? 'Filter',
            style: AppTextStyles.h5,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          Text(
            'Status',
            style: AppTextStyles.subtitle2,
          ),
          const SizedBox(height: 8),
          _buildStatusFilters(),
          const SizedBox(height: 24),
          Text(
            'Date Range',
            style: AppTextStyles.subtitle2,
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: _buildDateSelector(
                  'Start Date',
                  _startDate,
                  () => _selectDate(context, true),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildDateSelector(
                  'End Date',
                  _endDate,
                  () => _selectDate(context, false),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: CustomButton(
                  text: 'Reset',
                  onPressed: _resetFilters,
                  type: ButtonType.outline,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: CustomButton(
                  text: 'Apply',
                  onPressed: _applyFilters,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatusFilters() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        _buildStatusChip('All', 'all'),
        _buildStatusChip('Pending', 'pending'),
        _buildStatusChip('Completed', 'completed'),
        _buildStatusChip('Cancelled', 'cancelled'),
      ],
    );
  }

  Widget _buildStatusChip(String label, String value) {
    final isSelected = _status == value;
    return FilterChip(
      selected: isSelected,
      label: Text(label),
      onSelected: (selected) {
        setState(() {
          _status = value;
        });
      },
      backgroundColor: isSelected ? AppColors.primary.withOpacity(0.1) : null,
      selectedColor: AppColors.primary.withOpacity(0.2),
      labelStyle: AppTextStyles.chip.copyWith(
        color: isSelected ? AppColors.primary : AppColors.textSecondary,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(
          color: isSelected ? AppColors.primary : AppColors.border,
        ),
      ),
    );
  }

  Widget _buildDateSelector(String label, DateTime? date, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.border),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.textTertiary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              date != null
                  ? DateFormat('MMM dd, yyyy').format(date)
                  : 'Select Date',
              style: AppTextStyles.body2,
            ),
          ],
        ),
      ),
    );
  }

  void _resetFilters() {
    setState(() {
      _status = 'all';
      _startDate = null;
      _endDate = null;
    });
  }

  void _applyFilters() {
    widget.completer(
      SheetResponse(
        confirmed: true,
        data: {
          'status': _status,
          'startDate': _startDate,
          'endDate': _endDate,
        },
      ),
    );
  }
}
