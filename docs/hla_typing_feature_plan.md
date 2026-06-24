# HLA Typing Test — Feature Implementation Plan (MVP)

> **Audience:** an AI coding agent (Claude Code) implementing this feature, plus the human reviewing it.
> **Status:** Plan / specification. No code written yet.
> **Scope discipline:** This is an MVP. Every section below is deliberately limited to "what is needed for the feature to work end-to-end." Anything beyond that is listed explicitly under **Out of Scope** so it is not accidentally built.

---

## 1. Background & Problem

Circle is a Flutter + Firebase app for sickle cell patients (primary market: Cameroon). Patients who are candidates for a **bone marrow / stem cell transplant** need **HLA typing** to find a compatible donor. The lab work is performed by **partner labs in India** — the patient's sample is collected locally in Cameroon and physically shipped to India.

Today this process is opaque: patients hand over a sample and then have no visibility into where it is or what is happening. The feature exists to **streamline the request, standardize sample collection scheduling, and give the patient continuous clarity on the status of their test journey** — ending with the results being delivered inside the app.

Key real-world facts that shape the design:

- A sample is rarely tested alone. A patient's sample is **cross-matched against a panel** of other people — relatives and potential donors — whose samples are collected together. The data model must represent a **request that contains multiple sample subjects**.
- The process is **staff-mediated**. A patient cannot self-advance the status; only Circle staff (admin) know when a sample was shipped, received, tested, etc. So the feature is **two-sided**: a **client side** (patient requests + tracks) and an **admin side** (staff manage requests, advance status, upload results).
- Connectivity in the field can be poor; the app already follows a **local-first (ObjectBox) + remote (Firestore)** pattern, which we reuse.

---

## 2. Goals & Non-Goals

### Goals (MVP)
1. A patient can **request** an HLA typing test from inside the app.
2. The patient **books a collection appointment** from a set of preset, admin-defined slots, to come hand over the sample.
3. The patient can add the **panel of sample subjects** (themselves + relatives / potential donors) that will be collected and cross-matched.
4. The patient can **track the full status journey** of their request in real time.
5. The patient can **view and download results** once a staff member uploads them.
6. Staff (admin) can **see all requests, advance status, manage appointment slots, and upload results.**
7. Medical data is **access-controlled** so a patient only ever sees their own request and results.

### Non-Goals / Out of Scope (do NOT build for MVP)
- Online payment / billing for the test.
- In-app donor recruitment, matching algorithm, or compatibility scoring (results are delivered as a document/summary; interpretation is clinical, done off-app).
- Push notifications via FCM (status updates surface via in-app realtime read on open). *Hook left in place; see §11.*
- A separate standalone web admin portal. The admin side ships as **role-gated screens inside the same Flutter app** (see Decision D1).
- Chat / messaging between patient and staff.
- Editing a request after submission by the patient (patient can cancel only; staff can edit).
- Multi-language / i18n work beyond what the app already does.
- Shipment carrier tracking integration (transit status is set manually by staff).

---

## 3. Key Decisions & Assumptions

| ID | Decision | Rationale | Alternative (rejected for MVP) |
|----|----------|-----------|-------------------------------|
| **D1** | Admin side = **role-gated screens in the same Flutter app**, gated by a `role` field on the user (`patient` / `admin`). | Lowest scope; reuses all existing models, repos, theme, routing. Staff use the same app build. | Separate Flutter Web admin app — more surface area, separate auth/build/deploy. Defer. |
| **D2** | Status is **staff-driven**. The patient can only `create` and `cancel`. All forward transitions are admin-only and enforced by **Firestore Security Rules**. | Matches reality; prevents patients from faking progress. | Patient self-service status — incorrect for this domain. |
| **D3** | Results are stored as a **file (PDF/image) in Firebase Storage**, plus an optional short text summary in Firestore. | "Results uploaded on the app" implies a lab document. | Fully structured HLA allele data — large scope, clinically risky to render ourselves. Defer. |
| **D4** | Appointment booking uses **admin-defined preset slots** (`hla_appointment_slots`). Patient picks one; capacity decremented. | "based on a preset schedule" in the brief. | Free-form date picking / calendar integration — defer. |
| **D5** | Local-first persistence (ObjectBox cache) is **optional for MVP** and may be deferred to a fast-follow. The realtime source of truth is **Firestore snapshots**. | Status changes are remote-driven; realtime read is simplest and correct. Keep the repository seam so a local cache can be added later without touching providers/screens. | Full offline sync from day one — extra scope. |
| **D6** | One **active** request per patient at a time (a patient can have past/closed requests, but only one open journey). | Keeps UI and admin queue simple for MVP. | Unlimited concurrent requests — defer. |

