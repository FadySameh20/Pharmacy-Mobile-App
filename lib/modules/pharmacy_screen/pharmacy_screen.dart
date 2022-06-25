import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gradient_widgets/gradient_widgets.dart';
import 'package:pharmacy_management_system/models/pharmacy_model/pharmacy_model.dart';
import 'package:pharmacy_management_system/modules/customer_screens/item_screen/items_cubit.dart';
import 'package:pharmacy_management_system/modules/customer_screens/payments_screen/payments_screen.dart';

import 'package:pharmacy_management_system/modules/pharmacy_screen/pharmacy_cubit.dart';
import 'package:pharmacy_management_system/modules/pharmacy_screen/pharmacy_states.dart';
import 'package:pharmacy_management_system/shared/components/components.dart';
import 'package:pharmacy_management_system/shared/network/shared_preferences.dart';
import '../../models/item_pharmacy_model/item_pharmacy_model.dart';
import '../customer_screens/item_screen/items_state.dart';

//Todo: always check cart with available quantity
// ignore: must_be_immutable
class PharmacyScreen extends StatelessWidget {
  PharmacyModel certainPharmacy;

  String? certainPharmacyId;
  List<ItemPharmacyModel> itemsForCertainPharmacies = [];
  // ignore: use_key_in_widget_constructors
  PharmacyScreen(this.certainPharmacy, this.certainPharmacyId,
      this.itemsForCertainPharmacies);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        return PharmacyCubit();
      },
      child: BlocConsumer<PharmacyCubit, PharmacyState>(
        listener: ((context, state) {
          if (state is ClearCartPharmacyState) {
            CacheHelper.removeData("mypharmacy");
            CacheHelper.removeData("mycart");
          }
        }),
        builder: ((context, state) {
          PharmacyCubit.get(context).quantities =
              List.filled(itemsForCertainPharmacies.length, 0);
          if (state is InitialPharmacyState) {
            var test = CacheHelper.getData('mypharmacy') ?? false;
            if (test != false) {
              var pharmacy = CacheHelper.getData('mypharmacy') ?? false;
              if (pharmacy != certainPharmacyId && pharmacy != false) {
                // print(pharmacy);
                // print(certainPharmacyId);
                // ScaffoldMessenger.of(context).showSnackBar(
                //   const SnackBar(
                //       content: Text(
                //           'Please finish your order before browsing in new pharmacy')),
                // );
                Navigator.pop(context);
              }
            }
            // Fetch and decode data
            test = CacheHelper.getData("mycart") ?? false;
            if (test != false) {
              final String cartString =
                  CacheHelper.getData('mycart').toString();

              final List<ItemPharmacyModel> usercart =
                  ItemPharmacyModel.decode(cartString);
              // print("lol");
              // print(usercart[0].item);
              PharmacyCubit.get(context).choosenItems = List.from(usercart);

              int index = 0;
              for (var i in itemsForCertainPharmacies) {
                for (var j in usercart) {
                  if (i.item == j.item) {
                    PharmacyCubit.get(context).quantities[index] = j.quantity;
                    // print("loop");
                    // print(i.item);
                    // print(j.quantity);
                    // print(j.item);
                    // print("aho");
                    break;
                  }
                }
                index++;
              }
            }
          }
          return Scaffold(
            appBar: AppBar(
              title: GradientText(certainPharmacy.name.toString(),
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold)),
              centerTitle: true,
              actions: [
                Stack(
                  alignment: Alignment.topCenter,
                  children: [
                    CircleAvatar(
                      radius: 7,
                      backgroundColor: Colors.orange,
                      child: Text(
                          PharmacyCubit.get(context).getSum().toString(),
                          style: const TextStyle(
                              fontSize: 10, color: Colors.white)),
                    ),
                    IconButton(
                      onPressed: PharmacyCubit.get(context)
                              .choosenItems
                              .isNotEmpty
                          ? () async {
                              final String encodedData =
                                  ItemPharmacyModel.encode(
                                      PharmacyCubit.get(context).choosenItems);

                              await CacheHelper.setData(
                                  key: 'mycart', value: encodedData);
                              await CacheHelper.setData(
                                  key: 'mypharmacy', value: certainPharmacyId!);
                              // print(certainPharmacyId);
                              // Fetch and decode data
                              final String cartString =
                                  await CacheHelper.getData('mycart');

                              final List<ItemPharmacyModel> usercart =
                                  ItemPharmacyModel.decode(cartString);
                              // print(usercart[0].item);
                              // navigateTo(context,CheckOutScreen(certainPharmacyId.toString()));
                              navigateTo(
                                  context,
                                  PaymentScreen(
                                      certainPharmacyId.toString(), usercart));
                              // Navigator.pop(context);
                            }
                          : null,
                      icon: LinearGradientMask(
                          child: const Icon(Icons.shopping_cart)),
                      color: Colors.white,
                    ),
                  ],
                )
              ],
            ),
            body: SafeArea(
                child: SizedBox(
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(8.0, 0, 8.0, 8.0),
                child: Column(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 30.0,
                        ),
                        Row(
                          children: [
                            LinearGradientMask(
                              child: const Icon(
                                Icons.local_pharmacy,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                GradientText(
                                  certainPharmacy.name.toString(),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontStyle: FontStyle.italic,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  certainPharmacy.description.toString(),
                                  overflow: TextOverflow.ellipsis,
                                )
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    Expanded(
                      child: ListView.builder(
                          physics: const BouncingScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: itemsForCertainPharmacies.length,
                          itemBuilder: (context, index) {
                            return ListItem(itemsForCertainPharmacies[index],
                                PharmacyCubit.get(context).quantities[index]);
                          }),
                    )
                  ],
                ),
              ),
            )),
          );
        }),
      ),
    );
  }
}

