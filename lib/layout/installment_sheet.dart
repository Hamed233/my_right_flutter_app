import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:my_right/blocs/general_app_cubit/app_general_cubit.dart';
import 'package:my_right/blocs/general_app_cubit/states.dart';
import 'package:my_right/components/default_form_field.dart';
import 'package:my_right/components/random_components.dart';
import 'package:my_right/helpers/database_helper.dart';
import 'package:my_right/models/client_model.dart';
import 'package:my_right/models/installment_model.dart';
import 'package:my_right/styles/colors.dart';
import 'package:my_right/utiles/helper.dart';

class InstallmentSheet extends StatefulWidget {
  int clientId;

  InstallmentSheet(this.clientId);

  static GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  State<InstallmentSheet> createState() => _InstallmentSheetState();
}

class _InstallmentSheetState extends State<InstallmentSheet> {
  Client? client;

  TextEditingController priceController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    AppCubit cubit = AppCubit.get(context);
    List<Client> clientData = cubit.clientData;
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return Material(
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    height: 50,
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Spacer(),
                          Center(
                            child: Text('إضافة قسط',
                                style: Theme.of(context).textTheme.headline3),
                          ),
                          Spacer(),
                          CircleAvatar(
                            radius: 25,
                            backgroundColor: mainColor,
                            child: state is! GettingClientDataLoading
                                ? IconButton(
                                    icon: Icon(
                                      Icons.arrow_upward,
                                      color: Colors.white,
                                    ),
                                    onPressed: () {
                                      if (InstallmentSheet.formKey.currentState!
                                          .validate()) {
                                        Installment installment = Installment(
                                          price:
                                              int.parse(priceController.text),
                                          entry_date:
                                              DateFormat('dd, MMMM yyyy')
                                                  .format(DateTime.now())
                                                  .toString(),
                                          client_id: widget.clientId,
                                        );

                                        DatabaseHelper.instance
                                            .insertDataToTable(context,
                                                installment: installment);
                                        cubit
                                            .updateClientData(
                                          (double.parse(
                                                  clientData[0].left_price!) -
                                              double.parse(
                                                  priceController.text)),
                                          (double.parse(
                                                  clientData[0].payed_price!) +
                                              double.parse(
                                                  priceController.text)),
                                          widget.clientId,
                                        )
                                            .then((value) {
                                          cubit.getInstallments(
                                              context, widget.clientId);
                                          cubit.getClientData(widget.clientId);
                                          priceController.clear();
                                        });
                                      }
                                    },
                                  )
                                : Padding(
                                    padding: const EdgeInsets.only(
                                        bottom: 50, top: 30),
                                    child: Center(
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom),
                  child: Container(
                    padding: EdgeInsets.only(
                      left: 20,
                      right: 20,
                    ),
                    child: Form(
                      key: InstallmentSheet.formKey,
                      child: SingleChildScrollView(
                        physics: BouncingScrollPhysics(
                          parent: AlwaysScrollableScrollPhysics(),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            SizedBox(
                              height: 30,
                            ),
                            DefaultFormField(
                              controller: priceController,
                              label: 'المبلغ',
                              focusedColorBorder: Colors.white38,
                              type: TextInputType.number,
                              prefixColorIcon: Colors.grey[800],
                              labelColor: Colors.grey[800],
                              prefix: Icons.description_outlined,
                              borderColor: Colors.grey,
                              onChange: (val) {
                                if(val.isNotEmpty)
                                  cubit.getTotalPrice(val);
                              },
                              validate: (String? val) {
                                if (val!.isEmpty || !isNumeric(val)) {
                                  return "أدخل قيمة صالحة";
                                } else if (double.parse(val) >
                                    (double.parse(clientData[0].left_price!))) {
                                  return "المبلغ يجب ان يكون اقل من أو يساوى المبلغ المتبقى";
                                }

                                return null;
                              },
                            ),
                            SizedBox(
                              height: 30,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
