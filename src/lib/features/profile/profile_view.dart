import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:my_app/core/constants/app_colors.dart';
import 'package:my_app/core/constants/app_text_styles.dart';
import 'package:my_app/features/profile/profile_viewmodel.dart';
import 'package:my_app/widgets/custom_button.dart';
import 'package:my_app/widgets/custom_text_field.dart';
import 'package:my_app/widgets/loading_overlay.dart';

class ProfileView extends StackedView<ProfileViewModel> {
  const ProfileView({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    ProfileViewModel viewModel,
    Widget? child,
  ) {
    return LoadingOverlay(
      isLoading: viewModel.isBusy,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Profile', style: AppTextStyles.h6),
          actions: [
            if (!viewModel.isEditing)
              IconButton(
                icon: const Icon(Icons.edit),
                onPressed: viewModel.toggleEdit,
              )
            else
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: viewModel.toggleEdit,
              ),
          ],
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildProfileHeader(viewModel),
              const SizedBox(height: 32),
              if (viewModel.isEditing)
                _buildEditForm(viewModel)
              else
                _buildProfileInfo(viewModel),
              const SizedBox(height: 32),
              _buildActions(viewModel),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileHeader(ProfileViewModel viewModel) {
    return Column(
      children: [
        Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.primary.withOpacity(0.1),
          ),
          child: Center(
            child: Text(
              '${viewModel.currentUser?.firstName[0]}${viewModel.currentUser?.lastName[0]}',
              style: AppTextStyles.h2.copyWith(
                color: AppColors.primary,
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        if (!viewModel.isEditing) ...[
          Text(
            '${viewModel.currentUser?.firstName} ${viewModel.currentUser?.lastName}',
            style: AppTextStyles.h4,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            viewModel.currentUser?.specialization ?? '',
            style: AppTextStyles.body1.copyWith(
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ],
    );
  }

  Widget _buildEditForm(ProfileViewModel viewModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        CustomTextField(
          label: 'First Name',
          controller: viewModel.firstNameController,
          errorText: viewModel.firstNameError,
        ),
        const SizedBox(height: 16),
        CustomTextField(
          label: 'Last Name',
          controller: viewModel.lastNameController,
          errorText: viewModel.lastNameError,
        ),
        const SizedBox(height: 16),
        CustomTextField(
          label: 'Specialization',
          controller: viewModel.specializationController,
          errorText: viewModel.specializationError,
        ),
        const SizedBox(height: 16),
        CustomTextField(
          label: 'Phone Number',
          controller: viewModel.phoneNumberController,
          errorText: viewModel.phoneError,
          keyboardType: TextInputType.phone,
        ),
        const SizedBox(height: 24),
        CustomButton(
          text: 'Save Changes',
          onPressed: viewModel.saveProfile,
        ),
      ],
    );
  }

  Widget _buildProfileInfo(ProfileViewModel viewModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildInfoTile(
          'Email',
          viewModel.currentUser?.email ?? '',
          Icons.email_outlined,
        ),
        _buildInfoTile(
          'Phone',
          viewModel.currentUser?.phoneNumber ?? '',
          Icons.phone_outlined,
        ),
        _buildInfoTile(
          'Specialization',
          viewModel.currentUser?.specialization ?? '',
          Icons.medical_services_outlined,
        ),
        _buildInfoTile(
          'License Number',
          viewModel.currentUser?.licenseNumber ?? '',
          Icons.badge_outlined,
        ),
      ],
    );
  }

  Widget _buildInfoTile(String title, String value, IconData icon) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: AppColors.primary,
            size: 24,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: AppTextStyles.body1,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActions(ProfileViewModel viewModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (!viewModel.isEditing) ...[
          CustomButton(
            text: 'Change Password',
            onPressed: viewModel.changePassword,
            type: ButtonType.outline,
          ),
          const SizedBox(height: 16),
          CustomButton(
            text: 'Logout',
            onPressed: viewModel.logout,
            type: ButtonType.secondary,
          ),
        ],
      ],
    );
  }

  @override
  ProfileViewModel viewModelBuilder(BuildContext context) => ProfileViewModel();

  @override
  void onViewModelReady(ProfileViewModel viewModel) => viewModel.init();
}
