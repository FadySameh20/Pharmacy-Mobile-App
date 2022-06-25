import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmacy_management_system/models/pharmacy_model/pharmacy_model.dart';
import 'package:pharmacy_management_system/modules/search_screen/search_state.dart';

import '../../models/item_model/item_model.dart';

class SearchCubit extends Cubit<SearchState> {
  SearchCubit() : super(InitialSearchState());

  static SearchCubit get(context) => BlocProvider.of(context);

  List<ItemModel> suggestions = [];
  // List<String> pharmacies = [];
  List<PharmacyModel> pharmaciesModel = [];

  List getPharmaciesModel() {
    return pharmaciesModel;
  }

  searchForPharmacies(searchKey) async {
    suggestions.clear();
    emit(FindingPharmacySearchState());
    await FirebaseFirestore.instance
        .collection("pharmacies")
        .get()
        .then((value) {
      for (var doc in value.docs) {
        for (var docu in doc["items"]) {
          if (docu["item"] == searchKey) {
            pharmaciesModel.add(PharmacyModel.fromJson(doc.data()));
            break;
          }
        }
      }
    }).then((value) {
      emit(SuccessPharmacySearchState());
    }).catchError((onError) {
      emit(ErrorPharmacySearchState());
    });
    // await FirebaseFirestore.instance
    //     .collection("pharmacies")
    //     .get()
    //     .then((value) {
    //   for (var doc in value.docs) {
    //     if (pharmacies.contains(doc.id)) {
    //       pharmaciesModel.add(PharmacyModel.fromJson(doc.data()));
    //     }
    //   }
    // }).then((value) {
    //   emit(SuccessPharmaciesDetailSearchState());
    // }).catchError((onError) {
    //   emit(ErrorPharmaciesDetailSearchState());
    // });
  }

  getSuggestions() {
    return suggestions;
  }

  initiateSearch(value, {option = 1}) async {
    // print(value);
    // pharmacies.clear();
    pharmaciesModel.clear();
    if (value.length == 0) {
      suggestions = [];
      emit(ClearSearchState());
    } else {
      emit(TypingMedicineSearchState());
      if (option == 1) {
        await searchByName(value);
      } else {
        // print("ya rab");
        await searchForSuggestedPharmacies(value);
      }
    }
  }

  searchForSuggestedPharmacies(searchKey) async {
    emit(FindingPharmacySearchState());
    await FirebaseFirestore.instance
        .collection("pharmacies")
        .get()
        .then((value) {
      pharmaciesModel.clear();
      for (var element in value.docs) {
        // print(element['name'].toString().toLowerCase());
        // print(searchKey.toString().toLowerCase());
        // print(element['name']
        //     .toString()
        //     .toLowerCase()
        //     .contains(searchKey.toString().toLowerCase()));
        if (element['name']
            .toString()
            .toLowerCase()
            .contains(searchKey.toString().toLowerCase())) {
          pharmaciesModel.add(PharmacyModel.fromJson(element.data()));
          // print("ya rabbbbb");
          // print(pharmaciesModel[0].name);
          // print(pharmaciesModel.length);
        }
      }
    }).then((value) {
      emit(SuccessPharmacySearchState());
    }).catchError((onError) {
      emit(ErrorPharmacySearchState());
    });
  }

  Future<List<ItemModel>> searchByName(String input) async {
    emit(LoadingMedicineSearchState());

    await FirebaseFirestore.instance.collection('items').get().then((value) {
      suggestions.clear();
      for (var doc in value.docs) {
        if (doc['name']
            .toString()
            .toLowerCase()
            .contains(input.toLowerCase())) {
          suggestions.add(
              ItemModel(doc['description'], doc['name'], doc["image"], doc.id));
        }
      }
    }).then((value) {
      emit(TypingMedicineSearchState());
    }).catchError((onError) {
      emit(ErrorMedicineSearchState());
    });
    return suggestions;
  }
}
