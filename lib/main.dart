import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmacy_management_system/layouts/home_layout/home_states.dart';
import 'package:pharmacy_management_system/modules/admin_screens/adminhomescreen/adminhomelayout.dart';
import 'package:pharmacy_management_system/modules/boarding_screen/boarding_screen.dart';
import 'package:pharmacy_management_system/modules/entry_screens/entry_screen.dart';
import 'package:pharmacy_management_system/modules/pharmacist_screen/pharmacist_cubit.dart';
import 'package:pharmacy_management_system/modules/pharmacist_screen/pharmacist_screen.dart';
import 'package:pharmacy_management_system/modules/profile_screen/profile_cubit.dart';
import 'package:pharmacy_management_system/observer.dart';
import 'package:pharmacy_management_system/shared/components/constants.dart';
import 'package:pharmacy_management_system/shared/network/shared_preferences.dart';
import 'layouts/home_layout/cubit/home_cubit.dart';
import 'layouts/home_layout/home_layout.dart';
import 'models/pharmacist_model/pharmacist_model.dart';
import 'modules/admin_screens/adminhomescreen/adminhomecubit.dart';
import 'modules/search_screen/search_cubit.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await CacheHelper.init();
  bool? finishedBoarding = CacheHelper.getData("boarding") ?? false;
  Widget widget;
  // ItemPharmacyModel item1 = ItemPharmacyModel("reparil", 20, 10);
  // ItemPharmacyModel item2 = ItemPharmacyModel("reparil adeem", 40, 5);
  // List<ItemPharmacyModel> items = [item1, item2];
  // // PharmacyModel pham = PharmacyModel("Osama el tayeby", "Janaklees", "5771234",
  // //     "Found since 1980", [item1, item2]);
  // await FirebaseFirestore.instance.collection("pharmacies").add({
  //   "name": "Osama el tayeby",
  //   "address": "Janaklees",
  //   "phone": "577123",
  //   "description": "Found since 1980",
  //   "items": items.map((i) => i.toSimpleMap()).toList(),
  // }).then((value) {
  //   FirebaseFirestore.instance
  //       .collection("pharmacies")
  //       .doc(value.id)
  //       .update({"pharmacyid": value.id});
  // });

  // await FirebaseFirestore.instance.collection("pharmacies").add({
  //   "name": "Khalil",
  //   "address": "Sporting",
  //   "phone": "116141",
  //   "description": "sydlyya gamda gdn",
  //   "items": []
  // }).then((value) {
  //   FirebaseFirestore.instance
  //       .collection("pharmacies")
  //       .doc(value.id)
  //       .update({"pharmacyid": value.id});
  // });
  final User? user = FirebaseAuth.instance.currentUser;
  int flag = 0;
  // await CacheHelper.removeData('mycart');
  // await CacheHelper.removeData("mypharmacy");
  // var test = CacheHelper.getData("mycart") ?? false;
  // if (test == true) {
  // final String cartString = await CacheHelper.getData('mycart');
  // final List<ItemPharmacyModel> usercart =
  //     ItemPharmacyModel.decode(cartString);

  // print(usercart[0].item);
  // }
  // if (cartString == null) {
  // widget = SettingScreen();
  // }
  // else
  {
    if (user != null) {
      final uid = user.uid;
      myuId = uid;
      if (user.email == "admin@yahoo.com") {
        widget = AdminHomeLayout();
      } else {
        await FirebaseFirestore.instance
            .collection('pharmacists')
            .get()
            .then((value) {
          for (var element in value.docs) {
            print(uid);
            if (element["pharmacistId"] == uid) {
              flag = 1;
              break;
            }
          }
        });
        if (flag == 0) {
          widget = const HomeLayout();
        } else {
          widget = PharmacistScreen();
        }
      }
    } else if (finishedBoarding == false) {
      widget = const BoardingScreen();
    } else {
      widget = const EntryScreen();
    }
  }
  BlocOverrides.runZoned(
    () {
      runApp(MyApp(widget));
    },
    blocObserver: MyObserver(),
  );
}

// ignore: must_be_immutable
class MyApp extends StatelessWidget {
  Widget myWidget;
  MyApp(this.myWidget, {Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) {
            return AdminHomeCubit()
              ..getPharmacies()
              ..getPharmacists();
          }),
          BlocProvider(
            create: (context) {
              return HomeCubit()..getData();
            },
          ),
          BlocProvider(create: (context) {
            return SearchCubit();
          }),
          BlocProvider(create: (context) {
            return PharmacistCubit()..getData();
          }),
          BlocProvider(create: (context) {
            return ProfileCubit();
          }),
        ],
        child: BlocConsumer<HomeCubit, HomeStates>(
          listener: (context, state) {},
          builder: (context, state) {
            return MaterialApp(
              title: 'Pharmacy Management System',
              debugShowCheckedModeBanner: false,
              theme: ThemeData(
                textTheme: const TextTheme(
                    bodyText1: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      shadows: [Shadow(blurRadius: 1.7)],
                    ),
                    subtitle1: TextStyle(
                      fontSize: 12,
                    )),
                backgroundColor: Colors.white,
                primarySwatch: Colors.blue,
                appBarTheme: const AppBarTheme(
                  iconTheme: IconThemeData(color: Colors.black),
                  // backgroundColor: Color(0x44000000),
                  backgroundColor: Colors.white,
                  systemOverlayStyle: SystemUiOverlayStyle(
                      statusBarColor: Colors.transparent,
                      statusBarIconBrightness: Brightness.dark),
                  elevation: 0,
                  titleTextStyle: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              home: myWidget,
            );
          },
        ));
  }
}

// Orders->Random id->customer id
// 		   [List of items' id] ;bn7awl n2lel lists 3la ad m n2dr bs hna list a7sn 7aga
// 		                       ;3shan List msh btupdate hyya sabta

// Items_Orders->Random id->Order id
//                          [List of orders' id]
