import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmacy_management_system/modules/customer_screens/pharmacies_screen/pharmacies_screen.dart';
import 'package:pharmacy_management_system/modules/search_screen/search_cubit.dart';
import 'package:pharmacy_management_system/modules/search_screen/search_state.dart';

// ignore: must_be_immutable
class PharmacySearchScreen extends StatelessWidget {
  var searchController = TextEditingController();

  PharmacySearchScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => SearchCubit(),
        child: BlocConsumer<SearchCubit, SearchState>(
            listener: (context, state) {},
            builder: (context, state) {
              var cubit = SearchCubit.get(context);
              return Scaffold(
                  appBar: AppBar(
                    title: const Text('Search for specific pharmacy'),
                  ),
                  body: ListView(children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: TextField(
                        controller: searchController,
                        onChanged: (val) {
                          cubit.initiateSearch(val, option: 0);
                        },
                        decoration: InputDecoration(
                            contentPadding: const EdgeInsets.only(left: 25.0),
                            hintText: 'Search by pharmacy name',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(4.0))),
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    buildGridView(
                        searchController, context, cubit.getPharmaciesModel())
                  ]));
            }));
  }
}
