abstract class PharmacistUpdateState {}

class InitialPharmacistUpdateState extends PharmacistUpdateState {}

class SetControllersPharmacistUpdateCubit extends PharmacistUpdateState {}

class TypingPharmacistState extends PharmacistUpdateState {}

class SuccessDeletePharmacistState extends PharmacistUpdateState {}

class ErrorDeletePharmacistState extends PharmacistUpdateState {}

class SuccessAddPharmacistState extends PharmacistUpdateState {}

class ErrorAddPharmacistState extends PharmacistUpdateState {}

class SuccessUpdatePharmacistState extends PharmacistUpdateState {}

class SetCertainPharmacyState extends PharmacistUpdateState {}

class ErrorUpdatePharmacistState extends PharmacistUpdateState {}

class SuccessPharmaciesAdminHomeState extends PharmacistUpdateState {}

class ErrorPharmaciesAdminHomeState extends PharmacistUpdateState {}

class LoadingPharmaciesAdminHomeState extends PharmacistUpdateState {}

class ToggleVisibilityAdminHomeState extends PharmacistUpdateState {}
