import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:my_right/blocs/general_app_cubit/app_general_cubit.dart';
import 'package:my_right/blocs/general_app_cubit/states.dart';
import 'package:my_right/components/constatnts.dart';
import 'package:my_right/components/default_form_field.dart';
import 'package:my_right/components/random_components.dart';
import 'package:my_right/layout/auth/register/register_screen.dart';
import 'package:my_right/layout/layout_of_app.dart';
import 'package:my_right/local/cache_helper.dart';
import 'package:my_right/styles/colors.dart';
import 'package:my_right/utiles/helper.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginScreen extends StatelessWidget {
  var usernameController = TextEditingController();
  var passwordController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {
        if (state is AppLoginSuccessState) {
          Helper.showCustomSnackBar(context,
              content: "تم تسجيل الدخول بنجاح",
              bgColor: Colors.green,
              textColor: Colors.white);
          userId = state.uId;
          CacheHelper.saveData(
            key: "user_id",
            value: state.uId,
          ).then((value) {
            navigateAndFinish(
              context,
              AppLayout(),
            );
          });
        } else if (state is AppLoginErrorState) {
          Helper.showCustomSnackBar(context,
              content: state.error,
              bgColor: Colors.red,
              textColor: Colors.white);
        }
      },
      builder: (context, state) {
        return Scaffold(
            // backgroundColor: Colors.white,
            body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Center(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _headerSection(),
                    _userInputsAndSendForm(state, context),
                    _footerSection(context),
                  ],
                ),
              ),
            ),
          ),
        ));
      },
    );
  }

  Widget _headerSection() {
    return Column(
      children: [
        Text(
          "Welcome Back!",
          style: TextStyle(
            fontSize: 30.0,
            letterSpacing: 2.0,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const SizedBox(
          height: 10.0,
        ),
        Text(
          "login to your existant account",
          style: TextStyle(
            fontSize: 16.0,
            color: Colors.grey,
          ),
        ),
        const SizedBox(
          height: 25.0,
        ),
      ],
    );
  }

  Widget _userInputsAndSendForm(state, context) {
    return Column(
      children: [
        DefaultFormField(
          type: TextInputType.text,
          controller: usernameController,
          label: "إسم المستخدم",
          focusedColorBorder: HexColor("#ced4da"),
          borderWidth: 50.0,
          prefixColorIcon: Colors.grey,
          prefix: Icons.person,
          validate: (username) {
            if (username == null || username.isEmpty) {
              return 'أدخل إسم المستخدم';
            }
            return null;
          },
          borderColor: HexColor("#ced4da"),
        ),
        const SizedBox(
          height: 10.0,
        ),
        DefaultFormField(
          type: TextInputType.visiblePassword,
          controller: passwordController,
          label: "كلمة المرور",
          isPassword: AppCubit.get(context).isPassword,
          focusedColorBorder: HexColor("#ced4da"),
          labelColor: Colors.grey,
          borderWidth: 50.0,
          prefixColorIcon: Colors.grey,
          prefix: Icons.password,
          suffix: AppCubit.get(context).suffix,
          maxLines: 1,
          isSuffix: true,
          suffixPressed: () => AppCubit.get(context).changePasswordVisibility(),
          validate: (password) {
            if (password == null || password.isEmpty) {
              return 'أدخل كلمة المرور';
            } else if (password.length < 5) {
              return 'يجب أن تكون كلمة السر أكبر من 5 حروف';
            }
            return null;
          },
          borderColor: HexColor("#ced4da"),
        ),
        const SizedBox(
          height: 5.0,
        ),
        ConditionalBuilder(
          condition: state is! AppLoginLoadingState,
          builder: (context) => Container(
            width: MediaQuery.of(context).size.width * 0.5,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50.0),
              color: mainColor,
            ),
            child: MaterialButton(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  SystemChannels.textInput
                      .invokeMethod('TextInput.hide'); //hides the keyboard
                  AppCubit.get(context).userLogin(
                      username: usernameController.text,
                      password: passwordController.text);
                }
              },
              child: Text(
                "تسجيل الدخول".toUpperCase(),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                ),
              ),
            ),
          ),
          fallback: (context) =>
              const Center(child: CircularProgressIndicator()),
        ),
        const SizedBox(
          height: 30.0,
        ),
      ],
    );
  }

  Widget _footerSection(context) {
    return Column(
      children: [
        SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(0),
              child: TextButton(
                  onPressed: () {
                    AppCubit.get(context).getUsers();
                    navigateTo(context, RegisterScreen());
                  },
                  child: Text(
                    "إنشاء حساب",
                    style: TextStyle(
                        color: mainColor, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.left,
                  )),
            ),
            Text(
              "ليس لديك حساب؟",
              textDirection: TextDirection.ltr,
              style: TextStyle(
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