> **Action for implementer:** If the human reviewer disagrees with **D1** (admin in-app vs. separate portal) or **D3** (file vs. structured results), stop and confirm before building, because those two decisions shape the most code.

---

## 4. Refined User Stories & Acceptance Criteria

Stories are grouped by actor. Each has explicit acceptance criteria (AC) to keep implementation honest and scoped.

### A. Patient (client side)

**US-1 — Request an HLA typing test**
> As a sickle cell patient, I want to request an HLA typing test so that I can begin the journey toward finding a transplant match.
- AC1: From the HLA feature entry point, the patient sees a short plain-language explainer of what HLA typing is and why it matters, plus a "Request test" CTA.
- AC2: Submitting creates an `HlaTestRequest` with status `requested`, `userId` = current user, `createdAt` set.
- AC3: If the patient already has an **active** request (D6), the CTA is replaced by "View your active request" instead of allowing a duplicate.
- AC4: On failure (network/Firestore), the patient sees a non-destructive error (existing `snackbar_notifier` pattern) and no partial request is created.

**US-2 — Build the sample panel (subjects)**
> As a patient, I want to list the people whose samples will be collected and cross-matched (myself, relatives, potential donors), so the lab tests the right panel.
- AC1: The patient (themselves) is added automatically as the primary subject (`relation = self`).
- AC2: The patient can add additional subjects with: name (required), relation (`sibling`, `parent`, `child`, `relative`, `potentialDonor`, `other`), optional date of birth, optional genotype, optional phone.
- AC3: The patient can edit/remove additional subjects **only while status is `requested`** (before collection).
- AC4: At least one subject (self) always exists; the panel cannot be emptied.

**US-3 — Book a collection appointment**
> As a patient, I want to choose a date/time to come hand over my sample, from the slots the clinic offers.
- AC1: The patient sees a list of **available** preset slots (future-dated, `isActive == true`, `bookedCount < capacity`), each showing date, time, and location.
- AC2: Selecting a slot books it: the request stores `appointmentSlotId`, `appointmentDate`, `collectionLocation`, and the slot's `bookedCount` is incremented atomically.
- AC3: If a slot fills between view and booking, the patient sees "slot no longer available" and is asked to pick another (handle via Firestore transaction).
- AC4: The patient can see their booked appointment on the status screen.

**US-4 — Track the status journey**
> As a patient, I want to see exactly where my test is in the process so I have clarity and confidence.
- AC1: A status screen shows a **vertical timeline** of all stages (see §6 status model), with completed stages, the current stage highlighted, and upcoming stages dimmed.
- AC2: Each completed stage shows the timestamp it was reached (from `statusHistory`) and any staff note attached to that event.
- AC3: The screen reflects status changes in **near real time** via a Firestore snapshot stream (no manual refresh needed while open).
- AC4: The patient can **cancel** a request while it is still `requested` or `bookingConfirmed`; cancelling sets status `cancelled` and frees the booked slot.

**US-5 — View & download results**
> As a patient, I want to see my results in the app once they're ready.
- AC1: When status reaches `resultsAvailable`/`resultsSent`, a "View results" action appears.
- AC2: The patient can view the result document (open/download the file from Firebase Storage) and read the optional staff summary text.
- AC3: A patient can **only** access their own result file (enforced by Storage rules, §8).
- AC4: If no file is attached yet, the results screen shows a clear "results not uploaded yet" empty state rather than an error.

**US-6 — See my request history**
> As a patient, I want to see my current and past requests in one place.
- AC1: A list screen shows the patient's requests (active first, then closed/cancelled), each with status chip and appointment date.
- AC2: Tapping a request opens its status screen.

### B. Staff (admin side)

**US-7 — Review the request queue**
> As a Circle staff member, I want to see all incoming and in-progress requests so I can manage them.
- AC1: Admin-only list screen shows all `HlaTestRequest`s with patient name, status, appointment date; filterable by status.
- AC2: Visible only to users with `role == admin` (UI gate + rules enforcement).

