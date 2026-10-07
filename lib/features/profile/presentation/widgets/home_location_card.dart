import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../data/models/location_models.dart';
import '../providers/home_location_provider.dart';

class HomeLocationCard extends ConsumerStatefulWidget {
  const HomeLocationCard({super.key});

  @override
  ConsumerState<HomeLocationCard> createState() => _HomeLocationCardState();
}

class _HomeLocationCardState extends ConsumerState<HomeLocationCard> {
  final _pincodeController = TextEditingController();
  final _lsgController = TextEditingController();

  PincodeDetails? _currentPincodeDetails;
  LsgDetails? _currentLsgDetails;

  bool _isEditingLsg = true;
  bool _isLoadingPincode = false;
  bool _initialized = false;

  Timer? _debounce;
  List<LsgDetails> _lsgSuggestions = [];
  bool _isSearchingLsg = false;

  @override
  void dispose() {
    _pincodeController.dispose();
    _lsgController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onPincodeChanged(String value) async {
    if (value.length == 6) {
      setState(() {
        _isLoadingPincode = true;
      });
      final details = await ref.read(fetchPincodeProvider(value).future);
      setState(() {
        _currentPincodeDetails = details;
        _isLoadingPincode = false;
        // Reset LSG if pincode changes
        _currentLsgDetails = null;
        _isEditingLsg = true;
        _lsgController.clear();
      });
    } else {
      if (_currentPincodeDetails != null) {
        setState(() {
          _currentPincodeDetails = null;
        });
      }
    }
  }

  void _onLsgChanged(String value) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () async {
      if (value.length >= 2) {
        setState(() => _isSearchingLsg = true);
        final results = await ref.read(searchLsgProvider(value).future);
        if (mounted) {
          setState(() {
            _lsgSuggestions = results;
            _isSearchingLsg = false;
          });
        }
      } else {
        setState(() {
          _lsgSuggestions = [];
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final locationState = ref.watch(homeLocationStateProvider);

    if (!locationState.isLoading && !_initialized) {
      final savedLoc = locationState.value;
      if (savedLoc != null) {
        _pincodeController.text = savedLoc.pincodeDetails.pincode;
        _currentPincodeDetails = savedLoc.pincodeDetails;
        _currentLsgDetails = savedLoc.lsgDetails;
        if (_currentLsgDetails != null) {
          _isEditingLsg = false;
        } else {
          _isEditingLsg = true;
        }
      }
      _initialized = true;
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.borderSubtle),
        borderRadius: BorderRadius.circular(16),
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Home location', style: AppTextStyles.headlineSm),
          const SizedBox(height: 8),
          Text(
            'Where you live — this can decide which franchise territory a booking\'s commission goes to.',
            style: AppTextStyles.bodyMd.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 20),

          Text(
            'Pincode',
            style: AppTextStyles.bodyMd.copyWith(color: AppColors.textPrimary),
          ),
          const SizedBox(height: 6),
          TextField(
            controller: _pincodeController,
            keyboardType: TextInputType.number,
            maxLength: 6,
            onChanged: _onPincodeChanged,
            decoration: InputDecoration(
              hintText: 'e.g. 688001',
              counterText: '',
              suffixIcon: _isLoadingPincode
                  ? const Padding(
                      padding: EdgeInsets.all(12.0),
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : null,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppColors.borderStrong),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppColors.borderStrong),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                  color: AppColors.primary,
                  width: 1.5,
                ),
              ),
              fillColor: Colors.white,
              filled: true,
            ),
          ),
          if (_currentPincodeDetails != null) ...[
            const SizedBox(height: 8),
            Text(
              '${_currentPincodeDetails!.pincode} — ${_currentPincodeDetails!.officeName}, ${_currentPincodeDetails!.district}, ${_currentPincodeDetails!.state}',
              style: AppTextStyles.labelMd.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],


            const SizedBox(height: 16),
            Text(
              'Panchayat, municipality or corporation (Kerala only)',
              style: AppTextStyles.bodyMd.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 6),

            if (!_isEditingLsg && _currentLsgDetails != null)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.borderStrong),
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.white,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        'Already set on your account.',
                        style: AppTextStyles.bodyMd.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _isEditingLsg = true;
                          _lsgController.text = _currentLsgDetails!.name;
                          _onLsgChanged(_lsgController.text);
                        });
                      },
                      child: Text(
                        'Change',
                        style: AppTextStyles.labelMd.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),
              )
            else
              Column(
                children: [
                  TextField(
                    controller: _lsgController,
                    onChanged: _onLsgChanged,
                    decoration: InputDecoration(
                      hintText: 'Start typing your panchayat\'s name...',
                      suffixIcon: _isSearchingLsg
                          ? const Padding(
                              padding: EdgeInsets.all(12.0),
                              child: SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              ),
                            )
                          : null,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: AppColors.borderStrong,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: AppColors.borderStrong,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: AppColors.primary,
                          width: 1.5,
                        ),
                      ),
                      fillColor: Colors.white,
                      filled: true,
                    ),
                  ),
                  if (_lsgSuggestions.isNotEmpty && _isEditingLsg)
                    Container(
                      margin: const EdgeInsets.only(top: 4),
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColors.borderStrong),
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.white,
                      ),
                      child: ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _lsgSuggestions.length,
                        separatorBuilder: (context, index) => const Divider(
                          height: 1,
                          color: AppColors.borderSubtle,
                        ),
                        itemBuilder: (context, index) {
                          final lsg = _lsgSuggestions[index];
                          return InkWell(
                            onTap: () {
                              setState(() {
                                _currentLsgDetails = lsg;
                                _isEditingLsg = false;
                                _lsgSuggestions = [];
                                FocusScope.of(context).unfocus();
                              });
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    lsg.name,
                                    style: AppTextStyles.bodyLg.copyWith(
                                      color: AppColors.textPrimary,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    '${lsg.type == 'grama_panchayat' ? 'Grama panchayat' : 'Municipality'}, ${lsg.district}',
                                    style: AppTextStyles.labelMd.copyWith(
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                ],
              ),


          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: () async {
                      if (_currentPincodeDetails == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Please enter a valid pincode first.'),
                          ),
                        );
                        return;
                      }
                      
                      await ref
                          .read(homeLocationStateProvider.notifier)
                          .saveLocation(
                            _currentPincodeDetails!,
                            _currentLsgDetails,
                          );
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Home location saved successfully!'),
                          ),
                        );
                      }
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(
                  0xFF134E4A,
                ), // Dark teal to match screenshot
                disabledBackgroundColor: Colors.grey[300],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                'Save home location',
                style: AppTextStyles.labelLg.copyWith(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
