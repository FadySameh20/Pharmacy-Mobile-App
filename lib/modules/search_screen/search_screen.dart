import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmacy_management_system/layouts/home_layout/cubit/home_cubit.dart';
import 'package:pharmacy_management_system/modules/pharmacy_screen/pharmacy_screen.dart';
import 'package:pharmacy_management_system/modules/search_screen/search_cubit.dart';
import 'package:pharmacy_management_system/modules/search_screen/search_state.dart';

import '../../shared/components/components.dart';

// ignore: must_be_immutable
class SearchScreen extends StatelessWidget {
  var searchController = TextEditingController();

  SearchScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SearchCubit, SearchState>(
        listener: (context, state) {},
        builder: (context, state) {
          var cubit = SearchCubit.get(context);
          return Scaffold(
              appBar: AppBar(
                title: const Text('Search for specific medicine'),
              ),
              body: ListView(children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: TextField(
                    controller: searchController,
                    onChanged: (val) {
                      cubit.initiateSearch(val);
                    },
                    decoration: InputDecoration(
                        contentPadding: const EdgeInsets.only(left: 25.0),
                        hintText: 'Search by name',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(4.0))),
                  ),
                ),
                const SizedBox(height: 10.0),
                cubit.getSuggestions().length > 0
                    ? Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Please Choose a medicine to display available pharmacies",
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                      )
                    : const Text(""),
                const SizedBox(
                  height: 10,
                ),
                cubit.getPharmaciesModel().isEmpty
                    ? buildSearchGridView(
                        searchController, context, cubit.getSuggestions())
                    : buildSearchGridView(
                        searchController, context, cubit.getPharmaciesModel())
              ]));
        });
  }
}

Widget buildSearchGridView(
    TextEditingController searchController, context, data) {
  return GridView.builder(
    padding: const EdgeInsets.only(left: 10.0, right: 10.0),
    itemCount: data.length,
    primary: false,
    shrinkWrap: true,
    itemBuilder: (context, index) {
      var cubit = SearchCubit.get(context);
      var homeCubit = HomeCubit.get(context);
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
              child: cubit.getPharmaciesModel().isEmpty
                  ? buildItemCard(context, data[index], () {
                      cubit.searchForPharmacies(data[index].name);
                    })
                  : buildPharmacyCard(context, data[index], () {
                      HomeCubit.get(context)
                          .setCertainPharmacy(data[index].name);

                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => PharmacyScreen(
                                  homeCubit.certainPharmacy!,
                                  homeCubit.certainPharmacy!.pharmacyid,
                                  homeCubit.certainPharmacy!.items)));
                    })),
          cubit.getPharmaciesModel().isEmpty
              ? Padding(
                  padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                  child: Text(cubit.suggestions[index].name.toString(),
                      maxLines: 2, overflow: TextOverflow.ellipsis),
                )
              : const Text("")
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
