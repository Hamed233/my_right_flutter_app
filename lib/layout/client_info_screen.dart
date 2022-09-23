import 'package:flutter/material.dart';
import 'package:my_right/blocs/general_app_cubit/app_general_cubit.dart';
import 'package:my_right/blocs/general_app_cubit/states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_right/components/random_components.dart';
import 'package:my_right/helpers/database_helper.dart';
import 'package:my_right/models/client_model.dart';
import 'package:my_right/models/installment_model.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:my_right/utiles/helper.dart';

class ClientInfo extends StatelessWidget {
  final int clientId;

  const ClientInfo({required this.clientId, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        AppCubit cubit = AppCubit.get(context);
        List<Client> clientData = cubit.clientData;
        List<Installment> installments = cubit.installments;

        return Directionality(
          textDirection: TextDirection.rtl,
          child: Scaffold(
            appBar: AppBar(
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              title: Text("العميل"),
              centerTitle: true,
            ),
            body: ListView(
              shrinkWrap: true,
              children: [
                _clientData(context, clientData),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      if (clientData[0].left_price != '0.0')
                        Expanded(
                          child: _btnBuilder(
                              bgcolor: Colors.green,
                              onPressed: () {
                                Helper.showInstallmentBottomSheet(
                                    context, clientId);
                              },
                              title: "سداد"),
                        ),
                      if (clientData[0].left_price != '0.0')
                        SizedBox(
                          width: 5,
                        ),
                      Expanded(
                        child: _btnBuilder(
                            bgcolor: Colors.blue,
                            onPressed: () {
                              Helper.showAddClientBottomSheet(context,
                                  isUpdate: true, clientId: clientId);
                            },
                            title: "تعديل"),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Expanded(
                        child: _btnBuilder(
                            bgcolor: Colors.red,
                            onPressed: () {
                              print(clientId);
                              DatabaseHelper.instance
                                  .deleteFromTable("clients", clientId);
                              DatabaseHelper.instance
                                  .deleteFromTable("installments", clientId);
                              cubit.getclients(context);
                              Navigator.pop(context);
                            },
                            title: "حذف العميل"),
                      ),
                    ],
                  ),
                ),
                _installmentsOfClient(context, installments),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: _btnBuilder(
                      bgcolor: Colors.red,
                      onPressed: () {
                        
                        DatabaseHelper.instance
                            .deleteFromTable("installments", clientId);
                        cubit.getInstallments(context, clientId);
                      },
                      title: "حذف معلومات الدفع"),
                ),
                const SizedBox(
                  height: 20,
                ),
                if (clientData[0].left_price == '0.0')
                  Center(
                    child: Text("العميل سدد المبلغ الإجمالى بنجاح!",
                        style: Theme.of(context)
                            .textTheme
                            .headline2!
                            .copyWith(fontSize: 17, color: Colors.green)),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  DataRow _tblRowBuilder(context, Installment? model) {
    return DataRow(cells: [
      DataCell(Text(model!.id!.toString())),
      DataCell(Text(model.price!.toString() + " جنيه")),
      DataCell(Text(model.entry_date!.toString())),
    ]);
  }

  Widget _clientData(context, clientData) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.all(10),
      child: Column(
        children: [
          Text("معلومات العميل",
              style: Theme.of(context).textTheme.headline3!.copyWith(
                    fontSize: 17,
                  )),
          SizedBox(
            height: 10,
          ),
          Row(
            children: [
              Text("إسم العميل:",
                  style: Theme.of(context).textTheme.headline1!.copyWith(
                        fontSize: 17,
                      )),
              const SizedBox(
                width: 5,
              ),
              Text(clientData[0].name!,
                  style: Theme.of(context)
                      .textTheme
                      .bodyText1!
                      .copyWith(fontSize: 15, fontWeight: FontWeight.w400)),
            ],
          ),
          const Divider(),
          Row(
            children: [
              Text("المنتج:",
                  style: Theme.of(context).textTheme.headline1!.copyWith(
                        fontSize: 17,
                      )),
              const SizedBox(
                width: 5,
              ),
              Text(clientData[0].product!,
                  style: Theme.of(context)
                      .textTheme
                      .bodyText1!
                      .copyWith(fontSize: 15, fontWeight: FontWeight.w400)),
            ],
          ),
          const Divider(),
          Row(
            children: [
              Text("المبلغ الإجمالى:",
                  style: Theme.of(context).textTheme.headline1!.copyWith(
                        fontSize: 17,
                      )),
              const SizedBox(
                width: 5,
              ),
              Text(clientData[0].total_price! + " جنيه",
                  style: Theme.of(context)
                      .textTheme
                      .bodyText1!
                      .copyWith(fontSize: 15, fontWeight: FontWeight.w400)),
            ],
          ),
          const Divider(),
          Row(
            children: [
              Text("تم دفع:",
                  style: Theme.of(context).textTheme.headline1!.copyWith(
                        fontSize: 17,
                      )),
              const SizedBox(
                width: 5,
              ),
              Text(clientData[0].payed_price! + " جنيه",
                  style: Theme.of(context)
                      .textTheme
                      .bodyText1!
                      .copyWith(fontSize: 15, fontWeight: FontWeight.w400)),
            ],
          ),
          const Divider(),
          Row(
            children: [
              Text("المتبقى:",
                  style: Theme.of(context).textTheme.headline1!.copyWith(
                        fontSize: 17,
                      )),
              const SizedBox(
                width: 5,
              ),
              Text(clientData[0].left_price! + " جنيه",
                  style: Theme.of(context)
                      .textTheme
                      .bodyText1!
                      .copyWith(fontSize: 15, fontWeight: FontWeight.w400)),
            ],
          ),
          const Divider(),
          Row(
            children: [
              Text("التاريخ:",
                  style: Theme.of(context).textTheme.headline1!.copyWith(
                        fontSize: 17,
                      )),
              const SizedBox(
                width: 5,
              ),
              Text(clientData[0].entry_date ?? '',
                  style: Theme.of(context)
                      .textTheme
                      .bodyText1!
                      .copyWith(fontSize: 15, fontWeight: FontWeight.w400)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _installmentsOfClient(context, installments) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.all(10),
      child: Column(
        children: [
          Text("معلومات الدفع",
              style: Theme.of(context).textTheme.headline3!.copyWith(
                    fontSize: 17,
                  )),
          DataTable(
            columns: [
              DataColumn(
                label: Text('الرقم'),
              ),
              DataColumn(
                label: Text('تم دفع'),
              ),
              DataColumn(
                label: Text('التاريخ'),
              ),
            ],
            rows: [
              if (installments.isNotEmpty)
                for (var installment in installments)
                  _tblRowBuilder(context, installment),
            ],
          ),
          if (installments.isEmpty)
            Center(
              child: Text(
                "لا يوجد معلومات دفع، اضف الأن",
                style: Theme.of(context)
                    .textTheme
                    .headline3!
                    .copyWith(color: Colors.black),
              ),
            )
        ],
      ),
    );
  }

  Widget _btnBuilder({bgcolor, Function()? onPressed, title}) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50.0),
        color: bgcolor,
      ),
      child: MaterialButton(
        onPressed: onPressed,
        child: Text(
          title,
          style: TextStyle(
            color: Colors.white,
            fontSize: 20.0,
          ),
        ),
      ),
    );
  }
}
