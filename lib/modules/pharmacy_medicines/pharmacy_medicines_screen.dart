import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gradient_widgets/gradient_widgets.dart';
import 'package:pharmacy_management_system/modules/pharmacy_medicines/pharmacy_medicine_update.dart';
import 'package:pharmacy_management_system/shared/components/components.dart';

import '../pharmacist_screen/pharmacist_cubit.dart';
import '../pharmacist_screen/pharmacist_states.dart';

class PharmacyMedicines extends StatelessWidget {
  const PharmacyMedicines({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PharmacistCubit, PharmacistState>(
      listener: (context, state) {},
      builder: (context, state) {
        return PharmacistCubit.get(context).pharmacyModel == null
            ? const Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              )
            : Scaffold(
                appBar: AppBar(
                  title: GradientText(
                    PharmacistCubit.get(context).pharmacyModel!.name.toString(),
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
                body: Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                          physics: const BouncingScrollPhysics(),
                          itemCount: PharmacistCubit.get(context)
                              .pharmacyModel!
                              .items
                              .length,
                          itemBuilder: (context, index) {
                            return Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          GradientText(
                                            "Medicine: ${PharmacistCubit.get(context).pharmacyModel!.items[index].item.toString()}",
                                            style:
                                                const TextStyle(fontSize: 14),
                                          ),
                                          Text(
                                              "Quantity: ${PharmacistCubit.get(context).pharmacyModel!.items[index].quantity.toString()}, Price: ${PharmacistCubit.get(context).pharmacyModel!.items[index].price.toString()}")
                                        ],
                                      ),
                                    ),
                                    IconButton(
                                        onPressed: () {
                                          // print("hhhhhhhhhhhhhhhhhhh");
                                          // print(PharmacistCubit.get(context)
                                          // .pharmacyModel!
                                          // .items[index]
                                          // .item);
                                          navigateTo(
                                              context,
                                              PharmacyMedicineUpdate(
                                                  PharmacistCubit.get(context)
                                                      .pharmacyModel!
                                                      .items[index],
                                                  0,
                                                  PharmacistCubit.get(context)
                                                      .pharmacyModel!));
                                        },
                                        icon: LinearGradientMask(
                                            child: const Icon(
                                          Icons.edit,
                                          color: Colors.white,
                                        )))
                                  ],
                                ));
                          }),
                    ),
                  ],
                ),
              );
      },
    );
  }
}
