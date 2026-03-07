import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';

// Helper functions used throughout the app
class DateHelpers {
  static String dayLabel(DateTime t) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final day = DateTime(t.year, t.month, t.day);
    final d = day.difference(today).inDays;

    if (d == 0) return "Today";
    if (d == 1) return "Tomorrow";

    return '${t.month}/${t.day}';
  }

  static String formatScheduleTime(DateTime time) {
    return DateFormat('MMM d, h:mm a').format(time);
  }

  static String formatTimeOnly(DateTime time) {
    return DateFormat('h:mm a').format(time);
  }
}

class PhoneHelpers {
  static String formatPhoneNumber(String countryCode, String number) {
    return '$countryCode$number';
  }

  static bool isValidPhoneLength(String number) {
    final digitsOnly = number.replaceAll(RegExp(r'\D'), '');
    return digitsOnly.length >= 10 && digitsOnly.length <= 15;
  }
}

class CardHelpers {
  static String maskCardNumber(String last4) {
    return '****$last4';
  }

  static String getCardType(String number) {
    if (number.startsWith('4')) return 'visa';
    if (number.startsWith('5')) return 'mastercard';
    if (number.startsWith('34') || number.startsWith('37')) return 'amex';
    return 'unknown';
  }
}

void main() {
  group('DateHelpers', () {
    group('dayLabel', () {
      test('returns "Today" for current date', () {
        final today = DateTime.now();
        expect(DateHelpers.dayLabel(today), 'Today');
      });

      test('returns "Tomorrow" for next day', () {
        final tomorrow = DateTime.now().add(const Duration(days: 1));
        expect(DateHelpers.dayLabel(tomorrow), 'Tomorrow');
      });

      test('returns formatted date for future dates', () {
        final futureDate = DateTime.now().add(const Duration(days: 5));
        final result = DateHelpers.dayLabel(futureDate);

        expect(result, contains('/'));
        expect(result, '${futureDate.month}/${futureDate.day}');
      });

      test('returns formatted date for past dates', () {
        final pastDate = DateTime.now().subtract(const Duration(days: 2));
        final result = DateHelpers.dayLabel(pastDate);

        expect(result, '${pastDate.month}/${pastDate.day}');
      });

      test('handles end of month correctly', () {
        final endOfMonth = DateTime(2026, 1, 31);
        final result = DateHelpers.dayLabel(endOfMonth);

        expect(result, isNotEmpty);
      });
    });

    group('formatScheduleTime', () {
      test('formats morning time correctly', () {
        final morning = DateTime(2026, 3, 15, 9, 30);
        final result = DateHelpers.formatScheduleTime(morning);

        expect(result, 'Mar 15, 9:30 AM');
      });

      test('formats afternoon time correctly', () {
        final afternoon = DateTime(2026, 3, 15, 14, 45);
        final result = DateHelpers.formatScheduleTime(afternoon);

        expect(result, 'Mar 15, 2:45 PM');
      });

      test('formats midnight correctly', () {
        final midnight = DateTime(2026, 3, 15, 0, 0);
        final result = DateHelpers.formatScheduleTime(midnight);

        expect(result, 'Mar 15, 12:00 AM');
      });

      test('formats noon correctly', () {
        final noon = DateTime(2026, 3, 15, 12, 0);
        final result = DateHelpers.formatScheduleTime(noon);

        expect(result, 'Mar 15, 12:00 PM');
      });
    });

    group('formatTimeOnly', () {
      test('formats time without date', () {
        final time = DateTime(2026, 3, 15, 15, 30);
        final result = DateHelpers.formatTimeOnly(time);

        expect(result, '3:30 PM');
      });
    });
  });

  group('PhoneHelpers', () {
    group('formatPhoneNumber', () {
      test('combines country code and number', () {
        final result = PhoneHelpers.formatPhoneNumber('+1', '4155551234');
        expect(result, '+14155551234');
      });

      test('handles different country codes', () {
        expect(PhoneHelpers.formatPhoneNumber('+44', '7911123456'), '+447911123456');
        expect(PhoneHelpers.formatPhoneNumber('+91', '9876543210'), '+919876543210');
      });
    });

    group('isValidPhoneLength', () {
      test('accepts 10-digit US number', () {
        expect(PhoneHelpers.isValidPhoneLength('4155551234'), true);
      });

      test('accepts 11-digit number with country code', () {
        expect(PhoneHelpers.isValidPhoneLength('14155551234'), true);
      });

      test('rejects too short number', () {
        expect(PhoneHelpers.isValidPhoneLength('12345'), false);
      });

      test('rejects too long number', () {
        expect(PhoneHelpers.isValidPhoneLength('1234567890123456'), false);
      });

      test('ignores non-digit characters', () {
        expect(PhoneHelpers.isValidPhoneLength('(415) 555-1234'), true);
        expect(PhoneHelpers.isValidPhoneLength('415-555-1234'), true);
      });
    });
  });

  group('CardHelpers', () {
    group('maskCardNumber', () {
      test('masks card number with asterisks', () {
        expect(CardHelpers.maskCardNumber('1234'), '****1234');
        expect(CardHelpers.maskCardNumber('5678'), '****5678');
      });
    });

    group('getCardType', () {
      test('identifies Visa cards', () {
        expect(CardHelpers.getCardType('4111111111111111'), 'visa');
        expect(CardHelpers.getCardType('4'), 'visa');
      });

      test('identifies Mastercard cards', () {
        expect(CardHelpers.getCardType('5111111111111111'), 'mastercard');
        expect(CardHelpers.getCardType('5'), 'mastercard');
      });

      test('identifies Amex cards', () {
        expect(CardHelpers.getCardType('341111111111111'), 'amex');
        expect(CardHelpers.getCardType('371111111111111'), 'amex');
      });

      test('returns unknown for other cards', () {
        expect(CardHelpers.getCardType('6011111111111111'), 'unknown');
        expect(CardHelpers.getCardType('3'), 'unknown');
      });
    });
  });
}
