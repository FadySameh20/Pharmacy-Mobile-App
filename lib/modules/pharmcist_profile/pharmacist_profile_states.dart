abstract class PharmacistProfileState {}

class InitialPharmacistProfileState extends PharmacistProfileState {}

class LoadingPharmacistDataHomeState extends PharmacistProfileState {}

class SuccessPharmacistDataHomeState extends PharmacistProfileState {}

class ErrorPharmacistDataHomeState extends PharmacistProfileState {}

class ToggleVisibilityNewPasswordProfileState extends PharmacistProfileState {}

class ToggleVisibilityCurrentPasswordProfileState
    extends PharmacistProfileState {}

class UpdateControllerProfileState extends PharmacistProfileState {}

class ErrorInUserUpdate extends PharmacistProfileState {}

class SuccessUserUpdate extends PharmacistProfileState {}

class SuccessPasswordChange extends PharmacistProfileState {}

class ErrorPasswordChange extends PharmacistProfileState {}

class Typing extends PharmacistProfileState {}
