import 'package:flutter/material.dart';

import '../screens/DashboardPage.dart';
import '../screens/Locations/LocationsPage.dart';
import '../screens/Product/ProductsPage.dart';
import '../screens/ReportsPage.dart';
import '../screens/movements/OrdersPage.dart';

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
          _NavTab(context, title: 'Locations', icon: Icons.pin_drop, page: 'location', currentPage: currentPage),
          _NavTab(context, title: 'Order', icon: Icons.receipt_long, page: 'order', currentPage: currentPage),
          _NavTab(context, title: 'Reports', icon: Icons.assignment, page: 'report', currentPage: currentPage),
          const Spacer(),

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
            case 'location':
              nextPage = const LocationsPage();
              break;
            case 'order':
              nextPage = const OrdersPage();
              break;
            case 'report':
              nextPage = const ReportsPage();
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
