import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';


import '../model/StockQuotesModel.dart';
import '../view_model/StockQuotesViewModel.dart';


class StockQuotesView extends StatefulWidget {
  @override
  _StockQuotesViewState createState() => _StockQuotesViewState();
}

class _StockQuotesViewState extends State<StockQuotesView> {
  StockQuotesViewModel viewModel = StockQuotesViewModel();
  late Stream<List<StockQuotesModel>> quotesStream;

  @override
  void initState() {
    super.initState();
    loadQuotes();
  }

  void loadQuotes() {
    quotesStream = Stream.fromFuture(viewModel.fetchQuotes());
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Bolsa de Valores'),
        ),
        body: StreamBuilder<List<StockQuotesModel>>(
          stream: quotesStream,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  final quote = snapshot.data![index];
                  return StockQuoteCard(quote: quote);
                },
              );
            } else if (snapshot.hasError) {
              return ErrorScreen(
                error: snapshot.error.toString(),
                onTryAgain: () {
                  setState(() {
                    loadQuotes();
                  });
                },
              );
            }

            return ShimmerLoading();
          },
        ),
      ),
    );
  }
}
class StockQuoteCard extends StatelessWidget {
  final StockQuotesModel quote;
  final currencyFormat = NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');

  StockQuoteCard({required this.quote});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                SvgPicture.network(
                  quote.logo,
                  width: 24,
                  height: 24,
                  fit: BoxFit.fitHeight,
                  placeholderBuilder: (BuildContext context) => Container(
                    width: 16,
                    height: 16,
                    child: const CircularProgressIndicator(
                      color: Colors.yellow,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Text(
                    quote.stock,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 8),
            Text(quote.name),
            const SizedBox(height: 8),
            Text(currencyFormat.format(quote.close)),
          ],
        ),
      ),
    );
  }
}

class ShimmerLoading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: ListView.builder(
        itemCount: 5,
        itemBuilder: (_, __) => Padding(
          padding: const EdgeInsets.all(8.0),
          child: Card(
            child: ListTile(
              leading: Container(
                width: 48.0,
                height: 48.0,
                color: Colors.white,
              ),
              title: Container(
                color: Colors.white,
                height: 20.0,
              ),
              subtitle: Container(
                color: Colors.white,
                height: 14.0,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ErrorScreen extends StatelessWidget {
  final String error;
  final VoidCallback onTryAgain;

  ErrorScreen({required this.error, required this.onTryAgain});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Text(
            'Oops! Algo deu errado.',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: onTryAgain,
            child: const Text('Tentar novamente'),
          ),
        ],
      ),
    );
  }
}