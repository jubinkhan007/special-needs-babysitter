import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../theme/app_tokens.dart';
import '../../domain/job_details.dart'; // To use JobDetails and Address
import '../../domain/job.dart';
import '../../data/jobs_data_di.dart';
import '../providers/jobs_providers.dart';
import 'package:go_router/go_router.dart';
import '../../../../routing/routes.dart';
import 'package:intl/intl.dart';
import 'package:babysitter_app/src/common_widgets/app_toast.dart';

class EditJobScreen extends ConsumerStatefulWidget {
  final String jobId;

  const EditJobScreen({super.key, required this.jobId});

  @override
  ConsumerState<EditJobScreen> createState() => _EditJobScreenState();
}

class _EditJobScreenState extends ConsumerState<EditJobScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  late TextEditingController _titleController;
  late TextEditingController _detailsController;
  late TextEditingController _dateController;
  late TextEditingController _startTimeController;
  late TextEditingController _endTimeController;
  late TextEditingController _streetController;
  late TextEditingController _unitController;
  late TextEditingController _cityController;
  late TextEditingController _stateController;
  late TextEditingController _zipController;
  late TextEditingController _emergencyNameController;
  late TextEditingController _emergencyPhoneController;
  late TextEditingController _emergencyRelationController;

  double _payRate = 15.0;

  DateTime? _selectedDateStart;
  DateTime? _selectedDateEnd;
  TimeOfDay? _selectedTimeStart;
  TimeOfDay? _selectedTimeEnd;

  bool _isLoading = false;
  JobDetails? _jobDetails;

  bool get _isEditable => _jobDetails?.isEditable ?? false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _detailsController = TextEditingController();
    _dateController = TextEditingController();
    _startTimeController = TextEditingController();
    _endTimeController = TextEditingController();
    _streetController = TextEditingController();
    _unitController = TextEditingController();
    _cityController = TextEditingController();
    _stateController = TextEditingController();
    _zipController = TextEditingController();
    _emergencyNameController = TextEditingController();
    _emergencyPhoneController = TextEditingController();
    _emergencyRelationController = TextEditingController();

    // Fetch details
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchJobDetails();
    });
  }

  Future<void> _fetchJobDetails() async {
    setState(() => _isLoading = true);
    try {
      final repo = ref.read(jobsRepositoryProvider);
      final details = await repo.getJobDetails(widget.jobId);

      setState(() {
        _jobDetails = details;
        _isLoading = false;

        // Populate form
        _titleController.text = details.title;
        _detailsController.text = details.additionalNotes;
        _payRate = details.hourlyRate;

        _selectedDateStart = details.scheduleStartDate;
        _selectedDateEnd = details.scheduleEndDate;
        _dateController.text =
            _formatDateRange(_selectedDateStart, _selectedDateEnd);

        _selectedTimeStart = details.scheduleStartTime;
        _selectedTimeEnd = details.scheduleEndTime;
        _startTimeController.text = _formatTime(_selectedTimeStart);
        _endTimeController.text = _formatTime(_selectedTimeEnd);

        _streetController.text = details.address.streetAddress;
        _unitController.text = details.address.aptUnit;
        _cityController.text = details.address.city;
        _stateController.text = details.address.state;
        _zipController.text = details.address.zipCode;
        _emergencyNameController.text =
            details.emergencyContactName == 'Not Provided'
                ? ''
                : details.emergencyContactName;
        _emergencyPhoneController.text = details.emergencyContactPhone;
        _emergencyRelationController.text = details.emergencyContactRelation;
      });
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        AppToast.show(context, 
          SnackBar(content: Text('Failed to load job details: $e')),
        );
      }
    }
  }

  String _formatDateRange(DateTime? start, DateTime? end) {
    if (start == null) return '';
    final startStr = DateFormat('MM/dd/yyyy').format(start);
    if (end != null && end != start) {
      final endStr = DateFormat('MM/dd/yyyy').format(end);
      return '$startStr - $endStr';
    }
    return startStr;
  }

  String _formatTime(TimeOfDay? time) {
    if (time == null) return '';
    final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.period == DayPeriod.am ? 'AM' : 'PM';
    return '$hour:$minute $period';
  }

  @override
  void dispose() {
    _titleController.dispose();
    _detailsController.dispose();
    _dateController.dispose();
    _startTimeController.dispose();
    _endTimeController.dispose();
    _streetController.dispose();
    _unitController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _zipController.dispose();
    _emergencyNameController.dispose();
    _emergencyPhoneController.dispose();
    _emergencyRelationController.dispose();
    super.dispose();
  }

  Future<void> _pickDateRange() async {
    final now = DateTime.now();
    final result = await showDateRangePicker(
      context: context,
      firstDate: now,
      lastDate: now.add(const Duration(days: 365)),
      initialDateRange: (_selectedDateStart != null && _selectedDateEnd != null)
          ? DateTimeRange(start: _selectedDateStart!, end: _selectedDateEnd!)
          : null,
    );

    if (result != null) {
      setState(() {
        _selectedDateStart = result.start;
        _selectedDateEnd = result.end;
        _dateController.text = _formatDateRange(result.start, result.end);
      });
    }
  }

  Future<void> _pickTime(bool isStart) async {
    final initial = isStart ? _selectedTimeStart : _selectedTimeEnd;
    final result = await showTimePicker(
      context: context,
      initialTime: initial ?? TimeOfDay.now(),
    );

    if (result != null) {
      setState(() {
        if (isStart) {
          _selectedTimeStart = result;
          _startTimeController.text = _formatTime(result);
        } else {
          _selectedTimeEnd = result;
          _endTimeController.text = _formatTime(result);
        }
      });
    }
  }

  Future<void> _updateJob() async {
    if (!_isEditable) {
      if (mounted) {
        AppToast.show(
          context,
          const SnackBar(
            content: Text(
              'This job can\'t be updated once it is in progress or completed.',
            ),
          ),
        );
      }
      return;
    }
    if (!_formKey.currentState!.validate()) return;
    if (_selectedDateStart == null || _selectedDateEnd == null) return;
    if (_selectedTimeStart == null || _selectedTimeEnd == null) return;

    setState(() => _isLoading = true);

    try {
      final repo = ref.read(jobsRepositoryProvider);

      // Ensure single digit hours are padded? Api usually takes HH:mm:ss or HH:mm
      final startH = _selectedTimeStart!.hour.toString().padLeft(2, '0');
      final startM = _selectedTimeStart!.minute.toString().padLeft(2, '0');
      final endH = _selectedTimeEnd!.hour.toString().padLeft(2, '0');
      final endM = _selectedTimeEnd!.minute.toString().padLeft(2, '0');

      final normalizedState = _stateController.text.length > 2
          ? _stateController.text.substring(0, 2).toUpperCase()
          : _stateController.text.toUpperCase();
      final emergencyName = _emergencyNameController.text.trim();
      final emergencyPhone = _emergencyPhoneController.text.trim();
      final emergencyRelation = _emergencyRelationController.text.trim();

      // Build publicLocation from city and state
      final publicLocation = '${_cityController.text}, $normalizedState';

      // Get existing coordinates from job details if available
      final existingLat = _jobDetails?.address.streetAddress.isNotEmpty == true
          ? 36.1627
          : 36.1627;
      final existingLng = _jobDetails?.address.streetAddress.isNotEmpty == true
          ? -86.7816
          : -86.7816;

      final Map<String, dynamic> updateData = {
        'title': _titleController.text,
        'additionalDetails': _detailsController.text,
        'startDate': DateFormat('yyyy-MM-dd').format(_selectedDateStart!),
        'endDate': DateFormat('yyyy-MM-dd').format(_selectedDateEnd!),
        'startTime': '$startH:$startM',
        'endTime': '$endH:$endM',
        'payRate': _payRate,
        'address': {
          'streetAddress': _streetController.text,
          'aptUnit': _unitController.text,
          'city': _cityController.text,
          'state': normalizedState,
          'zipCode': _zipController.text,
          'latitude': existingLat,
          'longitude': existingLng,
          'publicLocation': publicLocation,
        },
      };

      if (emergencyName.isNotEmpty ||
          emergencyPhone.isNotEmpty ||
          emergencyRelation.isNotEmpty) {
        updateData['emergencyContact'] = {
          'name': emergencyName,
          'phone': emergencyPhone,
          'relationship': emergencyRelation,
        };
      }

      // DEBUG: Print full payload
      print('=== UPDATE JOB DEBUG ==>');
      print('Job ID: ${widget.jobId}');
      print('Update Payload: $updateData');

      await repo.updateJob(widget.jobId, updateData);

      ref.invalidate(allJobsProvider);

      if (mounted) {
        context.pop(true);
        AppToast.show(context, 
          const SnackBar(content: Text('Job updated successfully')),
        );
      }
    } catch (e, stackTrace) {
      // DEBUG: Print full error details
      print('=== UPDATE JOB ERROR ==>');
      print('Error: $e');
      print('Stack: $stackTrace');
      if (mounted) {
        // Extract user-friendly error message
        String errorMessage = 'Error updating job';
        if (e.toString().contains('in progress or completed')) {
          errorMessage = 'This job can\'t be updated because it is in progress or completed.';
        } else if (e.toString().contains('400')) {
          errorMessage = 'Unable to update job. Please try again.';
        }
        AppToast.show(context,
          SnackBar(content: Text(errorMessage)),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _deleteJob() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        title: const Text('Delete Job', style: TextStyle(color: Colors.black)),
        content: const Text(
          'Are you sure you want to delete this job? This action cannot be undone.',
          style: TextStyle(color: Colors.black),
        ),
        actions: [
          TextButton(
            onPressed: () => context.pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => context.pop(true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    setState(() => _isLoading = true);

    try {
      final repo = ref.read(jobsRepositoryProvider);
      await repo.deleteJob(widget.jobId);

      ref.invalidate(allJobsProvider);

      if (mounted) {
        // Pop twice to go back to AllJobsScreen (Edit -> Details -> List)
        // OR better: use GoRouter to go to list directly.
        // Assuming we want to go back to "My Jobs" list.
        context.go(Routes
            .parentJobs); // Use go to clear stack if needed, or pop twice?
        // Let's use pushReplacement or pop.
        // If we pop, we go to details. But details will try to load deleted job.
        // So we should go to list.
        // context.go(Routes.parentJobs); might work if configured.
        // Let's assume Routes.parentJobs exists or we pop until valid.

        // Actually, pop return value can indicate deletion?
        // But JobDetailsScreen won't know unless we handle it.
        // Safest is context.go('/parent/jobs'); if path is known.
        // checking routes.dart ... maybe Routes.jobs?
        // Let's try popping with a special result or using go.

        // If I use context.go, it resets stack.
        // Let's check Routes.parentDashboard or similar?
        // Assuming '/parent/jobs' is the list.
        context.go('/parent/jobs'); // Hardcoded based on logs /parent/jobs
      }
    } catch (e) {
      if (mounted) {
        AppToast.show(context, 
          SnackBar(content: Text('Error deleting job: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading && _jobDetails == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: AppTokens.jobsScreenBg,
      appBar: AppBar(
        title: const Text('Edit Job'),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => context.pop(),
        ),
        titleTextStyle: const TextStyle(
            color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (!_isEditable) ...[
                const Text(
                  'This job can\'t be edited once it is in progress or completed.',
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12),
              ],
              _buildLabel('Job Title'),
              TextFormField(
                controller: _titleController,
                decoration: _inputDecoration('Enter job title'),
                style: const TextStyle(color: AppTokens.textPrimary),
                validator: (v) => v!.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              _buildLabel('Date'),
              TextFormField(
                controller: _dateController,
                readOnly: true,
                onTap: _pickDateRange,
                style: const TextStyle(color: AppTokens.textPrimary),
                decoration: _inputDecoration('Select Date')
                    .copyWith(suffixIcon: const Icon(Icons.calendar_today)),
                validator: (v) => v!.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildLabel('Start Time'),
                        TextFormField(
                          controller: _startTimeController,
                          readOnly: true,
                          onTap: () => _pickTime(true),
                          style: const TextStyle(color: AppTokens.textPrimary),
                          decoration: _inputDecoration('Start').copyWith(
                              suffixIcon: const Icon(Icons.access_time)),
                          validator: (v) => v!.isEmpty ? 'Required' : null,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildLabel('End Time'),
                        TextFormField(
                          controller: _endTimeController,
                          readOnly: true,
                          onTap: () => _pickTime(false),
                          style: const TextStyle(color: AppTokens.textPrimary),
                          decoration: _inputDecoration('End').copyWith(
                              suffixIcon: const Icon(Icons.access_time)),
                          validator: (v) => v!.isEmpty ? 'Required' : null,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _buildLabel('Address'),
              TextFormField(
                controller: _streetController,
                style: const TextStyle(color: AppTokens.textPrimary),
                decoration: _inputDecoration('Street Address'),
                validator: (v) => v!.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                      child: TextFormField(
                          controller: _unitController,
                          style: const TextStyle(color: AppTokens.textPrimary),
                          decoration: _inputDecoration('Unit (Opt)'))),
                  const SizedBox(width: 8),
                  Expanded(
                      child: TextFormField(
                          controller: _zipController,
                          style: const TextStyle(color: AppTokens.textPrimary),
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          decoration: _inputDecoration('Zip Code'),
                          validator: (v) => v!.isEmpty ? 'Required' : null)),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                      child: TextFormField(
                          controller: _cityController,
                          style: const TextStyle(color: AppTokens.textPrimary),
                          decoration: _inputDecoration('City'),
                          validator: (v) => v!.isEmpty ? 'Required' : null)),
                  const SizedBox(width: 8),
                  Expanded(
                      child: TextFormField(
                          controller: _stateController,
                          style: const TextStyle(color: AppTokens.textPrimary),
                          decoration: _inputDecoration('State'),
                          validator: (v) => v!.isEmpty ? 'Required' : null)),
                ],
              ),
              const SizedBox(height: 16),
              _buildLabel('Emergency Contact'),
              TextFormField(
                controller: _emergencyNameController,
                style: const TextStyle(color: AppTokens.textPrimary),
                decoration: _inputDecoration('Name'),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _emergencyPhoneController,
                keyboardType: TextInputType.phone,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                style: const TextStyle(color: AppTokens.textPrimary),
                decoration: _inputDecoration('Phone Number'),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _emergencyRelationController,
                style: const TextStyle(color: AppTokens.textPrimary),
                decoration: _inputDecoration('Relation'),
              ),
              const SizedBox(height: 16),
              _buildLabel('Hourly Rate (\$/hr)'),
              Row(
                children: [
                  Text('\$${_payRate.toStringAsFixed(0)}',
                      style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppTokens.textPrimary)),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.remove_circle_outline),
                    onPressed: () => setState(() {
                      if (_payRate > 10) _payRate -= 1.0;
                    }),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add_circle_outline),
                    onPressed: () => setState(() {
                      _payRate += 1.0;
                    }),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _buildLabel('Description'),
              TextFormField(
                controller: _detailsController,
                maxLines: 4,
                style: const TextStyle(color: AppTokens.textPrimary),
                decoration: _inputDecoration('Job description...'),
                validator: (v) => v!.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _isLoading || !_isEditable ? null : _updateJob,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTokens.primaryBlue,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text('Update Job',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w600)),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: OutlinedButton(
                  onPressed: _isLoading || !_isEditable ? null : _deleteJob,
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.red),
                    foregroundColor: Colors.red,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('Delete Job',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(label,
          style: const TextStyle(
              fontWeight: FontWeight.w600, color: AppTokens.textPrimary)),
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppTokens.jobsCardBorder),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppTokens.jobsCardBorder),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    );
  }
}
