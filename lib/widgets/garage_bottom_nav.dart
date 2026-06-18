import 'package:flutter/material.dart';
import 'package:hornvin/localization/app_localizations.dart';

class GarageBottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  const GarageBottomNavBar({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1A4D3E),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.2), blurRadius: 10),
        ],
      ),
      child: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color(0xFF1A4D3E),
        selectedItemColor: const Color(0xFFF5B31A),
        unselectedItemColor: Colors.white54,
        currentIndex: selectedIndex,
        onTap: onItemTapped,
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.dashboard),
            label: context.trText('Home'),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.shopping_cart),
            label: context.trText('Orders'),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.store),
            label: context.trText('Market'),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.chat),
            label: context.trText('Chat'),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.person),
            label: context.trText('Profile'),
          ),
        ],
      ),
    );
  }
}