**US-8 — Advance the status of a request**
> As staff, I want to move a request through the journey and attach notes, so the patient always sees the truth.
- AC1: From a request detail screen, staff can set the next status (and, where it makes sense, jump to a specific status). Each change appends an `HlaStatusEvent` (status, timestamp, optional note) to `statusHistory` and updates `status` + `updatedAt`.
- AC2: Forward transitions follow the allowed order in §6; backward correction is allowed for admins (with a note) to fix mistakes.
- AC3: Status writes are admin-only (rules).

**US-9 — Manage appointment slots**
> As staff, I want to define when patients can come give samples.
- AC1: Admin can create slots: date/time, location, capacity, `isActive`.
- AC2: Admin can deactivate a slot (hides it from patients) without deleting history.

**US-10 — Upload results**
> As staff, I want to attach the lab's result document to a request and notify the patient (in-app).
- AC1: Admin can pick a PDF/image and upload it to `hla_results/{requestId}/...` in Firebase Storage; the download path/URL + filename are saved on the request.
- AC2: Admin can add an optional plain-text result summary.
- AC3: Uploading sets status to `resultsAvailable` (and staff can then mark `resultsSent`).

---

## 5. Architecture & File Layout

This feature follows the existing **feature-first** convention (`lib/features/<name>/` with `models / services / repositories / providers / screens`), **functional error handling** (`FutureEither<T>`, `futureHandler`, fpdart `Either`), **Riverpod + codegen**, **AutoRoute**, and **Material 3 theme tokens** (`AppColors`, `AppTextStyles`, `AppConstants`). Do **not** hardcode colors/spacing.

Feature folder name: **`hla`**.

```
lib/features/hla/
  models/
    hla_test_request.dart        # @Entity (ObjectBox) + toMap/fromMap, copyWith, Equatable
    hla_sample_subject.dart      # plain model, toMap/fromMap (stored as JSON in request)
    hla_status_event.dart        # plain model {status, timestamp, note}
    hla_appointment_slot.dart    # @Entity-optional; Firestore doc model
  services/
    remote/
      hla_service.dart           # Firestore reads/writes + Firebase Storage upload/download
    local/
      hla_local_service.dart     # (Optional, D5) ObjectBox cache. Stub allowed for MVP.
  repositories/
    hla_repository.dart          # abstract interface + Impl; returns FutureEither<T>
  providers/
    hla_requests_notifier.dart   # patient: own requests (+ realtime stream)   (+ .g.dart)
    hla_request_form_notifier.dart # patient: build/submit a new request        (+ .g.dart)
    hla_slots_notifier.dart      # available appointment slots                  (+ .g.dart)
    hla_admin_notifier.dart      # admin: all requests, status updates, uploads (+ .g.dart)
  screens/
    hla_intro_screen.dart        # explainer + "Request test" CTA / "View active request"
    hla_request_form_screen.dart # add subjects + pick slot + submit
    hla_requests_list_screen.dart# patient's requests
    hla_status_screen.dart       # the journey timeline + cancel + results entry
    hla_results_screen.dart      # view/download result file + summary
    components/
      hla_status_timeline.dart   # reusable vertical timeline widget
      hla_status_chip.dart       # status -> colored chip
      hla_subject_tile.dart      # subject row + add/edit sheet
      hla_slot_tile.dart         # appointment slot row
      components.dart            # barrel
    admin/
      hla_admin_list_screen.dart
      hla_admin_detail_screen.dart   # advance status, upload results, view subjects
      hla_admin_slots_screen.dart    # manage appointment slots
  hla.dart                       # barrel: export screens + components
```

Shared edits:
- `lib/core/utils/enums.dart` — add `HlaTestStatus`, `HlaSubjectRelation`, and a `UserRole` enum (if not already present).
- `lib/core/routes/routes.dart` — register the new routes (then regenerate `routes.gr.dart`).
- `lib/features/auth/models/user/...` — add a `role` field to the user model/profile (default `patient`). See §7.
- Home / navigation surface — add an entry point card/tile to the HLA feature (see §9).

### Data flow (unchanged pattern)
```
Screen → Notifier (Riverpod) → HlaRepository → HlaService (Firestore / Storage)
                                            ↘ HlaLocalService (ObjectBox, optional)
```
Repositories convert exceptions to `Failure` via `futureHandler`; notifiers `fold` the `Either` into `AsyncValue` state exactly like `MedNotifier`.

