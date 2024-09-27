import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:provider/provider.dart';
import 'package:stock_tracker_demo/pages/home_page.dart';
import 'package:stock_tracker_demo/services/graphql_client.dart';
import 'package:stock_tracker_demo/services/stock_info_service.dart';

late ValueNotifier<GraphQLClient> client;
late StockInfoService _stockInfoService;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initHiveForFlutter();
  client = GraphQLClientCreator.create();
  _initializeServices();
  runApp(const MyApp());
}

void _initializeServices() {
  _stockInfoService = StockInfoService(client: client.value);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [Provider<StockInfoService>.value(value: _stockInfoService)],
      child: GraphQLProvider(
        client: client,
        child: MaterialApp(
          title: 'Stock Tracker Demo',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
          home: const MyHomePage(title: 'Stock Tracker Demo'),
        ),
      ),
    );
  }
}
