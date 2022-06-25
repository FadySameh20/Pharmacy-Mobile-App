import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmacy_management_system/modules/profile_screen/profile_states.dart';
import '../../layouts/home_layout/cubit/home_cubit.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit() : super(InitialProfileState());

  static ProfileCubit get(context) => BlocProvider.of(context);
  bool isCurrentPasswordHidden = true;
  IconData currentPassIcon = Icons.visibility;
  bool isNewPasswordHidden = true;
  IconData newPassIcon = Icons.visibility;

  setController(context, nameController, phoneController) {
    print(HomeCubit.get(context).userData!.name);
    nameController.text = HomeCubit.get(context).userData!.name;
    phoneController.text = HomeCubit.get(context).userData!.phoneNum;
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
          email: HomeCubit.get(context).userData!.email.toString(),
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
          .collection("customers")
          .doc(HomeCubit.get(context).userData!.uid)
          .update(toUpdate)
          .then((value) {
        HomeCubit.get(context).getUserData();
        emit(SuccessUserUpdate());
      }).catchError((onError) {
        emit(ErrorInUserUpdate());
      });
    }
  }
}
