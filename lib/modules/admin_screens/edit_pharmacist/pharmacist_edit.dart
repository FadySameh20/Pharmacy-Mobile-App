import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmacy_management_system/modules/admin_screens/adminhomescreen/adminhomecubit.dart';
import 'package:pharmacy_management_system/modules/admin_screens/adminhomescreen/adminhomestates.dart';

import '../../../shared/components/components.dart';

class PharmacistEdit extends StatelessWidget {
  const PharmacistEdit({Key? key}) : super(key: key);

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
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: const BorderSide(
                          width: 0,
                          style: BorderStyle.none,
                        ),
                      ),
                      icon: LinearGradientMask(
                          child: const Icon(
                        Icons.search,
                        color: Colors.white,
                      )),
                      hintText: "Search for Pharmacist"),
                  onChanged: (value) {
                    AdminHomeCubit.get(context).initiatePharmacistSearch(value);
                  },
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemCount: AdminHomeCubit.get(context)
                          .pharmacistSuggestions
                          .isEmpty
                      ? AdminHomeCubit.get(context).availablePharmacists.length
                      : AdminHomeCubit.get(context)
                          .pharmacistSuggestions
                          .length,
                  itemBuilder: (context, index) {
                    return Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: buildPharmacistEditCard(
                            context,
                            index,
                            AdminHomeCubit.get(context)
                                    .pharmacistSuggestions
                                    .isEmpty
                                ? AdminHomeCubit.get(context)
                                    .availablePharmacists
                                : AdminHomeCubit.get(context)
                                    .pharmacistSuggestions));
                  }),
            ),
          ],
        );
      },
    );
  }
}
