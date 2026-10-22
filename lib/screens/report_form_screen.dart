import 'package:flutter/material.dart';

import '../widgets/app_button.dart';
import '../widgets/app_text_field.dart';

enum ReportState { form, loading, success, empty, error }

class ReportFormScreen extends StatefulWidget {
  const ReportFormScreen({super.key});

  @override
  State<ReportFormScreen> createState() => _ReportFormScreenState();
}

class _ReportFormScreenState extends State<ReportFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  ReportState _state = ReportState.form;
  bool _simulateError = false;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _submitReport() async {
    if (_state == ReportState.loading) return;
    if (!_formKey.currentState!.validate()) return;

    setState(() => _state = ReportState.loading);

    await Future<void>.delayed(const Duration(seconds: 4));

    if (!mounted) return;

    setState(() {
      _state = _simulateError ? ReportState.error : ReportState.success;
    });
  }

  void _retry() {
    setState(() => _state = ReportState.form);
    _submitReport();
  }

  void _resetForm() {
    _titleController.clear();
    _descriptionController.clear();
    setState(() {
      _simulateError = false;
      _state = ReportState.form;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AgriTrack Report Form'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: _buildContent(),
          ),
        ),
      ),
    );
  }

  Widget _buildContent() {
    switch (_state) {
      case ReportState.loading:
        return const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Submitting report... Please wait.'),
            SizedBox(height: 8),
            Text('Simulated request in progress'),
          ],
        );

      case ReportState.success:
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.check_circle, size: 64, color: Colors.green),
            const SizedBox(height: 16),
            const Text(
              'Report submitted successfully!',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text('Demo only: no database record was saved.'),
            const SizedBox(height: 16),
            AppButton(text: 'Submit Another Report', onPressed: _resetForm),
          ],
        );

      case ReportState.empty:
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.inbox_outlined, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            const Text(
              'No reports available yet.',
              style: TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 8),
            const Text('There are no report records to display.'),
            const SizedBox(height: 16),
            AppButton(
              text: 'Create a Report',
              onPressed: () => setState(() => _state = ReportState.form),
            ),
          ],
        );

      case ReportState.error:
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            const Text(
              'Unable to submit the report.',
              style: TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 8),
            const Text('This is a simulated error. Please retry.'),
            const SizedBox(height: 16),
            AppButton(text: 'Retry Submission', onPressed: _retry),
            TextButton(
              onPressed: () => setState(() => _state = ReportState.form),
              child: const Text('Edit Report'),
            ),
          ],
        );

      case ReportState.form:
        return Form(
          key: _formKey,
          child: ListView(
            children: [
              const Text(
                'Agricultural Product Report',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text('Enter the details of your agricultural report.'),
              const SizedBox(height: 24),
              AppTextField(
                label: 'Report Title',
                controller: _titleController,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a report title';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              AppTextField(
                label: 'Description',
                controller: _descriptionController,
                maxLines: 4,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              CheckboxListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Simulate an error (testing only)'),
                value: _simulateError,
                onChanged: (value) {
                  setState(() => _simulateError = value ?? false);
                },
              ),
              const SizedBox(height: 8),
              AppButton(
                text: 'Submit Report',
                isLoading: _state == ReportState.loading,
                onPressed: _submitReport,
              ),
              const SizedBox(height: 12),
              OutlinedButton(
                onPressed: () => setState(() => _state = ReportState.empty),
                child: const Text('Preview Empty State'),
              ),
            ],
          ),
        );
    }
  }
}
