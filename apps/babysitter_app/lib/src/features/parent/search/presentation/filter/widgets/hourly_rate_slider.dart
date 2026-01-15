import 'package:flutter/material.dart';
import '../../../../../../theme/app_tokens.dart';

class HourlyRateSlider extends StatelessWidget {
  final double value;
  final ValueChanged<double> onChanged;

  const HourlyRateSlider({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Slider with custom track/tick look
        // Standard slider is hard to customize exactly like Figma (ticks on track).
        // Uses simple slider for valid MVP or custom painter if needed.
        // Figma screenshot shows ticks at intervals.
        // Let's use Slider with divisions to get "ticks" behavior, but standard material ticks are small dots.
        // Figma has pill above thumb. Standard slider has label.
        // We'll stack it. or use Flutter Slider label property? Flutter Slider label is a bubble.
        // Figma pill is fixed/styled nicely.
        // Let's use a Stack or Column. Here we put Pill then Slider.

        // Pill Positioned - challenging to sync perfectly without layout builder.
        // Simple Vertical Layout: Pill centered (or dynamically offset based on value), then Slider.
        // Figma has pill "floating" above current value.

        // For MVP speed + pixel aesthetic, a clean Column is robust.
        // Dynamic alignment:
        Align(
          alignment: Alignment(
              // Map 0..100 to -1.0..1.0
              (value - 50) / 50,
              0.0),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: AppTokens.sliderValuePillBg,
              borderRadius:
                  BorderRadius.circular(AppTokens.sliderValuePillRadius),
            ),
            child: Text(
              '\$${value.round()}/hr',
              style: AppTokens.sheetSliderPillTextStyle,
            ),
          ),
        ),

        SizedBox(height: 4),

        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: AppTokens.sliderTrackActive,
            inactiveTrackColor: AppTokens.sliderTrackInactive,
            thumbColor: AppTokens.sliderThumbColor,
            overlayColor: AppTokens.sliderThumbColor.withOpacity(0.12),
            trackHeight: AppTokens.sliderTrackHeight,
            thumbShape: RoundSliderThumbShape(
                enabledThumbRadius: AppTokens.sliderThumbRadius),
            tickMarkShape:
                RoundSliderTickMarkShape(tickMarkRadius: 2), // Small dots
            activeTickMarkColor:
                Colors.white.withOpacity(0.5), // Subtle ticks on blue
            inactiveTickMarkColor:
                AppTokens.sliderTrackInactive, // Invisible or matched
          ),
          child: Slider(
            value: value,
            min: 0,
            max: 100,
            divisions: 10, // 0, 10, 20...
            onChanged: onChanged,
          ),
        ),

        // Labels
        Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: 10), // align with slider track ends roughly
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(
              11, // 0 to 100 step 10 = 11 items
              (index) {
                final val = index * 10;
                // Show only some labels or all? Figma screenshot shows 0, 10, 20...
                // At strict spacing 11 items might be crowded on small screens.
                // Screenshot shows 0 10 20 30 40 50 60 70 80 90 100.
                return Text(
                  val.toString(),
                  style: AppTokens.sheetSliderLabelStyle,
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