---

## 6. Status Model (the "journey")

Add to `core/utils/enums.dart`. Each value carries a `label` (patient-facing), a short `description`, and an `icon` so the timeline and chips render consistently (mirrors the `MedicationType` enum style).

```dart
enum HlaTestStatus {
  requested,        // "Sample requested"  — request created
  bookingConfirmed, // "Appointment booked" — slot chosen, awaiting collection
  collected,        // "Sample collected"  — patient handed over sample
  sentForTesting,   // "Sample sent for testing"
  inTransit,        // "Sample in transit" — shipping to India
  tested,           // "Sample tested"     — lab completed analysis
  resultsProcessing,// "Results processing"
  resultsAvailable, // "Results available" — file uploaded to app
  resultsSent,      // "Results sent"      — delivered/acknowledged to patient
  cancelled,        // terminal, patient- or staff-initiated
}
```

**Canonical forward order** (used to compute "completed vs upcoming" in the timeline and to validate admin transitions):
`requested → bookingConfirmed → collected → sentForTesting → inTransit → tested → resultsProcessing → resultsAvailable → resultsSent`

- `cancelled` is terminal and reachable from `requested` or `bookingConfirmed` (patient) or any non-terminal state (admin).
- Admins may move backward one or more steps to correct mistakes (must attach a note). Patients can never change status except to `cancelled`.

Provide helpers on the enum/extension: `int get order`, `bool get isTerminal`, `HlaTestStatus? get next`, and `bool get isResultsReady => order >= resultsAvailable.order`.

---

## 7. Data Model & Firestore Structure

### Collections
```
hla_test_requests/{requestId}        # one document per request
hla_appointment_slots/{slotId}       # admin-managed bookable slots
users/{uid}                          # existing — add `role` field (patient|admin)
```
### Storage
```
hla_results/{requestId}/{fileName}   # result document(s), admin-uploaded
```

### `hla_test_requests/{requestId}` document shape
```jsonc
{
  "id": "uuid",
  "userId": "<patient uid>",
  "patientName": "<denormalized for admin list>",
  "status": "requested",
  "subjects": [
    { "name": "Self", "relation": "self", "dob": null, "genotype": "ss", "phone": null },
    { "name": "Brother", "relation": "sibling", "dob": "...", "genotype": null, "phone": "..." }
  ],
  "appointmentSlotId": "slotId|null",
  "appointmentDate": "ISO8601|null",
  "collectionLocation": "string|null",
  "statusHistory": [
    { "status": "requested", "timestamp": "ISO8601", "note": null }
  ],
  "resultFileUrl": "string|null",
  "resultFileName": "string|null",
  "resultSummary": "string|null",
  "adminNotes": "string|null",        // admin-only field
  "isCancelled": false,
  "createdAt": "ISO8601",
  "updatedAt": "ISO8601"
}
```
- Serialize like existing models (`toMap` writes ISO8601 UTC strings, enums by `.name`; `fromMap` mirrors). Subjects and statusHistory are JSON-encoded lists, matching how `Dose`/`Frequency` are handled in `Medication`.
- `HlaSampleSubject` and `HlaStatusEvent` are plain Dart models with `toMap`/`fromMap`; if cached in ObjectBox they ride along as JSON strings via `@Transient` getters/setters (same trick as `Medication.dbDose`).

### `hla_appointment_slots/{slotId}`
```jsonc
{
  "id": "uuid",
  "dateTime": "ISO8601",
  "location": "string",
  "capacity": 10,
  "bookedCount": 0,
  "isActive": true
}
```
Booking/cancelling must use a **Firestore transaction** to read+increment/decrement `bookedCount` against `capacity` (AC for US-3.3).

### User role (§D1)
Add `role` (enum `UserRole { patient, admin }`, default `patient`) to the user profile model and its `toMap`/`fromMap`. Admin accounts are provisioned manually (set the field in Firestore console for MVP). The app reads `role` to gate admin UI; **rules** enforce it server-side (§8).

---

## 8. Security Rules (MUST ship with the feature)

Medical data — access control is part of the feature, not an afterthought. Add to `firestore.rules` and `storage.rules`.

