import 'dart:convert';

import 'package:financify_wallet/services/auth_service.dart';
import 'package:financify_wallet/shared/shared_values.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class WalletService {
  Future<void> updatePin(String oldPin, String newPin) async {
    try {
      final token = await AuthService().getToken();
      final response = await http.put(
        Uri.parse('$baseUrl/wallets'),
        body: {
          'previous_pin': oldPin,
          'new_pin': newPin,
        },
        headers: {
          'Authorization': token,
        },
      );

      if (response.statusCode != 200) {
        final errorResponse = jsonDecode(response.body);
        debugPrint('Response Status Code: ${response.statusCode}');
        debugPrint('Response Body: ${response.body}');
        debugPrint('Request Body: ${{
          'previous_pin': oldPin,
          'new_pin': newPin,
        }.toString()}');

        throw errorResponse['message'] ?? 'Unknown error occurred';
      }
    } catch (e) {
      rethrow;
    }
  }
}
