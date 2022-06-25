import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmacy_management_system/models/item_pharmacy_model/item_pharmacy_model.dart';
import 'package:pharmacy_management_system/modules/pharmacy_screen/pharmacy_cubit.dart';

import '../../../layouts/home_layout/cubit/home_cubit.dart';
import 'items_state.dart';

class ItemCubit extends Cubit<ItemState> {
  ItemCubit() : super(InitialItemState());
  static ItemCubit get(context) => BlocProvider.of(context);
  int itemCount = 0;
  setItemCount(option) {
    option == 0 ? itemCount++ : itemCount--;
    emit(UpdateItemState());
  }

  setQuantity(count) {
    itemCount = count;
    emit(UpdateItemState());
  }

  String getItemImage(input, context) {
    String image = "";
    for (var element in HomeCubit.get(context).items) {
      if (element.name == input) {
        image = element.image.toString();
        // emit(GotImageItemState());
        break;
      }
    }
    return image;
  }

  bool contains(context, item) {
    for (ItemPharmacyModel i in PharmacyCubit.get(context).choosenItems) {
      if (i.item == item) return true;
    }
    return false;
  }
}
