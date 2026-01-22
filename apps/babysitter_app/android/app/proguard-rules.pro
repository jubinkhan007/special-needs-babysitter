# Flutter Wrapper
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }

# Google Play Core
-keep class com.google.android.play.core.** { *; }
-keep interface com.google.android.play.core.** { *; }

# Stripe SDK
-keep class com.stripe.android.** { *; }
-keep interface com.stripe.android.** { *; }
-keep class com.stripe.android.pushProvisioning.** { *; }

# Flutter Stripe (uses reactnativestripesdk namespace internally in some versions)
-keep class com.reactnativestripesdk.** { *; }

# Prevent warning spam
-dontwarn com.stripe.android.**
-dontwarn com.google.android.play.core.**
