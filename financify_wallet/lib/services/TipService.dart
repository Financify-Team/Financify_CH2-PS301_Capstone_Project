import 'dart:convert';

import 'package:financify_wallet/models/tip_model.dart';
import 'package:financify_wallet/services/auth_service.dart';
import 'package:financify_wallet/shared/shared_values.dart';
import 'package:http/http.dart' as http;

class TipService {
  Future<List<TipModel>> getTips() async {
    try {
      final token = await AuthService().getToken();
      final res = await http.get(
        Uri.parse('$baseUrl/tips'),
        headers: {
          'Authorization': token,
        },
      );
      if (res.statusCode == 200) {
        final responseData = jsonDecode(res.body)['data'];
        return List<TipModel>.from(
          responseData.map(
            (tip) => TipModel.fromJson(tip),
          ),
        ).toList();
      }
      throw jsonDecode(res.body)['message'];
    } catch (e) {
      rethrow;
    }
  }
}
