abstract class AppStates {}
//// --------- MAIN APP --------
class AppInitialState extends AppStates {}
class AppChangeModeState extends AppStates {}
class ChangeeWakeUpOrSleepTime extends AppStates {}
class GettingGeneralDataLoading extends AppStates {}
class RetrieveGeneralDataFromDatabase extends AppStates {}
class UpdateGeneralUserSettingsLoading extends AppStates {}
class CalcLeftPriceState extends AppStates {}
class GetTotalPriceState extends AppStates {}

class UpdateGeneralUserSettings extends AppStates {}
class AppChangeBottomNavState extends AppStates {}

// Login
class AppLoginSuccessState extends AppStates {
  final String uId;
  AppLoginSuccessState(this.uId);
}
class AppLoginLoadingState extends AppStates {}
class AppLangChangedState extends AppStates {}
class AppLoginErrorState extends AppStates {
  late final String error;
  AppLoginErrorState(this.error);
}
// Get User Data
class GetUserDataSuccessState extends AppStates {
}
class GetUserDataLoadingState extends AppStates {}
class GetUserDataErrorState extends AppStates {
  late final String error;
  GetUserDataErrorState(this.error);
}

class UpdatetUserDataLoadingState extends AppStates {
}
class UpdatetUserDataSuccessState extends AppStates {}
class UpdatetUserDataErrorState extends AppStates {
  late final String error;
  UpdatetUserDataErrorState(this.error);
}

// Register
class AppRegisterSuccessState extends AppStates {}
class AppRegisterErrorState extends AppStates {
  late final String error;
  AppRegisterErrorState(this.error);
}

class ChangePasswordVisibilityState extends AppStates {}
class SignoutLoading extends AppStates {}
class SignoutSuccessful extends AppStates {}
class GettingClientsLoading extends AppStates {}
class GettingClientsDone extends AppStates {}
class GettingUsersLoading extends AppStates {}
class GettinUsersDone extends AppStates {}
class GettingClientDataLoading extends AppStates {}
class GettinClientDataDone extends AppStates {}
class UpdateClientDataSuccessfully extends AppStates {}
class UpdateClientDataFailer extends AppStates {}

class SearchClientLoadingState extends AppStates {}
class SearchClientSuccessState extends AppStates {}
class RetrieveClientDataFromDatabase extends AppStates {}
class SearchClientErrorState extends AppStates {}
class GettingInstallmentsLoading extends AppStates {}
class GettingInstallmentsDone extends AppStates {}

