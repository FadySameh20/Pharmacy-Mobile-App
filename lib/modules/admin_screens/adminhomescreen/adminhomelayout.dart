import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gradient_widgets/gradient_widgets.dart';
import 'package:pharmacy_management_system/modules/admin_screens/adminhomescreen/adminhomecubit.dart';
import 'package:pharmacy_management_system/modules/admin_screens/adminhomescreen/adminhomestates.dart';
import 'package:pharmacy_management_system/modules/admin_screens/edit_pharmacist/pharmacist_update.dart';
import 'package:pharmacy_management_system/modules/admin_screens/edit_pharmacy/pharmacy_update.dart';
import 'package:pharmacy_management_system/modules/admin_screens/edit_pharmacy/pharmacy_update_cubit.dart';

import '../../../models/pharmacist_model/pharmacist_model.dart';
import '../../../models/pharmacy_model/pharmacy_model.dart';
import '../../../shared/components/components.dart';

// ignore: must_be_immutable
class AdminHomeLayout extends StatelessWidget {
  List<String> appBarTitles = ["Pharmacist", "Available Pharmacy", "Sign out"];

  AdminHomeLayout({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AdminHomeCubit, AdminHomeState>(
        listener: (context, state) {},
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              actions: [
                IconButton(
                  onPressed: () {
                    if (AdminHomeCubit.get(context).screenIndex != 2) {
                      AdminHomeCubit.get(context).getPharmacists();
                      AdminHomeCubit.get(context).getPharmacies();
                    }
                  },
                  icon: LinearGradientMask(
                      child: const Icon(
                    Icons.refresh,
                    color: Colors.white,
                  )),
                ),
                if (AdminHomeCubit.get(context).screenIndex == 1 ||
                    AdminHomeCubit.get(context).screenIndex == 0)
                  TextButton(
                      onPressed: () {
                        //Go to new page to take pharmacy detail
                        navigateTo(
                            context,
                            AdminHomeCubit.get(context).screenIndex == 1
                                ? AdminPharmacyUpdate(
                                    PharmacyModel("", "", "", "", [], ""), 1)
                                : AdminPharmacistUpdate(
                                    PharmacistModel("", "", "", "", ""), 1));
                      },
                      child: const GradientText(
                        "New",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ))
              ],
              centerTitle: true,
              title: GradientText(
                appBarTitles[AdminHomeCubit.get(context).screenIndex],
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
              ),
            ),
            body: AdminHomeCubit.get(context)
                .screens[AdminHomeCubit.get(context).screenIndex],
            bottomNavigationBar: BottomNavigationBar(
                currentIndex: AdminHomeCubit.get(context).screenIndex,
                onTap: (index) {
                  AdminHomeCubit.get(context).changeNavBar(index, context);
                },
                items: [
                  BottomNavigationBarItem(
                      activeIcon: LinearGradientMask(
                          child: const Icon(
                        Icons.edit,
                        color: Colors.white,
                      )),
                      icon: const Icon(
                        Icons.edit,
                      ),
                      label: "Pharmacist"),
                  BottomNavigationBarItem(
                      activeIcon: LinearGradientMask(
                          child: const Icon(
                        Icons.edit,
                        color: Colors.white,
                      )),
                      icon: const Icon(Icons.edit),
                      label: "Pharmacy"),
                  BottomNavigationBarItem(
                      activeIcon: LinearGradientMask(
                          child: const Icon(
                        Icons.edit,
                        color: Colors.white,
                      )),
                      icon: const Icon(Icons.logout),
                      label: "Sign Out")
                ]),
          );
        });
  }
}
