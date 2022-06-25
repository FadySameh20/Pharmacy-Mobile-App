import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmacy_management_system/modules/customer_screens/payments_screen/payment_screen_state.dart';

class PaymentCubit extends Cubit<PaymentState> {
  PaymentCubit() : super(InitialPaymentState());

  static PaymentCubit get(context) => BlocProvider.of(context);
  // List<ItemPharmacyModel> userCart = [];
  // setCart(mycart) async {
  //   userCart = List.from(mycart);
  //   print(userCart);
  //   // var test = await CacheHelper.getData("mycart") ?? false;
  //   // if (test == true) {
  //   //   final String cartString = await CacheHelper.getData('mycart');
  //   //   userCart = ItemPharmacyModel.decode(cartString);

  //   //   print(userCart[0].item);
  //   // }
  // }
  int totalPrice = 0;
  returnTotalCost(userCart) {
    for (var i in userCart) {
      int price = i.price;
      // print(i.price);
      // print(i.quantity);
      int quantity = i.quantity;
      totalPrice += price * quantity;
    }
  }
}
