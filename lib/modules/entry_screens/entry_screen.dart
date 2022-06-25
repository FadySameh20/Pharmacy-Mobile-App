// ignore_for_file: unnecessary_const

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gradient_widgets/gradient_widgets.dart';
import 'package:pharmacy_management_system/modules/entry_screens/register_screen/register_screen.dart';

import 'package:pharmacy_management_system/shared/components/components.dart';
import 'package:pharmacy_management_system/shared/styles/colors.dart';

import 'login_screen/login_screen.dart';

class EntryScreen extends StatelessWidget {
  const EntryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: defaultColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarBrightness: Brightness.light,
        ),
      ),
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
                    child: Text("Welcome To Pharmacy App",
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
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20))),
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(children: [
                      Text(
                        "Login or Register to browse our platform",
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        width: 150,
                        child: GradientButton(
                          callback: () {
                            navigateAndReplace(context, LoginScreen());
                          },
                          child: const Text('LOGIN'),
                        ),
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        width: 150,
                        child: GradientButton(
                          callback: () {
                            navigateAndReplace(context, RegisterScreen());
                          },
                          child: const Text('REGISTER'),
                        ),
                      ),
                    ]),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
