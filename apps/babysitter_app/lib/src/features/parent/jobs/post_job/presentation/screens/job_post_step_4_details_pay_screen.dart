import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/job_post_providers.dart';
import '../controllers/job_post_controller.dart';
import 'job_post_step_header.dart';

/// Job Post Step 4: Additional Details & Pay Rate
/// Pixel-perfect implementation matching Figma design
class JobPostStep4DetailsPayScreen extends ConsumerStatefulWidget {
  final VoidCallback onComplete;
  final VoidCallback onBack;

  const JobPostStep4DetailsPayScreen({
    super.key,
    required this.onComplete,
    required this.onBack,
  });

  @override
  ConsumerState<JobPostStep4DetailsPayScreen> createState() =>
      _JobPostStep4DetailsPayScreenState();
}

class _JobPostStep4DetailsPayScreenState
    extends ConsumerState<JobPostStep4DetailsPayScreen> {
  // Controllers
  final TextEditingController _additionalDetailsController =
      TextEditingController();

  // Pay Rate Value
  double _payRate = 15.00;
  
  // Validation constants
  static const double _minPayRate = 5.0;
  static const double _maxPayRate = 99.0;
  static const double _payRateIncrement = 0.50;

  @override
  void initState() {
    super.initState();
    final state = ref.read(jobPostControllerProvider);
    _additionalDetailsController.text = state.additionalDetails;
    if (state.payRate > 0) {
      _payRate = state.payRate.clamp(_minPayRate, _maxPayRate);
    }
  }

  // Design Constants
  static const _bgColor = AppColors.surfaceTint; // Light sky background
  static const _titleColor = Color(0xFF0B1736); // Deep navy
  static const _mutedText = Color(0xFF7C8A9A); // Grey
  static const _borderColor = Color(0xFFBFE3F7); // Light blue border

  static const _progressFill = Color(0xFF7FC9EE); // Active progress
  static const _primaryBtn = AppColors.primary; // Continue button
  static const _iconBoxFill = Color(0xFFD7F0FF); // Icon box fill
  static const _iconBlue = Color(0xFF74BFEA); // Icon color

  @override
  void dispose() {
    _additionalDetailsController.dispose();
    super.dispose();
  }

  void _incrementPay() {
    setState(() {
      _payRate = (_payRate + _payRateIncrement).clamp(_minPayRate, _maxPayRate);
    });
  }

  void _decrementPay() {
    setState(() {
      _payRate = (_payRate - _payRateIncrement).clamp(_minPayRate, _maxPayRate);
    });
  }
  
  bool get _isPayRateValid => _payRate >= _minPayRate && _payRate <= _maxPayRate;
  
  String? get _payRateError {
    if (_payRate < _minPayRate) {
      return 'Pay rate must be at least \$${_minPayRate.toStringAsFixed(2)}';
    }
    if (_payRate > _maxPayRate) {
      return 'Pay rate cannot exceed \$${_maxPayRate.toStringAsFixed(2)}';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<JobPostState>(jobPostControllerProvider, (previous, next) {
      if (previous?.additionalDetails != next.additionalDetails) {
        _additionalDetailsController.text = next.additionalDetails;
      }
      if (previous?.payRate != next.payRate) {
        setState(() {
          _payRate = next.payRate;
        });
      }
    });

    return Scaffold(
      backgroundColor: _bgColor,
      body: SafeArea(
        child: Column(
          children: [
            // Top Bar
            // Step 4 of 5
            JobPostStepHeader(
              activeStep: 4,
              totalSteps: 5,
              onBack: widget.onBack,
            ),

            // Main Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 24),

                    // Icon Tile
                    _buildIconTile(),

                    const SizedBox(height: 20),

                    // Title
                    const Text(
                      'Additional Details & Pay Rate',
                      style: TextStyle(
                        fontSize:
                            28, // ~30-34 in strict design, but keeping scale consistent with prev steps
                        fontWeight: FontWeight.w800, // ExtraBold
                        color: _titleColor,
                        letterSpacing: -0.5,
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Additional Details (Text Area)
                    _buildAdditionalDetailsField(),

                    const SizedBox(height: 20),

                    // Pay Rate Field
                    _buildPayRateField(),

                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),

            // Bottom Bar
            _buildBottomBar(),
          ],
        ),
      ),
    );
  }

  Widget _buildIconTile() {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        color: _iconBoxFill,
        borderRadius: BorderRadius.circular(24),
      ),
      child: const Center(
        child: Icon(
          Icons.attach_money_rounded,
          size: 52,
          color: _iconBlue,
        ),
      ),
    );
  }

  Widget _buildAdditionalDetailsField() {
    return Container(
      height: 200, // ~180-220
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _borderColor, width: 1.5),
      ),
      child: TextField(
        controller: _additionalDetailsController,
        maxLines: null,
        expands: true,
        textAlignVertical: TextAlignVertical.top,
        cursorColor: _progressFill,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: _titleColor,
        ),
        decoration: InputDecoration(
          hintText: 'Additional Details*',
          hintStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: _mutedText,
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.all(20),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  Widget _buildPayRateField() {
    final error = _payRateError;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 70, // ~68-72
          padding: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: error != null ? AppColors.error : _borderColor,
              width: 1.5,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '\$${_payRate.toStringAsFixed(2)}/hr',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: error != null ? AppColors.error : _titleColor,
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: _incrementPay,
                    child: const Icon(
                      Icons.keyboard_arrow_up_rounded,
                      color: _mutedText,
                      size: 24,
                    ),
                  ),
                  GestureDetector(
                    onTap: _decrementPay,
                    child: const Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: _mutedText,
                      size: 24,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        if (error != null)
          Padding(
            padding: const EdgeInsets.only(left: 16, top: 8),
            child: Text(
              error,
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.error,
              ),
            ),
          )
        else
          const Padding(
            padding: EdgeInsets.only(left: 16, top: 8),
            child: Text(
              'Pay rate must be between \$5.00 and \$99.00',
              style: TextStyle(
                fontSize: 12,
                color: _mutedText,
              ),
            ),
          ),
      ],
    );
  }

  void _onContinue() {
    // Validate additional details
    if (_additionalDetailsController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter additional details'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }
    
    // Validate pay rate
    if (!_isPayRateValid) {
      final error = _payRateError;
      if (error != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(error),
            backgroundColor: AppColors.error,
          ),
        );
      }
      return;
    }
    
    ref.read(jobPostControllerProvider.notifier).updateAdditionalDetails(
          _additionalDetailsController.text.trim(),
        );
    ref.read(jobPostControllerProvider.notifier).updatePayRate(_payRate);
    widget.onComplete();
  }

  Widget _buildBottomBar() {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 10, 24, 18),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Previous Button
          TextButton(
            onPressed: widget.onBack,
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: const Text(
              'Previous',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFF667085), // Grey
              ),
            ),
          ),

          // Continue Button
          GestureDetector(
            onTap: _onContinue,
            child: Container(
              width: 200, // ~190-220
              height: 60, // ~60-66
              decoration: BoxDecoration(
                color: _primaryBtn,
                borderRadius: BorderRadius.circular(15), // ~14-16
              ),
              child: const Center(
                child: Text(
                  'Continue',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
