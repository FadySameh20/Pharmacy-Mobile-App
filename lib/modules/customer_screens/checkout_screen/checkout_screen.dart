import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gradient_widgets/gradient_widgets.dart';
import 'package:pharmacy_management_system/layouts/home_layout/home_layout.dart';
import 'package:pharmacy_management_system/models/item_pharmacy_model/item_pharmacy_model.dart';
import 'package:pharmacy_management_system/modules/customer_screens/checkout_screen/checkout_cubit.dart';
import 'package:pharmacy_management_system/shared/components/components.dart';
import 'checkout_state.dart';

// ignore: must_be_immutable
class CheckOutScreen extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  var addressController = TextEditingController();
  var buildingNoController = TextEditingController();
  var flatNoController = TextEditingController();
  final _dateController = TextEditingController();
  DateTime currentDate =
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
  String certainPharmacyId;
  List<ItemPharmacyModel> userCart;
  CheckOutScreen(this.certainPharmacyId, this.userCart, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) {
          return CheckOutCubit()..setCart(userCart);
        },
        child: BlocConsumer<CheckOutCubit, CheckOutState>(
          listener: (context, state) {
            if (state is OrderSuccessCheckOutState) {
              // ScaffoldMessenger.of(context).showSnackBar(
              //   const SnackBar(content: Text('Order success')),
              // );

              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => const HomeLayout(),
                ),
                (route) => false,
              );
            }
          },
          builder: (context, state) {
            var cubit = CheckOutCubit.get(context);
            return Scaffold(
              appBar: AppBar(
                title: const GradientText(
                  'Checkout',
                  style: TextStyle(),
                ),
                centerTitle: true,
              ),
              body: Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const GradientText(
                          'Delivery Info.',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontStyle: FontStyle.italic,
                            fontSize: 20.0,
                          ),
                        ),
                        const SizedBox(
                          height: 10.0,
                        ),
                        TextFormField(
                          controller: addressController,
                          validator: (val) =>
                              val!.isEmpty ? "Required Field !" : null,
                          decoration: InputDecoration(
                              icon: LinearGradientMask(
                                  child: const Icon(Icons.location_city,
                                      color: Colors.white)),
                              label: const Text('Address')),
                        ),
                        const SizedBox(
                          height: 20.0,
                        ),
                        TextFormField(
                          controller: buildingNoController,
                          validator: (val) =>
                              val!.isEmpty ? "Required Field !" : null,
                          decoration: InputDecoration(
                            icon: LinearGradientMask(
                                child: const Icon(Icons.numbers,
                                    color: Colors.white)),
                            label: const Text('Building number'),
                          ),
                        ),
                        const SizedBox(
                          height: 20.0,
                        ),
                        TextFormField(
                          controller: flatNoController,
                          validator: (val) =>
                              val!.isEmpty ? "Required Field !" : null,
                          decoration: InputDecoration(
                            icon: LinearGradientMask(
                                child: const Icon(Icons.numbers,
                                    color: Colors.white)),
                            label: const Text('Flat number'),
                          ),
                        ),
                        const SizedBox(
                          height: 20.0,
                        ),
                        TextFormField(
                          readOnly: true,
                          validator: (val) =>
                              val!.isEmpty ? "Required Field !" : null,
                          controller: _dateController,
                          onTap: () async {
                            // _selectDate(context);
                            final DateTime? pickedDate = await showDatePicker(
                                context: context,
                                initialDate: currentDate,
                                firstDate: DateTime(DateTime.now().year,
                                    DateTime.now().month, DateTime.now().day),
                                lastDate: DateTime(
                                    DateTime.now().year,
                                    DateTime.now().month,
                                    DateTime.now().day + 30));
                            if (pickedDate != null) {
                              currentDate = pickedDate;

                              _dateController.text = currentDate
                                  .toLocal()
                                  .toString()
                                  .split(' ')[0];
                            }
                          },
                          decoration: InputDecoration(
                            icon: LinearGradientMask(
                                child: const Icon(Icons.date_range,
                                    color: Colors.white)),
                            label: const Text('Delivery Day "yyyy-mm-dd"'),
                          ),
                        ),
                        const SizedBox(
                          height: 60.0,
                        ),
                        Center(
                          child: GradientButton(
                            callback: () {
                              if (_formKey.currentState!.validate()) {
                                cubit.addOrder(
                                    context,
                                    addressController.text,
                                    buildingNoController.text,
                                    flatNoController.text,
                                    _dateController.text,
                                    certainPharmacyId);
                                // print("Order placed successfully !");
                              } else {
                                // print("Error occurred");
                              }
                            },
                            child: const Text('Place Order'),
                          ),
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




//Order->Random Id->Customer id
                  //Pharmacy id
                  //Order id

// Order_item->Random id-> Order id ,item quantity bt3to
             //Random id-> Order id ->collection ->Items