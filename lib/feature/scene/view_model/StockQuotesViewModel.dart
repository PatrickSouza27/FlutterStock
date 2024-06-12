import '../../../service/StockQuotesService.dart';
import '../model/StockQuotesModel.dart';

class StockQuotesViewModel {
  final StockQuotesService apiService = StockQuotesService();

  Future<List<StockQuotesModel>> fetchQuotes() async {
    final quotesList = await apiService.fetchQuotes();
    return quotesList.map((quote) => StockQuotesModel(
      stock: quote['stock'],
      name: quote['name'],
      close: (quote['close'] as num).toDouble(),
      logo: quote['logo'],
    )).toList();
  }
}