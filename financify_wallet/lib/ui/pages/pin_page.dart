import 'package:financify_wallet/blocs/auth/auth_bloc.dart';
import 'package:financify_wallet/shared/shared_method.dart';
import 'package:financify_wallet/shared/theme.dart';
import 'package:financify_wallet/ui/widgets/buttons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

class PinPage extends StatefulWidget {
  const PinPage({super.key});

  @override
  State<PinPage> createState() => _PinPageState();
}

class _PinPageState extends State<PinPage> {
  final TextEditingController pinController = TextEditingController();
  String pin = '';
  bool isError = false;

  @override
  void initState() {
    super.initState();
    final authState = context.read<AuthBloc>().state;
    if (authState is AuthSuccess) {
      pin = authState.user.pin!;
    }
    if (Get.arguments?['clearPin'] == true) {
      pinController.clear();
    }
  }

  void addPin(String number) {
    if (pinController.text.length < 6) {
      setState(() {
        pinController.text += number;
      });

      if (pinController.text.length == 6) {
        if (pinController.text == pin) {
          Get.back(result: true);
        } else {
          setState(() {
            isError = true;
          });
          showCustomSnackbar(
              context, 'PIN yang anda masukkan salah. Silakan coba lagi.');
        }
      }
    }
  }

  void deletePin() {
    if (pinController.text.isNotEmpty) {
      setState(() {
        isError = false;
        pinController.text =
            pinController.text.substring(0, pinController.text.length - 1);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: darkBackgroundColor,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 58),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Sha PIN',
                style: whiteTextStyle.copyWith(
                  fontSize: 20,
                  fontWeight: semiBold,
                ),
              ),
              const SizedBox(height: 72),
              SizedBox(
                width: 200,
                child: TextFormField(
                  controller: pinController,
                  enabled: false,
                  obscureText: true,
                  obscuringCharacter: '*',
                  cursorColor: greyColor,
                  style: whiteTextStyle.copyWith(
                      fontSize: 36,
                      fontWeight: medium,
                      letterSpacing: 16,
                      color: isError ? redColor : whiteColor),
                  decoration: InputDecoration(
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: greyColor,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 66),
              Wrap(
                spacing: 40,
                runSpacing: 40,
                children: List.generate(12, (index) {
                  if (index == 9) return const SizedBox(width: 60, height: 60);
                  if (index == 11) {
                    return GestureDetector(
                      onTap: deletePin,
                      child: Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: numberBackgroundColor,
                        ),
                        child: Center(
                            child: Icon(
                          Icons.arrow_back,
                          color: whiteColor,
                        )),
                      ),
                    );
                  }
                  return CustomInputButton(
                    title: index == 10 ? '0' : '${index + 1}',
                    onTap: () => addPin(index == 10 ? '0' : '${index + 1}'),
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
