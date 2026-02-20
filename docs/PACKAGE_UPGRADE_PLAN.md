# Package Upgrade Plan

## Context
22 packages are outdated (some by multiple major versions). This plan upgrades them in 7 safe batches, ordered from lowest to highest risk. Each batch is independently testable and committable.

The monorepo has 10 pubspec.yaml files that need coordinated updates:
- `apps/babysitter_app/pubspec.yaml` (main app)
- `packages/{core,networking,domain,data,ui_kit,auth,notifications,realtime}/pubspec.yaml`

---

## Batch 1: Build Tooling & Linting (zero runtime risk)

**Packages:** `build_runner` 2.4→2.11, `json_serializable` 6.9→6.13, `json_annotation` 4.9→4.11, `flutter_lints` 3.0→6.0, `lints` 3.0→6.0

**pubspec.yaml changes:**
| File | Changes |
|------|---------|
| `apps/babysitter_app/pubspec.yaml` | `json_annotation: ^4.11.0`, `flutter_lints: ^6.0.0`, `build_runner: ^2.11.1`, `json_serializable: ^6.13.0` |
| `packages/data/pubspec.yaml` | `json_annotation: ^4.11.0`, `flutter_lints: ^6.0.0`, `build_runner: ^2.11.1`, `json_serializable: ^6.13.0` |
| `packages/auth/pubspec.yaml` | `flutter_lints: ^6.0.0`, `build_runner: ^2.11.1` |
| `packages/core/pubspec.yaml` | `flutter_lints: ^6.0.0` |
| `packages/networking/pubspec.yaml` | `flutter_lints: ^6.0.0` |
| `packages/notifications/pubspec.yaml` | `flutter_lints: ^6.0.0` |
| `packages/realtime/pubspec.yaml` | `flutter_lints: ^6.0.0` |
| `packages/ui_kit/pubspec.yaml` | `flutter_lints: ^6.0.0` |
| `packages/domain/pubspec.yaml` | `lints: ^6.0.0` |

**analysis_options.yaml:** `flutter_lints` 6.0 may rename the include. Update both `analysis_options.yaml` files if needed. Run `flutter analyze` after to fix any new/renamed lint rules.

**Code changes:** Regenerate all `.g.dart` and `.freezed.dart` files with `build_runner`.

**Verify:** `flutter pub get` → `dart run build_runner build --delete-conflicting-outputs` → `flutter analyze`

---

## Batch 2: Isolated Leaf Packages (low risk)

**Packages:** `flutter_dotenv` 5→6, `permission_handler` 11→12, `app_links` 6→7, `geocoding` 3→4, `flutter_map` 7→8

**pubspec.yaml changes:**
| File | Changes |
|------|---------|
| `apps/babysitter_app/pubspec.yaml` | `flutter_dotenv: ^6.0.0`, `permission_handler: ^12.0.0`, `app_links: ^7.0.0`, `geocoding: ^4.0.0`, `flutter_map: ^8.0.0` |
| `packages/core/pubspec.yaml` | `flutter_dotenv: ^6.0.0` |

**Code changes:** Check each package's changelog for API renames. Key files to update if APIs changed:
- `packages/core/lib/src/env/env_config.dart` (flutter_dotenv)
- `apps/.../paypal_deep_link_service.dart` (app_links)
- `apps/.../step3_location.dart`, `apps/.../sitter_active_booking_screen.dart` (flutter_map)
- 5 geocoding files across parent/sitter features

**Verify:** `flutter pub get` → `flutter analyze` → fix any compile errors

---

## Batch 3: Feature Packages with API Changes (medium risk)

**Packages:** `geolocator` 11→14, `share_plus` 7→12, `file_picker` 8→10, `pay` 2→3

**pubspec.yaml changes:** All in `apps/babysitter_app/pubspec.yaml`

**Key code changes:**
- **geolocator**: `getCurrentPosition()` named params (`desiredAccuracy`, `timeLimit`) → `LocationSettings` object. ~6 files affected.
- **share_plus**: `Share.share(text)` → `SharePlus.instance.share(ShareParams(text: ...))`. 1 file (referral_bonuses_screen.dart).
- **file_picker**: Verify `FilePicker.platform.pickFiles()` API. 4 files.
- **pay**: Verify `Pay()` constructor and `PaymentConfiguration`. 3 files.

**Verify:** `flutter pub get` → `flutter analyze` → fix compile errors → test location/payment/share flows

---

## Batch 4: Firebase Stack (medium-high risk)

**Packages:** `firebase_core` 2→4, `firebase_messaging` 14→16

**pubspec.yaml changes:**
| File | Changes |
|------|---------|
| `apps/babysitter_app/pubspec.yaml` | `firebase_core: ^4.4.0`, `firebase_messaging: ^16.1.1` |
| `packages/notifications/pubspec.yaml` | `firebase_core: ^4.4.0`, `firebase_messaging: ^16.1.1` |

