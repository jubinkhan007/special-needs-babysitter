# Remaining UI/UX Updates

Items from the client's approved UI/UX update list that still need implementation. These require backend changes, new screens, or significant feature work beyond simple UI text edits.

---

## Sitter Section

### ~~1. Distinguish Parent vs Support Chats~~ DONE
- **What:** Visually differentiate conversations with parents from conversations with platform support in the messages list.
- **Done:** Added `chatType` field (`parent` | `support`) to `IConversation` type, Mongoose schema, and API response. Frontend normalizer maps `chatType: 'support'` to `isSystem: true`. `MessageThreadTile` now shows a blue "SUPPORT" badge and chat bubble avatar for support conversations.

### ~~2. Notification Feed Screen with Grouping & Preview Text~~ DONE
- **What:** A dedicated notification feed screen that groups notifications by category (Jobs, Messages, Payments, Reminders) and shows preview text under each notification.
- **Done:** Built `NotificationFeedScreen` with category filter chips (All, Jobs, Payments, Rewards), time-based grouping (Today, Yesterday, Earlier), pull-to-refresh, mark-all-read, and unread badge on bell icons. Connected to existing backend `GET /notification-inbox` API. Files: `notification_item.dart`, `notifications_api_service.dart`, `notification_providers.dart`, `notification_feed_screen.dart`, `notification_tile.dart`.

### ~~3. Warm Notification Messages~~ DONE
- **What:** Replace robotic push notification copy (e.g. "Booking confirmed") with warmer, human-friendly language (e.g. "You're all set! Your booking with the Smith family is confirmed.").
- **Done:** Updated all 24 notification templates in `NotificationService.ts` with warmer, human-friendly copy (e.g. "Booking Accepted!" → "You're all set!", "Payment Received" → "You got paid!", "Application Update" → "Update on your application" with encouraging follow-up).

### ~~4. Rewards & Referral Explanation~~ DONE (already implemented)
- **What:** Add an explanation sentence on the sitter's Referral & Bonuses screen describing how rewards work (e.g. "Earn $25 for each sitter you refer who completes their first job").
- **Done:** `ReferralBonusesScreen` is fully built with: referral code display + copy, "How It Works" 3-step explanation, share functionality, rewards list showing earned bonuses, and bonus info cards. Backend has complete referral API (generate, invite, validate, stats, list). $10 bonus credited to both referrer and referred sitter on first job completion.

### ~~5. Notification Settings Grouped Logically~~ DONE
- **What:** The "Manage Notifications" screen should group notification toggles by category: Jobs, Messages, Payments, Reminders.
- **Done:** Rebuilt `ManageNotificationsScreen` with grouped sections (General, Jobs, Messages & Reminders, Other), section headers, and a master Push Notifications toggle that dims/disables category toggles when off. Replaced local-only `ChangeNotifier` with Riverpod `AsyncNotifier` backed by `GET/PATCH /notifications/preferences`. Wired sitter settings navigation. Toggles persist via backend.

---

## Parent Section

### 6. Bank Account (ACH Direct Debit) Payment Method
- **What:** Allow parents to pay via bank account (ACH) in addition to card and Apple Pay/Google Pay.
- **Why not done:** ACH Direct Debit requires Stripe Financial Connections integration, mandate collection, and handles 2-4 day settlement times. This is a significant integration.
- **Needs:** Stripe Financial Connections SDK integration, backend support for ACH payment intents, UI for bank account linking flow, handling of delayed settlement and payment failures.
- **Status:** Flagged for later discussion with client.

---

## Both Sections

### ~~7. Dispute Screen with Emotional/Supportive Language~~ DONE (already covered)
- **What:** If a dispute screen is added (currently no dedicated dispute screen exists), use empathetic language rather than legalistic tone.
- **Done:** No separate dispute screen is needed. The existing `ReportIssueScreen` handles disputes with warm, supportive copy: "Tell us what happened so we can help", confidentiality reassurance, and a 24-48 hour follow-up promise. The tone is empathetic throughout.

---

## Summary Table

| # | Item | Blocker | Effort |
|---|------|---------|--------|
| ~~1~~ | ~~Parent vs Support chat distinction~~ | ~~Backend `chatType` field~~ | ~~Medium~~ DONE |
| ~~2~~ | ~~Notification feed + grouping~~ | ~~New screen + backend API~~ | ~~Large~~ DONE |
| ~~3~~ | ~~Warm notification messages~~ | ~~Backend notification templates~~ | ~~Small (backend)~~ DONE |
| ~~4~~ | ~~Rewards/Referral screen~~ | ~~New screen + backend API~~ | ~~Medium~~ DONE (already existed) |
| ~~5~~ | ~~Notification settings grouped~~ | ~~New screen + backend API~~ | ~~Medium~~ DONE |
| 6 | Bank Account (ACH) payment | Stripe Financial Connections | Large |
| ~~7~~ | ~~Dispute screen~~ | ~~Design decision needed~~ | ~~Medium~~ DONE (already covered) |