// ignore: must_be_immutable
class ListItem extends StatelessWidget {
  ItemPharmacyModel medicine;
  int quantity;
  ListItem(this.medicine, this.quantity, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) {
          return ItemCubit()..setQuantity(quantity);
        },
        child: BlocConsumer<ItemCubit, ItemState>(
          listener: (context, state) {},
          builder: (context, state) {
            return Card(
              child: ListTile(
                  title: Padding(
                    padding: const EdgeInsets.only(top: 15.0),
                    child: GradientText(medicine.item.toString(),
                        // overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            fontSize: 14, fontWeight: FontWeight.bold)),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                          "Price: ${medicine.price.toString()}, Quantity: ${medicine.quantity.toString()}"),
                      Row(
                        children: [
                          IconButton(
                            onPressed: ItemCubit.get(context).itemCount == 0 ||
                                    ItemCubit.get(context)
                                        .contains(context, medicine.item)
                                ? null
                                : () {
                                    ItemCubit.get(context).setItemCount(1);

                                    // cubit.updateQuantity(index, 0);
                                  },
                            icon: LinearGradientMask(
                                child: Icon(
                              Icons.remove,
                              color: ItemCubit.get(context).itemCount != 0
                                  ? Colors.white
                                  : Colors.black38,
                            )),
                          ),
                          Text("${ItemCubit.get(context).itemCount}"),
                          IconButton(
                            onPressed: ItemCubit.get(context).itemCount ==
                                        medicine.quantity ||
                                    ItemCubit.get(context)
                                        .contains(context, medicine.item)
                                ? null
                                : () {
                                    ItemCubit.get(context).setItemCount(0);
                                    // setState(() {});
                                    // print(q)
                                    // cubit.updateQuantity(
                                    //     index, 1);
                                  },
                            icon: LinearGradientMask(
                                child: Icon(
                              Icons.add,
                              color: ItemCubit.get(context).itemCount !=
                                      medicine.quantity
                                  ? Colors.white
                                  : Colors.black38,
                            )),
                          )
                        ],
                      )
                    ],
                  ),
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(
                      ItemCubit.get(context)
                          .getItemImage(medicine.item, context),
                    ),
                  ),
                  trailing: IconButton(
                      onPressed: ItemCubit.get(context).itemCount != 0
                          ? () {
                              if (ItemCubit.get(context)
                                  .contains(context, medicine.item)) {
                                PharmacyCubit.get(context)
                                    .removeFromCart(context, medicine);
                              } else {
                                PharmacyCubit.get(context).addChoice(
                                    medicine, ItemCubit.get(context).itemCount);
                                // cubit.userChooseAnItem(index);
                              }
                            }
                          : null,
                      icon: LinearGradientMask(
                        child: ItemCubit.get(context)
                                .contains(context, medicine.item)
                            ? const Icon(
                                Icons.remove,
                                color: Colors.white,
                              )
                            : Icon(
                                Icons.add,
                                color: ItemCubit.get(context).itemCount > 0
                                    ? Colors.white
                                    : Colors.black38,
                              ),
                      ))),
            );
          },
        ));
  }
}
