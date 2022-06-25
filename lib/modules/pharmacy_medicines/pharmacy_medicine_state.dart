abstract class PharmacyMedicineState {}

class InitialPharmacyMedicineState extends PharmacyMedicineState {}

class LoadingPharmacyMedicineState extends PharmacyMedicineState {}

class TypingPharmacyMedicineState extends PharmacyMedicineState {}

class SuccessImagePharmacyMedicineState extends PharmacyMedicineState {}

class ErrorImagePharmacyMedicineState extends PharmacyMedicineState {}

class SuccessAddItemInItems extends PharmacyMedicineState {}

class ErrorAddItemInItems extends PharmacyMedicineState {}

class SuccessAddItemInPharmacy extends PharmacyMedicineState {}

class ErrorAddItemInPharmacy extends PharmacyMedicineState {}

class SetControllers extends PharmacyMedicineState {}

class SuccessUpdateState extends PharmacyMedicineState {}

class ErrorUpdateState extends PharmacyMedicineState {}
