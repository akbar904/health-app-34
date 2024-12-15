import 'package:stacked/stacked_annotations.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:my_app/features/auth/login/login_view.dart';
import 'package:my_app/features/auth/register/register_view.dart';
import 'package:my_app/features/dashboard/dashboard_view.dart';
import 'package:my_app/features/patients/patient_list/patient_list_view.dart';
import 'package:my_app/features/patients/patient_details/patient_details_view.dart';
import 'package:my_app/features/consultation/consultation_form/consultation_form_view.dart';
import 'package:my_app/features/consultation/consultation_history/consultation_history_view.dart';
import 'package:my_app/features/profile/profile_view.dart';
import 'package:my_app/services/api_service.dart';
import 'package:my_app/services/auth_service.dart';
import 'package:my_app/services/validation_service.dart';
import 'package:my_app/services/storage_service.dart';
import 'package:my_app/repositories/auth_repository.dart';
import 'package:my_app/repositories/patient_repository.dart';
import 'package:my_app/repositories/consultation_repository.dart';
import 'package:my_app/ui/dialogs/confirmation_dialog.dart';
import 'package:my_app/ui/dialogs/error_dialog.dart';
import 'package:my_app/ui/bottom_sheets/sort_sheet.dart';
import 'package:my_app/ui/bottom_sheets/filter_sheet.dart';

@StackedApp(
  routes: [
    MaterialRoute(page: LoginView, initial: true),
    MaterialRoute(page: RegisterView),
    MaterialRoute(page: DashboardView),
    MaterialRoute(page: PatientListView),
    MaterialRoute(page: PatientDetailsView),
    MaterialRoute(page: ConsultationFormView),
    MaterialRoute(page: ConsultationHistoryView),
    MaterialRoute(page: ProfileView),
  ],
  dependencies: [
    InitializableSingleton(classType: AuthService),
    InitializableSingleton(classType: ApiService),
    InitializableSingleton(classType: StorageService),
    LazySingleton(classType: NavigationService),
    LazySingleton(classType: DialogService),
    LazySingleton(classType: BottomSheetService),
    LazySingleton(classType: ValidationService),
    LazySingleton(classType: AuthRepository),
    LazySingleton(classType: PatientRepository),
    LazySingleton(classType: ConsultationRepository),
  ],
  dialogs: [
    StackedDialog(classType: ConfirmationDialog),
    StackedDialog(classType: ErrorDialog),
  ],
  bottomsheets: [
    StackedBottomsheet(classType: SortSheet),
    StackedBottomsheet(classType: FilterSheet),
  ],
)
class App {}
