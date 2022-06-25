import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gradient_widgets/gradient_widgets.dart';
import 'package:pharmacy_management_system/layouts/home_layout/cubit/home_cubit.dart';
import 'package:pharmacy_management_system/layouts/home_layout/home_states.dart';
import 'package:pharmacy_management_system/modules/pharmacy_screen/pharmacy_screen.dart';
import 'package:pharmacy_management_system/shared/components/components.dart';

// ignore: must_be_immutable
class PharmaciesScreen extends StatelessWidget {
  var searchController = TextEditingController();

  PharmaciesScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeCubit, HomeStates>(
      listener: (context, state) {},
      builder: ((context, state) {
        var cubit = HomeCubit.get(context);
        return ListView(children: <Widget>[
          const SizedBox(height: 10.0),
          cubit.returnPharmacies().isNotEmpty
              ? const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: GradientText(
                    "Please Choose a pharmacy to display it",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 19),
                  ),
                )
              : const Text(""),
          const SizedBox(
            height: 10,
          ),
          buildGridView(
            searchController,
            context,
            cubit.returnPharmacies(),
          )
        ]);
      }),
    );
  }
}

Widget buildGridView(TextEditingController searchController, context, data) {
  return GridView.builder(
    padding: const EdgeInsets.only(left: 10.0, right: 10.0),
    itemCount: data.length,
    primary: false,
    shrinkWrap: true,
    itemBuilder: (context, index) {
      var cubit = HomeCubit.get(context);
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
              child: buildPharmacyCard(context, data[index], () {
            cubit.setCertainPharmacy(data[index].name);
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => PharmacyScreen(
                        data[index],
                        cubit.pharmacies[index].pharmacyid,
                        cubit.pharmacies[index].items)));
          })),
        ],
      );
    },
    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 2,
      crossAxisSpacing: 4.0,
      mainAxisSpacing: 4.0,
    ),
  );
}
