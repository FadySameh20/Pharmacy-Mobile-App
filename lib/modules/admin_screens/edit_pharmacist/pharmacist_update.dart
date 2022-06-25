import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gradient_widgets/gradient_widgets.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:pharmacy_management_system/models/pharmacist_model/pharmacist_model.dart';
import 'package:pharmacy_management_system/modules/admin_screens/edit_pharmacist/pharmacist_update_cubit.dart';
import 'package:pharmacy_management_system/modules/admin_screens/edit_pharmacist/pharmacist_update_state.dart';

import '../../../shared/components/components.dart';
import '../adminhomescreen/adminhomecubit.dart';
import '../adminhomescreen/adminhomelayout.dart';

class AdminPharmacistUpdate extends StatelessWidget {
  PharmacistModel pharmacistModel;
  int updateOrAdd = 0;

  AdminPharmacistUpdate(this.pharmacistModel, this.updateOrAdd, {Key? key})
      : super(key: key);

  final _formKey = GlobalKey<FormState>();
  var nameController = TextEditingController();
  var emailController = TextEditingController();
  var phoneController = TextEditingController();
  var passController = TextEditingController();
  String initialCountry = 'EG';
  PhoneNumber number = PhoneNumber(isoCode: 'EG');
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) {
          return PharmacistUpdateCubit()
            ..setControllers(nameController, emailController, phoneController,
                pharmacistModel)
            ..getPharmacies();
        },
        child: BlocConsumer<PharmacistUpdateCubit, PharmacistUpdateState>(
          listener: (context, state) {},
          builder: (context, state) {
            return Scaffold(
              appBar: AppBar(
                title: Text(pharmacistModel.name.toString()),
                centerTitle: true,
                actions: [
                  TextButton(
                      onPressed: () async {
                        PharmacistUpdateCubit.get(context)
                            .deletePharmacist(pharmacistModel.pharmacistId);
                        await AdminHomeCubit.get(context).getPharmacists();
                        navigateAndReplace(context, AdminHomeLayout());
                      },
                      child: updateOrAdd == 0
                          ? const Text(
                              "Delete Pharmacists",
                              style: TextStyle(color: Colors.red),
                            )
                          : const Text(""))
                ],
              ),
              body: state is LoadingPharmaciesAdminHomeState
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
                                Column(
                                  children: [
                                    TextFormField(
                                      controller: nameController,
                                      onChanged: (value) {
                                        PharmacistUpdateCubit.get(context)
                                            .typing();
                                      },
                                      decoration: const InputDecoration(
                                          label: Text('Name')),
                                      validator: (value) {
                                        return (value != null &&
                                                    RegExp(r'[!@#<>?":_`~;[\]\\|=+)(*&^%0-9-]')
                                                        .hasMatch(value) ||
                                                value!.isEmpty)
                                            ? 'Please enter the pharmacist name correctly'
                                            : null;
                                      },
                                    ),
                                    const SizedBox(
                                      height: 20.0,
                                    ),
                                    TextFormField(
                                      controller: emailController,
                                      onChanged: (value) {
                                        PharmacistUpdateCubit.get(context)
                                            .typing();
                                      },
                                      validator: (value) {
                                        return (value != null &&
                                                value.isEmpty &&
                                                !RegExp(r'^.+@[a-zA-Z]+\.{1}[a-zA-Z]+(\.{0,1}[a-zA-Z]+)$')
                                                    .hasMatch(value))
                                            ? 'Please enter a valid email'
                                            : null;
                                      },
                                      decoration: const InputDecoration(
                                        label: Text('Email'),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    TextFormField(
                                      obscureText:
                                          PharmacistUpdateCubit.get(context)
                                              .isHidden,
                                      controller: passController,
                                      decoration: InputDecoration(
                                          labelText: 'Password',
                                          suffixIcon: IconButton(
                                              onPressed: () {
                                                PharmacistUpdateCubit.get(
                                                        context)
                                                    .toggleVisibility();
                                              },
                                              icon: Icon(
                                                  PharmacistUpdateCubit.get(
                                                          context)
                                                      .visibleIcon))),
                                      validator: (String? value) {
                                        return (value!.isEmpty)
                                            ? 'Password is incorrect.'
                                            : null;
                                      },
                                    ),
                                    const SizedBox(
                                      height: 20.0,
                                    ),
                                    InternationalPhoneNumberInput(
                                      onInputChanged: (PhoneNumber number) {
                                        PharmacistUpdateCubit.get(context)
                                            .typing();
                                      },
                                      onInputValidated: (bool value) {},
                                      selectorConfig: const SelectorConfig(
                                        selectorType:
                                            PhoneInputSelectorType.BOTTOM_SHEET,
                                      ),
                                      ignoreBlank: false,
                                      autoValidateMode:
                                          AutovalidateMode.onUserInteraction,
                                      selectorTextStyle:
                                          const TextStyle(color: Colors.black),
                                      initialValue: number,
                                      textFieldController: phoneController,
                                      formatInput: false,
                                      keyboardType:
                                          const TextInputType.numberWithOptions(
                                              signed: true, decimal: true),
                                      inputBorder: const OutlineInputBorder(),
                                      onSaved: (PhoneNumber number) {},
                                    ),
                                    const SizedBox(
                                      height: 20.0,
                                    ),
                                  ],
                                ),
                              SizedBox(
                                  width: double.infinity,
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton(
                                      disabledHint: const Text("ya rb"),
                                      isDense: true,
                                      value: PharmacistUpdateCubit.get(context)
                                                  .selectedPharmacy ==
                                              null
                                          ? PharmacistUpdateCubit.get(context)
                                                  .availablePharmacies
                                                  .isNotEmpty
                                              ? PharmacistUpdateCubit.get(
                                                      context)
                                                  .availablePharmacies[0]
                                                  .name
                                              : null
                                          : PharmacistUpdateCubit.get(context)
                                              .selectedPharmacy!
                                              .name,
                                      items: PharmacistUpdateCubit.get(context)
                                          .availablePharmacies
                                          .map((e) => DropdownMenuItem(
                                              value: e.name,
                                              child: Text(e.name.toString())))
                                          .toList(),
                                      onChanged: (value) {
                                        for (int i = 0;
                                            i <
                                                PharmacistUpdateCubit.get(
                                                        context)
                                                    .availablePharmacies
                                                    .length;
                                            i++) {
                                          if (PharmacistUpdateCubit.get(context)
                                                  .availablePharmacies[i]
                                                  .name ==
                                              value) {
                                            PharmacistUpdateCubit.get(context)
                                                .setSelectedPharmacy(
                                                    PharmacistUpdateCubit.get(
                                                            context)
                                                        .availablePharmacies[i]);
                                          }
                                        }
                                      },
                                    ),
                                  )),
                              Center(
                                child: SizedBox(
                                  width: 70,
                                  child: MaterialButton(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(80.0)),
                                    padding: const EdgeInsets.all(0.0),
                                    onPressed: nameController.text.isEmpty ||
                                            emailController.text.isEmpty ||
                                            phoneController.text.isEmpty
                                        ? null
                                        : () async {
                                            if (_formKey.currentState!
                                                .validate()) {
                                              pharmacistModel.name =
                                                  nameController.text;
                                              pharmacistModel.email =
                                                  emailController.text;
                                              pharmacistModel.phone =
                                                  phoneController.text;
                                              if (PharmacistUpdateCubit.get(
                                                          context)
                                                      .selectedPharmacy ==
                                                  null) {
                                                PharmacistUpdateCubit.get(
                                                            context)
                                                        .selectedPharmacy =
                                                    PharmacistUpdateCubit.get(
                                                            context)
                                                        .availablePharmacies[0];
                                              }
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                const SnackBar(
                                                    content: Text('Updating')),
                                              );
                                              if (updateOrAdd == 0) {
                                                pharmacistModel.pharmacyId =
                                                    PharmacistUpdateCubit.get(
                                                            context)
                                                        .selectedPharmacy!
                                                        .pharmacyid;

                                                PharmacistUpdateCubit.get(
                                                        context)
                                                    .updatePharmacist(
                                                        pharmacistModel);
                                              } else {
                                                pharmacistModel.pharmacyId =
                                                    PharmacistUpdateCubit.get(
                                                            context)
                                                        .selectedPharmacy!
                                                        .pharmacyid;
                                                PharmacistUpdateCubit.get(
                                                        context)
                                                    .addPharmacist(
                                                        pharmacistModel,
                                                        passController.text);
                                              }
                                              await AdminHomeCubit.get(context)
                                                  .getPharmacists();
                                              navigateAndReplace(
                                                  context, AdminHomeLayout());
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
