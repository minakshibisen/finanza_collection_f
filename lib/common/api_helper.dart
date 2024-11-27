import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiHelper {
  /// A common API call method to handle POST requests.
  /// 
  /// - [url]: The endpoint to send the request.
  /// - [body]: The request payload (Map<String, dynamic>).
  ///
  /// Returns a `Map<String, dynamic>` containing the JSON response or an error message.
  static Future<Map<String, dynamic>> postRequest({
    required String url,
    required Map<String, dynamic> body,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(url),
        body: body,
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return jsonDecode(response.body) as Map<String, dynamic>;
      } else {
        return {
          'error': true,
          'message': 'HTTP Error: ${response.statusCode}',
          'details': response.body,
        };
      }
    } catch (e) {
      return {
        'error': true,
        'message': 'An exception occurred',
        'details': e.toString(),
      };
    }
  }
}
