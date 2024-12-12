import 'package:financify_wallet/blocs/data_plan/data_plan_bloc.dart';
import 'package:financify_wallet/models/data_plan_form_model.dart';
import 'package:financify_wallet/models/data_plan_model.dart';
import 'package:financify_wallet/models/operator_card_model.dart';
import 'package:financify_wallet/shared/theme.dart';
import 'package:financify_wallet/ui/pages/pin_page.dart';
import 'package:financify_wallet/ui/pages/success_page.dart';
import 'package:financify_wallet/ui/widgets/forms.dart';
import 'package:financify_wallet/ui/widgets/package_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

import '../../blocs/auth/auth_bloc.dart';
import '../../shared/shared_method.dart';
import '../widgets/buttons.dart';

class DataPackagePage extends StatefulWidget {
  final OperatorCardModel operatorCard;

  const DataPackagePage({
    super.key,
    required this.operatorCard,
  });

  @override
  State<DataPackagePage> createState() => _DataPackagePageState();
}

class _DataPackagePageState extends State<DataPackagePage> {
  final phoneController = TextEditingController(text: '');
  DataPlanModel? selectedDataPlan;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DataPlanBloc(),
      child:
          BlocConsumer<DataPlanBloc, DataPlanState>(listener: (context, state) {
        if (state is DataPlanFailed) {
          showCustomSnackbar(context, state.e);
        }
        if (state is DataPlanSuccess) {
          context
              .read<AuthBloc>()
              .add(AuthUpdateBalance(selectedDataPlan!.price! * -1));
          Get.offAll(() => SuccessPage(
                title: 'Paket Data\nBerhasil Terbeli',
              ));
        }
      }, builder: (context, state) {
        if (state is DataPlanLoading) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
        return Scaffold(
          appBar: AppBar(
            title: const Text('Data Package'),
          ),
          body: ListView(
            padding: const EdgeInsets.symmetric(
              horizontal: 24,
            ),
            children: [
              const SizedBox(
                height: 30,
              ),
              Text(
                'Phone Number',
                style: blackTextStyle.copyWith(
                  fontSize: 16,
                  fontWeight: semiBold,
                ),
              ),
              CustomFormField(
                title: '+628',
                isShowTitle: false,
                controller: phoneController,
              ),
              const SizedBox(
                height: 40,
              ),
              Text(
                'Select Package',
                style: blackTextStyle.copyWith(
                  fontSize: 16,
                  fontWeight: semiBold,
                ),
              ),
              const SizedBox(
                height: 40,
              ),
              Wrap(
                spacing: 17,
                runSpacing: 17,
                children: widget.operatorCard.dataPlans?.isNotEmpty == true
                    ? widget.operatorCard.dataPlans!
                        .map(
                          (dataPlan) => GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedDataPlan = dataPlan;
                              });
                            },
                            child: PackageItem(
                              dataPlan: dataPlan,
                              isSelected: dataPlan.id == selectedDataPlan?.id,
                            ),
                          ),
                        )
                        .toList()
                    : [
                        Center(
                          child: Text(
                            'No data plans available',
                            style: greyTextStyle.copyWith(
                              fontSize: 14,
                              fontWeight: medium,
                            ),
                          ),
                        ),
                      ],
              ),
            ],
          ),
          floatingActionButton:
              (selectedDataPlan != null && phoneController.text.isNotEmpty)
                  ? Container(
                      margin: const EdgeInsets.all(24),
                      child: CustomFilledButton(
                        title: 'Continue',
                        onPressed: () async {
                          final result = await Get.to(() => const PinPage(),
                              arguments: {'clearPin': true});

                          if (result == true) {
                            final authState = context.read<AuthBloc>().state;
                            String pin = '';
                            if (authState is AuthSuccess) {
                              pin = authState.user.pin!;
                            }

                            context.read<DataPlanBloc>().add(
                                  DataPlanPost(
                                    DataPlanFormModel(
                                      dataPlanId: selectedDataPlan!.id,
                                      phoneNumber: phoneController.text,
                                      pin: pin,
                                    ),
                                  ),
                                );
                          }
                        },
                      ),
                    )
                  : Container(),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
        );
      }),
    );
  }
}
