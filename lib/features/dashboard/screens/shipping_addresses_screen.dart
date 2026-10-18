import 'package:flutter/material.dart';
import 'package:midhackathon/core/theme/app_colors.dart';

class ShippingAddressesScreen extends StatefulWidget {
  const ShippingAddressesScreen({super.key});

  @override
  State<ShippingAddressesScreen> createState() =>
      _ShippingAddressesScreenState();
}

class _ShippingAddressesScreenState extends State<ShippingAddressesScreen> {
  int selected = 0;
  final addresses = const [
    ('Jane Doe', '3 Newbridge Court', 'Chino Hills, CA 91709, United States'),
    ('John Doe', '3 Newbridge Court', 'Chino Hills, CA 91709, United States'),
    ('John Doe', '51 Riverside', 'Chino Hills, CA 91709, United States'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff8f8f8),
      appBar: AppBar(
        title: const Text('Shipping Addresses'),
        backgroundColor: Colors.transparent,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: addresses.length,
        itemBuilder: (context, index) {
          final address = addresses[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            elevation: 0,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 18, 12, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        address.$1,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: const Text(
                          'Edit',
                          style: TextStyle(color: AppColors.primary),
                        ),
                      ),
                    ],
                  ),
                  Text(address.$2, style: const TextStyle(fontSize: 17)),
                  Text(address.$3, style: const TextStyle(fontSize: 17)),
                  CheckboxListTile(
                    contentPadding: EdgeInsets.zero,
                    value: selected == index,
                    onChanged: (_) => setState(() => selected = index),
                    activeColor: AppColors.primary,
                    title: const Text('Use as the shipping address'),
                    controlAffinity: ListTileControlAffinity.leading,
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
    );
  }
}