**Firestore — `hla_test_requests`:**
- `create`: allowed if `request.resource.data.userId == request.auth.uid` and incoming `status == "requested"`.
- `read`: allowed if `resource.data.userId == request.auth.uid` **or** caller is admin.
- `update`:
  - **Patient** (owner, non-admin): may only set `isCancelled`/`status` to `cancelled`, or edit `subjects`/appointment fields **while `status == "requested"`**. May **not** modify `status` (beyond cancel), `statusHistory`, `resultFileUrl`, `resultSummary`, `adminNotes`.
  - **Admin**: may update any field.
- `delete`: admin only.

**Firestore — `hla_appointment_slots`:** `read` by any authenticated user; `create/update/delete` admin only (but allow the owner's transactional `bookedCount` increment — implement booking via a callable/transaction that the rules permit narrowly, or allow authenticated users to update only `bookedCount` within [previous, previous+1] and only on active future slots).

**Storage — `hla_results/{requestId}/...`:** `read` if caller is the owning patient of `requestId` or admin; `write` admin only.

> Define an `isAdmin()` rules helper that checks `get(/databases/.../users/$(uid)).data.role == 'admin'`. (For a hardening fast-follow, migrate to Firebase **custom claims** so rules don't pay a document read per check — out of scope for MVP, note it.)

---

## 9. Navigation & Entry Points

- Register routes in `lib/core/routes/routes.dart` (then run codegen):
  `HlaIntroScreen`, `HlaRequestFormScreen`, `HlaRequestsListScreen`, `HlaStatusScreen` (takes `requestId`), `HlaResultsScreen` (takes `requestId`), and admin: `HlaAdminListScreen`, `HlaAdminDetailScreen` (takes `requestId`), `HlaAdminSlotsScreen`.
- Each screen exposes a `static const String path` and `@RoutePage()` annotation, matching existing screens.
- **Patient entry point:** add a card/tile on the Home screen (and/or Profile) — e.g. "HLA typing & transplant matching" → `HlaIntroScreen`. Use existing home component patterns and theme tokens.
- **Admin entry point:** show an "Admin" section (only when `role == admin`) — e.g. an item in Profile/settings → `HlaAdminListScreen`. Gate purely on the role read; never show to patients.

---

## 10. Provider Responsibilities

All providers use `@Riverpod`, extend `_$ClassName`, receive the repository via `build()` (constructor injection, like `MedNotifier`), and `fold` `Either` into `AsyncValue`. Instantiate the service/repository singletons at top-of-file as the meds feature does.

- **`HlaRequestsNotifier`** (patient): exposes the user's requests; provides a **realtime stream** of the active request (Firestore `snapshots()`), and actions `cancelRequest()`.
- **`HlaRequestFormNotifier`** (patient): holds the in-progress new request (subjects list, selected slot); `addSubject`, `removeSubject`, `selectSlot`, `submit()`.
- **`HlaSlotsNotifier`**: loads available slots (future, active, not full).
- **`HlaAdminNotifier`** (admin): loads all requests (filterable by status); `advanceStatus(requestId, status, note)`, `uploadResult(requestId, file, summary)`, slot CRUD.

Keep business rules (transition order validation, "one active request") in the repository or notifier — **never** in services (services are pure Firebase/Storage I/O per the architecture doc).

---

## 11. Dependencies to Add

Add to `pubspec.yaml` (do **not** touch the `+N` build number):
- `firebase_storage` — upload/download result documents (**required**, not currently in deps).
- `file_picker` — admin selects a PDF/image to upload (**required** for US-10).
- (Already present, reuse) `url_launcher` to open a downloaded result, `uuid` for ids, `intl`/`jiffy` for date formatting, `cloud_firestore`, `firebase_auth`.
- **Optional / deferred:** `firebase_messaging` for push notifications on status change — leave a clearly-marked TODO in `HlaAdminNotifier.advanceStatus` where a notification would be triggered; do not implement for MVP.

Run `flutter pub get` after editing.

---

## 12. Implementation Phases (ordered, hand-off ready)

Each phase ends green (`flutter analyze` clean, app builds). Run codegen whenever annotations/routes/entities change:
`flutter pub run build_runner build --delete-conflicting-outputs`.

**Phase 0 — Scaffolding & deps**
- Add `firebase_storage`, `file_picker`; `flutter pub get`.
- Create the `lib/features/hla/` folder tree and the `hla.dart` barrel (empty exports to start).

**Phase 1 — Enums & user role**
- Add `HlaTestStatus`, `HlaSubjectRelation`, `UserRole` to `core/utils/enums.dart` (with labels/descriptions/icons + helpers in §6).
- Add `role` to the user profile model + `toMap`/`fromMap`; default `patient`. Regenerate.

**Phase 2 — Models**
- `HlaSampleSubject`, `HlaStatusEvent` (plain, `toMap`/`fromMap`, Equatable).
- `HlaAppointmentSlot` (model + `toMap`/`fromMap`).
- `HlaTestRequest` (`@Entity`, JSON-string converters for subjects/statusHistory like `Medication`, `copyWith`, `empty`, Equatable). Regenerate ObjectBox.

**Phase 3 — Remote service (`hla_service.dart`)**
- Firestore CRUD for `hla_test_requests` (create, get-by-user, stream-by-id, update, list-all-for-admin).
- Slots: list available, create/update (admin), transactional book/unbook (`bookedCount`).
- Storage: `uploadResult(requestId, file)` → returns download URL; result metadata write.

**Phase 4 — Repository (`hla_repository.dart`)**
- Abstract interface + Impl returning `FutureEither<T>` via `futureHandler`.
- Enforce business rules: one active request (D6), valid status transitions (§6), cancel frees slot.
- (Optional D5) wire `HlaLocalService`; otherwise read straight from remote.

**Phase 5 — Providers** (Phase 10 list) + regenerate.

**Phase 6 — Patient screens & components**
- Intro → request form (subjects + slot) → submit.
- Requests list → status timeline (realtime) → results view/download.
- Reusable: `hla_status_timeline`, `hla_status_chip`, `hla_subject_tile`, `hla_slot_tile`.

**Phase 7 — Admin screens (role-gated)**
- Admin list (filter by status) → detail (advance status + note, view subjects, upload result + summary) → slots management.
- Gate all admin UI on `role == admin`.

**Phase 8 — Routes, entry points, barrel**
- Register routes; regenerate `routes.gr.dart`.
- Add Home patient entry point and Profile admin entry point.
- Fill in `hla.dart` exports.

**Phase 9 — Security rules**
- Write `firestore.rules` + `storage.rules` per §8. Add `isAdmin()` helper. Test with the rules emulator if available.

**Phase 10 — QA, analyze, tests**
- `flutter analyze` clean; `dart fix --apply`.
- Add repository/notifier unit tests with mock repositories (the codebase's stated test pattern — pass mock repos into `build()`).
- Manual QA checklist (§13).

---

## 13. Manual QA Checklist (end-to-end)

1. New patient → Intro → Request test → request created with status `requested`.
2. Add a sibling + a potential donor subject; remove the donor; self cannot be removed.
3. Book an appointment slot → status `bookingConfirmed`, slot `bookedCount` increments; appointment shows on status screen.
4. Two patients race for the last seat in a slot → second gets "slot no longer available", no over-booking.
5. As admin: advance request through every stage; each step appears on the patient timeline in real time with timestamp + note.
6. As admin: upload a PDF result + summary → status `resultsAvailable`; patient sees "View results", can open the file.
7. Patient B cannot open Patient A's request or result file (rules block it).
8. Patient cancels a `bookingConfirmed` request → status `cancelled`, slot seat freed.
9. Non-admin user sees **no** admin entry point and is blocked by rules if they attempt an admin write.
10. Offline / flaky network → errors surface via snackbar, no partial/corrupt requests.

---

## 14. Open Questions for the Reviewer

1. **D1 confirmation:** Admin as in-app role-gated screens (recommended) vs. a separate web portal?
2. **D3 confirmation:** Results as an uploaded file + text summary (recommended) — acceptable, or is structured allele data needed even for MVP?
3. **Collection locations:** Are there fixed clinic locations to seed for appointment slots, or does the admin enter them free-form per slot?
4. **Admin provisioning:** OK to set `role: admin` manually in the Firestore console for MVP, with custom-claims migration as a fast-follow?
5. **Data retention / consent:** Any consent text the patient must accept before requesting (medical data leaving the country to India)? If yes, add a checkbox + stored consent flag to US-1 (small, in-scope addition).

> Question 5 in particular may be a **compliance requirement** for shipping medical samples internationally — flag to product/legal before launch even though it's a tiny code change.
