import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmacy_management_system/layouts/home_layout/home_layout.dart';
import 'package:pharmacy_management_system/modules/admin_screens/adminhomescreen/adminhomestates.dart';
import 'package:pharmacy_management_system/modules/admin_screens/edit_pharmacist/pharmacist_edit.dart';
import 'package:pharmacy_management_system/modules/admin_screens/edit_pharmacy/pharmacy_edit.dart';
import 'package:pharmacy_management_system/modules/entry_screens/entry_screen.dart';
import 'package:pharmacy_management_system/shared/components/components.dart';

import '../../../layouts/home_layout/cubit/home_cubit.dart';
import '../../../models/pharmacist_model/pharmacist_model.dart';
import '../../../models/pharmacy_model/pharmacy_model.dart';

class AdminHomeCubit extends Cubit<AdminHomeState> {
  AdminHomeCubit() : super(InitialAdminHomeState());

  static AdminHomeCubit get(context) => BlocProvider.of(context);
  int screenIndex = 0;

  List screens = [const PharmacistEdit(), const PharmacyEdit(), const Center()];
  changeNavBar(index, context) {
    screenIndex = index;

    if (screenIndex == 2) {
      screenIndex = 0;
      FirebaseAuth.instance.signOut();
      navigateAndReplace(context, const EntryScreen());
      emit(SuccessAdminSignOut());
    }
    emit(ChangeNavBarAdminHomeState());
  }

  getPharmacyForCertainPharmacist(context, searchId) {
    for (int i = 0;
        i < AdminHomeCubit.get(context).availablePharmacies.length;
        i++) {
      if (searchId ==
          AdminHomeCubit.get(context).availablePharmacies[i].pharmacyid) {
        return AdminHomeCubit.get(context).availablePharmacies[i].name;
      }
    }
  }

  List<PharmacyModel> pharmacySuggestions = [];
  initiatePharmacySearch(searchKey) {
    pharmacySuggestions = [];
    for (int i = 0; i < availablePharmacies.length; i++) {
      print(searchKey);
      print(availablePharmacies[i].name);
      if (availablePharmacies[i]
          .name!
          .toLowerCase()
          .contains(searchKey.toLowerCase())) {
        print(pharmacySuggestions);
        pharmacySuggestions.add(PharmacyModel(
            availablePharmacies[i].name,
            availablePharmacies[i].address,
            availablePharmacies[i].phone,
            availablePharmacies[i].description,
            availablePharmacies[i].items,
            availablePharmacies[i].pharmacyid));
      }
    }
    print("Suggestions");
    emit(PharmacySearchAdminHomeState());
  }

  List<PharmacistModel> availablePharmacists = [];
  List<PharmacistModel> pharmacistSuggestions = [];
  initiatePharmacistSearch(searchKey) {
    pharmacistSuggestions = [];
    print("test");
    print(availablePharmacists.length);
    for (int i = 0; i < availablePharmacists.length; i++) {
      print(searchKey);
      print(availablePharmacists[i].name);
      if (availablePharmacists[i]
          .name!
          .toLowerCase()
          .contains(searchKey.toLowerCase())) {
        print(pharmacySuggestions);
        pharmacistSuggestions.add(PharmacistModel(
            availablePharmacists[i].name,
            availablePharmacists[i].email,
            availablePharmacists[i].pharmacyId,
            availablePharmacists[i].pharmacistId,
            availablePharmacists[i].phone));
      }
    }
    print("Suggestions");
    emit(PharmacistSearchAdminHomeState());
  }

  getPharmacists() async {
    await FirebaseFirestore.instance
        .collection("pharmacists")
        .get()
        .then((value) {
      availablePharmacists = [];
      pharmacistSuggestions = [];
      for (var element in value.docs) {
        availablePharmacists.add(PharmacistModel.fromJson(element.data()));
      }
      emit(SuccessPharmaciesAdminHomeState());
    }).catchError((onError) {
      emit(ErrorPharmacistAdminHomeState());
    });
  }

  List<PharmacyModel> availablePharmacies = [];
  getPharmacies() async {
    await FirebaseFirestore.instance
        .collection("pharmacies")
        .get()
        .then((value) {
      availablePharmacies = [];
      pharmacySuggestions = [];
      for (var element in value.docs) {
        availablePharmacies.add(PharmacyModel.fromJson(element.data()));
      }
      emit(SuccessPharmaciesAdminHomeState());
    }).catchError((onError) {
      emit(ErrorPharmaciesAdminHomeState());
    });
  }
}
