# Release Notes v1.3.0 (Client Summary)

**Release Date:** Feb 9, 2026  
**Sprint:** Jan 31 – Feb 9, 2026

---

## What's Included

### Audio & Video Calling
- **Full Agora integration** for real-time audio and video calls
- Incoming, outgoing, and in-call screens with call controls
- Call state management (ringing, connected, ended, error handling)
- RTM (Real-Time Messaging) integration for call signaling
- Call navigation guard to prevent duplicate screens
- Call accept/decline from push notifications

### Call Logs in Chat
- Call logs now display **inline within chat threads**
- Shows call type (audio/video), duration, and status
- Call history merged with messages chronologically

### Referral & Bonuses System
- Referral bonuses screen with reward tracking
- Referral code validation
- Invite sitters card with share functionality
- Bonus tracking and display

### Sitter Wallet Enhancements
- My Wallet screen improvements
- Payout history screen
- Withdraw functionality via bottom sheet

### UI & UX Improvements
- Booking flow refinements (parent & sitter)
- Profile setup improvements
- Job details screen enhancements
- Chat UI improvements (readability, scroll position)
- Payment method selector widget

---

## Bug Fixes

| Issue | Status |
|-------|--------|
| Black screen when accepting ended calls | ✅ Fixed |
| Call history API returning 400 error | ✅ Fixed |
| Chat starting from oldest messages | ✅ Fixed |
| Dropdown assertion error (duplicate security questions) | ✅ Fixed |

---

## Known Issues (Carried Over + New)

### High Priority

| Issue | Status |
|-------|--------|
| Parent Home "See All" not working | 🔴 Pending |
| Saved Sitters item tap not working | 🔴 Pending |
| Review posting from Sitter side not working | 🔴 Pending |
| Form validation missing in multiple areas | 🔴 Pending |
| iOS FCM token retrieval intermittently fails | 🔴 Pending |
| Sitter profile setup → Step 5 skip button not working | 🔴 Pending |
| Change password takes to home screen (not implemented) | 🔴 Pending |
| Social sign-in not implemented yet | 🔴 Pending |

### Medium Priority

| Issue | Status |
|-------|--------|
| Verify Identity & Background Check flow incomplete | 🟡 Pending |
| Some responsiveness issues on small devices | 🟡 Pending |
| Profile completion loader keeps spinning even when dialog is open | 🟡 Pending |
| Completed jobs and saved sitters data is static/hardcoded (not from server) | 🟡 Pending |

### Low Priority

| Issue | Status |
|-------|--------|
| Parent avatar sometimes missing on review screen | 🟢 Fixed (needs verification) |

---

## What We Need You to Test

- **Calls:** Make audio/video calls, accept/decline from notification, check call logs in chat
- **Chat:** Verify messages show latest first, call logs appear correctly
- **Referrals:** Generate referral code, share invite, validate referral
- **Wallet:** Check payout history, withdrawal flow (sitter side)
