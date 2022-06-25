import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gradient_widgets/gradient_widgets.dart';
import 'package:pharmacy_management_system/layouts/home_layout/home_layout.dart';
import 'package:pharmacy_management_system/modules/admin_screens/adminhomescreen/adminhomelayout.dart';
import 'package:pharmacy_management_system/modules/entry_screens/login_screen/login_cubit.dart';
import 'package:pharmacy_management_system/modules/entry_screens/login_screen/login_state.dart';
import 'package:pharmacy_management_system/modules/entry_screens/register_screen/register_screen.dart';
import 'package:pharmacy_management_system/shared/components/components.dart';

import '../../../layouts/home_layout/cubit/home_cubit.dart';
import '../../../shared/styles/colors.dart';
import '../../pharmacist_screen/pharmacist_screen.dart';

class EmailFieldValidator {
  static validateEmail(String? value) {
    if (value!.isEmpty) {
      return 'Email field is required !';
    }
    return (value != null &&
            !RegExp(r'^.+@[a-zA-Z]+\.{1}[a-zA-Z]+(\.{0,1}[a-zA-Z]+)$')
                .hasMatch(value))
        ? 'Email is incorrect !'
        : null;
  }
}

class PasswordFieldValidator {
  static validatePassword(String? value) {
    return (value!.isEmpty) ? 'Password field is required !' : null;
  }
}

class LoginScreen extends StatelessWidget {
  final formKey = GlobalKey<FormState>();
  var emailController = TextEditingController();
  var passController = TextEditingController();

  LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => LoginCubit(),
        child: BlocConsumer<LoginCubit, LoginState>(
          listener: (context, state) async {
            if (state is ErrorLoginState) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.error ?? "Error")),
              );
            }
            if (state is SuccessLoginState) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Logged in')),
              );
              if (FirebaseAuth.instance.currentUser!.email ==
                  "admin@yahoo.com") {
                navigateAndReplace(context, AdminHomeLayout());
              } else {
                int flag = 0;
                await FirebaseFirestore.instance
                    .collection('pharmacists')
                    .get()
                    .then((value) {
                  for (var element in value.docs) {
                    if (element["pharmacistId"] ==
                        FirebaseAuth.instance.currentUser!.uid) {
                      flag = 1;

                      break;
                    }
                  }
                });
                await HomeCubit.get(context).getData();
                if (flag == 1) {
                  navigateAndReplace(context, PharmacistScreen());
                } else {
                  navigateAndReplace(context, const HomeLayout());
                }
              }
            }
          },
          builder: (context, state) {
            var cubit = LoginCubit.get(context);
            return Scaffold(
              backgroundColor: defaultColor,
              extendBodyBehindAppBar: true,
              body: Container(
                decoration: const BoxDecoration(
                    gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [Colors.blue, Colors.red, Colors.pink],
                )),
                child: SafeArea(
                  child: Column(
                    children: [
                      SizedBox(
                        height: 250,
                        child: Center(
                            child: Text("LOGIN",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1
                                    ?.copyWith(color: Colors.white))),
                      ),
                      const SizedBox(
                        height: 50,
                      ),
                      Expanded(
                        child: Container(
                          width: double.infinity,
                          decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(20),
                                  topRight: Radius.circular(20))),
                          child: SingleChildScrollView(
                            child: Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Form(
                                key: formKey,
                                onChanged: () {
                                  Form.of(primaryFocus!.context!)!.save();
                                },
                                child: Column(children: [
                                  const SizedBox(
                                    height: 15,
                                  ),
                                  TextFormField(
                                    controller: emailController,
                                    decoration: InputDecoration(
                                      icon: LinearGradientMask(
                                          child: const Icon(
                                        Icons.person,
                                        color: Colors.white,
                                      )),
                                      labelText: 'Email',
                                    ),
                                    validator: (String? value) =>
                                        EmailFieldValidator.validateEmail(
                                            value),
                                  ),
                                  const SizedBox(
                                    height: 15,
                                  ),
                                  TextFormField(
                                    controller: passController,
                                    obscureText:
                                        LoginCubit.get(context).getIsHidden(),
                                    decoration: InputDecoration(
                                        icon: LinearGradientMask(
                                            child: const Icon(
                                          Icons.password,
                                          color: Colors.white,
                                        )),
                                        labelText: 'Password',
                                        suffixIcon: IconButton(
                                            onPressed: () {
                                              LoginCubit.get(context)
                                                  .toggleVisibility();
                                            },
                                            icon: LinearGradientMask(
                                                child: Icon(
                                              cubit.getIcon(),
                                              color: Colors.white,
                                            )))),
                                    validator: (String? value) =>
                                        PasswordFieldValidator.validatePassword(
                                            value),
                                  ),
                                  const SizedBox(
                                    height: 15,
                                  ),
                                  GradientButton(
                                    callback: () {
                                      if (formKey.currentState!.validate()) {
                                        cubit.login(emailController.text,
                                            passController.text);

                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                              content: Text('Processing Data')),
                                        );
                                      }
                                    },
                                    child: const Text('LOGIN'),
                                  ),
                                  const SizedBox(
                                    height: 15,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Text("Don't Have An Account?"),
                                      TextButton(
                                          onPressed: () {
                                            return navigateAndReplace(
                                                context, RegisterScreen());
                                          },
                                          child: const GradientText(
                                            "REGISTER",
                                            style: TextStyle(fontSize: 15),
                                          ))
                                    ],
                                  )
                                ]),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ));
  }
}
