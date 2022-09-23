import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:my_right/blocs/general_app_cubit/app_general_cubit.dart';
import 'package:my_right/blocs/general_app_cubit/states.dart';
import 'package:my_right/components/constatnts.dart';
import 'package:my_right/components/default_form_field.dart';
import 'package:my_right/components/random_components.dart';
import 'package:my_right/helpers/database_helper.dart';
import 'package:my_right/models/client_model.dart';
import 'package:my_right/models/installment_model.dart';
import 'package:my_right/styles/colors.dart';
import 'package:my_right/utiles/helper.dart';

class ClientSheet extends StatefulWidget {
  bool isUpdate;
  int clientId;

  ClientSheet(this.isUpdate, this.clientId);

  static GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  State<ClientSheet> createState() => _ClientSheetState();
}

class _ClientSheetState extends State<ClientSheet> {
  Client? client;

  TextEditingController nameController = TextEditingController();
  TextEditingController productController = TextEditingController();
  TextEditingController totalPriceController = TextEditingController();
  TextEditingController payedPriceController = TextEditingController();
        bool dataIsGet = false;


  @override
  void dispose() {
    nameController.dispose();
    productController.dispose();
    totalPriceController.dispose();
    payedPriceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    AppCubit cubit = AppCubit.get(context);
    var originalDate;
    if (widget.isUpdate) {
      List<Client> clientData = cubit.clientData;

      if (clientData.isNotEmpty) {
        originalDate = clientData[0].entry_date;
        nameController = TextEditingController()
          ..text = clientData[0].name.toString();
        productController = TextEditingController()
          ..text = clientData[0].product.toString();

        if (!dataIsGet) {
          totalPriceController =
              TextEditingController(text: clientData[0].total_price.toString());
          payedPriceController =
              TextEditingController(text: clientData[0].payed_price.toString());
          cubit.totalPrice = double.parse(clientData[0].total_price.toString());
          cubit.payedPrice = double.parse(clientData[0].payed_price.toString());
          cubit.leftPrice = double.parse(clientData[0].left_price.toString());
          dataIsGet = true;
        }
      }
    }
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
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Spacer(),
                          Center(
                            child: Text(
                              widget.isUpdate ? 'تعديل عميل' : 'إضافة عميل',
                              style: Theme.of(context).textTheme.headline3,
                              textAlign: TextAlign.center,
                            ),
                          ),
                          const Spacer(),
                          CircleAvatar(
                            radius: 25,
                            backgroundColor: mainColor,
                            child: IconButton(
                              icon: Icon(
                                widget.isUpdate
                                    ? Icons.check
                                    : Icons.arrow_upward,
                                color: Colors.white,
                              ),
                              onPressed: () {
                                if (ClientSheet.formKey.currentState!
                                    .validate()) {
                                  if (widget.isUpdate) {
                                    Client client = Client(
                                      name: nameController.text,
                                      product: productController.text,
                                      total_price: totalPriceController.text,
                                      payed_price: payedPriceController.text,
                                      left_price: cubit.leftPrice.toString(),
                                      entry_date: originalDate,
                                      userId: userId,
                                    );

                                    client.id = widget.clientId;

                                    DatabaseHelper.instance
                                        .updateTable(client: client)
                                        .then((value) {
                                      cubit.getClientData(widget.clientId);
                                      totalPriceController.clear();
                                      payedPriceController.clear();
                                      cubit.leftPrice = 0.0;
                                      cubit.totalPrice = 0.0;
                                      cubit.payedPrice = 0.0;
                                      print(cubit.totalPrice);
                                      print(cubit.payedPrice);
                                      Navigator.pop(context);
                                      Helper.showCustomSnackBar(context,
                                          content: "تم التعديل بنجاح!",
                                          bgColor: Colors.green,
                                          textColor: Colors.white);
                                    });
                                  } else {
                                    Client client = Client(
                                      name: nameController.text,
                                      product: productController.text,
                                      total_price: totalPriceController.text,
                                      payed_price: payedPriceController.text,
                                      left_price: cubit.leftPrice.toString(),
                                      entry_date: DateFormat("dd, MMMM yyyy")
                                          .format(DateTime.now())
                                          .toString(),
                                      userId: int.parse(userId),
                                    );

                                    DatabaseHelper.instance
                                        .insertDataToTable(context,
                                            client: client)
                                        .then((value) {
                                      cubit.getclients(context);
                                      nameController.clear();
                                      productController.clear();
                                      totalPriceController.clear();
                                      payedPriceController.clear();
                                      cubit.leftPrice = 0.0;
                                      cubit.totalPrice = 0.0;
                                      cubit.payedPrice = 0.0;

                                      Helper.showCustomSnackBar(context,
                                          content: "تم إضافة العميل بنجاح!",
                                          bgColor: Colors.green,
                                          textColor: Colors.white);
                                    });
                                  }
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                state is! GettingClientDataLoading
                    ? Padding(
                        padding: EdgeInsets.only(
                            bottom: MediaQuery.of(context).viewInsets.bottom),
                        child: Container(
                          padding: EdgeInsets.only(
                            left: 20,
                            right: 20,
                          ),
                          child: Form(
                            key: ClientSheet.formKey,
                            child: SingleChildScrollView(
                              physics: BouncingScrollPhysics(
                                parent: AlwaysScrollableScrollPhysics(),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  SizedBox(height: 20),
                                  DefaultFormField(
                                    controller: nameController,
                                    label: 'إسم العميل',
                                    autoFocus: true,
                                    focusedColorBorder: Colors.white38,
                                    hintText: 'إسم العميل',
                                    labelColor: Colors.grey[800],
                                    type: TextInputType.text,
                                    prefixColorIcon: Colors.grey[800],
                                    prefix: Icons.person,
                                    validate: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'أدخل إسم العميل';
                                      }
                                      return null;
                                    },
                                    borderColor: Colors.grey,
                                  ),
                                  SizedBox(height: 10),
                                  DefaultFormField(
                                    controller: productController,
                                    label: 'المنتج',
                                    focusedColorBorder: Colors.white38,
                                    type: TextInputType.text,
                                    prefixColorIcon: Colors.grey[800],
                                    labelColor: Colors.grey[800],
                                    prefix: Icons.description_outlined,
                                    borderColor: Colors.grey,
                                  ),
                                  const SizedBox(height: 10),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: DefaultFormField(
                                          controller: payedPriceController,
                                          label: 'المبلغ المدفوع',
                                          focusedColorBorder: Colors.white38,
                                          type: TextInputType.number,
                                          prefixColorIcon: Colors.grey[800],
                                          labelColor: Colors.grey[800],
                                          prefix: Icons.description_outlined,
                                          borderColor: Colors.grey,
                                          onChange: (val) {

                                            if (val.isNotEmpty)
                                              cubit.getPayedPrice(val);
                                            if (val.isNotEmpty &&
                                                cubit.totalPrice != 0.0)
                                              cubit.getCalcLeftPrice();
                                          },
                                          validate: (String? val) {
                                    
                                            if (val!.isEmpty ||
                                                !isNumeric(val)) {
                                              return "أدخل قيمة صالحة";
                                            } else if (double.parse(val) >
                                                double.parse(cubit.totalPrice
                                                    .toString())) {
                                              return "المبلغ الدفوع أكبر من المبلغ الكلى!";
                                            }

                                            return null;
                                          },
                                        ),
                                      ),
                                      const SizedBox(width: 5),
                                      Expanded(
                                        child: DefaultFormField(
                                          controller: totalPriceController,
                                          label: 'المبلغ الكلى',
                                          focusedColorBorder: Colors.white38,
                                          type: TextInputType.number,
                                          prefixColorIcon: Colors.grey[800],
                                          labelColor: Colors.grey[800],
                                          prefix: Icons.description_outlined,
                                          borderColor: Colors.grey,
                                          onChange: (val) {
                                            print(val);
                                            print(cubit.payedPrice);
                                            if (val.isNotEmpty)
                                              cubit.getTotalPrice(val);
                                            if (val.isNotEmpty &&
                                                cubit.payedPrice != 0.0)
                                              cubit.getCalcLeftPrice();
                                          },
                                          validate: (String? val) {
                                            if (val!.isEmpty ||
                                                !isNumeric(val)) {
                                              return "أدخل قيمة صالحة";
                                            }

                                            return null;
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 20),
                                  Row(
                                    children: [
                                      Text(
                                        state is GettingClientsDone
                                            ? '0.0'
                                            : cubit.leftPrice.toString(),
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline2,
                                      ),
                                      const Spacer(),
                                      Text(":المبلغ المتبقى",
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline3),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      )
                    : Padding(
                        padding: const EdgeInsets.only(bottom: 50, top: 30),
                        child: Center(
                          child: CircularProgressIndicator(
                            color: mainColor,
                          ),
                        ),
                      ),
              ],
            ),
          ),
        );
      },
    );
  }
}
