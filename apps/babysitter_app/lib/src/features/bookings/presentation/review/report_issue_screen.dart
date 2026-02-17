import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../theme/app_tokens.dart';
import '../../domain/review/report_issue_args.dart';
import '../widgets/booking_details_app_bar.dart';
import 'widgets/bottom_primary_bar.dart';
import 'widgets/form_text_area.dart';
import 'widgets/issue_type_dropdown.dart';
import 'widgets/upload_tile.dart';

class ReportIssueScreen extends StatefulWidget {
  final ReportIssueArgs args;

  const ReportIssueScreen({super.key, required this.args});

  @override
  State<ReportIssueScreen> createState() => _ReportIssueScreenState();
}

class _ReportIssueScreenState extends State<ReportIssueScreen> {
  String? _issueType;
  late final TextEditingController _descriptionController;

  static const _issueTypes = [
    'Late Arrival',
    'No Show',
    'Unprofessional Behavior',
    'Property Damage',
    'Other',
  ];

  @override
  void initState() {
    super.initState();
    _descriptionController = TextEditingController();
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context)
          .copyWith(textScaler: const TextScaler.linear(1)),
      child: Scaffold(
        backgroundColor: AppTokens.bg,
        appBar: const BookingDetailsAppBar(
          title: 'Report An Issue',
        ),
        bottomNavigationBar: BottomPrimaryBar(
          label: 'Submit For Review',
          onTap: () {
            if (_issueType != null && _descriptionController.text.isNotEmpty) {
              context.pop();
            }
          },
        ),
        body: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            // 1. Title Header
            const SliverPadding(
              padding: EdgeInsets.fromLTRB(
                  AppTokens.screenHorizontalPadding,
                  24,
                  AppTokens.screenHorizontalPadding,
                  8),
              sliver: SliverToBoxAdapter(
                child: Text(
                  'Report An Issue',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: AppTokens.textPrimary,
                  ),
                ),
              ),
            ),

            // 2. Subtitle
            SliverPadding(
              padding: const EdgeInsets.symmetric(
                  horizontal: AppTokens.screenHorizontalPadding),
              sliver: SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 24),
                  child: Text(
                    'Details of the Complaint:',
                    style: AppTokens.subLabelStyle,
                  ),
                ),
              ),
            ),

            // 3. Dropdown
            SliverPadding(
              padding: const EdgeInsets.symmetric(
                  horizontal: AppTokens.screenHorizontalPadding),
              sliver: SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: IssueTypeDropdown(
                    value: _issueType,
                    items: _issueTypes,
                    onChanged: (val) {
                      setState(() {
                        _issueType = val;
                      });
                    },
                  ),
                ),
              ),
            ),

            // 4. Description Area
            SliverPadding(
              padding: const EdgeInsets.symmetric(
                  horizontal: AppTokens.screenHorizontalPadding),
              sliver: SliverToBoxAdapter(
                child: FormTextArea(
                  controller: _descriptionController,
                  hintText: 'Describe The Issue......',
                  maxLines: 8,
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
                    onTap: () {},
                  ),
                ),
              ),
            ),

            // 6. Disclaimer Text
            SliverPadding(
              padding: const EdgeInsets.symmetric(
                  horizontal: AppTokens.screenHorizontalPadding),
              sliver: SliverToBoxAdapter(
                child: Text(
                  'Our team reviews major issues and resolves disputes within 24-48 hours. Payments won’t be delayed for minor discrepancies.',
                  style: AppTokens.helperTextStyle,
                ),
              ),
            ),

            // Bottom Spacer
            const SliverPadding(padding: EdgeInsets.only(bottom: 32)),
          ],
        ),
      ),
    );
  }
}
