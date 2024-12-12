import 'dart:convert';
import 'dart:io';

import 'package:financify_wallet/blocs/auth/auth_bloc.dart';
import 'package:financify_wallet/models/signup_form_model.dart';
import 'package:financify_wallet/shared/theme.dart';
import 'package:financify_wallet/ui/pages/sign_up_success_page.dart';
import 'package:financify_wallet/ui/widgets/buttons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../shared/shared_method.dart';

class SignUpSetKtp extends StatefulWidget {
  final SignupFormModel data;

  const SignUpSetKtp({
    super.key,
    required this.data,
  });

  @override
  State<SignUpSetKtp> createState() => _SignUpSetKtpState();
}

class _SignUpSetKtpState extends State<SignUpSetKtp> {
  XFile? selectedImage;

  bool validate() {
    if (selectedImage == null) {
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<AuthBloc, AuthState>(listener: (context, state) {
        if (state is AuthFailed) {
          showCustomSnackbar(context, state.e);
        }

        if (state is AuthSuccess) {
          Get.to(() => const SignUpSuccessPage());
        }
      }, builder: (context, state) {
        if (state is AuthLoading) {
          return Center(
            child: const CircularProgressIndicator(),
          );
        }
        return ListView(
          padding: const EdgeInsets.symmetric(
            horizontal: 24,
          ),
          children: [
            Center(
              child: Container(
                width: 155,
                height: 50,
                margin: const EdgeInsets.only(
                  top: 100,
                  bottom: 100,
                ),
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/img_logo_light.png'),
                  ),
                ),
              ),
            ),
            Text(
              'Verify Your\n Account',
              style: blackTextStyle.copyWith(
                fontSize: 20,
                fontWeight: semiBold,
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Container(
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20), color: whiteColor),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () async {
                      final image = await selectImage();
                      if (image != null) {
                        setState(() {
                          selectedImage = image;
                        });
                      }
                    },
                    child: Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: lightBackgroundColor,
                        image: selectedImage == null
                            ? null
                            : DecorationImage(
                                fit: BoxFit.cover,
                                image: FileImage(
                                  File(selectedImage!.path),
                                ),
                              ),
                      ),
                      child: selectedImage != null
                          ? null
                          : Center(
                              child: Image.asset(
                                'assets/ic_upload.png',
                                width: 32,
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Text(
                    'Passport/ID Card',
                    style: blackTextStyle.copyWith(
                      fontSize: 18,
                      fontWeight: medium,
                    ),
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  CustomFilledButton(
                    title: 'Continue',
                    onPressed: () {
                      if (validate()) {
                        final encodeImage = base64Encode(
                            File(selectedImage!.path).readAsBytesSync());
                        context.read<AuthBloc>().add(
                              AuthRegister(
                                widget.data.copyWith(
                                    ktp: selectedImage == null
                                        ? null
                                        : 'data:image/png;base64,$encodeImage'),
                              ),
                            );
                      } else {
                        showCustomSnackbar(
                            context, 'Silahkan masukkkan gambar KTP anda');
                      }
                    },
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 60,
            ),
            CustomTextButton(
              title: 'Skip for Now',
              onPressed: () {
                context.read<AuthBloc>().add(
                      AuthRegister(widget.data),
                    );
              },
            ),
          ],
        );
      }),
    );
  }
}
