# Circle · HLA Admin (Flutter Web)

A standalone Flutter **web** dashboard for Circle staff to manage the HLA typing
feature. It is a sibling app in this monorepo (`admin/`) and talks to the **same
Firebase project** (`circle-60af7`) as the mobile app — the same Firestore
collections (`hla_test_requests`, `hla_appointment_slots`, `hla_admins`) and the
same Storage path (`hla_results/`).

It is deliberately **not** coupled to the mobile app's code: the mobile HLA
models are ObjectBox entities and the app pulls in mobile-only plugins that don't
build for web. This app re-implements the small HLA data layer in pure Dart, with
serialization that matches the mobile app exactly so the same documents round-trip.

## What staff can do

- **Requests queue** — see every request in real time, filter by status, open one.
- **Advance status** — move a request through the journey with an optional note
  (appended to the patient-visible timeline).
- **Upload results** — attach a PDF/image to a request (stored in Firebase
  Storage) plus an optional summary; sets status to *Results available*.
- **Appointment slots** — create slots, activate/deactivate them.

## Architecture

```
lib/
  core/        enums (status/relation), theme, formatting, AdminException
  models/      HlaTestRequest, HlaSampleSubject, HlaStatusEvent, HlaAppointmentSlot
  services/    AuthService (Google popup), HlaAdminService (Firestore + Storage)
  repositories/HlaAdminRepository (status events, result upload, slot release)
  providers/   Riverpod (no codegen): auth + admin gate, requests/slots streams, mutations
  screens/     app_root (auth gate) -> sign_in / not_authorized / dashboard
               dashboard -> requests (master/detail) + slots
  widgets/     status chip, status timeline
```

State: `flutter_riverpod` (no build_runner). Errors flow through `AsyncValue` and
surface as snackbars.

## One-time setup

The committed `lib/firebase_options.dart` has **placeholder** `apiKey`/`appId` —
a Web app must be registered on the Firebase project first.

1. **Install deps**
   ```bash
   cd admin
   flutter pub get
   ```

2. **Add web Firebase config** (from `admin/`):
   ```bash
   flutterfire configure --project=circle-60af7 --platforms=web
   ```
   This rewrites `lib/firebase_options.dart` with the real web credentials.
   (Or register a Web app in the Firebase console and paste `apiKey` + `appId`.)

3. **Enable sign-in providers**: Firebase console -> Authentication -> Sign-in
   method -> enable **Google** and **Email/Password** (the dashboard offers
   both). Under Authentication -> Settings -> Authorized domains, add `localhost`
   (for local dev) and your eventual hosting domain. Email/password admins are
   created in Authentication -> Users.

4. **Deploy the security rules + indexes** (from the repo root — these are shared
   with the mobile feature and live in `../firestore.rules`, `../storage.rules`):
   ```bash
   firebase deploy --only firestore:rules,firestore:indexes,storage
   ```

5. **Provision admins**: the dashboard gate (and the security rules) require an
   `hla_admins/{uid}` document. For each staff member, after they sign in once
   (to create their Firebase Auth uid), add an empty document at
   `hla_admins/{their-uid}` in Firestore.

## Run / build

```bash
cd admin
flutter run -d chrome        # local dev
flutter build web            # production bundle -> build/web
flutter test                 # unit tests
```

To host it: `firebase deploy --only hosting` after configuring a Hosting target
that serves `admin/build/web` (not yet wired in `firebase.json`).

## Notes

- The admin gate is **authoritative via `hla_admins`**, not the user's profile
  `role` field — a non-admin who signs in sees an "access denied" screen and the
  rules reject any write.
- Result uploads use `putData` (web has bytes, not file paths).
- This app resolves to newer Firebase/Riverpod majors than the mobile app; that's
  fine since it's an independent package.
