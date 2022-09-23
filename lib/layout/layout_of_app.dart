import 'package:flutter/material.dart';
import 'package:my_right/blocs/general_app_cubit/app_general_cubit.dart';
import 'package:my_right/blocs/general_app_cubit/states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_right/components/random_components.dart';
import 'package:my_right/layout/home_screen.dart';
import 'package:my_right/layout/search_screen.dart';
import 'package:my_right/styles/colors.dart';
import 'package:my_right/utiles/helper.dart';

class AppLayout extends StatelessWidget {

  var scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {


    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        
        var cubit = AppCubit.get(context);

        return Directionality(
          textDirection: TextDirection.rtl,
          child: Scaffold(
            key: scaffoldKey,
            appBar: AppBar(
              elevation: 0,
              leading: Icon(
                Icons.attach_money_outlined,
                color: mainColor,),
              titleSpacing: 0,
              title: Text("إقساطى"),
              actions: [
                IconButton(onPressed: (
                ) {
                  navigateTo(context, SearchScreen());
                }, icon: const Icon(Icons.search)),
                IconButton(onPressed: (
                ) {
                  AppCubit.get(context).signOut(context);
                }, icon: const Icon(Icons.logout_outlined)),
                
              ],
            ),
            body: HomeScreen(),
            
            floatingActionButton: FloatingActionButton(
              backgroundColor: mainColor,
              child: Icon(Icons.add),
              onPressed: () {
                Helper.showAddClientBottomSheet(context, isUpdate: false);
              },
            ),
          ),
        );
      },
    );
  }
}