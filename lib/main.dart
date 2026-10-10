import 'package:flutter/material.dart';
import 'database/sql_helper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SqlHelper.insertProduct(
    productName: 'Phone',
    quantity: 5,
    price: 9999.5,
  );

  final all = await SqlHelper.getAllProducts();
  debugPrint(all.toString());

  final found = await SqlHelper.searchProducts('Pho');
  debugPrint(found.toString());

  await SqlHelper.updateProduct(
    id: 1,
    productName: 'Phone X',
    quantity: 3,
    price: 8000,
    isFavorite: true,
  );

  await SqlHelper.deleteProduct(1);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        body: Center(
          child: Text('Amazon Database Task'),
        ),
      ),
    );
  }
}