import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pharmacy_management_system/models/item_model/item_model.dart';
import 'package:pharmacy_management_system/models/item_pharmacy_model/item_pharmacy_model.dart';
import 'package:pharmacy_management_system/models/pharmacy_model/pharmacy_model.dart';
import 'package:pharmacy_management_system/modules/pharmacy_medicines/pharmacy_medicine_state.dart';

class PharmacyMedicineCubit extends Cubit<PharmacyMedicineState> {
  PharmacyMedicineCubit() : super(InitialPharmacyMedicineState());
  static PharmacyMedicineCubit get(context) => BlocProvider.of(context);

  typing() {
    emit(TypingPharmacyMedicineState());
  }

  update(
      PharmacyModel pharmacyModel, ItemPharmacyModel itemPharmacyModel) async {
    for (int i = 0; i < pharmacyModel.items.length; i++) {
      if (itemPharmacyModel.item == pharmacyModel.items[i].item) {
        pharmacyModel.items[i].price = itemPharmacyModel.price;
        pharmacyModel.items[i].quantity = itemPharmacyModel.quantity;
        break;
      }
    }

    await FirebaseFirestore.instance
        .collection("pharmacies")
        .doc(pharmacyModel.pharmacyid)
        .set(pharmacyModel.toMap())
        .then((value) {
      emit(SuccessUpdateState());
    }).catchError((onError) {
      emit(ErrorUpdateState());
    });
  }

  setControllers(
      TextEditingController priceController,
      TextEditingController quantityController,
      ItemPharmacyModel itemPharmacyModel) {
    priceController.text = itemPharmacyModel.price.toString();
    quantityController.text = itemPharmacyModel.quantity.toString();
    emit(SetControllers());
  }

  File? image;
  getImage() async {
    image = null;
    XFile? file = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (file != null) {
      image = File(file.path);
      emit(SuccessImagePharmacyMedicineState());
    } else {
      emit(ErrorImagePharmacyMedicineState());
    }
  }

  addItemInItemModel(context, String description, String name, price, quantity,
      PharmacyModel pharmacyModel) async {
    FirebaseStorage storage = FirebaseStorage.instance;
    String id = FirebaseFirestore.instance.collection("items").doc().id;
    Reference reference =
        storage.ref().child("images/${image!.path.split('/').last}");
    UploadTask uploadTask = reference.putFile(image!);
    TaskSnapshot snapshot = await uploadTask;
    String url = await snapshot.ref.getDownloadURL();
    image = null;

    ItemModel itemModel = ItemModel(description, name, url, id);
    String? pharmacyId = pharmacyModel.pharmacyid;
    await FirebaseFirestore.instance
        .collection("items")
        .doc(id)
        .set(itemModel.toMap())
        .then((value) async {
      emit(SuccessAddItemInItems());
      pharmacyModel.items.add(ItemPharmacyModel(name, price, quantity));
      await FirebaseFirestore.instance
          .collection("pharmacies")
          .doc(pharmacyId)
          .set(pharmacyModel.toMap())
          .then((value) {
        emit(SuccessAddItemInPharmacy());
      }).catchError((onError) {
        emit(ErrorAddItemInPharmacy());
      });
    }).catchError((onError) {
      emit(ErrorAddItemInItems());
    });
  }
}
