import 'package:flutter_test/flutter_test.dart';
import 'package:pharmacy_management_system/models/item_pharmacy_model/item_pharmacy_model.dart';
import 'package:pharmacy_management_system/modules/pharmacy_screen/pharmacy_cubit.dart';

void main() {
  test('Adding an item to shopping cart should increment its length by 1', () {
    var pharmacyCubit = PharmacyCubit();
    var oldCartLength = pharmacyCubit.choosenItems.length;

    var price = 10;
    var itemQuantity = 3;
    var userQuantity = 2;
    var item = ItemPharmacyModel('test_medicine', price, itemQuantity);
    pharmacyCubit.addChoice(item, userQuantity);
    var newCartLength = pharmacyCubit.choosenItems.length;

    expect(newCartLength, oldCartLength + 1);
  });
  test('Removing an item from shopping cart should decrement its length by 1',
      () {
    var pharmacyCubit = PharmacyCubit();

    var price = 10;
    var itemQuantity = 3;
    var userQuantity = 2;
    var item = ItemPharmacyModel('test_medicine', price, itemQuantity);
    pharmacyCubit.addChoice(item, userQuantity);
    int oldCartLength = pharmacyCubit.choosenItems.length;
    pharmacyCubit.removeFromCart(null, item);
    int newCartLength = pharmacyCubit.choosenItems.length;

    expect(newCartLength, oldCartLength - 1);
  });

  test('Testing sum of quantities in cart', () {
    var pharmacyCubit = PharmacyCubit();

    var price = 10;
    var itemQuantity = 3;
    var userQuantity = 2;
    var item = ItemPharmacyModel('test_medicine', price, itemQuantity);
    pharmacyCubit.addChoice(item, userQuantity);

    var price1 = 10;
    var itemQuantity1 = 3;
    var userQuantity1 = 5;
    var item1 = ItemPharmacyModel('test_medicine1', price1, itemQuantity1);
    pharmacyCubit.addChoice(item1, userQuantity1);
    var totalQuantities = pharmacyCubit.getSum();
    expect(totalQuantities, 7);
  });
}
