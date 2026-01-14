import 'package:flutter/material.dart';
// import '../../../../../theme/app_tokens.dart';

class MapBackground extends StatelessWidget {
  const MapBackground({super.key});

  @override
  Widget build(BuildContext context) {
    // Placeholder map background color matching the "grey" areas in map
    // In real implementation, this would be an image asset or GoogleMap
    return Container(
      color: const Color(0xFFE0E0E0), // Placeholder grey
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.map_outlined, size: 64, color: Colors.white),
            const SizedBox(height: 16),
            Text(
              'Map View',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
