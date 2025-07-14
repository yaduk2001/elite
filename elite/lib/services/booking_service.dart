import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/booking.dart';

class BookingService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static Future<void> createBooking(Booking booking) async {
    await _firestore.collection('bookings').doc(booking.id).set(booking.toMap());
  }

  static Stream<List<Booking>> getBookingsByStatus(String status) {
    return _firestore
        .collection('bookings')
        .where('status', isEqualTo: status)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => Booking.fromMap(doc.data()))
          .toList();
    });
  }

  static Future<void> updateBookingStatus(String bookingId, String status) async {
    await _firestore
        .collection('bookings')
        .doc(bookingId)
        .update({'status': status});
  }

  static Stream<List<Booking>> getUserBookings(String userId) {
    return _firestore
        .collection('bookings')
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => Booking.fromMap(doc.data()))
          .toList();
    });
  }
} 