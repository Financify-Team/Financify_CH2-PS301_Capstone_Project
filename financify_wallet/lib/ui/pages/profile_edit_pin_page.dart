import 'package:financify_wallet/blocs/auth/auth_bloc.dart';
import 'package:financify_wallet/shared/shared_method.dart';
import 'package:financify_wallet/ui/pages/success_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

import '../../shared/theme.dart';
import '../widgets/buttons.dart';
import '../widgets/forms.dart';

class ProfileEditPinPage extends StatefulWidget {
  const ProfileEditPinPage({super.key});

  @override
  State<ProfileEditPinPage> createState() => _ProfileEditPinPageState();
}

class _ProfileEditPinPageState extends State<ProfileEditPinPage> {
  final oldPinController = TextEditingController(text: '');
  final newPinController = TextEditingController(text: '');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Pin'),
      ),
      body: BlocConsumer<AuthBloc, AuthState>(listener: (context, state) {
        if (state is AuthFailed) {
          if (state.e.contains('Old PIN incorrect')) {
            showCustomSnackbar(
                context, 'Old PIN is incorrect. Please try again.');
          } else {
            showCustomSnackbar(
                context, 'Failed to update PIN. Try again later.');
          }
        }
        if (state is AuthSuccess) {
          Get.off(() => const SuccessPage(
                title: 'Nice Update!',
                description: 'Your data is safe with\nour system',
              ));
        }
      }, builder: (context, state) {
        if (state is AuthLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        return ListView(
          padding: const EdgeInsets.symmetric(
            horizontal: 24,
          ),
          children: [
            const SizedBox(
              height: 30,
            ),
            Container(
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: whiteColor,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomFormField(
                    title: 'Old PIN',
                    controller: oldPinController,
                    obscureText: true,
                    // keyboardType: TextInputType.number,
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  CustomFormField(
                    title: 'New PIN',
                    controller: newPinController,
                    obscureText: true,
                    // keyboardType: TextInputType.number,
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  CustomFilledButton(
                    title: 'Update Now',
                    onPressed: () {
                      if (oldPinController.text.isEmpty ||
                          newPinController.text.isEmpty) {
                        showCustomSnackbar(context,
                            'Both Old PIN and New PIN must be filled.');
                        return;
                      }
                      debugPrint('Emitting AuthUpdatePin Event...');
                      context.read<AuthBloc>().add(
                            AuthUpdatePin(
                              oldPinController.text,
                              newPinController.text,
                            ),
                          );
                    },
                  ),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }
}
