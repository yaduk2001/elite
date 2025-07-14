import 'package:flutter/material.dart';

import 'booking_summary_page.dart';

class BookingPage extends StatefulWidget {
  const BookingPage({super.key});

  @override
  State<BookingPage> createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  DateTime? _checkInDate;
  DateTime? _checkOutDate;
  int _adults = 1;
  int _seniors = 0;
  int _children = 0;
  String _selectedRoomType = 'Standard';
  String _selectedPackage = 'Basic';
  
  final List<String> _roomTypes = ['Standard', 'Deluxe', 'Suite', 'Presidential'];
  final Map<String, Map<String, dynamic>> _packages = {
    'Basic': {
      'price': 1000,
      'description': 'Room only package',
      'features': ['Free Wi-Fi', 'Basic Amenities'],
    },
    'Premium': {
      'price': 2000,
      'description': 'Room with breakfast and dinner',
      'features': ['Free Wi-Fi', 'All Meals', 'Spa Access', 'Airport Transfer'],
    },
    'Luxury': {
      'price': 3000,
      'description': 'All-inclusive luxury package',
      'features': ['Free Wi-Fi', 'All Meals', 'Spa Access', 'Airport Transfer', 'Private Pool'],
    },
  };

  double _calculateTotalPrice() {
    // If dates aren't selected, return base package price
    if (_checkInDate == null || _checkOutDate == null) {
      return _packages[_selectedPackage]!['price'].toDouble();
    }
    
    int numberOfDays = _checkOutDate!.difference(_checkInDate!).inDays;
    // Ensure at least 1 day is counted
    numberOfDays = numberOfDays <= 0 ? 1 : numberOfDays;
    
    double basePrice = _packages[_selectedPackage]!['price'].toDouble();
    double roomMultiplier = (_roomTypes.indexOf(_selectedRoomType) + 1).toDouble();
    
    // Calculate room cost
    double roomCost = basePrice * roomMultiplier * numberOfDays;
    
    // Calculate guest charges
    double guestCharges = (_adults * 100) + (_seniors * 80) + (_children * 50);
    
    // Total price is room cost plus guest charges
    double totalPrice = roomCost + guestCharges;
    
    return totalPrice;
  }

