import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmacy_management_system/layouts/home_layout/home_states.dart';
import 'package:pharmacy_management_system/models/pharmacy_model/pharmacy_model.dart';
import 'package:pharmacy_management_system/modules/customer_screens/item_screen/item_screen.dart';

import '../../../models/item_model/item_model.dart';
import '../../../models/customer_model/customer_model.dart';
import '../../../modules/customer_screens/pharmacies_screen/pharmacies_screen.dart';
import '../../../modules/profile_screen/profile_screen.dart';

class HomeCubit extends Cubit<HomeStates> {
  HomeCubit() : super(InitialHomeState());

  static HomeCubit get(context) => BlocProvider.of(context);
  int screenIndex = 0;
  List screens = [ItemScreen(), PharmaciesScreen(), ProfileScreen()];

  CustomerModel? userData;
  List<ItemModel> items = [];
  List<PharmacyModel> pharmacies = [];
  List<PharmacyModel> suggestions = [];
  PharmacyModel? certainPharmacy;

  initiateSearch(value) async {
    if (value.length <= 2) {
      suggestions.clear();
      emit(ClearSearchHomeState());
    } else {
      emit(TypingSearchHomeState());

      await searchByName(value);
    }
  }

  getSuggestions() {
    return suggestions;
  }

  searchByName(String input) async {
    emit(LoadingSearchHomeState());

    await FirebaseFirestore.instance
        .collection('pharmacies')
        .get()
        .then((value) {
      suggestions.clear();
      for (var doc in value.docs) {
        if (doc["name"]
            .toString()
            .toLowerCase()
            .contains(input.toLowerCase())) {
          suggestions.add(PharmacyModel.fromJson(doc.data()));

          break;
        }
      }
    }).then((value) {
      emit(SuccessSearchHomeState());
    }).catchError((onError) {
      emit(ErrorSearchHomeState());
    });
    return suggestions;
  }

  List<PharmacyModel> returnPharmacies() {
    return pharmacies;
  }

  returnItems() {
    return items;
  }

  setCertainPharmacy(value) {
    for (int i = 0; i < pharmacies.length; i++) {
      if (pharmacies[i].name == value) {
        certainPharmacy = PharmacyModel(
            pharmacies[i].name,
            pharmacies[i].address,
            pharmacies[i].phone,
            pharmacies[i].description,
            pharmacies[i].items,
            pharmacies[i].pharmacyid);
      }
    }

    suggestions.clear();

    emit(SetCertainPharmacyState());
  }

  void setIndex(index) {
    screenIndex = index;
    emit(ChangeNavBarHomeState());
  }

  getUserData() {
    emit(LoadingUserDataHomeState());
    final User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      FirebaseFirestore.instance
          .collection('customers')
          .doc(user.uid)
          .get()
          .then((value) {
        userData = CustomerModel.fromJson(value.data() as Map<String, dynamic>);
      }).then((value) {
        emit(SuccessUserDataHomeState());
      }).catchError((onError) {
        emit(ErrorUserDataHomeState());
      });
    }
  }

  getItems() async {
    items = [];
    emit(LoadingItemsHomeState());
    await FirebaseFirestore.instance.collection("items").get().then((value) {
      for (var doc in value.docs) {
        items.add(ItemModel.fromJson(doc.data()));
      }
    }).then((value) {
      emit(SuccessItemsHomeState());
    }).catchError((onError) {
      emit(ErrorItemsHomeState());
    });
  }

  getData() async {
    await getUserData();
    await getItems();
    await getPharmacies();
    emit(AllDataReadyHomeState());
  }

  getPharmacies() async {
    pharmacies = [];
    emit(LoadingPharmacyHomeState());
    await FirebaseFirestore.instance
        .collection("pharmacies")
        .get()
        .then((value) {
      for (var doc in value.docs) {
        pharmacies.add(PharmacyModel.fromJson(doc.data()));
      }
    }).then((value) {
      emit(SuccessPharmacyHomeState());
    }).catchError((onError) {
      emit(ErrorPharmacyHomeState());
    });
  }
}
