import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmacy_management_system/modules/entry_screens/login_screen/login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(InitialLoginState());

  static LoginCubit get(context) => BlocProvider.of(context);

  bool isHidden = true;
  IconData visibleIcon = Icons.visibility;

  toggleVisibility() {
    isHidden = !isHidden;
    isHidden == false
        ? visibleIcon = Icons.visibility_off
        : visibleIcon = Icons.visibility;
    emit(ToggleVisibilityLoginState());
  }

  getIsHidden() {
    return isHidden;
  }

  getIcon() {
    return visibleIcon;
  }

  login(email, password) async {
    await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password)
        .then((value) => emit(SuccessLoginState(value.user!.uid)))
        .catchError((onError) {
      emit(ErrorLoginState("Unable to login"));
    });
  }
}
