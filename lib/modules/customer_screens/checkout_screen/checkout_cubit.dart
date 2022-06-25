import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmacy_management_system/models/order_model/order_model.dart';
import 'package:pharmacy_management_system/shared/network/shared_preferences.dart';

import '../../../layouts/home_layout/cubit/home_cubit.dart';
import '../../../models/item_pharmacy_model/item_pharmacy_model.dart';
import '../../../models/pharmacy_model/pharmacy_model.dart';
import 'checkout_state.dart';

class CheckOutCubit extends Cubit<CheckOutState> {
  CheckOutCubit() : super(InitialCheckOutState());

  static CheckOutCubit get(context) => BlocProvider.of(context);
  List<ItemPharmacyModel> userCart = [];
  setCart(cart) {
    userCart = List.from(cart);
  }

  PharmacyModel? myPharmacy;
  getPharmacy(pharmacyId) async {
    await FirebaseFirestore.instance
        .collection("pharmacies")
        .doc(pharmacyId)
        .get()
        .then((value) {
      myPharmacy = PharmacyModel.fromJson(value.data() as Map<String, dynamic>);
    });
  }

  List<String> unavailableItems = [];
  addOrder(context, address, buildingNo, flatNo, date, pharmacyId) async {
    // print("h3yyyyt");
    // print(userCart.length);
    unavailableItems = [];
    await getPharmacy(pharmacyId);
    // print("hyayayaya");
    // print(myPharmacy!.items.length);
    int flag = 0;
    for (int i = 0; i < userCart.length; i++) {
      for (int j = 0; j < myPharmacy!.items.length; j++) {
        if (userCart[i].item == myPharmacy!.items[j].item) {
          if (myPharmacy!.items[j].quantity!.toInt() -
                  userCart[i].quantity!.toInt() <
              0) {
            // print("gowa");
            unavailableItems.add(userCart[i].item.toString());
            flag = 1;
          }
          int newPrice = myPharmacy!.items[j].quantity!.toInt() -
              userCart[i].quantity!.toInt();
          // print("b7sb");
          // print(userCart[i].item);
          // print(myPharmacy!.items[j].item);
          // print(userCart[i].quantity);
          // print(myPharmacy!.items[j].quantity);
          // print(newPrice);

          myPharmacy!.items[j].quantity = newPrice;

          // print("l index");

          break;
        }
      }
    }
    // indexes = [0, 1];
    // newQuantity = [4, 5];
    if (flag == 0) {
      final uid = FirebaseAuth.instance.currentUser!.uid;
      String id = FirebaseFirestore.instance.collection("orders").doc().id;
      OrderModel order = OrderModel(
          address, buildingNo, flatNo, pharmacyId, uid, date, userCart, id);
      // await FirebaseFirestore.instance.collection("pharmacies").doc("")
      // for (int i = 0; i < myPharmacy!.items.length; i++) {

      // String name = "quantity";
      await FirebaseFirestore.instance
          .collection('pharmacies')
          .doc(pharmacyId)
          // 'items'.$item.item':updated.item,'items.$item.quantity': updated.quantity,'items.$item.price':updated.price
          .update(myPharmacy!.itemstoMap());
      // }
      await FirebaseFirestore.instance
          .collection("orders")
          .doc(id)
          .set(order.toMap())
          .then((value) async {
        emit(OrderSuccessCheckOutState());
        await HomeCubit.get(context).getPharmacies();
        // await FirebaseFirestore.instance.collection("orders_items").add();
      }).catchError((error) {
        emit(OrderErrorCheckOutState());
      });
    } else {
      emit(QuantityNotAvailableState());
      // return unavailableItems;
    }
    await CacheHelper.removeData('mycart');
    await CacheHelper.removeData("mypharmacy");
  }
}
