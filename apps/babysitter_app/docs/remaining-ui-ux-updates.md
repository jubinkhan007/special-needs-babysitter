# Remaining UI/UX Updates

Items from the client's approved UI/UX update list that still need implementation. These require backend changes, new screens, or significant feature work beyond simple UI text edits.

---

## Sitter Section

### 1. Distinguish Parent vs Support Chats
- **What:** Visually differentiate conversations with parents from conversations with platform support in the messages list.
- **Why not done:** The `Conversation` model has no `type` or `isSupport` field. All chats render identically in `MessagesScreen`.
- **Needs:** Backend to add a `chatType` field (e.g. `parent`, `support`) to the conversation API response. Then update `MessageThreadTile` to show a badge or different styling for support chats.

### 2. Notification Feed Screen with Grouping & Preview Text
- **What:** A dedicated notification feed screen that groups notifications by category (Jobs, Messages, Payments, Reminders) and shows preview text under each notification.
- **Why not done:** No notification feed screen exists. Push notifications are handled by FCM and shown as OS-level notifications only.
- **Needs:** New `NotificationFeedScreen` with a backend API endpoint to fetch notification history. Group items by category. Add preview/subtitle text for each notification type.

### 3. Warm Notification Messages
- **What:** Replace robotic push notification copy (e.g. "Booking confirmed") with warmer, human-friendly language (e.g. "You're all set! Your booking with the Smith family is confirmed.").
- **Why not done:** Push notification text is composed on the backend and sent via FCM. The app does not control the wording.
- **Needs:** Backend team to update all notification templates with friendlier copy. Provide a list of current notification types and proposed new wording for each.

### 4. Rewards & Referral Explanation
- **What:** Add an explanation sentence on the sitter's Referral & Bonuses screen describing how rewards work (e.g. "Earn $25 for each sitter you refer who completes their first job").
- **Why not done:** No Referral & Bonuses screen exists for sitters yet. The menu item exists in `SitterAccountMenuList` but the screen is a placeholder.
- **Needs:** Build a `SitterReferralScreen` with referral code display, referral history, and an explanation of the rewards program. Backend API for referral tracking.

### 5. Notification Settings Grouped Logically
- **What:** The "Manage Notifications" screen should group notification toggles by category: Jobs, Messages, Payments, Reminders.
- **Why not done:** The Manage Notifications screen is a TODO placeholder in `SitterSettingsScreen`.
- **Needs:** Build a `NotificationSettingsScreen` with grouped toggle sections. Backend API to read/write per-category notification preferences.

---

## Parent Section

### 6. Bank Account (ACH Direct Debit) Payment Method
- **What:** Allow parents to pay via bank account (ACH) in addition to card and Apple Pay/Google Pay.
- **Why not done:** ACH Direct Debit requires Stripe Financial Connections integration, mandate collection, and handles 2-4 day settlement times. This is a significant integration.
- **Needs:** Stripe Financial Connections SDK integration, backend support for ACH payment intents, UI for bank account linking flow, handling of delayed settlement and payment failures.
- **Status:** Flagged for later discussion with client.

---

## Both Sections

### 7. Dispute Screen with Emotional/Supportive Language
- **What:** If a dispute screen is added (currently no dedicated dispute screen exists), use empathetic language rather than legalistic tone.
- **Why not done:** No dispute screen exists. Disputes are currently handled through the Report An Issue flow and backend review.
- **Needs:** If a dedicated dispute resolution screen is planned, design it with supportive copy. Otherwise, the updated Report An Issue screen (already done) covers this.

---

## Summary Table

| # | Item | Blocker | Effort |
|---|------|---------|--------|
| 1 | Parent vs Support chat distinction | Backend `chatType` field | Medium |
| 2 | Notification feed + grouping | New screen + backend API | Large |
| 3 | Warm notification messages | Backend notification templates | Small (backend) |
| 4 | Rewards/Referral screen | New screen + backend API | Medium |
| 5 | Notification settings grouped | New screen + backend API | Medium |
| 6 | Bank Account (ACH) payment | Stripe Financial Connections | Large |
| 7 | Dispute screen | Design decision needed | Medium |
