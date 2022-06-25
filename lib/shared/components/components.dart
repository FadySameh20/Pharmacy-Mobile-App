import 'package:flutter/material.dart';
import 'package:gradient_widgets/gradient_widgets.dart';
import 'package:pharmacy_management_system/models/pharmacist_model/pharmacist_model.dart';
import 'package:pharmacy_management_system/modules/admin_screens/edit_pharmacist/pharmacist_update.dart';
import 'package:pharmacy_management_system/modules/admin_screens/edit_pharmacist/pharmacist_update_cubit.dart';

import '../../modules/admin_screens/adminhomescreen/adminhomecubit.dart';
import '../../modules/admin_screens/edit_pharmacy/pharmacy_update.dart';

void navigateAndReplace(context, widget) {
  Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (BuildContext context) => widget),
      (route) => false);
}

void navigateTo(context, widget) {
  Navigator.push(context, MaterialPageRoute(builder: (context) => widget));
}

Widget buildItemCard(context, data, function) {
  return GestureDetector(
    onTap: function,
    child: Card(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        elevation: 2.0,
        child: Center(
          child: data.image != null
              ? Image(
                  image: NetworkImage(data.image),
                  errorBuilder: (BuildContext context, Object exception,
                      StackTrace? stackTrace) {
                    return const Text('ð¢');
                  },
                )
              : const Text(""),
        )),
  );
}

Widget buildPharmacyCard(context, data, function) {
  return GestureDetector(
    onTap: function,
    child: Card(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        elevation: 2.0,
        child: Center(
            child: Text(
          data.name,
          textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 20.0,
          ),
        ))),
  );
}

Widget buildPharmacyEditCard(context, index, pharmacies) {
  return Card(
    child: Padding(
      padding: const EdgeInsets.all(10.0),
      child: Row(
        children: [
          Expanded(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              GradientText(
                pharmacies[index].name.toString(),
                overflow: TextOverflow.ellipsis,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                maxLines: 1,
              ),
              const SizedBox(
                height: 5,
              ),
              Text(
                "Description: ${pharmacies[index].description.toString()}",
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
              Text(
                "Address: ${pharmacies[index].address.toString()}",
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
              Text(
                "Phone: ${pharmacies[index].phone.toString()}",
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              )
            ]),
          ),
          IconButton(
              onPressed: () {
                // AdminHomeCubit.get(context).setPharmacyToEdit();
                navigateTo(context, AdminPharmacyUpdate(pharmacies[index], 0));
              },
              icon: LinearGradientMask(
                  child: const Icon(
                Icons.edit,
                color: Colors.white,
              )))
        ],
      ),
    ),
  );
}

Widget buildPharmacistEditCard(
    context, index, List<PharmacistModel> pharmacist) {
  return Card(
    child: Padding(
      padding: const EdgeInsets.all(10.0),
      child: Row(
        children: [
          Expanded(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              GradientText(
                pharmacist[index].name.toString(),
                overflow: TextOverflow.ellipsis,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                maxLines: 1,
              ),
              const SizedBox(
                height: 5,
              ),
              Text(
                "Email: ${pharmacist[index].email.toString()}",
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
              Text(
                "Phone: ${pharmacist[index].phone.toString()}",
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
              Text(
                "Pharmacy: ${AdminHomeCubit.get(context).getPharmacyForCertainPharmacist(context, pharmacist[index].pharmacyId).toString()}",
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              )
            ]),
          ),
          IconButton(
            onPressed: () {
              // AdminHomeCubit.get(context).setPharmacyToEdit();
              navigateTo(context, AdminPharmacistUpdate(pharmacist[index], 0));
            },
            icon: LinearGradientMask(
              child: const Icon(
                Icons.edit,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

class LinearGradientMask extends StatelessWidget {
  LinearGradientMask({this.child});
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (bounds) => const LinearGradient(
        begin: Alignment.centerLeft,
        colors: [Colors.blue, Colors.red, Colors.pink],
        tileMode: TileMode.mirror,
      ).createShader(bounds),
      child: child,
    );
  }
}

Widget buildShaderMask(widget) {
  return ShaderMask(
      child: widget,
      shaderCallback: (Rect bounds) {
        return const RadialGradient(
                radius: 4, colors: [Colors.blue, Colors.red, Colors.pink])
            .createShader(bounds);
      });
}
// Widget buildAppBar() {
//   return AppBar(
//     title: Text(appBarTitle[HomeCubit.get(context).screenIndex]),
//     actions: [
//       IconButton(
//           onPressed: () {
//             Navigator.push(
//               context,
//               MaterialPageRoute(builder: (context) => SearchScreen()),
//             );
//           },
//           icon: Icon(Icons.search)),
//       IconButton(
//           onPressed: () {
//             // Navigator.push(
//             //   context,
//             //   MaterialPageRoute(builder: (context) => SearchScreen()),
//             // );
//           },
//           icon: Icon(Icons.shopping_cart))
//     ],
//   );
// }
