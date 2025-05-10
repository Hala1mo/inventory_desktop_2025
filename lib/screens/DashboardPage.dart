


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../widgets/CustomAppBar.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardScreenState();
}


class _DashboardScreenState extends State<DashboardPage> {


  @override
  void initState() {
    super.initState();
    // getCategoriesList();

    // Add simulated loading delay
    //_loadData();
  }

  // Future<void> _loadData() async {
  //   // Simulate network delay
  //   await Future.delayed(const Duration(seconds: 3));
  //
  //   if (mounted) {
  //     setState(() {
  //       _isLoading = false;
  //     });
  //   }
  // }

  // Future<void> getProductList() async {
  //   try {
  //    // final categoriesFetched = await categoryFetchController.fetchCategories();
  //    setState(() {
  //      categories=staticCategories;
  //    });
  //   } catch (e) {
  //     print('Error fetching categories: $e');
  //   }
  // }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xFF1A262D) ,
      appBar: const CustomAppBar(currentPage: 'dashboard'),
       body:SingleChildScrollView(
         child: Text("hala"),
       ),
    );
  }
}