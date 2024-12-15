import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:my_app/core/constants/app_colors.dart';
import 'package:my_app/core/constants/app_text_styles.dart';
import 'package:my_app/features/patients/patient_list/patient_list_viewmodel.dart';
import 'package:my_app/widgets/custom_text_field.dart';
import 'package:my_app/widgets/loading_overlay.dart';
import 'package:my_app/widgets/patient_card.dart';
import 'package:my_app/widgets/error_view.dart';

class PatientListView extends StackedView<PatientListViewModel> {
  const PatientListView({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    PatientListViewModel viewModel,
    Widget? child,
  ) {
    return LoadingOverlay(
      isLoading: viewModel.isBusy,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Patients', style: AppTextStyles.h6),
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
          onPressed: viewModel.navigateToAddPatient,
          backgroundColor: AppColors.primary,
          child: const Icon(Icons.add, color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildSearchBar(PatientListViewModel viewModel) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: CustomTextField(
        controller: viewModel.searchController,
        hint: 'Search patients...',
        prefix: Icon(
          Icons.search,
          color: AppColors.textTertiary,
        ),
        onChanged: viewModel.onSearchChanged,
      ),
    );
  }

  Widget _buildContent(PatientListViewModel viewModel) {
    if (viewModel.hasError) {
      return ErrorView(
        message: viewModel.modelError.toString(),
        onRetry: viewModel.loadPatients,
      );
    }

    if (viewModel.patients.isEmpty) {
      return _buildEmptyState(viewModel);
    }

    return RefreshIndicator(
      onRefresh: viewModel.loadPatients,
      child: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: viewModel.patients.length,
        separatorBuilder: (context, index) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final patient = viewModel.patients[index];
          return PatientCard(
            patient: patient,
            onTap: () => viewModel.navigateToPatientDetails(patient.id),
          );
        },
      ),
    );
  }

  Widget _buildEmptyState(PatientListViewModel viewModel) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.people_outline,
            size: 64,
            color: AppColors.textTertiary,
          ),
          const SizedBox(height: 16),
          Text(
            viewModel.searchController.text.isNotEmpty
                ? 'No patients found matching your search'
                : 'No patients added yet',
            style: AppTextStyles.body1.copyWith(
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
          if (viewModel.searchController.text.isEmpty) ...[
            const SizedBox(height: 24),
            TextButton.icon(
              onPressed: viewModel.navigateToAddPatient,
              icon: Icon(
                Icons.add_circle_outline,
                color: AppColors.primary,
              ),
              label: Text(
                'Add New Patient',
                style: AppTextStyles.button.copyWith(
                  color: AppColors.primary,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  @override
  PatientListViewModel viewModelBuilder(BuildContext context) =>
      PatientListViewModel();

  @override
  void onViewModelReady(PatientListViewModel viewModel) => viewModel.init();
}
