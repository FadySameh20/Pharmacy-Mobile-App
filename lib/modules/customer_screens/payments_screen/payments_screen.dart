import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gradient_widgets/gradient_widgets.dart';
import 'package:pharmacy_management_system/models/item_pharmacy_model/item_pharmacy_model.dart';
import 'package:pharmacy_management_system/modules/customer_screens/payments_screen/payment_screen_state.dart';
import 'package:pharmacy_management_system/modules/customer_screens/payments_screen/payments_screen_cubit.dart';
import 'package:pharmacy_management_system/shared/components/components.dart';

import '../checkout_screen/checkout_screen.dart';

// ignore: must_be_immutable
class PaymentScreen extends StatelessWidget {
  String certainPharmacyId;
  List<ItemPharmacyModel> userCart = [];
  PaymentScreen(this.certainPharmacyId, this.userCart, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        return PaymentCubit()..returnTotalCost(userCart);
      },
      child: BlocConsumer<PaymentCubit, PaymentState>(
          listener: ((context, state) {}),
          builder: (context, state) {
            return Scaffold(
              appBar: AppBar(
                title: const GradientText(
                  "View Cart",
                  style: const TextStyle(),
                ),
                centerTitle: true,
              ),
              body: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(children: [
                  Row(
                    children: const [
                      Expanded(
                        child: Text(
                          "Name",
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          "Price",
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          "Quantity",
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Expanded(
                    child: ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        itemCount: userCart.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 10.0),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    userCart[index].item.toString(),
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    userCart[index].price.toString(),
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    userCart[index].quantity.toString(),
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),
                  ),
                  Text(
                      "Total Price is ${PaymentCubit.get(context).totalPrice}"),
                  SizedBox(
                      width: double.infinity,
                      child: GradientButton(
                          increaseWidthBy: 200,
                          child: const Text("Proceed to checkout"),
                          callback: () {
                            navigateTo(context,
                                CheckOutScreen(certainPharmacyId, userCart));
                          }))
                ]),
              ),
            );
          }),
    );
  }
}
//  Row(
//                     children: [
//                       Text(
//                         userCart[0].item.toString(),
//                         overflow: TextOverflow.ellipsis,
//                       ),
//                       Text(
//                         userCart[0].price.toString(),
//                         overflow: TextOverflow.ellipsis,
//                       ),
//                       Text(
//                         userCart[0].quantity.toString(),
//                         overflow: TextOverflow.ellipsis,
//                       )
//                     ],
//                   ),










//  Row(
//                             children: [
//                               Text(
//                                 PaymentCubit.get(context)
//                                     .userCart[index]
//                                     .item
//                                     .toString(),
//                                 overflow: TextOverflow.ellipsis,
//                               ),
//                               Text(
//                                 PaymentCubit.get(context)
//                                     .userCart[index]
//                                     .price
//                                     .toString(),
//                                 overflow: TextOverflow.ellipsis,
//                               ),
//                               Text(
//                                 PaymentCubit.get(context)
//                                     .userCart[index]
//                                     .quantity
//                                     .toString(),
//                                 overflow: TextOverflow.ellipsis,
//                               )
//                             ],
//                           );