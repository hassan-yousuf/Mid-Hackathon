import 'package:flutter/material.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff8f8f8),
      appBar: AppBar(
        title: const Text('My Orders'),
        backgroundColor: Colors.transparent,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _tabs(),
          const SizedBox(height: 20),
          ...List.generate(3, (index) => _orderCard(index)),
        ],
      ),
    );
  }

  Widget _tabs() => Row(
    children: ['Delivered', 'Processing', 'Cancelled']
        .map(
          (tab) => Expanded(
            child: Padding(
              padding: const EdgeInsets.only(right: 6),
              child: ChoiceChip(
                label: Text(tab),
                selected: tab == 'Delivered',
                onSelected: (_) {},
                labelStyle: TextStyle(color: Colors.black),
              ),
            ),
          ),
        )
        .toList(),
  );

  Widget _orderCard(int index) => Card(
    elevation: 0,
    margin: const EdgeInsets.only(bottom: 16),
    child: Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Order №19470${34 + index}',
                style: const TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const Text('05-12-2019', style: TextStyle(color: Colors.grey)),
            ],
          ),
          const SizedBox(height: 18),
          const Text(
            'Tracking number:  IW3475453455',
            style: TextStyle(color: Colors.grey, fontSize: 16),
          ),
          const SizedBox(height: 8),
          const Text(
            'Quantity:  3             Total Amount: 112\$',
            style: TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              OutlinedButton(onPressed: () {}, child: const Text('Details')),
              const Text(
                'Delivered',
                style: TextStyle(color: Colors.green, fontSize: 17),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}
