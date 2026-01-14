import 'package:flutter/material.dart';
import '../../../../theme/app_tokens.dart';
import '../models/route_stop_ui_model.dart';
import 'widgets/map_background.dart';
import 'widgets/map_route_app_bar.dart';
import 'widgets/route_stops_card.dart';

class MapRouteScreen extends StatelessWidget {
  final String bookingId;

  const MapRouteScreen({
    super.key,
    required this.bookingId,
  });

  @override
  Widget build(BuildContext context) {
    // MOCK DATA
    const stops = [
      RouteStopUiModel(
        addressLine: '25 Connell Dr, New York, NY 05622',
        timeLabel: '9:41 AM',
        isActive: true,
      ),
      RouteStopUiModel(
        addressLine: '25 Connell Dr, New York, NY 05622',
        timeLabel: '9:41 AM',
        isActive: false,
      ),
      RouteStopUiModel(
        addressLine: '25 Connell Dr, New York, NY 05622',
        timeLabel: '9:41 AM',
        isActive: false,
      ),
      RouteStopUiModel(
        addressLine: '25 Connell Dr, New York, NY 05622',
        timeLabel: '9:41 AM',
        isActive: false,
        isLast: true,
      ),
    ];

    return MediaQuery(
      data: MediaQuery.of(context)
          .copyWith(textScaler: const TextScaler.linear(1.0)),
      child: Scaffold(
        backgroundColor: AppTokens.surfaceWhite,
        body: Stack(
          children: [
            // 1. Map Background (Full Screen)
            const Positioned.fill(
              child: MapBackground(),
            ),

            // 2. App Bar Overlay (Top)
            const Align(
              alignment: Alignment.topCenter,
              child: MapRouteAppBar(),
            ),

            // 3. Bottom Route Card Overlay
            Positioned(
              left: AppTokens.routeCardMarginHorizontal,
              right: AppTokens.routeCardMarginHorizontal,
              bottom:
                  AppTokens.routeCardBottomInset, // Lifted above bottom edge
              child: SafeArea(
                top: false, // Don't care about top safe area here
                child: RouteStopsCard(stops: stops),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
