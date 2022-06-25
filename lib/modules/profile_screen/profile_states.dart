abstract class ProfileState {}

class InitialProfileState extends ProfileState {}

class ToggleVisibilityNewPasswordProfileState extends ProfileState {}

class ToggleVisibilityCurrentPasswordProfileState extends ProfileState {}

class UpdateControllerProfileState extends ProfileState {}

class ErrorInUserUpdate extends ProfileState {}

class SuccessUserUpdate extends ProfileState {}

class SuccessPasswordChange extends ProfileState {}

class ErrorPasswordChange extends ProfileState {}
