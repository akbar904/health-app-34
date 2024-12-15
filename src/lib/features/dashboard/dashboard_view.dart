import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:my_app/core/constants/app_colors.dart';
import 'package:my_app/core/constants/app_text_styles.dart';
import 'package:my_app/features/dashboard/dashboard_viewmodel.dart';
import 'package:my_app/widgets/loading_overlay.dart';

class DashboardView extends StackedView<DashboardViewModel> {
  const DashboardView({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    DashboardViewModel viewModel,
    Widget? child,
  ) {
    return LoadingOverlay(
      isLoading: viewModel.isBusy,
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: CustomScrollView(
            slivers: [
              SliverAppBar(
                floating: true,
                backgroundColor: AppColors.surface,
                title: Text(
                  'Dashboard',
                  style: AppTextStyles.h5,
                ),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.notifications_outlined),
                    onPressed: viewModel.showNotifications,
                  ),
                ],
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildWelcomeSection(viewModel),
                      const SizedBox(height: 24),
                      _buildQuickActions(viewModel),
                      const SizedBox(height: 24),
                      _buildStatisticsSection(viewModel),
                      const SizedBox(height: 24),
                      _buildRecentConsultations(viewModel),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: viewModel.currentIndex,
          onTap: viewModel.setIndex,
          selectedItemColor: AppColors.primary,
          unselectedItemColor: AppColors.textTertiary,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.dashboard_outlined),
              label: 'Dashboard',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.people_outline),
              label: 'Patients',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.calendar_today),
              label: 'Schedule',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWelcomeSection(DashboardViewModel viewModel) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Welcome back,\nDr. ${viewModel.doctorName}',
            style: AppTextStyles.h4.copyWith(color: Colors.white),
          ),
          const SizedBox(height: 16),
          Text(
            'You have ${viewModel.todayAppointments} appointments today',
            style: AppTextStyles.body1.copyWith(color: Colors.white70),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions(DashboardViewModel viewModel) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      children: [
        _actionCard(
          'Add Patient',
          Icons.person_add_outlined,
          viewModel.navigateToAddPatient,
        ),
        _actionCard(
          'New Consultation',
          Icons.medical_services_outlined,
          viewModel.navigateToNewConsultation,
        ),
        _actionCard(
          'Patient List',
          Icons.people_outline,
          viewModel.navigateToPatientList,
        ),
        _actionCard(
          'History',
          Icons.history,
          viewModel.navigateToConsultationHistory,
        ),
      ],
    );
  }

  Widget _actionCard(String title, IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 32,
              color: AppColors.primary,
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: AppTextStyles.subtitle2,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatisticsSection(DashboardViewModel viewModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Statistics',
          style: AppTextStyles.h6,
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _statisticCard(
                'Total Patients',
                viewModel.totalPatients.toString(),
                Icons.people,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _statisticCard(
                'Today\'s Consultations',
                viewModel.todayConsultations.toString(),
                Icons.calendar_today,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _statisticCard(String title, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            color: AppColors.primary,
            size: 24,
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: AppTextStyles.h4,
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentConsultations(DashboardViewModel viewModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Recent Consultations',
              style: AppTextStyles.h6,
            ),
            TextButton(
              onPressed: viewModel.navigateToConsultationHistory,
              child: Text(
                'View All',
                style: AppTextStyles.button.copyWith(
                  color: AppColors.primary,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        if (viewModel.recentConsultations.isEmpty)
          Center(
            child: Text(
              'No recent consultations',
              style: AppTextStyles.body2.copyWith(
                color: AppColors.textTertiary,
              ),
            ),
          )
        else
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: viewModel.recentConsultations.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final consultation = viewModel.recentConsultations[index];
              return ListTile(
                onTap: () => viewModel.navigateToConsultationDetails(
                  consultation.id,
                ),
                tileColor: AppColors.surface,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(color: AppColors.border),
                ),
                title: Text(
                  consultation.patientName,
                  style: AppTextStyles.subtitle1,
                ),
                subtitle: Text(
                  consultation.diagnosis,
                  style: AppTextStyles.body2.copyWith(
                    color: AppColors.textSecondary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                trailing: Icon(
                  Icons.chevron_right,
                  color: AppColors.textTertiary,
                ),
              );
            },
          ),
      ],
    );
  }

  @override
  DashboardViewModel viewModelBuilder(BuildContext context) =>
      DashboardViewModel();
}
