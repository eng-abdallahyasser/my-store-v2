import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:store_app_v2/controller/sign_up_controller.dart';
import 'package:store_app_v2/core/constants.dart';
import 'package:store_app_v2/view/global%20widget/my_button.dart';
import 'package:store_app_v2/view/global%20widget/my_textfield.dart';
import 'package:store_app_v2/routes/my_routes.dart';

class SignUpScreen extends StatelessWidget {
  final SignUpController controller = Get.put(SignUpController());
  SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Container(
              height: MediaQuery.of(context).size.height / 4.0,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: MyColors.elsie,
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.elliptical(
                    MediaQuery.of(context).size.width,
                    105,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                top: 70.0,
              ),
              child: Column(
                children: [
                  const Center(
                    child: Text(
                      'SignUp',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const Center(
                    child: Text(
                      'Create a new account',
                      style: TextStyle(
                        color: MyColors.white,
                        fontSize: 18.0,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    margin: const EdgeInsets.all(20),
                    child: Material(
                      color: Colors.white,
                      elevation: 5.0,
                      borderRadius: BorderRadius.circular(
                        20,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: GetBuilder<SignUpController>(
                          builder: (_) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(
                                  height: 10,
                                ),
                                MyTextfield(
                                  hintText: 'Name',
                                  controller: controller.nameController,
                                  obscureText: false,
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                MyTextfield(
                                  hintText: 'Email',
                                  controller: controller.emailController,
                                  obscureText: false,
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Row(children: [
                                  Expanded(
                                    child: MyTextfield(
                                      hintText: 'Password',
                                      controller: controller.pwController,
                                      obscureText: controller.showPassword,
                                    ),
                                  ),
                                  IconButton(
                                      onPressed: () {
                                        controller.hidePassword();
                                      },
                                      icon:
                                          const Icon(Icons.remove_red_eye_outlined))
                                ]),
                                const SizedBox(
                                  height: 20,
                                ),
                                Row(children: [
                                  Expanded(
                                    child: MyTextfield(
                                      hintText: 'Confirm password',
                                      controller: controller.confirmPwController,
                                      obscureText: controller.showConfirmPassword,
                                    ),
                                  ),
                                  IconButton(
                                      onPressed: () {
                                        controller.hideConfirmPassword();
                                      },
                                      icon:
                                          const Icon(Icons.remove_red_eye_outlined))
                                ]),
                                const SizedBox(
                                  height: 30,
                                ),
                                Center(
                                  child: GestureDetector(
                                    onTap: controller.signUp,
                                    child: const MyButton(
                                      text: "Sign Up",
                                    ),
                                  ),
                                ),
                              ],
                            );
                          }
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "I already have acount, ",
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Get.offAllNamed(MyRoutes.signInScreen);
                          },
                          child: const Text(
                            "Sign In Now",
                            style: TextStyle(
                              fontSize: 18.0,
                              color: Color(0xff7f30fe),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
