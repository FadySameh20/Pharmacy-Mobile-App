abstract class PharmacistState {}

class InitialPharmacistState extends PharmacistState {}

class SuccessChangeNavBar extends PharmacistState {}

class SuccessOrdersPharmacistState extends PharmacistState {}

class ErrorOrdersPharmacistState extends PharmacistState {}

class SuccessPharmacistDataState extends PharmacistState {}

class ErrorPharmacistDataState extends PharmacistState {}

class SuccessGetCustomerFromId extends PharmacistState {}

class ErrorGetCustomerFromId extends PharmacistState {}

class SuccessDeleteFromOrders extends PharmacistState {}

class ErrorDeleteFromOrders extends PharmacistState {}

class ChangeNavBarPharmacist extends PharmacistState {}
