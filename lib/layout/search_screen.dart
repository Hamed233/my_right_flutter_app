import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_right/blocs/general_app_cubit/app_general_cubit.dart';
import 'package:my_right/blocs/general_app_cubit/states.dart';
import 'package:my_right/components/random_components.dart';
import 'package:my_right/layout/client_info_screen.dart';
import 'package:my_right/models/client_model.dart';
import 'package:my_right/styles/colors.dart';

class SearchScreen extends StatelessWidget {

  SearchScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var searchController = TextEditingController();

    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = AppCubit.get(context);
        return Scaffold(
          appBar: AppBar(
            backgroundColor: mainColor,
            elevation: 0,
            titleSpacing: 0,
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back_ios,
                color: Colors.white,
              ),
              onPressed: () => Navigator.of(context).pop(context),
            ),
            title: Container(
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(5)),
              width: double.infinity,
              height: 40,
              margin: const EdgeInsetsDirectional.only(end: 14.0),
              child: Center(
                child: TextFormField(
                  controller: searchController,
                  autofocus: true,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    hintText: "search",
                    prefixIcon: Icon(
                      Icons.search,
                      color: mainColor,
                    ),
                    focusColor: mainColor,
                    border: InputBorder.none,
                  ),
                  cursorColor: mainColor,
                  validator: (String? value) {
                    if (value!.isEmpty) {
                      return 'Enter text to search';
                    }
                    return null;
                  },

                  onChanged: (String text) {
                    cubit.search(text);
                  },

                ),
              ),
            ),

          ),
          body: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  SizedBox(
                    height: 10.0,
                  ),
                  if (state is SearchClientLoadingState) Center(child: CircularProgressIndicator()),
                  SizedBox(height: 5.0,),
                  if (state is RetrieveClientDataFromDatabase)
                    ConditionalBuilder(
                      condition: cubit.searchList.length > 0,
                      builder: (context) { 
                        return Column(
                        children: List.generate(
                          cubit.searchList.length,
                              (index) {
                            return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  color: Colors.white,
                  height: MediaQuery.of(context).size.height,
                  child: ListView(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    children: [
                      const SizedBox(height: 10),
                      DataTable(
                        columns: [
                          DataColumn(
                            label: Text('الرقم'),
                          ),
                          DataColumn(
                            label: Text('العميل'),
                          ),
                          DataColumn(
                            label: Text('المنتج'),
                          ),
                          DataColumn(
                            label: Text('الإجمالى'),
                          ),
                          DataColumn(
                            label: Text('تم دفع'),
                          ),
                          DataColumn(
                            label: Text('الباقى'),
                          ),
                          DataColumn(
                            label: Text('التاريخ'),
                          ),
                        ],
                        rows: [
                          if(cubit.clients.isNotEmpty)
                            for (var client in cubit.clients)
                              _tblRowBuilder(context, client),
                        ],
                      ),

                     
                    ],
                  ),
                ),
              );
                          },
                        ),
                      );
                      },
                      fallback: (context) => Text("لا يوجد بيانات")),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  DataRow _tblRowBuilder(context, Client? model) {
    return DataRow(cells: [
      DataCell(Text(model!.id!.toString())),
      DataCell(
        Text(
          model.name!.toString(),
          style: Theme.of(context).textTheme.bodyText1,
        ),
        onTap: () {
            AppCubit.get(context).getClientData(model.id!);
            AppCubit.get(context).getInstallments(context, model.id!);
            navigateTo(context, ClientInfo(clientId: model.id!));
        },
      ),
      DataCell(Text(model.product!.toString())),
      DataCell(Text('${model.total_price!.toString()} جنيه')),
      DataCell(Text('${model.payed_price!.toString()} جنيه')),
      DataCell(Text('${model.left_price!.toString()} جنيه')),
      DataCell(Text(model.entry_date!.toString())),
    ]);
  }
}
