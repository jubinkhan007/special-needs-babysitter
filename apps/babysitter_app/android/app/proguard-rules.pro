# Stripe SDK Proguard Rules
-keep class com.stripe.android.** { *; }
-keep interface com.stripe.android.** { *; }

# Push Provisioning specific rules (as per error message)
-keep class com.stripe.android.pushProvisioning.** { *; }

# Keep Stripe-specific assets and resources
-keep class com.stripe.android.databinding.** { *; }
-keep class com.stripe.android.view.** { *; }

# Common Flutter rules (just in case)
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }
