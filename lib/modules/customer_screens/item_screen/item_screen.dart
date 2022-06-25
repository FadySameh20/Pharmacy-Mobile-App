import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gradient_widgets/gradient_widgets.dart';
import 'package:pharmacy_management_system/layouts/home_layout/cubit/home_cubit.dart';
import 'package:pharmacy_management_system/layouts/home_layout/home_states.dart';
import 'package:pharmacy_management_system/modules/pharmacy_screen/pharmacy_screen.dart';
import 'package:pharmacy_management_system/modules/search_screen/search_screen.dart';
import 'package:pharmacy_management_system/shared/components/components.dart';

import '../../search_screen/search_cubit.dart';

// ignore: must_be_immutable
class ItemScreen extends StatelessWidget {
  List<String> carouselImages = [
    "https://th.bing.com/th/id/OIP.TSy7gpfUSq4Z8x_9PVtgVQHaFi?pid=ImgDet&rs=1",
    "https://i.pinimg.com/originals/44/fb/1b/44fb1b9d7b572044bf1817d55f2b6c5a.jpg",
    "https://www.mebelapteka.ru/wp-content/uploads/2021/04/San-Diego-CA-1024x680.jpg"
  ];

  ItemScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeCubit, HomeStates>(
        listener: ((context, state) {}),
        builder: (context, state) {
          return SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CarouselSlider(
                        options: CarouselOptions(
                            height: 250,
                            aspectRatio: 16 / 9,
                            viewportFraction: 1,
                            initialPage: 0,
                            enableInfiniteScroll: true,
                            autoPlay: true,
                            autoPlayInterval: const Duration(seconds: 3),
                            autoPlayAnimationDuration:
                                const Duration(milliseconds: 800),
                            autoPlayCurve: Curves.fastOutSlowIn,
                            enlargeCenterPage: true,
                            scrollDirection: Axis.horizontal),
                        items: carouselImages.map((i) {
                          return Builder(
                            builder: (BuildContext context) {
                              return Card(
                                clipBehavior: Clip.antiAliasWithSaveLayer,
                                // shape: RoundedRectangleBorder(
                                //   borderRadius: BorderRadius.circular(50),
                                // ),
                                child: Image(
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  image: NetworkImage(i),
                                  errorBuilder: (BuildContext context,
                                      Object exception,
                                      StackTrace? stackTrace) {
                                    return const Text('ð¢');
                                  },
                                ),
                              );
                            },
                          );
                        }).toList(),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const GradientText(
                        "Available Pharmacies",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 24),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      SizedBox(
                        width: double.infinity,
                        height: 100,
                        child: ListView.builder(
                          physics: const BouncingScrollPhysics(),
                          scrollDirection: Axis.horizontal,
                          itemCount:
                              HomeCubit.get(context).returnPharmacies().length,
                          itemBuilder: (context, index) {
                            var cubit = HomeCubit.get(context);
                            // print("hello");
                            // print(hel)
                            return SizedBox(
                              width: 200,
                              child: buildPharmacyCard(
                                  context, cubit.returnPharmacies()[index],
                                  () async {
                                cubit.setCertainPharmacy(
                                    cubit.pharmacies[index].name);
                                // print(cubit.certainPharmacy);
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => PharmacyScreen(
                                            HomeCubit.get(context)
                                                .certainPharmacy!,
                                            HomeCubit.get(context)
                                                .certainPharmacy!
                                                .pharmacyid,
                                            HomeCubit.get(context)
                                                .certainPharmacy!
                                                .items)));
                              }),
                            );
                          },
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const GradientText(
                        "Available Items",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 24),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      SizedBox(
                        width: double.infinity,
                        height: 100,
                        child: ListView.builder(
                          physics: const BouncingScrollPhysics(),
                          scrollDirection: Axis.horizontal,
                          itemCount:
                              HomeCubit.get(context).returnItems().length,
                          itemBuilder: (context, index) {
                            var cubit = HomeCubit.get(context);
                            // print("hello");
                            // print(HomeCubit.get(context)
                            //     .returnItems()[index]
                            //     .name);
                            return SizedBox(
                              width: 200,
                              child: Column(
                                children: [
                                  Expanded(
                                    child: buildItemCard(
                                        context, cubit.returnItems()[index],
                                        () async {
                                      // print("hehehehe");
                                      SearchCubit.get(context).pharmaciesModel =
                                          [];
                                      // print(cubit.items[index].name);
                                      await SearchCubit.get(context)
                                          .searchForPharmacies(
                                              cubit.items[index].name);
                                      // print(index);

                                      navigateTo(context, SearchScreen());
                                    }),
                                  ),
                                  Text(cubit.returnItems()[index].name)
                                ],
                              ),
                            );
                          },
                        ),
                      )
                    ]),
              ),
            ),
          );
        });
  }
}
