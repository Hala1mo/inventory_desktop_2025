import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../widgets/CreateLocation.dart';
import '../widgets/CustomAppBar.dart';
import '../widgets/CustomButton.dart';

class OrdersPage extends StatelessWidget {
  const OrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF1A262D) ,
      appBar: const CustomAppBar(currentPage: 'order'),
      body:  Center(child:
      CustomButton(
        text: 'Add Product',
        onPressed: () {
          // showDialog(
          //   context: context,
          //   builder: (BuildContext context) {
          //     return AddLocation();
          //   },
          // );
        },
      ),),
    );
  }
}