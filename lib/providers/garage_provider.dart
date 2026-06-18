import 'package:flutter/material.dart';

class Garage {
  final String name;
  final String location;
  final String status;
  final int lastOrderAmount;
  final int totalOrders;
  final String lastOrderDate;
  final int dueAmount;
  final String dueDate;

  Garage({
    required this.name,
    required this.location,
    required this.status,
    this.lastOrderAmount = 0,
    this.totalOrders = 0,
    this.lastOrderDate = '',
    this.dueAmount = 0,
    this.dueDate = '',
  });
}

class GarageProvider with ChangeNotifier {
  List<Garage> _activeGarages = [];
  List<Garage> _allGarages = [];

  List<Garage> get activeGarages => _activeGarages;
  List<Garage> get allGarages => _allGarages;

  GarageProvider() {
    loadGarages();
  }

  void loadGarages() {
    _allGarages = [
      Garage(
        name: 'ABC Auto Care',
        location: 'Downtown',
        status: 'Active',
        lastOrderAmount: 15000,
        totalOrders: 28,
        lastOrderDate: 'Jan 15, 2022',
        dueAmount: 5000,
        dueDate: 'Jan 30, 2022',
      ),
      Garage(
        name: 'Speedy Garage',
        location: 'Eastside',
        status: 'Active',
        lastOrderAmount: 8750,
        totalOrders: 28,
        lastOrderDate: 'Jan 15, 2022',
        dueAmount: 8750,
        dueDate: 'Feb 10, 2022',
      ),
      Garage(
        name: 'XYZ Motors',
        location: 'Northside',
        status: 'Active',
        lastOrderAmount: 12000,
        totalOrders: 28,
        lastOrderDate: 'Jan 15, 2022',
        dueAmount: 3000,
        dueDate: 'Jan 25, 2022',
      ),
      Garage(
        name: 'AutoFix Garage',
        location: 'Westside',
        status: 'Low Order',
        lastOrderAmount: 5000,
        totalOrders: 15,
        lastOrderDate: 'Dec 20, 2022',
        dueAmount: 2000,
        dueDate: 'Jan 28, 2022',
      ),
      Garage(
        name: 'Elite Motors',
        location: 'Southside',
        status: 'Active',
        lastOrderAmount: 12500,
        totalOrders: 42,
        lastOrderDate: 'Jan 18, 2022',
        dueAmount: 12500,
        dueDate: 'Feb 5, 2022',
      ),
    ];

    _activeGarages = _allGarages.where((g) => g.status == 'Active').toList();
    notifyListeners();
  }

  List<Garage> getGaragesByStatus(String status) {
    if (status == 'All') return _allGarages;
    return _allGarages.where((g) => g.status == status).toList();
  }

  List<Garage> getPaymentReminders() {
    return _allGarages.where((g) => g.dueAmount > 0).toList();
  }
}
