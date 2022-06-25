import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmacy_management_system/models/pharmacist_model/pharmacist_model.dart';
import 'package:pharmacy_management_system/modules/pharmcist_profile/pharmacist_profile_states.dart';

import '../pharmacist_screen/pharmacist_cubit.dart';

class PharmacistProfieCubit extends Cubit<PharmacistProfileState> {
  PharmacistProfieCubit() : super(InitialPharmacistProfileState());

  static PharmacistProfieCubit get(context) => BlocProvider.of(context);

  PharmacistModel? pharmacistModel;
  bool isCurrentPasswordHidden = true;
  IconData currentPassIcon = Icons.visibility;
  bool isNewPasswordHidden = true;
  IconData newPassIcon = Icons.visibility;
  bool isEnable = false;

  typing() {
    emit(Typing());
  }

  setController(context, nameController, phoneController,
      currentPasswordController, newPasswordController) {
    nameController.text = PharmacistCubit.get(context).pharmacistModel!.name;
    phoneController.text = PharmacistCubit.get(context).pharmacistModel!.phone;
    currentPasswordController = "";
    newPasswordController = "";
    emit(UpdateControllerProfileState());
  }

  togglePasswordVisibility(option) {
    if (option == 0) {
      isCurrentPasswordHidden = !isCurrentPasswordHidden;
      currentPassIcon = isCurrentPasswordHidden == true
          ? Icons.visibility
          : Icons.visibility_off;
      emit(ToggleVisibilityCurrentPasswordProfileState());
    } else {
      isNewPasswordHidden = !isNewPasswordHidden;
      newPassIcon =
          isNewPasswordHidden == true ? Icons.visibility : Icons.visibility_off;
      emit(ToggleVisibilityNewPasswordProfileState());
    }
  }

  performUpdate(context, currentPass, newPass, name, phone) async {
    if (currentPass.text.isNotEmpty && newPass.text.isNotEmpty) {
      final User? user = FirebaseAuth.instance.currentUser;
      final cred = EmailAuthProvider.credential(
          email: PharmacistCubit.get(context).pharmacistModel!.email.toString(),
          password: currentPass.text);

      user!.reauthenticateWithCredential(cred).then((value) {
        user.updatePassword(newPass.text).then((value_) {
          emit(SuccessPasswordChange());
        }).catchError((error) {});
      }).catchError((err) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('${currentPass.text} is Incorrect Password')));
        emit(ErrorPasswordChange());
      });
    }
    Map<String, dynamic> toUpdate = {};
    if (name.text.isNotEmpty) {
      toUpdate['name'] = name.text;
    }
    if (phone.text.isNotEmpty) {
      toUpdate['phone'] = phone.text;
    }
    if (toUpdate.isNotEmpty) {
      FirebaseFirestore.instance
          .collection("pharmacists")
          .doc(PharmacistCubit.get(context).pharmacistModel!.pharmacistId)
          .update(toUpdate)
          .then((value) {
        PharmacistCubit.get(context).getData();
        emit(SuccessUserUpdate());
      }).catchError((onError) {
        emit(ErrorInUserUpdate());
      });
    }
  }

  get_Pharmacist() async {
    emit(LoadingPharmacistDataHomeState());
    pharmacistModel!.pharmacistId = FirebaseAuth.instance.currentUser!.uid;
    await FirebaseFirestore.instance
        .collection('pharmacists')
        .doc(pharmacistModel!.pharmacistId)
        .get()
        .then((value) {
      pharmacistModel = PharmacistModel.fromJson(value as Map<String, dynamic>);
    }).then((value) {
      emit(SuccessPharmacistDataHomeState());
    }).catchError((onError) {
      emit(ErrorPharmacistDataHomeState());
    });
  }
}
