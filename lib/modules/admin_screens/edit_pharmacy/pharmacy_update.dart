import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gradient_widgets/gradient_widgets.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:pharmacy_management_system/modules/admin_screens/adminhomescreen/adminhomecubit.dart';
import 'package:pharmacy_management_system/modules/admin_screens/adminhomescreen/adminhomelayout.dart';
import 'package:pharmacy_management_system/modules/admin_screens/edit_pharmacy/pharmacy_update_cubit.dart';
import 'package:pharmacy_management_system/modules/admin_screens/edit_pharmacy/pharmacy_update_state.dart';
import 'package:pharmacy_management_system/shared/components/components.dart';

import '../../../models/pharmacy_model/pharmacy_model.dart';

class AdminPharmacyUpdate extends StatelessWidget {
  PharmacyModel pharmacyModel;
  int updateOrAdd = 0;

  AdminPharmacyUpdate(this.pharmacyModel, this.updateOrAdd, {Key? key})
      : super(key: key);

  final _formKey = GlobalKey<FormState>();
  var nameController = TextEditingController();
  var addressController = TextEditingController();
  var descriptionController = TextEditingController();
  var phoneController = TextEditingController();
  String initialCountry = 'EG';
  PhoneNumber number = PhoneNumber(isoCode: 'EG');
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) {
          return PharmacyUpdateCubit()
            ..setControllers(nameController, addressController,
                descriptionController, phoneController, pharmacyModel);
        },
        child: BlocConsumer<PharmacyUpdateCubit, PharmacyUpdateState>(
          listener: (context, state) {},
          builder: (context, state) {
            return Scaffold(
              appBar: AppBar(
                title: Text(pharmacyModel.name.toString()),
                centerTitle: true,
                actions: [
                  TextButton(
                      onPressed: () async {
                        PharmacyUpdateCubit.get(context)
                            .deletePharmacy(pharmacyModel.pharmacyid, context);
                        await AdminHomeCubit.get(context).getPharmacies();
                        navigateAndReplace(context, AdminHomeLayout());
                      },
                      child: updateOrAdd == 0
                          ? const Text(
                              "Delete Pharmacy",
                              style: TextStyle(color: Colors.red),
                            )
                          : const Text(""))
                ],
              ),
              body: Form(
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
                        TextFormField(
                          controller: nameController,
                          onChanged: (value) {
                            PharmacyUpdateCubit.get(context).typing();
                          },
                          decoration:
                              const InputDecoration(label: Text('Name')),
                          validator: (value) {
                            return (value != null &&
                                        RegExp(r'[!@#<>?":_`~;[\]\\|=+)(*&^%0-9-]')
                                            .hasMatch(value) ||
                                    value!.isEmpty)
                                ? 'Please enter the pharmacy name correctly'
                                : null;
                          },
                        ),
                        const SizedBox(
                          height: 20.0,
                        ),
                        TextFormField(
                          controller: descriptionController,
                          onChanged: (value) {
                            PharmacyUpdateCubit.get(context).typing();
                          },
                          validator: (value) {
                            return (value != null && value.isEmpty)
                                ? 'Please enter the description'
                                : null;
                          },
                          decoration: const InputDecoration(
                            label: Text('Description'),
                          ),
                        ),
                        TextFormField(
                          controller: addressController,
                          onChanged: (value) {
                            PharmacyUpdateCubit.get(context).typing();
                          },
                          validator: (value) {
                            return (value != null && value.isEmpty)
                                ? 'Please enter your address correctly'
                                : null;
                          },
                          decoration: const InputDecoration(
                            label: Text('Address'),
                          ),
                        ),
                        const SizedBox(
                          height: 20.0,
                        ),
                        InternationalPhoneNumberInput(
                          onInputChanged: (PhoneNumber number) {
                            PharmacyUpdateCubit.get(context).typing();
                          },
                          onInputValidated: (bool value) {},
                          selectorConfig: const SelectorConfig(
                            selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
                          ),
                          ignoreBlank: false,
                          autoValidateMode: AutovalidateMode.onUserInteraction,
                          selectorTextStyle:
                              const TextStyle(color: Colors.black),
                          initialValue: number,
                          textFieldController: phoneController,
                          formatInput: false,
                          keyboardType: const TextInputType.numberWithOptions(
                              signed: true, decimal: true),
                          inputBorder: const OutlineInputBorder(),
                          onSaved: (PhoneNumber number) {},
                        ),
                        const SizedBox(
                          height: 20.0,
                        ),
                        const SizedBox(
                          height: 60.0,
                        ),
                        Center(
                          child: SizedBox(
                            width: 70,
                            child: MaterialButton(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(80.0)),
                              padding: const EdgeInsets.all(0.0),
                              onPressed: nameController.text.isEmpty ||
                                      addressController.text.isEmpty ||
                                      descriptionController.text.isEmpty ||
                                      phoneController.text.isEmpty
                                  ? null
                                  : () async {
                                      if (_formKey.currentState!.validate()) {
                                        pharmacyModel.name =
                                            nameController.text;
                                        pharmacyModel.address =
                                            addressController.text;
                                        pharmacyModel.phone =
                                            phoneController.text;
                                        pharmacyModel.description =
                                            descriptionController.text;

                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                              content: Text('Updating')),
                                        );
                                        if (updateOrAdd == 0) {
                                          PharmacyUpdateCubit.get(context)
                                              .updatePharmacy(pharmacyModel);
                                        } else {
                                          PharmacyUpdateCubit.get(context)
                                              .addPharmacy(pharmacyModel);
                                        }
                                        await AdminHomeCubit.get(context)
                                            .getPharmacies();
                                        navigateAndReplace(
                                            context, AdminHomeLayout());
                                      }
                                    },
                              child: Ink(
                                decoration: const BoxDecoration(
                                  gradient: Gradients.hotLinear,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(80.0)),
                                ),
                                child: Container(
                                  constraints: const BoxConstraints(
                                      minWidth: 88.0, minHeight: 36.0),
                                  alignment: Alignment.center,
                                  child: Text(
                                    updateOrAdd == 0 ? 'Update' : 'Add',
                                    style: TextStyle(color: Colors.white),
                                    textAlign: TextAlign.center,
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
