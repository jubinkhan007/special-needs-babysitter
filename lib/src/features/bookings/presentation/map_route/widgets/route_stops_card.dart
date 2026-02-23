import 'package:flutter/material.dart';
import 'package:babysitter_app/src/theme/app_tokens.dart';
import 'package:babysitter_app/src/features/bookings/presentation/models/route_stop_ui_model.dart';
import 'route_stop_row.dart';

class RouteStopsCard extends StatelessWidget {
  final List<RouteStopUiModel> stops;

  const RouteStopsCard({
    super.key,
    required this.stops,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppTokens.routeCardBg,
        borderRadius: BorderRadius.circular(AppTokens.routeCardRadius),
        boxShadow: AppTokens.routeCardShadow,
      ),
      padding: const EdgeInsets.all(AppTokens.routeCardPadding),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: stops.map((stop) => RouteStopRow(stop: stop)).toList(),
      ),
    );
  }
}
