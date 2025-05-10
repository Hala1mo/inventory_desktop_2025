import 'package:flutter/material.dart';

import '../screens/DashboardPage.dart';
import '../screens/ProductsPage.dart';
import '../screens/OrdersPage.dart';
import '../screens/ReportPage.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String currentPage;

  const CustomAppBar({super.key, required this.currentPage});

  @override
  Size get preferredSize => const Size.fromHeight(70);

  @override
  Widget build(BuildContext context) {
    return Container(
      color:  Color(0xFF0F171A),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical:16),
      child: Row(
        children: [
          // Logo
          Row(
            children: [
              Image.asset(
                'assets/images/erplogo.png',
              ),

            ],
          ),

          const Spacer(),

          // Navigation buttons
          _NavTab(context, title: 'Dashboard', icon: Icons.dashboard, page: 'dashboard', currentPage: currentPage),
          _NavTab(context, title: 'Inventory', icon: Icons.inventory_2, page: 'inventory', currentPage: currentPage),
          _NavTab(context, title: 'Order', icon: Icons.receipt_long, page: 'order', currentPage: currentPage),
          _NavTab(context, title: 'Report', icon: Icons.bar_chart, page: 'report', currentPage: currentPage),

          const Spacer(),

          IconButton(
            icon: const Icon(Icons.settings, color: Colors.white),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.notifications_none, color: Colors.white),
            onPressed: () {},
          ),
          const CircleAvatar(
            radius: 16,
            backgroundColor: Colors.orange,
            child: Text("H", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Widget _NavTab(
      BuildContext context, {
        required String title,
        required IconData icon,
        required String page,
        required String currentPage,
      }) {
    final bool isActive = currentPage == page;


    return GestureDetector(
      onTap: () {
        if (!isActive) {
          Widget nextPage;

          switch (page) {
            case 'dashboard':
              nextPage = const DashboardPage();
              break;
            case 'inventory':
              nextPage = const ProductsPage();
              break;
            case 'order':
              nextPage = const OrdersPage();
              break;
            case 'report':
              nextPage = const ReportPage();
              break;
            default:
              nextPage = const DashboardPage();
          }

          Navigator.of(context).push(
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) => nextPage,
              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                return FadeTransition(
                  opacity: animation,
                  child: child,
                );
              },
              transitionDuration: const Duration(milliseconds: 300),
            ),
          );
        }
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? Colors.green.withOpacity(0.15) : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white12),
        ),
        child: Row(
          children: [
            Icon(icon, size: 16, color: Colors.white70),
            const SizedBox(width: 4),
            Text(title, style: const TextStyle(color: Colors.white70)),
          ],
        ),
      ),
    );
  }
}
