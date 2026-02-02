# Release Notes v1.2.0
**Release Date:** January 30, 2026  
**Sprint:** Jan 21 - Jan 30, 2026

---

## 📱 Application Package Changes

### Android Package Rename
- **Changed package name** from `com.specialneedssitters.parent_app` to `com.waywise.specialneedssitters`
- Updated MainActivity.kt with new package structure
- Updated AndroidManifest.xml and build.gradle.kts configurations

---

## ✨ New Features

### 1. Sitter Job Search & Filter System
**Files Added/Modified:**
- `lib/src/features/sitter/home/domain/entities/job_search_filters.dart` (NEW)
- `lib/src/features/sitter/home/presentation/widgets/job_filter_sheet.dart` (NEW)
- `lib/src/features/sitter/home/presentation/screens/sitter_all_jobs_screen.dart`
- `lib/src/features/sitter/home/presentation/providers/sitter_home_providers.dart`

**Implementation Details:**
- Implemented comprehensive job filtering with multiple criteria
- Added filter bottom sheet UI for easy filter selection
- Filters include: location, job type, pay rate, date range
- Real-time filter application with state management

### 2. Sitter Active Booking & Session Management
**Files Added/Modified:**
- `lib/src/features/sitter/bookings/presentation/screens/sitter_active_booking_screen.dart` (NEW/Enhanced)
- `lib/src/features/sitter/bookings/presentation/controllers/session_tracking_controller.dart`
- `lib/src/features/sitter/bookings/presentation/widgets/break_timer_dialog.dart` (NEW)
- `lib/src/features/sitter/bookings/presentation/widgets/pause_clock_dialog.dart` (NEW)
- `lib/src/features/sitter/bookings/data/models/clock_out_result_model.dart` (NEW)

**Implementation Details:**
- Live session tracking with timer functionality
- Break timer dialog with duration display
- Pause/Resume clock functionality with reason capture
- Clock-out result handling and validation
- Real-time location tracking during active sessions

### 3. Sitter Wallet & Stripe Connect Integration
**Files Added/Modified:**
- `lib/src/features/sitter/wallet/presentation/screens/sitter_wallet_screen.dart` (NEW)
- `lib/src/features/sitter/wallet/data/models/stripe_connect_status.dart` (NEW)
- `lib/src/features/sitter/wallet/data/sources/stripe_connect_remote_datasource.dart` (NEW)
- `lib/src/features/sitter/wallet/presentation/providers/stripe_connect_providers.dart` (NEW)
- `lib/src/features/sitter/wallet/presentation/widgets/onboarding_status_card.dart` (NEW)

**Implementation Details:**
- Stripe Connect onboarding integration for sitter payments
- Wallet screen with balance display and transaction history
- Onboarding status tracking for payment setup
- Payout management interface

### 4. Review System with Image Upload
**Files Added/Modified:**
- `lib/src/features/bookings/data/sources/review_remote_datasource.dart` (NEW)
- `lib/src/features/bookings/data/sources/review_image_upload_remote_datasource.dart` (NEW)
- `lib/src/features/bookings/presentation/providers/review_providers.dart` (NEW)
- `lib/src/features/sitter/bookings/presentation/screens/sitter_review_screen.dart` (NEW)
- `lib/src/features/bookings/presentation/review/review_screen.dart`

**Implementation Details:**
- Star rating system for completed bookings
- Review text input with validation
- Image upload capability for reviews (up to 5 images)
- Review aggregation and display on sitter profiles

### 5. Sitter Reviews Management
**Files Added/Modified:**
- `lib/src/features/sitter/account/data/models/sitter_review.dart` (NEW)
- `lib/src/features/sitter/account/data/sources/sitter_reviews_remote_datasource.dart` (NEW)
- `lib/src/features/sitter/account/presentation/providers/sitter_reviews_providers.dart` (NEW)
- `lib/src/features/sitter/account/presentation/screens/sitter_reviews_screen.dart`

**Implementation Details:**
- Sitter can view all reviews received from parents
- Review statistics and average rating calculation
- Review detail view with parent comments

### 6. Sitter Settings Screen
**Files Added/Modified:**
- `lib/src/features/sitter/account/presentation/screens/sitter_settings_screen.dart` (NEW)
- `lib/src/features/sitter/account/sitter_account_screen.dart`

**Implementation Details:**
- New dedicated settings screen for sitters
- Account preferences management
- Notification settings integration

### 7. Sitter Profile Edit Features
**Files Added/Modified:**
- `lib/src/features/sitter/account/presentation/profile_details/presentation/widgets/edit_availability_dialog.dart` (NEW)
- `lib/src/features/sitter/account/presentation/profile_details/presentation/widgets/edit_hourly_rate_dialog.dart` (NEW)
- `lib/src/features/sitter/account/presentation/profile_details/presentation/widgets/edit_skills_certifications_dialog.dart` (NEW)
- `lib/src/features/sitter/account/presentation/profile_details/presentation/widgets/edit_professional_info_dialog.dart`

