import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmacy_management_system/layouts/home_layout/cubit/home_cubit.dart';
import 'package:pharmacy_management_system/layouts/home_layout/home_states.dart';
import 'package:pharmacy_management_system/modules/customer_screens/pharmacies_screen/pharmacy_search_screen.dart';
import 'package:pharmacy_management_system/modules/search_screen/search_cubit.dart';
import 'package:pharmacy_management_system/modules/search_screen/search_screen.dart';
import 'package:pharmacy_management_system/shared/components/components.dart';
import 'package:pharmacy_management_system/shared/styles/colors.dart';

class HomeLayout extends StatelessWidget {
  const HomeLayout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeCubit, HomeStates>(
      listener: ((context, state) {
        if (state is AllDataReadyHomeState) {
          HomeCubit.get(context).setIndex(0);
        }
      }),
      builder: ((context, state) {
        List appBarTitle = [
          "Home Page",
          "Pharmacies",
          "Profile",
        ];
        return Scaffold(
          appBar: AppBar(
            title: Text(
              appBarTitle[HomeCubit.get(context).screenIndex],
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  foreground: defaultForeground),
            ),
            centerTitle: true,
            actions: [
              IconButton(
                onPressed: () {
                  if (HomeCubit.get(context).screenIndex != 1) {
                    SearchCubit.get(context).pharmaciesModel = [];
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SearchScreen()),
                    );
                  } else {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => PharmacySearchScreen()),
                    );
                  }
                },
                icon: LinearGradientMask(
                    child: const Icon(
                  Icons.search,
                  color: Colors.red,
                )),
              ),
              IconButton(
                onPressed: () {
                  if (HomeCubit.get(context).screenIndex != 1) {
                    HomeCubit.get(context).getData();
                  }
                },
                icon: LinearGradientMask(
                  child: const Icon(
                    Icons.refresh,
                    color: Colors.white,
                  ),
                ),
              )
            ],
          ),
          extendBodyBehindAppBar: true,
          body: HomeCubit.get(context).pharmacies.isEmpty &&
                  HomeCubit.get(context).items.isEmpty &&
                  HomeCubit.get(context).userData == null
              ? const Center(child: CircularProgressIndicator())
              : HomeCubit.get(context)
                  .screens[HomeCubit.get(context).screenIndex],
          bottomNavigationBar: BottomNavigationBar(
            onTap: ((value) {
              HomeCubit.get(context).setIndex(value);
            }),
            currentIndex: HomeCubit.get(context).screenIndex,
            type: BottomNavigationBarType.fixed,
            items: [
              BottomNavigationBarItem(
                  activeIcon: LinearGradientMask(
                      child: const Icon(
                    Icons.home,
                    color: Colors.white,
                  )),
                  icon: const Icon(Icons.home),
                  label: "Home"),
              BottomNavigationBarItem(
                  activeIcon: LinearGradientMask(
                      child: const Icon(
                    Icons.apps,
                    color: Colors.white,
                  )),
                  icon: const Icon(Icons.apps),
                  label: "Pharmacies"),
              BottomNavigationBarItem(
                  activeIcon: LinearGradientMask(
                      child: const Icon(Icons.person, color: Colors.white)),
                  icon: const Icon(Icons.person),
                  label: "Profile"),
            ],
          ),
        );
      }),
    );
  }
}
