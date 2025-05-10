import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../widgets/CustomAppBar.dart';

class OrdersPage extends StatelessWidget {
  const OrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF1A262D) ,
      appBar: const CustomAppBar(currentPage: 'order'),
      body: const Center(child: Text("OrdersPage")),
    );
  }
}