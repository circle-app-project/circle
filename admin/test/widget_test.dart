import 'package:flutter_test/flutter_test.dart';
import 'package:hla_admin/core/enums.dart';
import 'package:hla_admin/models/hla_test_request.dart';

void main() {
  group('HlaTestStatusX', () {
    test('next advances and stops at resultsSent', () {
      expect(HlaTestStatus.requested.next, HlaTestStatus.bookingConfirmed);
      expect(HlaTestStatus.resultsAvailable.next, HlaTestStatus.resultsSent);
      expect(HlaTestStatus.resultsSent.next, isNull);
      expect(HlaTestStatus.cancelled.next, isNull);
    });

    test('isResultsReady only once results are available', () {
      expect(HlaTestStatus.tested.isResultsReady, isFalse);
      expect(HlaTestStatus.resultsAvailable.isResultsReady, isTrue);
      expect(HlaTestStatus.cancelled.isResultsReady, isFalse);
    });
  });

  test('HlaTestRequest round-trips through the Firestore map shape', () {
    final source = {
      'id': 'req-1',
      'userId': 'user-1',
      'patientName': 'Jane Doe',
      'status': 'bookingConfirmed',
      'subjects': [
        {'name': 'Jane', 'relation': 'self', 'genotype': 'ss'},
        {'name': 'John', 'relation': 'sibling'},
      ],
      'statusHistory': [
        {'status': 'requested', 'timestamp': '2026-06-24T10:00:00.000Z'},
        {
          'status': 'bookingConfirmed',
          'timestamp': '2026-06-24T11:00:00.000Z',
          'note': 'Booked',
        },
      ],
      'collectionLocation': 'Clinic A',
      'isCancelled': false,
    };

    final request = HlaTestRequest.fromMap(source);
    expect(request.uid, 'req-1');
    expect(request.status, HlaTestStatus.bookingConfirmed);
    expect(request.subjects.length, 2);
    expect(request.subjects.first.isSelf, isTrue);
    expect(request.statusHistory.last.note, 'Booked');

    // toMap preserves the key the mobile app reads the id from.
    expect(request.toMap()['id'], 'req-1');
    expect(request.toMap()['status'], 'bookingConfirmed');
  });
}
