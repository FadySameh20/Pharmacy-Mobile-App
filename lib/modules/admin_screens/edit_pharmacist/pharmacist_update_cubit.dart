import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmacy_management_system/modules/admin_screens/edit_pharmacist/pharmacist_update_state.dart';

import '../../../models/pharmacist_model/pharmacist_model.dart';
import '../../../models/pharmacy_model/pharmacy_model.dart';

class PharmacistUpdateCubit extends Cubit<PharmacistUpdateState> {
  PharmacistUpdateCubit() : super(InitialPharmacistUpdateState());

  static PharmacistUpdateCubit get(context) => BlocProvider.of(context);
  PharmacyModel? selectedPharmacy;
  setSelectedPharmacy(pharmacyModel) {
    selectedPharmacy = pharmacyModel;
    emit(SetCertainPharmacyState());
  }

  void toggleVisibility() {
    isHidden = !isHidden;
    isHidden == false
        ? visibleIcon = Icons.visibility_off
        : visibleIcon = Icons.visibility;
    emit(ToggleVisibilityAdminHomeState());
  }

  bool isHidden = true;
  IconData visibleIcon = Icons.visibility;

  List<PharmacyModel> availablePharmacies = [];
  getPharmacies() async {
    emit(LoadingPharmaciesAdminHomeState());
    await FirebaseFirestore.instance
        .collection("pharmacies")
        .get()
        .then((value) {
      for (var element in value.docs) {
        availablePharmacies.add(PharmacyModel.fromJson(element.data()));
      }
      emit(SuccessPharmaciesAdminHomeState());
    }).catchError((onError) {
      emit(ErrorPharmaciesAdminHomeState());
    });
  }

  typing() {
    emit(TypingPharmacistState());
  }

  setControllers(
      nameController, emailController, phoneController, pharmacistModel) {
    nameController.text = pharmacistModel.name;
    phoneController.text = pharmacistModel.phone;
    emailController.text = pharmacistModel.email;
    emit(SetControllersPharmacistUpdateCubit());
  }

  deletePharmacist(pharmacistId) async {
    await FirebaseFirestore.instance
        .collection("pharmacists")
        .doc(pharmacistId)
        .delete()
        .then((value) {
      emit(SuccessDeletePharmacistState());
    }).catchError((onError) {
      emit(ErrorDeletePharmacistState());
    });
  }

  addPharmacist(PharmacistModel pharmacistModel, pass) async {
    String? id;
    FirebaseApp app = await Firebase.initializeApp(
        name: 'Secondary', options: Firebase.app().options);
    try {
      FirebaseAuth.instanceFor(app: app)
          .createUserWithEmailAndPassword(
              email: pharmacistModel.email.toString(), password: pass)
          .then((value) async {
        id = FirebaseAuth.instanceFor(app: app).currentUser!.uid;

        pharmacistModel.pharmacistId = id;

        await FirebaseFirestore.instance
            .collection("pharmacists")
            .doc(id)
            .set(pharmacistModel.toMap())
            .then((value) {
          emit(SuccessAddPharmacistState());
        }).catchError((onError) {
          emit(ErrorAddPharmacistState());
        });
      });
    } on FirebaseAuthException {
      return false;
    }
  }

  updatePharmacist(PharmacistModel pharmacistModel) async {
    Map<String, dynamic> toMap = {};
    toMap["name"] = pharmacistModel.name;
    toMap["phone"] = pharmacistModel.phone;
    toMap["email"] = pharmacistModel.email;
    toMap["pharmacyId"] = pharmacistModel.pharmacyId;

    await FirebaseFirestore.instance
        .collection("pharmacists")
        .doc(pharmacistModel.pharmacistId)
        .update(toMap)
        .then((value) {
      emit(SuccessUpdatePharmacistState());
    }).catchError((onError) {
      emit(ErrorUpdatePharmacistState());
    });
  }
}