**Implementation Details:**
- Edit availability schedule dialog
- Hourly rate editing with validation
- Skills and certifications management
- Professional information updates

### 8. Saved Sitters (Bookmarked Sitters)
**Files Added/Modified:**
- `lib/src/features/sitters/presentation/saved/saved_sitters_controller.dart` (NEW)
- `lib/src/features/parent/home/presentation/widgets/saved_sitter_card.dart`
- `lib/src/features/sitters/presentation/saved/saved_sitters_screen.dart`

**Implementation Details:**
- Parents can save/bookmark favorite sitters
- Saved sitters list with quick access
- Remove from saved functionality

### 9. Google Pay Integration
**Files Added/Modified:**
- `lib/src/common_widgets/google_pay_button_widget.dart` (NEW)
- `lib/src/common_widgets/payment_method_selector.dart` (NEW)
- `assets/google_pay_config.json` (NEW)

**Implementation Details:**
- Google Pay button widget for quick payments
- Payment method selector UI component
- Configuration for Google Pay SDK integration

### 10. Background Check Banner & Onboarding
**Files Added/Modified:**
- `assets/images/banner/background_check_required.png` (NEW)
- `assets/images/banner/required_bg_check.png` (NEW)
- `lib/src/features/sitter/home/presentation/widgets/background_check_banner.dart`
- `lib/src/features/sitter/background_check/presentation/screens/background_check_screen.dart`
- `lib/src/features/onboarding/onboarding_screen.dart`

**Implementation Details:**
- Background check requirement banners
- Sitter-specific onboarding slides
- Specialized care information display
- Identity verification flow updates

### 11. Chat & Messaging Improvements
**Files Added/Modified:**
- `lib/src/features/messages/presentation/chat_thread_screen.dart`
- `lib/src/features/messages/presentation/providers/chat_providers.dart`
- `lib/src/features/messages/presentation/widgets/chat_composer_bar.dart`
- `lib/src/features/messages/domain/chat_thread_args.dart` (NEW)
- `packages/data/lib/src/datasources/chat_remote_datasource.dart`
- `packages/data/lib/src/dtos/chat_message_dto.dart` (NEW)
- `packages/data/lib/src/dtos/chat_init_dto.dart` (NEW)

**Implementation Details:**
- Chat composer bar with forced light theme for better visibility
- Chat message DTOs with proper serialization
- Chat initialization handling
- Message bubble UI improvements1234
- Chat thread arguments for navigation

### 12. Location & Map Enhancements
**Files Added/Modified:**
- `lib/src/features/bookings/data/datasources/google_geocoding_remote_datasource.dart` (NEW)
- `lib/src/features/bookings/data/models/booking_location_dto.dart` (NEW)
- `lib/src/features/bookings/domain/booking_location.dart` (NEW)
- `lib/src/features/bookings/presentation/map_route/map_route_screen.dart`
- `lib/src/features/bookings/presentation/providers/booking_location_provider.dart` (NEW)
- `lib/src/features/bookings/presentation/providers/booking_route_stops_provider.dart` (NEW)

**Implementation Details:**
- Google Geocoding API integration for address resolution
- Booking location tracking with coordinates
- Map route display with multiple stops
- Live tracking section updates
- Location provider for real-time updates

### 13. Job Application Flow
**Files Added/Modified:**
- `lib/src/features/sitter/application/presentation/screens/sitter_application_preview_screen.dart`
- `lib/src/features/sitter/jobs/presentation/screens/sitter_application_details_screen.dart`
- `lib/src/features/sitter/jobs/presentation/screens/sitter_job_request_details_screen.dart`
- `lib/src/features/sitter/jobs/data/models/job_request_details_model.dart`

**Implementation Details:**
- Application preview screen with cover letter
- Job request details with full information
- Application status tracking
- Accept/Decline job request functionality

### 14. Parent Profile & Booking Flow Updates
**Files Added/Modified:**
- `lib/src/features/parent/account/profile_details/presentation/profile_details_screen.dart`
- `lib/src/features/parent/booking_flow/presentation/screens/parent_booking_step3_screen.dart`
- `lib/src/features/parent/booking_flow/presentation/screens/service_details_screen.dart`
- `lib/src/features/parent/jobs/post_job/presentation/widgets/job_post_success_dialog.dart`

**Implementation Details:**
- Parent profile editing with emergency contacts
- Insurance plan management
- Booking flow UI improvements
- Job post success dialog updates

