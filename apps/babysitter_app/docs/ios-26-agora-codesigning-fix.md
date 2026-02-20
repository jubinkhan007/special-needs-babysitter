# iOS 26: Agora SDK Code Signing Fix

**Date:** 2026-02-20
**Affected:** iOS 26 Simulator (Xcode 26.2+)
**Status:** Resolved

## Problem

The app crashes immediately on launch when running on the **iOS 26 simulator** with the following error:

```
Termination Reason: Namespace DYLD, Code 1, Library missing
Library not loaded: @rpath/AgoraRtmKit.framework/AgoraRtmKit
Reason: code signature in .../Runner.app/Frameworks/AgoraRtmKit.framework/AgoraRtmKit (invalid)
```

The macOS crash dialog shows: **"Runner cannot be opened because of a problem."**

## Root Cause

The Agora SDK pods ship **unsigned framework binaries**. This includes:

- `AgoraRtmKit.framework` (RTM SDK)
- `AgoraRtcKit.framework` (RTC SDK)
- ~50 other Agora extension frameworks (noise suppression, video encoding, etc.)

**iOS 26 introduced stricter code signature enforcement on the simulator.** Previous iOS versions (18 and below) allowed unsigned frameworks to load on the simulator without issue. iOS 26's dynamic linker (`dyld`) now validates code signatures even in the simulator environment and rejects any unsigned binaries at launch time.

The framework files are physically present in `Runner.app/Frameworks/`, but `dyld` reports them as "Library missing" because it refuses to load them due to invalid signatures.

### Verification

You can confirm a framework is unsigned by running:

```bash
codesign -dv "ios/Pods/AgoraRtm_OC_Special/AgoraRtmKit.xcframework/ios-arm64_x86_64-simulator/AgoraRtmKit.framework/AgoraRtmKit"
# Output: "code object is not signed at all"
```

## Solution

Added an **ad-hoc code signing step** in the `Podfile` `post_install` block. This finds all unsigned `.framework` binaries inside the Pods directory and signs them with an ad-hoc signature.

### Code Added to `ios/Podfile`

```ruby
post_install do |installer|
  # ... existing post_install code ...

  # Ad-hoc sign all Agora xcframework binaries so iOS 26 simulator accepts them.
  # iOS 26 enforces code-signature validation even on the simulator; the Agora
  # pods ship unsigned binaries which causes a DYLD "Library missing" crash.
  Dir.glob(File.join(Dir.pwd, 'Pods', '**', '*.xcframework', '**', '*.framework')).each do |fw|
    binary = File.join(fw, File.basename(fw, '.framework'))
    next unless File.exist?(binary)
    sig = `codesign -dv "#{binary}" 2>&1`
    if sig.include?('not signed')
      puts "DEBUG: Ad-hoc signing #{binary}"
      system("codesign --force --sign - --timestamp=none \"#{binary}\"")
    end
  end

  # ... rest of post_install ...
end
```

### How It Works

1. Globs all `.framework` directories nested inside `.xcframework` bundles under `Pods/`
2. For each framework, checks if the binary is unsigned via `codesign -dv`
3. If unsigned, applies an ad-hoc signature (`--sign -`) with no timestamp
4. This runs automatically on every `pod install`

## Scope

### Simulator (Development) - Fix Required

The ad-hoc signing fix is necessary for the iOS 26 simulator. It runs automatically during `pod install`, so no manual steps are needed after the initial Podfile change.

### Real Devices & App Store - No Fix Needed

When building for a real device or App Store submission:

- Xcode's build pipeline automatically re-signs **all** embedded frameworks with your Apple Developer certificate and provisioning profile
- The unsigned Agora binaries get properly signed during the archive/export process
- This is a standard part of the iOS code signing workflow and requires no additional configuration

## Affected Package Versions

| Package | Version | Native SDK |
|---------|---------|-----------|
| `agora_rtc_engine` | 6.5.3 | AgoraRtcEngine_iOS 4.5.2 |
| `agora_rtm` | 2.2.6 | AgoraRtm_OC_Special 2.2.6.2 |

These are the latest available versions as of February 2026. Agora has not yet released updated native SDKs with pre-signed binaries for iOS 26 compatibility.

## Environment

- **Flutter:** 3.41.1 (stable)
- **Xcode:** 26.2 (build 17C52)
- **CocoaPods:** 1.16.2
- **iOS Simulator Runtime:** iOS 26.2 (23C54)
- **macOS:** 26.2 (25C56), Apple M4

## References

- [Flutter UIScene Migration Guide](https://docs.flutter.dev/release/breaking-changes/uiscenedelegate)
- [Xcode 26 Release Notes](https://developer.apple.com/documentation/xcode-release-notes/xcode-26-release-notes)
- [iOS 26 Release Notes](https://developer.apple.com/documentation/ios-ipados-release-notes/ios-ipados-26-release-notes)
- [Xcode 26 Enhanced Security - Guardsquare](https://www.guardsquare.com/blog/xcode-26-enhanced-security-for-ios-apps)
