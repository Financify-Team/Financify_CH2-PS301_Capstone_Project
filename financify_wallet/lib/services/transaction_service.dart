import 'dart:convert';

import 'package:financify_wallet/models/data_plan_form_model.dart';
import 'package:financify_wallet/models/topup_form_model.dart';
import 'package:financify_wallet/models/transaction_model.dart';
import 'package:financify_wallet/models/transfer_form_model.dart';
import 'package:financify_wallet/services/auth_service.dart';
import 'package:financify_wallet/shared/shared_values.dart';
import 'package:http/http.dart' as http;

class TransactionService {
  Future<String> topUp(TopUpFormModel data) async {
    try {
      final token = await AuthService().getToken();

      if (token.isEmpty) {
        throw 'Token is invalid or not login yet. Please login first';
      }

      final res = await http.post(
        Uri.parse('$baseUrl/top_ups'),
        headers: {'Authorization': token},
        body: data.toJson(),
      );

      // debugPrint("Status Code: ${res.statusCode}");
      // debugPrint("response: ${res.body}");
      if (res.statusCode == 200) {
        final responseData = jsonDecode(res.body);
        return responseData['redirect_url'];
      } else {
        final errorMessage =
            jsonDecode(res.body)['message'] ?? "Terjadi kesalahan.";
        throw errorMessage;
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> transfer(TransferFormModel data) async {
    try {
      final token = await AuthService().getToken();

      if (token.isEmpty) {
        throw 'Token is invalid or not login yet. Please login first';
      }

      final res = await http.post(
        Uri.parse('$baseUrl/transfers'),
        headers: {
          'Authorization': token,
        },
        body: data.toJson(),
      );

      // debugPrint("Status Code: ${res.statusCode}");
      // debugPrint("response: ${res.body}");
      if (res.statusCode != 200) {
        throw jsonDecode(res.body)['message'];
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> dataPlan(DataPlanFormModel data) async {
    try {
      final token = await AuthService().getToken();

      final res = await http.post(
        Uri.parse('$baseUrl/data_plans'),
        headers: {
          'Authorization': token,
        },
        body: data.toJson(),
      );

      if (res.statusCode != 200) {
        throw jsonDecode(res.body)['message'];
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<List<TransactionModel>> getTransactions() async {
    try {
      final token = await AuthService().getToken();

      if (token.isEmpty) {
        throw 'Token is invalid or not login yet. Please login first';
      }

      final res = await http.get(
        Uri.parse('$baseUrl/transactions'),
        headers: {
          'Authorization': token,
        },
      );

      if (res.statusCode == 200) {
        final responseData = jsonDecode(res.body)['data'];
        return List<TransactionModel>.from(
          responseData
              .map((transaction) => TransactionModel.fromJson(transaction))
              .toList(),
        );
      } else {
        throw jsonDecode(res.body)['message'] ?? "Terjadi kesalahan.";
      }
    } catch (e) {
      rethrow;
    }
  }
}
