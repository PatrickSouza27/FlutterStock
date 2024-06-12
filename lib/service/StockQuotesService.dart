import 'package:http/http.dart' as http;
import 'dart:convert';

class StockQuotesServiceException implements Exception {
  final String message;
  StockQuotesServiceException(this.message);

  @override
  String toString() => 'StockQuotesServiceException: $message';
}

class StockQuotesService {
  Future<List<dynamic>> fetchQuotes() async {
    try {
      final response = await http.get(Uri.parse('https://brapi.dev/api/quote/list?token=vRTXfv8ocGi4JrNn7Qbft4'));
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        return data['stocks'];
      } else {
        throw StockQuotesServiceException('Failed to load quotes. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw StockQuotesServiceException('Failed to load quotes. Error: $e');
    }
  }
}