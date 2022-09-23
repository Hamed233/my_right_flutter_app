import 'package:flutter/material.dart';
import 'package:my_right/blocs/general_app_cubit/app_general_cubit.dart';
import 'package:my_right/blocs/general_app_cubit/states.dart';
import 'package:my_right/components/default_form_field.dart';
import 'package:my_right/components/random_components.dart';
import 'package:my_right/layout/client_info_screen.dart';
import 'package:my_right/models/client_model.dart';
import 'package:my_right/models/user_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    TextEditingController searchController  = TextEditingController();

    return BlocConsumer<AppCubit, AppStates>(
        listener: (context, state) {},
        builder: (context, state) {
          AppCubit cubit = AppCubit.get(context);

          return Directionality(
            textDirection: TextDirection.rtl,
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
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
              ),
            ),
          );
        });
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
      DataCell(
        Text(
          model.entry_date.toString(),
        )),
    ]);
  }
}
