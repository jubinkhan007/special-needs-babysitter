# Release Notes — Special Needs Sitters v1.1.0

**Release Date:** January 27, 2026  
**Version:** 1.1.0  
**Status:** Beta / Production Candidate

## Overview
Special Needs Sitters v1.1.0 introduces significant functional upgrades to the Sitter experience, specifically focusing on the **Active Booking lifecycle** and **Real-Time Messaging**. This release transitions the Messaging feature from a UI prototype to a fully functional system powered by Agora RTM. Additionally, it brings robust location tracking via Google Maps for active shifts, enhanced session management tools (break timers, clock-out logic), and critical UI polish for text visibility and layout stability across devices.

## Key Features

### 💬 Real-Time Messaging (Agora RTM)
*   **Fully Functional Chat:** Messaging is no longer just UI; it is now powered by **Agora RTM**, enabling real-time communication between Parents and Sitters.
*   **Dynamic Thread Updates:** Conversation lists and message threads now update dynamically.
*   **Connection Stability:** Improved connection handling for robust message delivery.

### 📍 Sitter Active Booking Experience
*   **Google Maps Integration:** Active bookings now feature live Google Maps integration for better location context and navigation.
*   **Shift Management:**
    *   **Clock-In/Clock-Out Logic:** Refined logic for starting and ending shifts, including debugging improvements for the clock-in flow.
    *   **Break Timer:** New dialog and timer functionality to track breaks during active sessions.
    *   **Session Tracking:** Enhanced background session management to ensure booking states persist correctly.
*   **Shift Reminders:** Added notifications/reminders for upcoming and active shifts.

### 👤 Sitter Profile & Management
*   **Edit Professional Info:** Sitters can now directly edit their professional information (experience, bio, etc.) from the Profile Details screen.
*   **Job Application Flow:** Updates to the application flow for smoother interaction.
*   **Booking Cancellation:** Implemented a structured flow for sitters to cancel bookings when necessary.

### 🛠️ Bug Fixes & UI Improvements
*   **Chat Visibility:** Fixed a critical issue where input text in the chat composer was invisible (white text on white background).
*   **Button Layouts:** Resolved text clipping issues on primary buttons by adjusting line-height metrics, ensuring labels are fully visible on all devices.
*   **Job Display:** Fixed an issue where child details were appearing empty on the Parent Jobs screen.
*   **Layout Stability:**
    *   Fixed overflow issues in the Booking Flow and Background Banner.
    *   Resolved layout constraints in the Sitter Shell.
    *   Standardized date formats across the app.
*   **Visual Polish:** Swapped booking status colors for better semantic clarity and improved overall navigation flow.
*   **Toast Notifications:** Integrated `AppToast` for consistent in-app feedback (success/error messages).
*   **API Fixes:** Resolved a 400 Error that occurred when declining a job.

## Known Issues
*   Background check status tracking is UI-ready but awaiting full backend synchronization.
