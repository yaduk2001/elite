class Booking {
  final String id;
  final DateTime checkInDate;
  final DateTime checkOutDate;
  final int adults;
  final int seniors;
  final int children;
  final String roomType;
  final String package;
  final double totalPrice;
  final String status;
  final String userId;

  Booking({
    required this.id,
    required this.checkInDate,
    required this.checkOutDate,
    required this.adults,
    required this.seniors,
    required this.children,
    required this.roomType,
    required this.package,
    required this.totalPrice,
    required this.status,
    required this.userId,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'checkInDate': checkInDate.toIso8601String(),
      'checkOutDate': checkOutDate.toIso8601String(),
      'adults': adults,
      'seniors': seniors,
      'children': children,
      'roomType': roomType,
      'package': package,
      'totalPrice': totalPrice,
      'status': status,
      'userId': userId,
    };
  }

  factory Booking.fromMap(Map<String, dynamic> map) {
    return Booking(
      id: map['id'],
      checkInDate: DateTime.parse(map['checkInDate']),
      checkOutDate: DateTime.parse(map['checkOutDate']),
      adults: map['adults'],
      seniors: map['seniors'],
      children: map['children'],
      roomType: map['roomType'],
      package: map['package'],
      totalPrice: map['totalPrice'],
      status: map['status'],
      userId: map['userId'],
    );
  }
} 