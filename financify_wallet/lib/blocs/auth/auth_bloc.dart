import 'package:equatable/equatable.dart';
import 'package:financify_wallet/models/sign_in_form.dart';
import 'package:financify_wallet/models/signup_form_model.dart';
import 'package:financify_wallet/services/auth_service.dart';
import 'package:financify_wallet/services/user_service.dart';
import 'package:financify_wallet/services/wallet_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/user_edit_form_model.dart';
import '../../models/user_model.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitial()) {
    on<AuthEvent>((event, emit) async {
      if (event is AuthCheckEmail) {
        try {
          emit(AuthLoading());
          final res = await AuthService().checkEmail(event.email);
          if (res == false) {
            emit(AuthCheckEmailSuccess());
          } else {
            emit(const AuthFailed('Email sudah terpakai'));
          }
        } catch (e) {
          emit(AuthFailed(e.toString()));
        }
      }

      if (event is AuthRegister) {
        try {
          emit(AuthLoading());
          final user = await AuthService().register(event.data);
          emit(AuthSuccess(user));
        } catch (e) {
          emit(AuthFailed(e.toString()));
        }
      }

      if (event is AuthLogin) {
        try {
          emit(AuthLoading());
          final user = await AuthService().login(event.data);
          emit(AuthSuccess(user));
        } catch (e) {
          final errorMessage =
              e.toString().isNotEmpty ? e.toString() : 'Unknown error occurred';
          emit(AuthFailed(errorMessage));
        }
      }

      if (event is AuthGetCurrentUser) {
        try {
          emit(AuthLoading());
          final SignInFormModel data =
              await AuthService().getCredentialFromLocal();
          final UserModel user = await AuthService().login(data);
          emit(AuthSuccess(user));
        } catch (e) {
          emit(AuthFailed(e.toString()));
        }
      }

      if (event is AuthUpdateUser) {
        try {
          if (state is AuthSuccess) {
            final updateUser = (state as AuthSuccess).user.copyWith(
                username: event.data.username,
                name: event.data.name,
                email: event.data.email,
                password: event.data.password);
            emit(AuthLoading());
            await UserService().updateUser(event.data);
            emit(AuthSuccess(updateUser));
          }
        } catch (e) {
          emit(AuthFailed(e.toString()));
        }
      }

      if (event is AuthUpdatePin) {
        try {
          debugPrint('Updating PIN...');
          if (state is AuthSuccess) {
            final updateUser = (state as AuthSuccess).user.copyWith(
                  pin: event.newPin,
                );
            emit(AuthLoading());
            await WalletService().updatePin(
              event.oldPin,
              event.newPin,
            );
            emit(AuthSuccess(updateUser));
            debugPrint('PIN updated successfully.');
          }
        } catch (e) {
          debugPrint('Error: $e');
          emit(AuthFailed('Failed to update PIN: $e'));
        }
      }

      if (event is AuthLogout) {
        try {
          emit(AuthLoading());
          await AuthService().logout();
          emit(AuthInitial());
        } catch (e) {
          emit(AuthFailed(e.toString()));
        }
      }

      if (event is AuthUpdateBalance) {
        if (state is AuthSuccess) {
          final currentUser = (state as AuthSuccess).user;
          final updateUser = currentUser.copyWith(
              balance: currentUser.balance! + event.amount);
          emit(AuthSuccess(updateUser));
        }
      }
    });
  }
}
