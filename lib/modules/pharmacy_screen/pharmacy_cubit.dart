import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmacy_management_system/layouts/home_layout/cubit/home_cubit.dart';
import 'package:pharmacy_management_system/models/item_pharmacy_model/item_pharmacy_model.dart';
import 'package:pharmacy_management_system/modules/pharmacy_screen/pharmacy_states.dart';

class PharmacyCubit extends Cubit<PharmacyState> {
  PharmacyCubit() : super(InitialPharmacyState());

  static PharmacyCubit get(context) => BlocProvider.of(context);
  List quantities = [];
  String getItemImage(input, context) {
    String image = "";
    for (var element in HomeCubit.get(context).items) {
      if (element.name == input) {
        image = element.image.toString();
        break;
      }
    }
    return image;
  }

  List<ItemPharmacyModel> choosenItems = [];
  var quantity = 0;
  updateCartCount(num value) {
    quantity += 1;
  }

  removeFromCart(context, medicine) {
    for (int i = 0; i < choosenItems.length; i++) {
      if (choosenItems[i].item == medicine.item) {
        choosenItems.removeAt(i);
      }
    }
    emit(RemoveFromCartPharmacyState());
    if (choosenItems.isEmpty) emit(ClearCartPharmacyState());
  }

  int getSum() {
    int quantity = 0;
    for (var i in choosenItems) {
      quantity += i.quantity!.toInt();
    }
    return quantity;
  }

  addChoice(ItemPharmacyModel item, userquantity) {
    ItemPharmacyModel myitem =
        ItemPharmacyModel(item.item, item.price, userquantity);
    choosenItems.add(myitem);
    emit(AddChoicePharmacyState());
  }
}
