import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../routing/routes.dart';
import '../../../../theme/app_tokens.dart';
import '../../domain/review/report_issue_args.dart';
import '../../domain/review/review_args.dart';
import '../widgets/booking_details_app_bar.dart';
import 'widgets/bottom_action_bar.dart';
import 'widgets/form_text_area.dart';
import 'widgets/review_header_card.dart';
import 'widgets/star_rating_row.dart';
import 'widgets/upload_tile.dart';

class ReviewScreen extends StatefulWidget {
  final ReviewArgs args;

  const ReviewScreen({super.key, required this.args});

  @override
  State<ReviewScreen> createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  int _rating = 0;
  late final TextEditingController _notesController;

  @override
  void initState() {
    super.initState();
    _notesController = TextEditingController();
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context)
          .copyWith(textScaler: const TextScaler.linear(1)),
      child: Scaffold(
        backgroundColor: AppTokens.bg,
        appBar: BookingDetailsAppBar(
          title: 'Review ${widget.args.sitterName}',
        ),
        bottomNavigationBar: BottomActionBar(
          onReportTap: () {
            context.push(
              Routes.reportIssue,
              extra: ReportIssueArgs(
                bookingId: widget.args.bookingId,
                sitterId: widget.args.sitterId,
              ),
            );
          },
          onSkipTap: () {
            context.pop();
          },
          onSubmitTap: () {
            context.pop();
            // Show Success?
          },
        ),
        body: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            // 1. Header Card
            SliverPadding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppTokens.screenHorizontalPadding,
                vertical: 24,
              ),
              sliver: SliverToBoxAdapter(
                child: ReviewHeaderCard(uiModel: widget.args.sitterData),
              ),
            ),

            // 2. "How Was Your Experience?"
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.only(bottom: 24),
                child: Center(
                  child: Text(
                    'How Was Your Experience?',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: AppTokens.textPrimary,
                    ),
                  ),
                ),
              ),
            ),

            // 3. Stars
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 32),
                child: StarRatingRow(
                  rating: _rating,
                  onRatingChanged: (val) {
                    setState(() {
                      _rating = val;
                    });
                  },
                ),
              ),
            ),

            // 4. Note Area
            SliverPadding(
              padding: const EdgeInsets.symmetric(
                  horizontal: AppTokens.screenHorizontalPadding),
              sliver: SliverToBoxAdapter(
                child: FormTextArea(
                  controller: _notesController,
                  hintText: 'Additional Notes...',
                ),
              ),
            ),

            // 5. Upload Tile
            SliverPadding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppTokens.screenHorizontalPadding,
                vertical: 24,
              ),
              sliver: SliverToBoxAdapter(
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: UploadTile(
                    onTap: () {
                      // Upload logic
                    },
                  ),
                ),
              ),
            ),

            // Bottom Padding for scroll
            const SliverPadding(padding: EdgeInsets.only(bottom: 24)),
          ],
        ),
      ),
    );
  }
}
