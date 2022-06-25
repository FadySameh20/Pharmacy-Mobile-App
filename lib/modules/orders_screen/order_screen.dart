import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gradient_widgets/gradient_widgets.dart';
import 'package:pharmacy_management_system/models/order_model/order_model.dart';
import 'package:pharmacy_management_system/modules/pharmacist_screen/pharmacist_cubit.dart';
import 'package:pharmacy_management_system/modules/pharmacist_screen/pharmacist_states.dart';
import 'package:pharmacy_management_system/shared/components/components.dart';

class OrderScreen extends StatelessWidget {
  const OrderScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PharmacistCubit, PharmacistState>(
        listener: (context, state) {},
        builder: (context, state) {
          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    itemCount: PharmacistCubit.get(context).orders.length,
                    itemBuilder: (context, index) {
                      return Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: buildPharmacistEditCard(context, index,
                              PharmacistCubit.get(context).orders));
                    }),
              ),
            ],
          );
        });
  }
}

Widget buildPharmacistEditCard(context, index, List<OrderModel> orders) {
  return Card(
    child: Padding(
      padding: const EdgeInsets.all(10.0),
      child: Row(
        children: [
          Expanded(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(
                children: [
                  GradientText(
                    PharmacistCubit.get(context)
                        .getCustomerFromCustomerId(orders[index].customerId)
                        .name,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                    maxLines: 1,
                  ),
                  const Spacer(),
                  IconButton(
                      onPressed: () {
                        PharmacistCubit.get(context)
                            .deleteFromOrders(orders[index]);
                      },
                      icon: LinearGradientMask(
                          child: const Icon(
                        Icons.done,
                        color: Colors.white,
                      )))
                ],
              ),
              const SizedBox(
                height: 5,
              ),
              Text(
                "Phone: ${PharmacistCubit.get(context).getCustomerFromCustomerId(orders[index].customerId).phoneNum}",
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
              Text("Address: ${orders[index].address}"),
              const SizedBox(
                height: 5,
              ),
              Text("Delivery Date: ${orders[index].deliveryDate}"),
              const SizedBox(
                height: 5,
              ),
              Text("Building No: ${orders[index].buildNo}"),
              const SizedBox(
                height: 5,
              ),
              Text("Flat No: ${orders[index].flatNo}"),
              const SizedBox(
                height: 5,
              ),
              const Text("Order:"),
              ListView.builder(
                  shrinkWrap: true,
                  itemCount: orders[index].items.length,
                  itemBuilder: (context, ind) {
                    return Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(orders[index].items[ind].item.toString()),
                            Text(" x${orders[index].items[ind].quantity}")
                          ],
                        ),
                      ],
                    );
                  })
            ]),
          ),
        ],
      ),
    ),
  );
}
