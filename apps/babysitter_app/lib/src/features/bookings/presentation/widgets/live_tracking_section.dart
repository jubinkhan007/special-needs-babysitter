import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../routing/routes.dart';
import '../../../../theme/app_tokens.dart';

class LiveTrackingSection extends StatelessWidget {
  const LiveTrackingSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header Row
        Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Live Tracking',
                style: AppTokens.activeSectionTitle,
              ),
              GestureDetector(
                onTap: () {
                  context.push(Routes.mapRoute,
                      extra: 'booking-id-placeholder');
                },
                child: Text(
                  'Open in Maps',
                  style: AppTokens.linkTextStyle,
                ),
              ),
            ],
          ),
        ),

        // Map Card
        Container(
          height: AppTokens.mapHeight,
          decoration: BoxDecoration(
            color: AppTokens.mapCardBg,
            borderRadius: BorderRadius.circular(AppTokens.mapCardRadius),
            boxShadow: AppTokens.cardShadow,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(AppTokens.mapCardRadius),
            child: Stack(
              fit: StackFit.expand,
              children: [
                // Placeholder Map Background
                Container(
                  color: const Color(0xFFE5E5E5), // Placeholder grey
                  // In real app, GoogleMap widget goes here
                  child: Center(
                    child: Icon(Icons.map, size: 48, color: Colors.grey[400]),
                  ),
                ),

                // TODO: Replace with actual map widget or asset image as requested
                // For now, using a Container representation.
              ],
            ),
          ),
        ),
      ],
    );
  }
}
