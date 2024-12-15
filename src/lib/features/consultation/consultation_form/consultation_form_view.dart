import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:stacked/stacked.dart';
import 'package:my_app/core/constants/app_colors.dart';
import 'package:my_app/core/constants/app_text_styles.dart';
import 'package:my_app/features/consultation/consultation_form/consultation_form_viewmodel.dart';
import 'package:my_app/widgets/custom_button.dart';
import 'package:my_app/widgets/custom_text_field.dart';
import 'package:my_app/widgets/loading_overlay.dart';

class ConsultationFormView extends StackedView<ConsultationFormViewModel> {
  final String? consultationId;

  const ConsultationFormView({Key? key, this.consultationId}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    ConsultationFormViewModel viewModel,
    Widget? child,
  ) {
    return LoadingOverlay(
      isLoading: viewModel.isBusy,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            viewModel.isEditing ? 'Edit Consultation' : 'New Consultation',
            style: AppTextStyles.h6,
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (viewModel.hasError)
                Container(
                  padding: const EdgeInsets.all(16),
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: AppColors.error.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    viewModel.modelError.toString(),
                    style: AppTextStyles.body2.copyWith(color: AppColors.error),
                  ),
                ),
              _buildPatientSection(viewModel),
              const SizedBox(height: 24),
              _buildConsultationDetails(viewModel, context),
              const SizedBox(height: 24),
              _buildAttachments(viewModel),
              const SizedBox(height: 24),
              CustomButton(
                text: viewModel.isEditing
                    ? 'Update Consultation'
                    : 'Save Consultation',
                onPressed: viewModel.saveConsultation,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPatientSection(ConsultationFormViewModel viewModel) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Patient Information', style: AppTextStyles.h6),
            const SizedBox(height: 16),
            if (viewModel.selectedPatient != null)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    viewModel.selectedPatient!.fullName,
                    style: AppTextStyles.subtitle1,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${viewModel.selectedPatient!.age} years • ${viewModel.selectedPatient!.gender}',
                    style: AppTextStyles.body2.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              )
            else
              CustomButton(
                text: 'Select Patient',
                onPressed: viewModel.selectPatient,
                type: ButtonType.outline,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildConsultationDetails(
    ConsultationFormViewModel viewModel,
    BuildContext context,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Consultation Details', style: AppTextStyles.h6),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () => viewModel.selectConsultationDate(context),
                    child: InputDecorator(
                      decoration: InputDecoration(
                        labelText: 'Date',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        viewModel.consultationDate != null
                            ? DateFormat('MMM dd, yyyy')
                                .format(viewModel.consultationDate!)
                            : 'Select Date',
                        style: AppTextStyles.body1,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: viewModel.status,
                    decoration: InputDecoration(
                      labelText: 'Status',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    items: ['pending', 'completed', 'cancelled']
                        .map((status) => DropdownMenuItem(
                              value: status,
                              child: Text(
                                status.toUpperCase(),
                                style: AppTextStyles.body1,
                              ),
                            ))
                        .toList(),
                    onChanged: (value) => viewModel.updateStatus(value!),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            CustomTextField(
              label: 'Chief Complaint',
              controller: viewModel.chiefComplaintController,
              errorText: viewModel.chiefComplaintError,
              maxLines: 2,
            ),
            const SizedBox(height: 16),
            CustomTextField(
              label: 'Diagnosis',
              controller: viewModel.diagnosisController,
              errorText: viewModel.diagnosisError,
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            CustomTextField(
              label: 'Symptoms',
              controller: viewModel.symptomsController,
              errorText: viewModel.symptomsError,
              maxLines: 2,
              hint: 'Enter symptoms separated by commas',
            ),
            const SizedBox(height: 16),
            CustomTextField(
              label: 'Prescriptions',
              controller: viewModel.prescriptionsController,
              errorText: viewModel.prescriptionsError,
              maxLines: 3,
              hint: 'Enter prescriptions separated by commas',
            ),
            const SizedBox(height: 16),
            CustomTextField(
              label: 'Notes',
              controller: viewModel.notesController,
              maxLines: 4,
              hint: 'Additional notes (optional)',
            ),
            const SizedBox(height: 16),
            InkWell(
              onTap: () => viewModel.selectFollowUpDate(context),
              child: InputDecorator(
                decoration: InputDecoration(
                  labelText: 'Follow-up Date (Optional)',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  viewModel.followUpDate != null
                      ? DateFormat('MMM dd, yyyy')
                          .format(viewModel.followUpDate!)
                      : 'Select Follow-up Date',
                  style: AppTextStyles.body1,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAttachments(ConsultationFormViewModel viewModel) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Attachments', style: AppTextStyles.h6),
            const SizedBox(height: 16),
            if (viewModel.attachments.isEmpty)
              Center(
                child: Text(
                  'No attachments added',
                  style: AppTextStyles.body2.copyWith(
                    color: AppColors.textTertiary,
                  ),
                ),
              )
            else
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: viewModel.attachments.length,
                separatorBuilder: (context, index) => const SizedBox(height: 8),
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(
                      viewModel.attachments[index],
                      style: AppTextStyles.body2,
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => viewModel.removeAttachment(index),
                    ),
                  );
                },
              ),
            const SizedBox(height: 16),
            CustomButton(
              text: 'Add Attachment',
              onPressed: viewModel.addAttachment,
              type: ButtonType.outline,
            ),
          ],
        ),
      ),
    );
  }

  @override
  ConsultationFormViewModel viewModelBuilder(BuildContext context) =>
      ConsultationFormViewModel();

  @override
  void onViewModelReady(ConsultationFormViewModel viewModel) =>
      viewModel.setConsultationId(consultationId);
}
