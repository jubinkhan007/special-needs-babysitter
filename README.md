# Special Needs Sitters - Flutter Monorepo

A production-ready Flutter monorepo for a two-sided marketplace connecting parents with babysitters for special needs children.

## 📱 Architecture

**Single app with role-based navigation:**
- Users select their role (Parent/Babysitter) during signup
- Role is **immutable** after signup - cannot be changed
- Routing uses separate shells based on user role

### Key Design Decisions

| Decision | Details |
|----------|---------|
| **Single app** | `apps/babysitter_app/` serves both parents and sitters |
| **Immutable roles** | Selected at signup, stored server-side |
| **Role-based routing** | `/parent/*` and `/sitter/*` shells |
| **Clean Architecture** | Domain is pure Dart, no Flutter dependencies |

## 🗂 Project Structure

```
special-needs-sitters/
├── apps/
│   └── babysitter_app/       # Main Flutter app
├── packages/
│   ├── core/                 # Theme, errors, env config
│   ├── networking/           # Dio client, interceptors
│   ├── domain/               # Entities, repositories (pure Dart)
│   ├── data/                 # DTOs, mappers, implementations
│   ├── ui_kit/               # Shared UI components
│   ├── auth/                 # Session store, auth providers
│   ├── notifications/        # FCM + local notifications
│   └── realtime/             # Agora RTC/RTM wrappers
├── melos.yaml                # Monorepo config
└── pubspec.yaml              # Workspace root
```

## 🚀 Getting Started

### Prerequisites
- Flutter SDK 3.19.0+
- Dart 3.3.0+
- Melos CLI: `dart pub global activate melos`

### Setup
```bash
# Clone and navigate
cd special-needs-sitters

# Install dependencies (each package individually)
for pkg in packages/*/; do cd "$pkg" && flutter pub get && cd -; done
cd apps/babysitter_app && flutter pub get && cd -

# Run code generation (for freezed/json_serializable)
cd packages/data && dart run build_runner build --delete-conflicting-outputs && cd -

# Run the app
cd apps/babysitter_app && flutter run
```

### Environment Variables
Copy `.env.example` to `.env` in the app directory:
```
API_BASE_URL=https://api.example.com
AGORA_APP_ID=your_agora_app_id
AGORA_TOKEN_SERVER_URL=https://tokens.example.com
FIREBASE_PROJECT_ID=your_firebase_project
```

## 🔐 Authentication Flow

1. **Launch** → Splash screen checks auth state
2. **Unauthenticated** → Sign in screen
3. **Sign up** → Role selection (Parent/Sitter) → Account details
4. **Authenticated** → Router redirects to role-specific shell
   - Parent → `/parent/home`
   - Sitter → `/sitter/home`

## 🔧 Melos Commands

```bash
melos run analyze     # Static analysis
melos run test        # Run all tests
melos run format      # Format code
melos run build       # Code generation (build_runner)
melos run clean       # Clean all packages
```

## 📦 Package Dependencies

```
core ← networking ← data ← auth → babysitter_app
     ← domain ←─────────┘
     ← ui_kit ←─────────────────┘
     ← notifications ←──────────┘
     ← realtime ←───────────────┘
```

## ⚠️ Firebase & Agora

Both services are **optional** for development:
- App compiles and runs without Firebase config files
- Agora services throw `ConfigFailure` if App ID is missing
- Notifications fallback to no-op implementation

For production, add:
- `google-services.json` (Android)
- `GoogleService-Info.plist` (iOS)
- Set `AGORA_APP_ID` in `.env`
