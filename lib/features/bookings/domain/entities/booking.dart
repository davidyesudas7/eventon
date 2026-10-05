enum BookingStatus {
  awaitingAdvance('Awaiting advance'),
  confirmed('Confirmed'),
  completed('Completed'),
  cancelled('Cancelled');

  const BookingStatus(this.label);
  final String label;
}

class Booking {
  const Booking({
    required this.id,
    required this.serviceName,
    required this.date,
    required this.amount,
    required this.status,
    this.minAdvancePercent = 20,
  });

  final String id;
  final String serviceName;
  final DateTime date;
  final int amount;
  final BookingStatus status;
  final int minAdvancePercent;

  int get minAdvance => (amount * minAdvancePercent / 100).ceil();

  bool get isCancelled => status == BookingStatus.cancelled;

  bool get isPast {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    return date.isBefore(today);
  }

  bool get isUpcoming => !isCancelled && !isPast;
}

/// Temporary sample data until bookings come from the backend.
final List<Booking> mockBookings = [
  Booking(
    id: 'bk_001',
    serviceName: 'Standard DJ set',
    date: DateTime(2026, 10, 13),
    amount: 20000,
    status: BookingStatus.awaitingAdvance,
  ),
];

Booking? findBookingById(String id) {
  for (final b in mockBookings) {
    if (b.id == id) return b;
  }
  return null;
}

const _months = [
  'Jan',
  'Feb',
  'Mar',
  'Apr',
  'May',
  'Jun',
  'Jul',
  'Aug',
  'Sep',
  'Oct',
  'Nov',
  'Dec',
];

/// e.g. "Oct 13, 2026"
String formatBookingDate(DateTime d) =>
    '${_months[d.month - 1]} ${d.day}, ${d.year}';
