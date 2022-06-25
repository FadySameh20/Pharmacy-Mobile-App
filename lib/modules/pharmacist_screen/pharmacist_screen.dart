import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gradient_widgets/gradient_widgets.dart';
import 'package:pharmacy_management_system/models/item_pharmacy_model/item_pharmacy_model.dart';
import 'package:pharmacy_management_system/modules/pharmacist_screen/pharmacist_cubit.dart';
import 'package:pharmacy_management_system/modules/pharmacist_screen/pharmacist_states.dart';
import 'package:pharmacy_management_system/modules/pharmacy_medicines/pharmacy_medicine_update.dart';
import 'package:pharmacy_management_system/shared/components/components.dart';

class PharmacistScreen extends StatelessWidget {
  List<String> appBarTitles = ["Pharmacy Medicines", "Orders", "Profile"];
  PharmacistScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PharmacistCubit, PharmacistState>(
      listener: (context, state) {},
      builder: (context, state) {
        return PharmacistCubit.get(context).pharmacistModel == null
            ? const Scaffold(body: Center(child: CircularProgressIndicator()))
            : Scaffold(
                appBar: AppBar(
                  title: GradientText(
                    appBarTitles[PharmacistCubit.get(context).screenIndex],
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  centerTitle: true,
                  actions: [
                    IconButton(
                        onPressed: () async {
                          await PharmacistCubit.get(context).getData();
                        },
                        icon: LinearGradientMask(
                          child: const Icon(
                            Icons.refresh,
                            color: Colors.white,
                          ),
                        )),
                    if (PharmacistCubit.get(context).screenIndex == 0)
                      TextButton(
                          onPressed: () {
                            navigateTo(
                                context,
                                PharmacyMedicineUpdate(
                                    ItemPharmacyModel("", 0, 0),
                                    1,
                                    PharmacistCubit.get(context)
                                        .pharmacyModel!));
                          },
                          child: const GradientText(
                            "New",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ))
                  ],
                ),
                body: PharmacistCubit.get(context)
                    .screens[PharmacistCubit.get(context).screenIndex],
                bottomNavigationBar: BottomNavigationBar(
                  currentIndex: PharmacistCubit.get(context).screenIndex,
                  onTap: (index) {
                    PharmacistCubit.get(context).changeNavBar(index);
                  },
                  items: [
                    BottomNavigationBarItem(
                        icon: LinearGradientMask(
                            child: const Icon(
                          Icons.local_pharmacy,
                          color: Colors.white,
                        )),
                        label: "Pharmacy Medicine"),
                    BottomNavigationBarItem(
                        icon: LinearGradientMask(
                            child: const Icon(
                          Icons.shopping_cart,
                          color: Colors.white,
                        )),
                        label: "Order"),
                    BottomNavigationBarItem(
                        icon: LinearGradientMask(
                            child: const Icon(
                          Icons.person,
                          color: Colors.white,
                        )),
                        label: "Profile"),
                  ],
                ),
              );
      },
    );
  }
}
