import 'dart:async';

import 'package:flutter/material.dart';
import '../services/booking_service.dart';
import '../models/booking.dart';
import 'package:uuid/uuid.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:io';

class BookingSummaryPage extends StatelessWidget {
  final DateTime checkInDate;
  final DateTime checkOutDate;
  final int adults;
  final int seniors;
  final int children;
  final String roomType;
  final String package;
  final double totalPrice;

  const BookingSummaryPage({
    super.key,
    required this.checkInDate,
    required this.checkOutDate,
    required this.adults,
    required this.seniors,
    required this.children,
    required this.roomType,
    required this.package,
    required this.totalPrice,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Booking Summary'),
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
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 20),
                    _buildDetailRow('Check-in', checkInDate.toString().split(' ')[0]),
                    _buildDetailRow('Check-out', checkOutDate.toString().split(' ')[0]),
                    _buildDetailRow('Room Type', roomType),
                    _buildDetailRow('Package', package),
                    const Divider(),
                    _buildDetailRow('Adults', adults.toString()),
                    _buildDetailRow('Seniors', seniors.toString()),
                    _buildDetailRow('Children', children.toString()),
                    const Divider(),
                    _buildDetailRow(
                      'Total Amount',
                      '₹${totalPrice.toStringAsFixed(2)}',
                      isTotal: true,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Theme.of(context).primaryColor,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 60),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () async {
                  // Check if Firebase is initialized
                  try {
                    if (FirebaseAuth.instance == null) {
                      throw Exception('Firebase not initialized');
                    }

                    // Check if user is logged in
                    if (FirebaseAuth.instance.currentUser == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Please login to make a booking'),
                          backgroundColor: Colors.red,
                        ),
                      );
                      Navigator.pushReplacementNamed(context, '/login');
                      return;
                    }

                    // Show loading indicator
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (BuildContext context) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      },
                    );

                    final booking = Booking(
                      id: const Uuid().v4(),
                      checkInDate: checkInDate,
                      checkOutDate: checkOutDate,
                      adults: adults,
                      seniors: seniors,
                      children: children,
                      roomType: roomType,
                      package: package,
                      totalPrice: totalPrice,
                      status: 'pending',
                      userId: FirebaseAuth.instance.currentUser!.uid,
                    );

                    await BookingService.createBooking(booking);
                    
                    if (context.mounted) {
                      Navigator.pop(context); // Close loading indicator
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Booking successful!'),
                          backgroundColor: Colors.green,
                        ),
                      );
                      Navigator.popUntil(context, (route) => route.isFirst);
                    }
                  } catch (e) {
                    if (context.mounted) {
                      Navigator.pop(context); // Close loading indicator if shown
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Error: ${e.toString()}'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  }
                },
                child: const Text(
                  'BOOK NOW',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                    color: Colors.white,
                    inherit: false,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: isTotal ? 18 : 16,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: isTotal ? 18 : 16,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              color: isTotal ? Colors.green : null,
            ),
          ),
        ],
      ),
    );
  }
} 