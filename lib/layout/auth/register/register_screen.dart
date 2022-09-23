import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:my_right/blocs/general_app_cubit/app_general_cubit.dart';
import 'package:my_right/blocs/general_app_cubit/states.dart';
import 'package:my_right/components/default_form_field.dart';
import 'package:my_right/components/random_components.dart';
import 'package:my_right/layout/auth/login/login_screen.dart';
import 'package:my_right/models/user_model.dart';
import 'package:my_right/styles/colors.dart';
import 'package:my_right/utiles/helper.dart';


class RegisterScreen extends StatelessWidget {
  var emailController = TextEditingController();
  var usernameController = TextEditingController();
  var passwordController = TextEditingController();

  User? model;

  final formKey = GlobalKey<FormState>();
  bool isApiCallProcess = false;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {
        if (state is AppRegisterSuccessState) {
            Helper.showCustomSnackBar(
              context,
              content: "تم إنشاء الحساب، سجل الدخول الأن!",
              bgColor: Colors.green,
              textColor: Colors.white
            );

           navigateAndFinish(
              context,
              LoginScreen(),
            );
        } else if (state is AppRegisterErrorState) {
          Helper.showCustomSnackBar(context,
              content: state.error,
              bgColor: Colors.red,
              textColor: Colors.white);
        }
      },
      builder: (context, state) {
        List<User> users = AppCubit.get(context).users;
        List namesOfUsers = [];
        for(var user in users) {
          namesOfUsers.add(user.username);
        }

        return Scaffold(
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
                    _userInputAndSendForm(state, context, namesOfUsers),
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
      children: const [
        Text(
          "Let's Get Started",
          style: TextStyle(
            fontSize: 28.0,
            letterSpacing: 1.0,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        SizedBox(
          height: 10.0,
        ),
        Text(
          "Create a new account in small steps!",
          style: TextStyle(
            fontSize: 16.0,
            color: Colors.grey,
          ),
        ),
        SizedBox(
          height: 15.0,
        ),
      ],
    );
  }

  Widget _userInputAndSendForm(state, context, namesOfUsers) {
    return Column(
      children: [
        const SizedBox(
          height: 10,
        ),
        DefaultFormField(
          type: TextInputType.text,
          controller: usernameController,
          label: "إسم المستخدم",
          focusedColorBorder: HexColor("#ced4da"),
          labelColor: Colors.grey,
          borderWidth: 50.0,
          prefixColorIcon: Colors.grey,
          prefix: Icons.person,
          validate: (usernameVal) {
            final RegExp _messageRegex = RegExp(r'[a-zA-Z0-9]');
            if (usernameVal!.length < 3) {
              return 'Username must have atleast 3 characters';
            } else if (usernameVal.contains('@')) {
              return 'Sign @ not allowed';
            } else if (!_messageRegex.hasMatch(usernameVal)) {
              return 'Emoji not supported';
            } else if (usernameVal.isEmpty || usernameVal == null) {
              return "أدخل إسم المستخدم";
            } else if (namesOfUsers.contains(usernameVal)) {
              return "هذا المستخدم موجود بالفعل، أدخل إسم أخر!";
            }
            return null;
          },
          borderColor: HexColor("#ced4da"),
        ),
        const SizedBox(
          height: 10.0,
        ),
        DefaultFormField(
          type: TextInputType.emailAddress,
          controller: emailController,
          label: "البريد الإلكترونى",
          focusedColorBorder: HexColor("#ced4da"),
          labelColor: Colors.grey,
          borderWidth: 50.0,
          prefixColorIcon: Colors.grey,
          prefix: Icons.alternate_email,
          validate: (emailVal) {
            bool emailValid = RegExp(
                    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                .hasMatch(emailVal!);
            if (emailVal == null || emailVal.isEmpty) {
              return 'أدخل البريد الإلكترونى';
            } else if (!emailValid) {
              return 'البريد الإلكترونى غير صالح';
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
          focusedColorBorder: HexColor("#ced4da"),
          labelColor: Colors.grey,
          borderWidth: 50.0,
          prefixColorIcon: Colors.grey,
          prefix: Icons.person,
          isPassword: AppCubit.get(context).isPassword,
          suffix: AppCubit.get(context).suffix,
          isSuffix: true,
          maxLines: 1,
          suffixPressed: () => AppCubit.get(context).changePasswordVisibility(),
          validate: (passwordVal) {
            if (passwordVal == null || passwordVal.isEmpty) {
              return 'أدخل كلمة المرور';
            } else if (passwordVal.length < 5) {
              return 'يجب أن تكون كلمة السر أكبر من 5 حروف';
            }
            return null;
          },
          borderColor: HexColor("#ced4da"),
        ),
        const SizedBox(
          height: 15.0,
        ),
        ConditionalBuilder(
          condition: state is! AppRegisterSuccessState,
          builder: (context) => Container(
            width: MediaQuery.of(context).size.width * 0.5,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50.0),
              color: mainColor,
            ),
            child: MaterialButton(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  SystemChannels.textInput.invokeMethod('TextInput.hide');
                  AppCubit.get(context).createUser(context,
                      name: usernameController.text,
                      email: emailController.text,
                      password: passwordController.text);
                }
              },
              child: Text(
                "إنشاء حساب".toUpperCase(),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                ),
              ),
            ),
          ),
          fallback: (context) => const Center(child: CircularProgressIndicator()),
        ),
        const SizedBox(
          height: 30.0,
        ),
      ],
    );
  }

  Widget _footerSection(context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(0),
          width: 95,
          child: TextButton(
              onPressed: () {
                navigateTo(context, LoginScreen());
              },
              child: Text(
                "تسجيل الدخول",
                style: TextStyle(
                    color: mainColor,
                    fontWeight: FontWeight.bold),
              )),
        ),
      
        Text(
          "هل لديك حساب؟",
          textDirection: TextDirection.ltr,
          style: TextStyle(
            color: Colors.grey,
          ),
        ),
      ],  
    );
  }
}
