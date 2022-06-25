import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gradient_widgets/gradient_widgets.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:pharmacy_management_system/layouts/home_layout/cubit/home_cubit.dart';
import 'package:pharmacy_management_system/layouts/home_layout/home_layout.dart';
import 'package:pharmacy_management_system/modules/entry_screens/login_screen/login_screen.dart';
import 'package:pharmacy_management_system/modules/entry_screens/register_screen/register_cubit.dart';
import 'package:pharmacy_management_system/modules/entry_screens/register_screen/register_state.dart';
import '../../../shared/components/components.dart';
import '../../../shared/styles/colors.dart';

class RegisterScreen extends StatelessWidget {
  final formKey = GlobalKey<FormState>();
  String initialCountry = 'EG';
  PhoneNumber number = PhoneNumber(isoCode: 'EG');
  final TextEditingController controller = TextEditingController();
  String? password;
  var nameController = TextEditingController();
  var passController = TextEditingController();
  var emailController = TextEditingController();

  RegisterScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => RegisterCubit(),
        child: BlocConsumer<RegisterCubit, RegisterState>(
          listener: (context, state) async {
            if (state is ErrorRegisterState) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.error ?? "Error")),
              );
            }
            if (state is SuccessRegisterState) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Registered Successfully')),
              );
              await HomeCubit.get(context).getData();

              navigateAndReplace(context, const HomeLayout());
            }
          },
          builder: (context, state) {
            var cubit = RegisterCubit.get(context);
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
                            child: Text("REGISTER",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1
                                    ?.copyWith(color: Colors.white))),
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
                                  TextFormField(
                                    controller: nameController,
                                    decoration: InputDecoration(
                                        icon: LinearGradientMask(
                                            child: const Icon(
                                          Icons.person,
                                          color: Colors.white,
                                        )),
                                        labelText: 'Name',
                                        labelStyle: const TextStyle()),
                                    validator: (value) {
                                      return (value != null &&
                                                  RegExp(r'[!@#<>?":_`~;[\]\\|=+)(*&^%0-9-]')
                                                      .hasMatch(value) ||
                                              value!.isEmpty)
                                          ? 'Please enter your name correctly'
                                          : null;
                                    },
                                  ),
                                  const SizedBox(
                                    height: 15,
                                  ),
                                  TextFormField(
                                    controller: emailController,
                                    decoration: InputDecoration(
                                      icon: LinearGradientMask(
                                          child: const Icon(
                                        Icons.email,
                                        color: Colors.white,
                                      )),
                                      labelText: 'Email',
                                    ),
                                    validator: (String? value) {
                                      return (value != null &&
                                              !RegExp(r'^.+@[a-zA-Z]+\.{1}[a-zA-Z]+(\.{0,1}[a-zA-Z]+)$')
                                                  .hasMatch(value))
                                          ? 'Email is incorrect.'
                                          : null;
                                    },
                                  ),
                                  const SizedBox(
                                    height: 15,
                                  ),
                                  TextFormField(
                                    obscureText: cubit.getIsVisible(),
                                    controller: passController,
                                    decoration: InputDecoration(
                                        icon: LinearGradientMask(
                                            child: const Icon(
                                          Icons.password,
                                          color: Colors.white,
                                        )),
                                        labelText: 'Password',
                                        suffixIcon: IconButton(
                                            onPressed: () {
                                              cubit.toggleVisibility();
                                            },
                                            icon: LinearGradientMask(
                                                child: Icon(
                                              cubit.visibleIcon,
                                              color: Colors.white,
                                            )))),
                                    validator: (String? value) {
                                      return (value!.isEmpty)
                                          ? 'Password is incorrect.'
                                          : null;
                                    },
                                  ),
                                  const SizedBox(
                                    height: 15,
                                  ),
                                  InternationalPhoneNumberInput(
                                    onInputChanged: (PhoneNumber number) {},
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
                                    textFieldController: controller,
                                    formatInput: false,
                                    keyboardType:
                                        const TextInputType.numberWithOptions(
                                            signed: true, decimal: true),
                                    inputBorder: const OutlineInputBorder(),
                                    onSaved: (PhoneNumber number) {},
                                  ),
                                  const SizedBox(
                                    height: 15,
                                  ),
                                  GradientButton(
                                    callback: () {
                                      if (formKey.currentState!.validate()) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                              content: Text('Processing Data')),
                                        );
                                        RegisterCubit.get(context).createUser(
                                            nameController.text,
                                            emailController.text,
                                            passController.text,
                                            controller.text);
                                      }
                                    },
                                    child: const Text('Register'),
                                  ),
                                  const SizedBox(
                                    height: 15,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Text("Already Have An Account?"),
                                      TextButton(
                                          onPressed: () {
                                            return navigateAndReplace(
                                                context, LoginScreen());
                                          },
                                          child: const GradientText(
                                            "LOGIN",
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
