import 'package:circle/core/utils/enums.dart';
import 'package:circle/features/hla/models/hla_sample_subject.dart';
import 'package:circle/features/hla/models/hla_status_event.dart';
import 'package:circle/features/hla/models/hla_test_request.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('HlaTestStatusX', () {
    test('order follows declaration order; cancelled is -1', () {
      expect(HlaTestStatus.requested.order, 0);
      expect(
        HlaTestStatus.bookingConfirmed.order >
            HlaTestStatus.requested.order,
        isTrue,
      );
      expect(HlaTestStatus.cancelled.order, -1);
    });

    test('next advances forward and stops at resultsSent', () {
      expect(HlaTestStatus.requested.next, HlaTestStatus.bookingConfirmed);
      expect(HlaTestStatus.resultsAvailable.next, HlaTestStatus.resultsSent);
      expect(HlaTestStatus.resultsSent.next, isNull);
      expect(HlaTestStatus.cancelled.next, isNull);
    });

    test('terminal + cancellable flags', () {
      expect(HlaTestStatus.resultsSent.isTerminal, isTrue);
      expect(HlaTestStatus.cancelled.isTerminal, isTrue);
      expect(HlaTestStatus.requested.isTerminal, isFalse);

      expect(HlaTestStatus.requested.isPatientCancellable, isTrue);
      expect(HlaTestStatus.bookingConfirmed.isPatientCancellable, isTrue);
      expect(HlaTestStatus.collected.isPatientCancellable, isFalse);
    });

    test('isResultsReady only once results are available', () {
      expect(HlaTestStatus.tested.isResultsReady, isFalse);
      expect(HlaTestStatus.resultsAvailable.isResultsReady, isTrue);
      expect(HlaTestStatus.resultsSent.isResultsReady, isTrue);
      expect(HlaTestStatus.cancelled.isResultsReady, isFalse);
    });
  });

  group('HlaTestRequest serialization', () {
    test('toMap/fromMap round-trips subjects and status history', () {
      final DateTime now = DateTime.utc(2026, 6, 24, 10, 30);
      final request = HlaTestRequest(
        uid: 'req-1',
        userId: 'user-1',
        patientName: 'Jane Doe',
        status: HlaTestStatus.bookingConfirmed,
        subjects: [
          HlaSampleSubject.self(name: 'Jane'),
          const HlaSampleSubject(
            name: 'John',
            relation: HlaSubjectRelation.sibling,
            genotype: Genotype.as,
          ),
        ],
        statusHistory: [
          HlaStatusEvent(status: HlaTestStatus.requested, timestamp: now),
          HlaStatusEvent(
            status: HlaTestStatus.bookingConfirmed,
            timestamp: now.add(const Duration(hours: 1)),
            note: 'Slot booked',
          ),
        ],
        appointmentDate: now.add(const Duration(days: 2)),
        collectionLocation: 'Clinic A',
        createdAt: now,
        updatedAt: now,
      );

      final restored = HlaTestRequest.fromMap(request.toMap());

      expect(restored.uid, request.uid);
      expect(restored.userId, request.userId);
      expect(restored.patientName, request.patientName);
      expect(restored.status, HlaTestStatus.bookingConfirmed);
      expect(restored.subjects.length, 2);
      expect(restored.subjects.first.isSelf, isTrue);
      expect(restored.subjects[1].relation, HlaSubjectRelation.sibling);
      expect(restored.subjects[1].genotype, Genotype.as);
      expect(restored.statusHistory.length, 2);
      expect(restored.statusHistory.last.note, 'Slot booked');
      expect(restored.collectionLocation, 'Clinic A');
    });

    test('hasResults requires both a results status and a file url', () {
      final base = HlaTestRequest(
        uid: 'r',
        userId: 'u',
        patientName: 'P',
        status: HlaTestStatus.resultsAvailable,
      );
      expect(base.hasResults, isFalse);
      expect(
        base.copyWith(resultFileUrl: 'https://x/y.pdf').hasResults,
        isTrue,
      );
    });
  });

  group('HlaSampleSubject', () {
    test('self factory marks the primary subject', () {
      final self = HlaSampleSubject.self(name: 'Me');
      expect(self.isSelf, isTrue);
      expect(self.relation, HlaSubjectRelation.self);
    });
  });
}
