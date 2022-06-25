abstract class PharmacyUpdateState {}

class InitialPharmacyUpdateState extends PharmacyUpdateState {}

class SuccessPharmacyUpdateState extends PharmacyUpdateState {}

class ErrorPharmacyUpdateState extends PharmacyUpdateState {}

class SuccessDeletePharmacyState extends PharmacyUpdateState {}

class ErrorDeletePharmacyState extends PharmacyUpdateState {}

class TypingPharmacyState extends PharmacyUpdateState {}

class SetControllersPharmacyUpdateCubit extends PharmacyUpdateState {}

class SuccessAddPharmacyState extends PharmacyUpdateState {}

class ErrorAddPharmacyState extends PharmacyUpdateState {}
