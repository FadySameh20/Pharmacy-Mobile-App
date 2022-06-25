import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmacy_management_system/modules/admin_screens/adminhomescreen/adminhomecubit.dart';
import 'package:pharmacy_management_system/modules/admin_screens/edit_pharmacy/pharmacy_update_state.dart';

import '../../../models/pharmacy_model/pharmacy_model.dart';

class PharmacyUpdateCubit extends Cubit<PharmacyUpdateState> {
  PharmacyUpdateCubit() : super(InitialPharmacyUpdateState());

  static PharmacyUpdateCubit get(context) => BlocProvider.of(context);

  typing() {
    emit(TypingPharmacyState());
  }

  setControllers(name, address, description, phone, pharmacyModel) {
    name.text = pharmacyModel.name;
    address.text = pharmacyModel.address;
    description.text = pharmacyModel.description;
    phone.text = pharmacyModel.phone;
    emit(SetControllersPharmacyUpdateCubit());
  }

  addPharmacy(PharmacyModel pharmacyModel) async {
    String id = FirebaseFirestore.instance.collection('pharmacies').doc().id;
    pharmacyModel.pharmacyid = id;
    await FirebaseFirestore.instance
        .collection('pharmacies')
        .doc(id)
        .set(pharmacyModel.toMap())
        .then((value) {
      emit(SuccessAddPharmacyState());
    }).catchError((onError) {
      emit(ErrorPharmacyUpdateState());
    });
  }

  deletePharmacy(pharmacyId, context) async {
    int tempPharmacists = 0;
    int tempOrders = 0;
    await FirebaseFirestore.instance
        .collection("pharmacists")
        .get()
        .then((value) {
      value.docs.forEach((element) {
        if (element["pharmacyId"] == pharmacyId) {
          tempPharmacists += 1;
        }
      });
    });
    await FirebaseFirestore.instance.collection("orders").get().then((value) {
      value.docs.forEach((element) {
        if (element["pharmacyId"] == pharmacyId) {
          tempOrders += 1;
        }
      });
    });
    if (tempPharmacists == 0 && tempOrders == 0) {
      await FirebaseFirestore.instance
          .collection("pharmacies")
          .doc(pharmacyId)
          .delete()
          .then((value) {
        emit(SuccessDeletePharmacyState());
      }).catchError((error) {
        emit(ErrorDeletePharmacyState());
      });
    } else {
      if (tempPharmacists != 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                  'Cant delete this pharmacy!! Please move ${tempPharmacists.toString()} Pharmacists to another Pharmacy')),
        );
      }
      if (tempOrders != 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                  'Cant delete this pharmacy!! Please make the pharmacists accept remaining ${tempOrders.toString()} order(s)')),
        );
      }
    }
  }

  updatePharmacy(PharmacyModel pharmacyModel) async {
    Map<String, dynamic> toMap = {};
    toMap["name"] = pharmacyModel.name;
    toMap["address"] = pharmacyModel.address;
    toMap["description"] = pharmacyModel.description;
    toMap["phone"] = pharmacyModel.phone;
    await FirebaseFirestore.instance
        .collection("pharmacies")
        .doc(pharmacyModel.pharmacyid)
        .update(toMap)
        .then((value) {
      emit(SuccessPharmacyUpdateState());
    }).catchError((error) {
      emit(ErrorPharmacyUpdateState());
    });
  }
}
