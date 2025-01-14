import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

enum ApiServicesMethodType {
  get,
  post,
}

const baseUrl = "https://api.stripe.com/v1";

final Map<String, String> requestHeaders = {
  "Authorization": "Bearer ${dotenv.env["STRIPE_SECRET_KEY"]}",
  "Content-Type": "application/x-www-form-urlencoded",
};

Future<Map<String, dynamic>?> stripeApiServices({
  required ApiServicesMethodType requestMethod,
  Map<String, dynamic>? requestBody,
  required String endpoint,
}) async {
  final requestUrl = "$baseUrl/$endpoint";

  try {
    final response = requestMethod == ApiServicesMethodType.get
        ? await http.get(
            Uri.parse(requestUrl),
            headers: requestHeaders,
          )
        : await http.post(
            Uri.parse(requestUrl),
            headers: requestHeaders,
            body: requestBody,
          );

    // handle response
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      print("Error: ${response.statusCode}");
      throw Exception("Fail to get data");
    }

    // handle error
  } catch (e) {
    if (kDebugMode) {
      print(e);
    }
    return null;
  }
}