  void _showPackageDetails(String package) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              package,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              _packages[package]!['description'],
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 10),
            const Text(
              'Features:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            ..._packages[package]!['features'].map<Widget>((feature) =>
              Padding(
                padding: const EdgeInsets.only(left: 10, top: 5),
                child: Row(
                  children: [
                    const Icon(Icons.check_circle, color: Colors.green),
                    const SizedBox(width: 10),
                    Text(feature),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Base Price: ₹${_packages[package]!['price']} per night',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGuestCounter(String title, int value, Function() onDecrement, Function() onIncrement) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontSize: 16)),
        Row(
          children: [
            IconButton(
              icon: const Icon(Icons.remove),
              onPressed: onDecrement,
            ),
            Text('$value'),
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: onIncrement,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPriceSummary() {
    double totalPrice = _calculateTotalPrice();
    int numberOfDays = _checkInDate != null && _checkOutDate != null 
        ? _checkOutDate!.difference(_checkInDate!).inDays 
        : 0;

    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Price Summary',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 15),
            // Base package price
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('${_selectedPackage} Package:'),
                Text('₹${_packages[_selectedPackage]!['price']} per night'),
              ],
            ),
            const SizedBox(height: 8),
            // Room type multiplier
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('${_selectedRoomType} Room:'),
                Text('${_roomTypes.indexOf(_selectedRoomType) + 1}x multiplier'),
              ],
            ),
            const SizedBox(height: 8),
            // Number of nights
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Number of nights:'),
                Text('$numberOfDays'),
              ],
            ),
            const Divider(),
            // Guest charges
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Adults:'),
                Text('₹${_adults * 100} (₹100 per adult)'),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Seniors:'),
                Text('₹${_seniors * 80} (₹80 per senior)'),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Children:'),
                Text('₹${_children * 50} (₹50 per child)'),
              ],
            ),
            const Divider(),
            // Total amount
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Total Amount:',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '₹${totalPrice.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Book Your Stay'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Booking Details',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    ListTile(
                      leading: const Icon(Icons.calendar_today),
                      title: const Text('Check-in Date'),
                      subtitle: Text(_checkInDate?.toString().split(' ')[0] ?? 'Select date'),
                      onTap: () async {
                        final DateTime? picked = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime.now(),
                          lastDate: DateTime.now().add(const Duration(days: 365)),
                        );
                        if (picked != null) {
                          setState(() {
                            _checkInDate = picked;
                          });
                        }
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.calendar_today),
                      title: const Text('Check-out Date'),
                      subtitle: Text(_checkOutDate?.toString().split(' ')[0] ?? 'Select date'),
                      onTap: () async {
                        final DateTime? picked = await showDatePicker(
                          context: context,
                          initialDate: _checkInDate?.add(const Duration(days: 1)) ?? DateTime.now().add(const Duration(days: 1)),
                          firstDate: _checkInDate?.add(const Duration(days: 1)) ?? DateTime.now(),
                          lastDate: DateTime.now().add(const Duration(days: 365)),
                        );
                        if (picked != null) {
                          setState(() {
                            _checkOutDate = picked;
                          });
                        }
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.people),
                      title: const Text('Guests'),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildGuestCounter(
                            'Adults',
                            _adults,
                            () {
                              if (_adults > 1) {
                                setState(() => _adults--);
                              }
                            },
                            () => setState(() => _adults++),
                          ),
                          _buildGuestCounter(
                            'Senior Citizens',
                            _seniors,
                            () {
                              if (_seniors > 0) {
                                setState(() => _seniors--);
                              }
                            },
                            () => setState(() => _seniors++),
                          ),
                          _buildGuestCounter(
                            'Children',
                            _children,
                            () {
                              if (_children > 0) {
                                setState(() => _children--);
                              }
                            },
                            () => setState(() => _children++),
                          ),
                        ],
                      ),
                    ),
                    ListTile(
                      leading: const Icon(Icons.hotel),
                      title: const Text('Room Type'),
                      subtitle: DropdownButton<String>(
                        value: _selectedRoomType,
                        isExpanded: true,
                        items: _roomTypes.map((String type) {
                          return DropdownMenuItem<String>(
                            value: type,
                            child: Text(type),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          if (newValue != null) {
                            setState(() {
                              _selectedRoomType = newValue;
                            });
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Package Selection',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 15),
                    ...['Basic', 'Premium', 'Luxury'].map((package) =>
                      ListTile(
                        leading: Radio<String>(
                          value: package,
                          groupValue: _selectedPackage,
                          onChanged: (value) {
                            setState(() => _selectedPackage = value!);
                          },
                        ),
                        title: Text(package),
                        trailing: TextButton(
                          onPressed: () => _showPackageDetails(package),
                          child: const Text('View Details'),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            _buildPriceSummary(),
            const SizedBox(height: 20),
            // Book Now Button
            Container(
              width: double.infinity,
              margin: const EdgeInsets.only(bottom: 20),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Theme.of(context).primaryColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () {
                  if (_checkInDate == null || _checkOutDate == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Please select check-in and check-out dates'),
                      ),
                    );
                    return;
                  }
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BookingSummaryPage(
                        checkInDate: _checkInDate!,
                        checkOutDate: _checkOutDate!,
                        adults: _adults,
                        seniors: _seniors,
                        children: _children,
                        roomType: _selectedRoomType,
                        package: _selectedPackage,
                        totalPrice: _calculateTotalPrice(),
                      ),
                    ),
                  );
                },
                child: const Text(
                  'Book Now',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
} 