---

## 🔧 Improvements & Bug Fixes

### UI/UX Improvements
1. **Button Text Clipping Fixed**
   - Updated `app_tokens.dart` to prevent button text overflow
   - Golden tests updated for verification

2. **Chat Input Visibility**
   - Fixed chat input text visibility in dark mode
   - Chat composer bar now forces light theme

3. **Search Screen UI Updates**
   - Sitter card layout improvements
   - App icon box styling updates
   - Search results screen enhancements

4. **Onboarding Screen Updates**
   - Sitter-specific onboarding content
   - Specialized care slide added
   - Background check information display

5. **OTP Input Improvements**
   - Enhanced OTP input widget styling
   - Better error state handling

### API & Backend Updates
1. **Base URL Updated**
   - Changed from `https://sns-apis.tausifk.com/api` to `https://babysitter-backend.waywisetech.com/api`
   - File: `packages/core/lib/src/constants/constants.dart`

2. **Profile Data Synchronization**
   - Auth profile sync improvements
   - Fallback profile fetch for avatar visibility
   - Real-time profile updates

### Authentication Updates
1. **Sign Up Flow**
   - Step 1 account info validation improvements
   - Sign up flow navigation fixes

2. **Password Management**
   - Forgot password screen API integration
   - Change password functionality
   - Password reset flow improvements

---

## 📦 New Dependencies

```yaml
# Added for Google Pay integration
google_pay: ^latest

# Added for Stripe Connect
flutter_stripe: ^latest

# Added for Google Maps & Geocoding
google_maps_flutter: ^latest
geocoding: ^latest

# Updated existing packages
flutter_riverpod: ^latest
freezed_annotation: ^latest
json_annotation: ^latest
```

---

## 🐛 Known Issues

### Critical Issues
1. **"See All" on Parent Home Not Working**
   - The "See All" button/link on parent home screen is not navigating to the expected screen
   - Status: Under Investigation
   - Priority: High

2. **Tapping on Saved Sitters Not Working**
   - Saved sitters list items are not responding to tap gestures
   - No navigation to sitter profile occurs
   - Status: Under Investigation
   - Priority: High

### Feature Issues
3. **Verify Identity & Background Check Flow Incomplete**
   - Identity verification UI exists but backend integration pending
   - Background check status not properly synced
   - Status: Backend Development Required
   - Priority: Medium

4. **Text Input Field Validation Missing**
   - Form validation not implemented across text input fields
   - Users can submit empty or invalid data
   - Affected areas: Profile setup, booking forms, job posting
   - Status: Pending Implementation
   - Priority: High

5. **Responsiveness Issues Remaining**
   - Some screens not properly responsive on smaller devices
   - UI elements may overlap or cut off on certain screen sizes
   - Affected areas: Booking screens, profile pages
   - Status: In Progress
   - Priority: Medium

### Minor Issues
6. **Parent Avatar Visibility**
   - Parent avatar occasionally not displaying in review screen
   - Fallback profile fetch implemented but needs testing
   - Status: Fix Applied, Testing Required
   - Priority: Low

7. **Build Output Cleanup Cache Locks**
   - Gradle cache lock issues during build (development environment)
   - Status: Development Environment Issue
   - Priority: Low

---

## 📝 Testing Notes

### Golden Tests Added/Updated
- `test/goldens/all_jobs_screen.png`
- `test/goldens/job_details_screen.png`
- `test/goldens/chat_thread_screen.png`

### Unit Tests
- Parsing logic tests for booking data
- Chat message DTO serialization tests

---

## 🚀 Deployment Checklist

- [ ] Update base URL in production environment
- [ ] Configure Stripe Connect production keys
- [ ] Setup Google Pay production configuration
- [ ] Update Google Geocoding API key
- [ ] Test background check flow end-to-end
- [ ] Verify saved sitters functionality
- [ ] Test "See All" navigation on parent home
- [ ] Add form validation to all input fields
- [ ] Run full regression test suite
- [ ] Update app store screenshots
- [ ] Submit for app store review

---

## 📊 Statistics

**Total Commits:** 14  
**Files Modified:** 200+  
**New Files Added:** 60+  
**Features Implemented:** 14  
**Bug Fixes:** 8  
**Known Issues:** 7

---

## 👥 Contributors

- **jubinkhan007** - Lead Developer

---

*This release represents significant progress in the Sitter-side functionality with major features like Job Search, Active Booking Management, Wallet Integration, and Review System. Parent-side improvements include Saved Sitters and Booking Flow enhancements.*

**Next Sprint Focus:**
- Fix known critical issues (See All, Saved Sitters)
- Implement form validation across the app
- Complete Background Check & Identity Verification flow
- Address responsiveness issues
- Performance optimization
