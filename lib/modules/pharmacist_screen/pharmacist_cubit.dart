import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmacy_management_system/models/customer_model/customer_model.dart';
import 'package:pharmacy_management_system/models/order_model/order_model.dart';
import 'package:pharmacy_management_system/models/pharmacist_model/pharmacist_model.dart';
import 'package:pharmacy_management_system/models/pharmacy_model/pharmacy_model.dart';
import 'package:pharmacy_management_system/modules/orders_screen/order_screen.dart';
import 'package:pharmacy_management_system/modules/pharmacist_screen/pharmacist_states.dart';
import 'package:pharmacy_management_system/modules/pharmcist_profile/pharmacist_profile_screen.dart';

import '../pharmacy_medicines/pharmacy_medicines_screen.dart';

class PharmacistCubit extends Cubit<PharmacistState> {
  PharmacistCubit() : super(InitialPharmacistState());

  int screenIndex = 0;
  List screens = [
    const PharmacyMedicines(),
    const OrderScreen(),
    PharmacistProfileScreen()
  ];

  static PharmacistCubit get(context) => BlocProvider.of(context);

  setIndex(index) {
    screenIndex = index;
    emit(ChangeNavBarPharmacist());
  }

  changeNavBar(index) {
    screenIndex = index;
    emit(SuccessChangeNavBar());
  }

  getData() async {
    await getPharmacistData();
    await getItems();
    await getOrders();
    await getCustomers();
  }

  deleteFromOrders(OrderModel orderModel) async {
    await FirebaseFirestore.instance
        .collection("orders")
        .doc(orderModel.orderId)
        .delete()
        .then((value) async {
      emit(SuccessDeleteFromOrders());
      await getOrders();
    }).catchError((onError) {
      emit(ErrorDeleteFromOrders());
    });
  }

  PharmacistModel? pharmacistModel;
  PharmacyModel? pharmacyModel;
  getPharmacistData() async {
    final User? user = FirebaseAuth.instance.currentUser;
    final pharmacistId = user!.uid;
    await FirebaseFirestore.instance
        .collection('pharmacists')
        .doc(pharmacistId)
        .get()
        .then((value) {
      pharmacistModel =
          PharmacistModel.fromJson(value.data() as Map<String, dynamic>);
      emit(SuccessPharmacistDataState());
    }).catchError((onError) {
      emit(ErrorPharmacistDataState());
    });
  }

  getItems() async {
    await FirebaseFirestore.instance
        .collection('pharmacies')
        .doc(pharmacistModel!.pharmacyId)
        .get()
        .then((value) {
      pharmacyModel =
          PharmacyModel.fromJson(value.data() as Map<String, dynamic>);
    });
  }

  List<CustomerModel> customers = [];
  getCustomers() async {
    await FirebaseFirestore.instance
        .collection("customers")
        .get()
        .then((value) {
      for (var element in value.docs) {
        customers.add(CustomerModel.fromJson(element.data()));
      }
    });
  }

  getCustomerFromCustomerId(custId) {
    for (int i = 0; i < customers.length; i++) {
      if (customers[i].uid == custId) {
        return customers[i];
      }
    }
  }

  List<OrderModel> orders = [];
  getOrders() async {
    await FirebaseFirestore.instance.collection("orders").get().then((value) {
      orders = [];
      for (var element in value.docs) {
        if (element["pharmacyId"] == pharmacistModel!.pharmacyId) {
          orders.add(OrderModel.fromJson(element.data()));
          print(element.data());
        }
      }
    }).then((value) {
      emit(SuccessOrdersPharmacistState());
    }).catchError((onError) {
      emit(ErrorOrdersPharmacistState());
    });
  }
}