**Code changes:**
- `apps/babysitter_app/lib/main.dart`: Verify `Firebase.initializeApp()` still works without `DefaultFirebaseOptions`
- `packages/notifications/lib/src/notifications_service_impl.dart`: Verify `getAPNSToken()` return type (may change to `Uint8List?`), verify `setForegroundNotificationPresentationOptions()` exists
- Update Android `google-services` plugin if required
- Run `cd ios && pod update` for native Firebase SDK update

**Verify:** `flutter pub get` → `pod update` → `flutter analyze` → test FCM token registration, push notifications

---

## Batch 5: Notifications + CallKit (high risk - critical pipeline)

**Packages:** `flutter_local_notifications` 17→20, `flutter_callkit_incoming` 2→3

**pubspec.yaml changes:**
| File | Changes |
|------|---------|
| `apps/babysitter_app/pubspec.yaml` | `flutter_local_notifications: ^20.1.0`, `flutter_callkit_incoming: ^3.0.0` |
| `packages/notifications/pubspec.yaml` | `flutter_local_notifications: ^20.1.0` |

**Key code changes - flutter_local_notifications 20.x converts positional params to named:**
- `plugin.show(id, title, body, details)` → `plugin.show(id: ..., title: ..., body: ..., notificationDetails: ...)`
- `plugin.initialize(settings, ...)` → `plugin.initialize(initializationSettings: settings, ...)`
- `AndroidNotificationChannel(id, name, ...)` → `AndroidNotificationChannel(id: ..., name: ..., ...)`
- `AndroidInitializationSettings(icon)` → `AndroidInitializationSettings(defaultIcon: icon)`

Files affected:
- `packages/notifications/lib/src/notifications_service_impl.dart`
- `packages/notifications/lib/src/local_notifications_config.dart`
- `apps/.../call_notification_service.dart`
- `apps/babysitter_app/lib/main.dart`

**CRITICAL:** Preserve initialization order: `NotificationsServiceImpl` first, `CallNotificationService` second.

**flutter_callkit_incoming 3.0:** Verify `CallKitParams`, `FlutterCallkitIncoming` method signatures, `Event` enum values.

**Verify:** Test incoming call (foreground + background), notification tap → navigation, Accept/Decline actions

---

## Batch 6: GoRouter + Stripe (high risk - wide impact)

**Packages:** `go_router` 14→17, `flutter_stripe` 10→12

**pubspec.yaml changes:** All in `apps/babysitter_app/pubspec.yaml`

**go_router:** Breaking changes are mainly case-sensitivity (paths already lowercase) and niche API areas. Likely minimal code changes needed. Key file: `apps/.../routing/app_router.dart`. Verify `GoRouterState` property names, `ShellRoute` constructor, redirect callbacks.

**flutter_stripe:** Verify `Stripe.instance` methods, `PaymentMethodParams`, `confirmPayment` signature. Key files: `payment_method_selector.dart`, `google_pay_button_widget.dart`.

**Verify:** `flutter analyze` → test all navigation flows, payment flows, deep link → navigation

---

## Batch 7: Riverpod 3 (highest impact, but StateNotifier still works)

**Packages:** `flutter_riverpod` 2→3, `riverpod_annotation` 2→4, `riverpod_generator` 2→4

**pubspec.yaml changes:**
| File | Changes |
|------|---------|
| `apps/babysitter_app/pubspec.yaml` | `flutter_riverpod: ^3.0.0`, `riverpod_annotation: ^4.0.0`, `riverpod_generator: ^4.0.0` |
| `packages/auth/pubspec.yaml` | `flutter_riverpod: ^3.0.0`, `riverpod_annotation: ^4.0.0`, `riverpod_generator: ^4.0.0` |
| `packages/notifications/pubspec.yaml` | `flutter_riverpod: ^3.0.0` |
| `packages/realtime/pubspec.yaml` | `flutter_riverpod: ^3.0.0` |

**Key code changes:**
- Add `import 'package:flutter_riverpod/legacy.dart';` to all files using `StateNotifier`, `StateNotifierProvider`, or `StateProvider` (~18 files)
- Regenerate all `@riverpod` codegen files (3 controllers)
- Verify `Ref` type changes (subclass `FutureProviderRef` removed)

**StateNotifier→Notifier migration is DEFERRED** to a follow-up task. StateNotifier still works in Riverpod 3 with deprecation warnings.

**Verify:** `build_runner build` → `flutter analyze` → full regression test of all features

---

## Also Update (can be done alongside any batch)
- Remove `dependency_overrides` for `ffi` and `google_maps_flutter_android` if no longer needed after upgrades
- Update `environment` SDK constraints: `sdk: ^3.8.0` and `flutter: ">=3.32.0"` across all pubspec.yaml files (matches flutter_local_notifications 20.x minimum)

## Verification (after all batches)
1. `flutter pub get` — no resolution errors
2. `flutter analyze` — no errors (warnings OK for deprecations)
3. `flutter build ios --no-codesign` — iOS builds successfully
4. `flutter build apk` — Android builds successfully
5. Manual test on device: auth flow, notifications, calls, payments, maps, navigation
