abstract class CheckOutState {}

class InitialCheckOutState extends CheckOutState {}

class OrderSuccessCheckOutState extends CheckOutState {}

class OrderErrorCheckOutState extends CheckOutState {}

class QuantityNotAvailableState extends CheckOutState {}
