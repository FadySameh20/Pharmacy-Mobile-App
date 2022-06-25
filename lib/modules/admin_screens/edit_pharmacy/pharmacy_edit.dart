import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmacy_management_system/modules/admin_screens/adminhomescreen/adminhomecubit.dart';
import 'package:pharmacy_management_system/modules/admin_screens/adminhomescreen/adminhomestates.dart';
import 'package:pharmacy_management_system/shared/components/components.dart';

class PharmacyEdit extends StatelessWidget {
  const PharmacyEdit({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AdminHomeCubit, AdminHomeState>(
        listener: (context, state) {},
        builder: (context, state) {
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Card(
                  elevation: 5,
                  child: TextField(
                    decoration: InputDecoration(
                        icon: LinearGradientMask(
                            child: const Icon(
                          Icons.search,
                          color: Colors.white,
                        )),
                        border: InputBorder.none,
                        hintText: "Search for Pharmacy"),
                    onChanged: (value) {
                      AdminHomeCubit.get(context).initiatePharmacySearch(value);
                    },
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    itemCount: AdminHomeCubit.get(context)
                            .pharmacySuggestions
                            .isEmpty
                        ? AdminHomeCubit.get(context).availablePharmacies.length
                        : AdminHomeCubit.get(context)
                            .pharmacySuggestions
                            .length,
                    itemBuilder: (context, index) {
                      return Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: buildPharmacyEditCard(
                              context,
                              index,
                              AdminHomeCubit.get(context)
                                      .pharmacySuggestions
                                      .isEmpty
                                  ? AdminHomeCubit.get(context)
                                      .availablePharmacies
                                  : AdminHomeCubit.get(context)
                                      .pharmacySuggestions));
                    }),
              ),
            ],
          );
        });
  }
}
