import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../widgets/CustomAppBar.dart';

class ReportPage extends StatelessWidget {
  const ReportPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF1A262D) ,
      appBar: const CustomAppBar(currentPage: 'report'),
      body: const Center(child: Text("REPORTSPage")),
    );
  }
}