import 'dart:developer' as developer;

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:core/core.dart';
import 'package:notifications/notifications.dart';

import 'package:flutter_stripe/flutter_stripe.dart';

import 'app.dart';

/// Top-level background message handler (required by Firebase)
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // Ensure Firebase is initialized for background handling
  try {
    await Firebase.initializeApp();
  } catch (_) {}

  developer.log(
    'Background message: ${message.notification?.title}',
    name: 'Notifications',
  );
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load environment configuration
  await EnvConfig.tryLoad();

  // Initialize Stripe
  Stripe.publishableKey =
      'pk_test_51SpPCQA94FXRonexZprCttmNtDC5z91d57n5MVW1r8TjGPApriYe9FTiZXbYOx9TVytNLchLwsAUvfJvuXzDBzmf00LJxEXg8h';
  await Stripe.instance.applySettings();

  // Initialize Firebase with try/catch for missing config
  bool firebaseReady = false;
  try {
    await Firebase.initializeApp();
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
    firebaseReady = true;
    developer.log('Firebase initialized successfully', name: 'App');
  } catch (e) {
    developer.log(
      'Firebase initialization failed (config may be missing): $e',
      name: 'App',
    );
    // Continue without Firebase - app will use no-op notifications
  }

  runApp(
    ProviderScope(
      overrides: [
        // Set Firebase ready state based on initialization result
        firebaseReadyProvider.overrideWith((ref) => firebaseReady),
      ],
      child: const BabysitterApp(),
    ),
  );
}
