import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gradient_widgets/gradient_widgets.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:pharmacy_management_system/layouts/home_layout/cubit/home_cubit.dart';
import 'package:pharmacy_management_system/modules/entry_screens/entry_screen.dart';
import 'package:pharmacy_management_system/modules/profile_screen/profile_cubit.dart';
import 'package:pharmacy_management_system/modules/profile_screen/profile_states.dart';
import 'package:pharmacy_management_system/shared/components/components.dart';
import 'package:pharmacy_management_system/shared/network/shared_preferences.dart';

class ProfileScreen extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  var nameController = TextEditingController();
  var currentPassController = TextEditingController();
  var newPasswordController = TextEditingController();
  var phoneController = TextEditingController();
  String initialCountry = 'EG';
  PhoneNumber number = PhoneNumber(isoCode: 'EG');

  ProfileScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: ((context) {
          return ProfileCubit()
            ..setController(context, nameController, phoneController);
        }),
        child: BlocConsumer<ProfileCubit, ProfileState>(
          listener: (context, state) {
            if (state is SuccessUserUpdate) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('User data updated Successfully')),
              );
            }
            if (state is SuccessPasswordChange) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Password changed successfully')),
              );
            }
          },
          builder: (context, state) {
            return Scaffold(
              appBar: AppBar(
                title: Text('${HomeCubit.get(context).userData!.name}'),
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
                        const SizedBox(
                          height: 10.0,
                        ),
                        TextFormField(
                          controller: nameController,
                          decoration:
                              const InputDecoration(label: Text('Name')),
                        ),
                        const SizedBox(
                          height: 20.0,
                        ),
                        TextFormField(
                          controller: currentPassController,
                          obscureText:
                              ProfileCubit.get(context).isCurrentPasswordHidden,
                          decoration: InputDecoration(
                            label: const Text('Current Password'),
                            suffix: IconButton(
                                onPressed: () {
                                  ProfileCubit.get(context)
                                      .togglePasswordVisibility(0);
                                },
                                icon: Icon(
                                    ProfileCubit.get(context).currentPassIcon)),
                          ),
                        ),
                        TextFormField(
                          controller: newPasswordController,
                          obscureText:
                              ProfileCubit.get(context).isNewPasswordHidden,
                          decoration: InputDecoration(
                            label: const Text('New Password'),
                            suffix: IconButton(
                                onPressed: () {
                                  ProfileCubit.get(context)
                                      .togglePasswordVisibility(1);
                                },
                                icon: Icon(
                                    ProfileCubit.get(context).newPassIcon)),
                          ),
                        ),
                        const SizedBox(
                          height: 20.0,
                        ),
                        InternationalPhoneNumberInput(
                          onInputChanged: (PhoneNumber number) {},
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
                                      (currentPassController.text.isEmpty ^
                                          newPasswordController.text.isEmpty) ||
                                      phoneController.text.isEmpty
                                  ? null
                                  : () async {
                                      ProfileCubit.get(context).performUpdate(
                                          context,
                                          currentPassController,
                                          newPasswordController,
                                          nameController,
                                          phoneController);
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
                                  child: const Text(
                                    'Update',
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
                        Center(
                          child: GradientButton(
                            callback: () {
                              newPasswordController.text = "";
                              currentPassController.text = "";
                              HomeCubit.get(context).setIndex(0);
                              HomeCubit.get(context).getData();
                              CacheHelper.removeData("mycart");
                              CacheHelper.removeData("mypharmacy");
                              FirebaseAuth.instance.signOut();
                              navigateAndReplace(context, const EntryScreen());
                            },
                            child: const Text('Sign Out'),
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
