import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gradient_widgets/gradient_widgets.dart';
import 'package:pharmacy_management_system/models/item_pharmacy_model/item_pharmacy_model.dart';
import 'package:pharmacy_management_system/models/pharmacy_model/pharmacy_model.dart';
import 'package:pharmacy_management_system/modules/pharmacist_screen/pharmacist_cubit.dart';
import 'package:pharmacy_management_system/modules/pharmacist_screen/pharmacist_screen.dart';
import 'package:pharmacy_management_system/modules/pharmacy_medicines/pharmacy_medicine_cubit.dart';
import 'package:pharmacy_management_system/modules/pharmacy_medicines/pharmacy_medicine_state.dart';
import 'package:pharmacy_management_system/shared/components/components.dart';

class PharmacyMedicineUpdate extends StatelessWidget {
  ItemPharmacyModel? itemPharmacyModel;
  int updateOrAdd = 0;
  PharmacyModel? pharmicyModel;
  PharmacyMedicineUpdate(
      this.itemPharmacyModel, this.updateOrAdd, this.pharmicyModel,
      {Key? key})
      : super(key: key);

  final _formKey = GlobalKey<FormState>();
  var itemController = TextEditingController();
  var priceController = TextEditingController();
  var quantityController = TextEditingController();
  var descriptionController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) {
          return PharmacyMedicineCubit()
            ..setControllers(
                priceController, quantityController, itemPharmacyModel!);
        },
        child: BlocConsumer<PharmacyMedicineCubit, PharmacyMedicineState>(
          listener: (context, state) {},
          builder: (context, state) {
            return Scaffold(
              appBar: AppBar(
                title: Text(itemPharmacyModel!.item.toString()),
                centerTitle: true,
                actions: const [],
              ),
              body: state is LoadingPharmacyMedicineState
                  ? const Center(child: CircularProgressIndicator())
                  : Form(
                      key: _formKey,
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(
                                height: 10.0,
                              ),
                              if (updateOrAdd == 1)
                                TextFormField(
                                  controller: itemController,
                                  onChanged: (value) {
                                    PharmacyMedicineCubit.get(context).typing();
                                  },
                                  decoration: const InputDecoration(
                                      label: Text('Item')),
                                  validator: (value) {
                                    return (value != null &&
                                                RegExp(r'[!@#<>?":_`~;[\]\\|=+)(*&^%0-9-]')
                                                    .hasMatch(value) ||
                                            value!.isEmpty)
                                        ? 'Please enter the Item name correctly'
                                        : null;
                                  },
                                ),
                              const SizedBox(
                                height: 20.0,
                              ),
                              if (updateOrAdd == 1)
                                Column(
                                  children: [
                                    TextFormField(
                                      controller: descriptionController,
                                      onChanged: (value) {
                                        PharmacyMedicineCubit.get(context)
                                            .typing();
                                      },
                                      validator: (value) {
                                        return (value != null && value.isEmpty)
                                            ? 'Please enter description'
                                            : null;
                                      },
                                      decoration: const InputDecoration(
                                        label: Text('Description'),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    GradientButton(
                                        increaseWidthBy: 20,
                                        callback: () {
                                          PharmacyMedicineCubit.get(context)
                                              .getImage();
                                        },
                                        child: const Text("Upload Image")),
                                    PharmacyMedicineCubit.get(context).image !=
                                            null
                                        ? const Text("Image Added Successfully")
                                        : const Text(""),
                                  ],
                                ),
                              Column(
                                children: [
                                  TextFormField(
                                    controller: quantityController,
                                    onChanged: (value) {
                                      PharmacyMedicineCubit.get(context)
                                          .typing();
                                    },
                                    keyboardType: TextInputType.number,
                                    validator: (value) {
                                      return (value != null &&
                                              (value.isEmpty ||
                                                  int.parse(value) <= 0))
                                          ? 'Please enter quantity'
                                          : null;
                                    },
                                    decoration: const InputDecoration(
                                      label: Text('Quantity'),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  TextFormField(
                                    controller: priceController,
                                    onChanged: (value) {
                                      PharmacyMedicineCubit.get(context)
                                          .typing();
                                    },
                                    keyboardType: TextInputType.number,
                                    validator: (value) {
                                      return (value != null &&
                                              (value.isEmpty ||
                                                  int.parse(value) <= 0))
                                          ? 'Please enter price'
                                          : null;
                                    },
                                    decoration: const InputDecoration(
                                      label: Text('Price'),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 20.0,
                              ),
                              Center(
                                child: SizedBox(
                                  width: 70,
                                  child: MaterialButton(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(80.0)),
                                    padding: const EdgeInsets.all(0.0),
                                    onPressed: (updateOrAdd != 0 &&
                                                itemController.text.isEmpty) ||
                                            quantityController.text.isEmpty ||
                                            priceController.text.isEmpty ||
                                            (PharmacyMedicineCubit.get(context)
                                                        .image ==
                                                    null &&
                                                updateOrAdd != 0)
                                        ? null
                                        : () async {
                                            if (_formKey.currentState!
                                                .validate()) {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                const SnackBar(
                                                    content: Text('Updating')),
                                              );
                                              if (updateOrAdd == 0) {
                                                itemPharmacyModel!.price =
                                                    int.parse(
                                                        priceController.text);
                                                itemPharmacyModel!.quantity =
                                                    int.parse(quantityController
                                                        .text);

                                                await PharmacyMedicineCubit.get(
                                                        context)
                                                    .update(pharmicyModel!,
                                                        itemPharmacyModel!);
                                              } else {
                                                itemPharmacyModel!.item =
                                                    itemController.text
                                                        .toString();
                                                itemPharmacyModel!.price =
                                                    int.parse(
                                                        priceController.text);
                                                await PharmacyMedicineCubit.get(
                                                        context)
                                                    .addItemInItemModel(
                                                        context,
                                                        descriptionController
                                                            .text,
                                                        itemController.text,
                                                        int.parse(
                                                            priceController
                                                                .text),
                                                        int.parse(
                                                            quantityController
                                                                .text),
                                                        pharmicyModel!);
                                              }

                                              await PharmacistCubit.get(context)
                                                  .getData();
                                              navigateAndReplace(
                                                  context, PharmacistScreen());
                                            }
                                          },
                                    child: Ink(
                                      decoration: const BoxDecoration(
                                        gradient: Gradients.hotLinear,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(80.0)),
                                      ),
                                      child: Container(
                                        constraints: const BoxConstraints(
                                            minWidth: 88.0, minHeight: 36.0),
                                        alignment: Alignment.center,
                                        child: updateOrAdd == 0
                                            ? const Text('Update',
                                                style: TextStyle(
                                                    color: Colors.white))
                                            : const Text(
                                                "Add",
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
            );
          },
        ));
  }
}
