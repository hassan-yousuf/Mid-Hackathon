import 'package:flutter/material.dart';
import 'package:midhackathon/features/dashboard/models/product.dart';

class ProductSearchDelegate extends SearchDelegate<Product?> {
  ProductSearchDelegate(this.items);

  final List<Product> items;

  @override
  List<Widget>? buildActions(BuildContext context) => [
    IconButton(onPressed: () => query = '', icon: const Icon(Icons.clear)),
  ];

  @override
  Widget? buildLeading(BuildContext context) =>
      BackButton(onPressed: () => close(context, null));

  @override
  Widget buildResults(BuildContext context) => _results(context);

  @override
  Widget buildSuggestions(BuildContext context) => _results(context);

  Widget _results(BuildContext context) {
    final matches = items
        .where(
          (item) => '${item.name} ${item.brand}'.toLowerCase().contains(
            query.toLowerCase(),
          ),
        )
        .toList();

    if (matches.isEmpty) {
      return const Center(child: Text('No products found'));
    }

    return ListView.builder(
      itemCount: matches.length,
      itemBuilder: (_, index) {
        final product = matches[index];
        return ListTile(
          leading: Image.network(product.image, width: 50, fit: BoxFit.cover),
          title: Text(product.name),
          subtitle: Text(product.brand),
          trailing: Text('\$${product.price.toStringAsFixed(0)}'),
          onTap: () => close(context, product),
        );
      },
    );
  }
}
