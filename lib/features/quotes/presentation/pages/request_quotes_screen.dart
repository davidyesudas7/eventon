import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/widgets/inline_error_banner.dart';
import '../providers/quote_cart_provider.dart';
import '../providers/quotes_providers.dart';

class RequestQuotesScreen extends ConsumerStatefulWidget {
  const RequestQuotesScreen({super.key});

  @override
  ConsumerState<RequestQuotesScreen> createState() =>
      _RequestQuotesScreenState();
}

class _RequestQuotesScreenState extends ConsumerState<RequestQuotesScreen> {
  final _formKey = GlobalKey<FormState>();
  final _dateController = TextEditingController();
  final _guestsController = TextEditingController();
  final _budgetController = TextEditingController();
  final _whereController = TextEditingController();
  final _requirementsController = TextEditingController();

  DateTime? _selectedDate;
  bool _isSubmitting = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _requirementsController.addListener(_clearError);
    _dateController.addListener(_clearError);
  }

  void _clearError() {
    if (_errorMessage != null) {
      setState(() => _errorMessage = null);
    }
  }

  @override
  void dispose() {
    _dateController.dispose();
    _guestsController.dispose();
    _budgetController.dispose();
    _whereController.dispose();
    _requirementsController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _dateController.text = DateFormat('MM/dd/yyyy').format(picked);
        _errorMessage = null;
      });
    }
  }

  Future<void> _sendQuoteRequest() async {
    if (!(_formKey.currentState?.validate() ?? false)) {
      setState(() => _errorMessage = 'Please complete the required fields');
      return;
    }

    final quoteItems = ref.read(quoteCartProvider);
    if (quoteItems.isEmpty) {
      setState(() => _errorMessage = 'No businesses selected for quote');
      return;
    }

    final Map<String, dynamic> body = {
      'listingIds': quoteItems.map((q) => q.id).toList(),
      if (_selectedDate != null)
        'eventDate': _selectedDate!.toIso8601String().substring(0, 10),
      if (_guestsController.text.isNotEmpty)
        'guestCount': int.tryParse(_guestsController.text),
      if (_budgetController.text.isNotEmpty)
        'budget': num.tryParse(_budgetController.text),
      if (_whereController.text.isNotEmpty)
        'eventLocation': _whereController.text,
      if (_requirementsController.text.isNotEmpty)
        'message': _requirementsController.text,
    };

    setState(() {
      _isSubmitting = true;
      _errorMessage = null;
    });

    try {
      final result =
          await ref.read(quotesRepositoryProvider).createQuoteRequest(body);
      if (!mounted) return;
      setState(() => _isSubmitting = false);

      result.fold(
        (failure) {
          setState(() => _errorMessage = failure.message);
        },
        (quoteRequest) {
          ref.read(quoteCartProvider.notifier).clearQuotes();
          context.go('/quote-requests/${quoteRequest.id}');
        },
      );
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isSubmitting = false;
        _errorMessage = extractErrorMessage(e);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final quoteItems = ref.watch(quoteCartProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          'EventOn',
          style: TextStyle(
            color: Color(0xFF155E56),
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: false,
        titleSpacing: 0,
      ),
      body: quoteItems.isEmpty
          ? _buildEmptyState()
          : _buildFilledState(quoteItems),
    );
  }

  Widget _buildEmptyState() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Request quotes',
            style: AppTextStyles.headlineMd.copyWith(fontSize: 22),
          ),
          const SizedBox(height: 8),
          Text(
            'One message to every business you picked. Each replies in their own chat, and you compare the quotes side by side before booking.',
            style: AppTextStyles.bodyMd.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 32),
          Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.borderSubtle),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'You have not picked any businesses yet.',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.bodyMd.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Browse businesses and tap "+ Quote"',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.labelMd.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilledState(List<QuoteItem> items) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Request quotes',
                    style: AppTextStyles.headlineMd.copyWith(fontSize: 22),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'One message to every business you picked. Each replies in their own chat, and you compare the quotes side by side before booking.',
                    style: AppTextStyles.bodyMd.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Asking ${items.length} businesses',
                    style: AppTextStyles.labelMd.copyWith(
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ...items.map((item) => _buildBusinessItem(item)),
                  const SizedBox(height: 12),
                  GestureDetector(
                    onTap: () => context.pop(),
                    child: Text(
                      '+ Add more businesses',
                      style: AppTextStyles.labelMd.copyWith(
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF155E56),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  _buildLabel('Event date'),
                  _buildTextField(
                    controller: _dateController,
                    hintText: 'mm/dd/yyyy',
                    readOnly: true,
                    onTap: _selectDate,
                    suffixIcon: const Icon(Icons.calendar_today, size: 20),
                    validator: (value) => value == null || value.isEmpty
                        ? 'Please select a date'
                        : null,
                  ),
                  _buildLabel('Guests — optional'),
                  _buildTextField(
                    controller: _guestsController,
                    hintText: '',
                    keyboardType: TextInputType.number,
                  ),
                  _buildLabel('Budget (₹) — optional'),
                  _buildTextField(
                    controller: _budgetController,
                    hintText: '',
                    keyboardType: TextInputType.number,
                  ),
                  _buildLabel('Where — optional'),
                  _buildTextField(
                    controller: _whereController,
                    hintText: 'Venue or area',
                  ),
                  _buildLabel('What do you need?'),
                  _buildTextField(
                    controller: _requirementsController,
                    hintText:
                        'E.g. engagement for about 150 guests, pastel stage décor with fresh flowers, setup by 4pm.',
                    maxLines: 4,
                    validator: (value) => value == null || value.isEmpty
                        ? 'Please enter your requirements'
                        : null,
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, -5),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (_errorMessage != null && _errorMessage!.isNotEmpty) ...[
                InlineErrorBanner(
                  message: _errorMessage,
                  margin: const EdgeInsets.only(bottom: 12),
                  onDismiss: () => setState(() => _errorMessage = null),
                ),
              ],
              ElevatedButton(
                onPressed: _isSubmitting ? null : _sendQuoteRequest,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF155E56),
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 56),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  textStyle: AppTextStyles.labelLg.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                child: _isSubmitting
                    ? const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : Text('Send to ${items.length} businesses'),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBusinessItem(QuoteItem item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.borderSubtle),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(8),
              image: item.imageUrl != null
                  ? DecorationImage(
                      image: NetworkImage(item.imageUrl!),
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
            child: item.imageUrl == null
                ? const Icon(Icons.image, color: Colors.grey)
                : null,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: AppTextStyles.labelMd.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (item.price != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    item.price!,
                    style: AppTextStyles.bodySm.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ],
            ),
          ),
          IconButton(
            icon: const Icon(
              Icons.close,
              color: AppColors.textSecondary,
              size: 20,
            ),
            onPressed: () {
              ref.read(quoteCartProvider.notifier).removeQuote(item.id);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, top: 16),
      child: Text(
        text,
        style: AppTextStyles.bodyMd.copyWith(color: AppColors.textSecondary),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    bool readOnly = false,
    VoidCallback? onTap,
    Widget? suffixIcon,
    TextInputType? keyboardType,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      readOnly: readOnly,
      onTap: onTap,
      keyboardType: keyboardType,
      maxLines: maxLines,
      validator: validator,
      style: AppTextStyles.bodyMd.copyWith(color: AppColors.textPrimary),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: AppTextStyles.bodyMd.copyWith(color: AppColors.textMuted),
        suffixIcon: suffixIcon,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.borderSubtle),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.borderSubtle),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primary),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
      ),
    );
  }
}
