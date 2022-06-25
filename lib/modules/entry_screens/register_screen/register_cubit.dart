import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmacy_management_system/models/customer_model/customer_model.dart';
import 'package:pharmacy_management_system/modules/entry_screens/register_screen/register_state.dart';

class RegisterCubit extends Cubit<RegisterState> {
  RegisterCubit() : super(InitialRegisterState());

  static RegisterCubit get(context) => BlocProvider.of(context);

  bool isHidden = true;
  IconData visibleIcon = Icons.visibility;

  void toggleVisibility() {
    isHidden = !isHidden;
    isHidden == false
        ? visibleIcon = Icons.visibility_off
        : visibleIcon = Icons.visibility;
    emit(ToggleVisibilityRegisterState());
  }

  bool getIsVisible() {
    return isHidden;
  }

  IconData getVisibility() {
    return visibleIcon;
  }

  createUser(name, email, password, phoneNum) async {
    await FirebaseAuth.instance
        .fetchSignInMethodsForEmail(email)
        .then((value) async {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((value) async => await addUser(name, email, password, phoneNum))
          .catchError((onError) {
        emit(ErrorRegisterState("The email address is already in use"));
      });
    }).catchError((onError) {});
  }

  addUser(name, email, password, phoneNum) async {
    final User? userInstance = FirebaseAuth.instance.currentUser;
    final uid = userInstance!.uid;
    CustomerModel user = CustomerModel(name, email, phoneNum, uid);
    await FirebaseFirestore.instance
        .collection('customers')
        .doc(uid)
        .set(user.toMap())
        .then((value) => emit(SuccessRegisterState(uid)))
        .catchError((onError) {
      emit(ErrorRegisterState("An error occured"));
    });
  }
}
