import 'package:dars72_location/model/travel.dart';
import 'package:flutter/material.dart';

class ProductCard extends StatelessWidget {
  final Travel product;

  const ProductCard({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          Image.network(product.photo),
          Text(product.title),
        ],
      ),
    );
  }
}
