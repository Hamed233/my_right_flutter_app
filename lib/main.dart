import 'dart:io';

import 'package:flutter/material.dart';
import 'package:my_right/blocs/bloc_observer.dart';
import 'package:my_right/blocs/general_app_cubit/app_general_cubit.dart';
import 'package:my_right/components/constatnts.dart';
import 'package:my_right/layout/auth/login/login_screen.dart';
import 'package:my_right/layout/layout_of_app.dart';
import 'package:my_right/local/cache_helper.dart';
import 'package:my_right/styles/themes.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'blocs/general_app_cubit/states.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = MyBlocObserver();
  await CacheHelper.init();

  Widget widget = userId.isNotEmpty ? AppLayout() : LoginScreen();

  runApp(MyApp(
    startWidget: widget,
  ));
}

class MyApp extends StatelessWidget {
  MyApp({this.startWidget});
  final Widget? startWidget;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AppCubit>(
          create: (BuildContext context) => AppCubit()
            ..getclients(context)
        ),
      ],
      child: BlocConsumer<AppCubit, AppStates>(
        listener: (context, state) {},
        builder: (context, state) {
          return Directionality(
            textDirection: TextDirection.rtl,
            child: MaterialApp(
              title: "إقساطى",
              debugShowCheckedModeBanner: false,
              theme: lightTheme,
              darkTheme: darkTheme,
              themeMode: ThemeMode.light,
              home: startWidget,
            ),
          );
        },
      ),
    );
  }
}
