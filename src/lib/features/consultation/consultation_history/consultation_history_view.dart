import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:my_app/core/constants/app_colors.dart';
import 'package:my_app/core/constants/app_text_styles.dart';
import 'package:my_app/features/consultation/consultation_history/consultation_history_viewmodel.dart';
import 'package:my_app/widgets/consultation_card.dart';
import 'package:my_app/widgets/custom_text_field.dart';
import 'package:my_app/widgets/error_view.dart';
import 'package:my_app/widgets/loading_overlay.dart';

class ConsultationHistoryView
    extends StackedView<ConsultationHistoryViewModel> {
  const ConsultationHistoryView({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    ConsultationHistoryViewModel viewModel,
    Widget? child,
  ) {
    return LoadingOverlay(
      isLoading: viewModel.isBusy,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Consultation History', style: AppTextStyles.h6),
          actions: [
            IconButton(
              icon: const Icon(Icons.filter_list),
              onPressed: viewModel.showFilterOptions,
            ),
            IconButton(
              icon: const Icon(Icons.sort),
              onPressed: viewModel.showSortOptions,
            ),
          ],
        ),
        body: Column(
          children: [
            _buildSearchBar(viewModel),
            Expanded(
              child: _buildContent(viewModel),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: viewModel.navigateToNewConsultation,
          backgroundColor: AppColors.primary,
          child: const Icon(Icons.add, color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildSearchBar(ConsultationHistoryViewModel viewModel) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: CustomTextField(
        hint: 'Search consultations...',
        prefix: Icon(
          Icons.search,
          color: AppColors.textTertiary,
        ),
        onChanged: viewModel.onSearchChanged,
      ),
    );
  }

  Widget _buildContent(ConsultationHistoryViewModel viewModel) {
    if (viewModel.hasError) {
      return ErrorView(
        message: viewModel.modelError.toString(),
        onRetry: viewModel.loadConsultations,
      );
    }

    if (viewModel.consultations.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.medical_services_outlined,
              size: 64,
              color: AppColors.textTertiary,
            ),
            const SizedBox(height: 16),
            Text(
              'No consultations found',
              style: AppTextStyles.body1.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: viewModel.clearFilters,
              child: Text(
                'Clear Filters',
                style: AppTextStyles.button.copyWith(
                  color: AppColors.primary,
                ),
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: viewModel.refreshConsultations,
      child: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: viewModel.consultations.length,
        separatorBuilder: (context, index) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final consultation = viewModel.consultations[index];
          return ConsultationCard(
            consultation: consultation,
            onTap: () => viewModel.navigateToConsultationDetails(
              consultation.id,
            ),
          );
        },
      ),
    );
  }

  @override
  ConsultationHistoryViewModel viewModelBuilder(BuildContext context) =>
      ConsultationHistoryViewModel();

  @override
  void onViewModelReady(ConsultationHistoryViewModel viewModel) =>
      viewModel.init();
}
