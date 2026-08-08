import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_card.dart';
import '../../domain/entities/service_request_entity.dart';
import '../bloc/services_bloc.dart';
import '../bloc/services_event.dart';
import '../bloc/services_state.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_state.dart';

class CreateServiceRequestPage extends StatefulWidget {
  const CreateServiceRequestPage({super.key});

  @override
  State<CreateServiceRequestPage> createState() =>
      _CreateServiceRequestPageState();
}

class _CreateServiceRequestPageState extends State<CreateServiceRequestPage> {
  final _formKey = GlobalKey<FormState>();
  final _descriptionController = TextEditingController();

  String? _shippingAddress;
  List<DocumentSnapshot> _addresses = [];
  bool _isLoadingAddresses = true;

  DateTime _selectedDate = DateTime.now();
  TimeOfDay? _selectedTime;

  @override
  void initState() {
    super.initState();
    _loadAddresses();
  }

  String? get _userId {
    final state = context.read<AuthBloc>().state;
    if (state is Authenticated) {
      return state.userId;
    }
    return null;
  }

  Future<void> _loadAddresses() async {
    final userId = _userId;
    if (userId == null) {
      if (mounted) setState(() => _isLoadingAddresses = false);
      return;
    }

    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('customers')
          .doc(userId)
          .collection('addresses')
          .orderBy('createdAt', descending: true)
          .get();

      if (mounted) {
        setState(() {
          _addresses = snapshot.docs;
          if (_addresses.isNotEmpty && _shippingAddress == null) {
            _shippingAddress = _addresses.first['address'] as String;
          }
          _isLoadingAddresses = false;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _isLoadingAddresses = false);
    }
  }

  Future<void> _addAddress(String newAddress) async {
    final userId = _userId;
    if (userId == null) return;
    try {
      await FirebaseFirestore.instance
          .collection('customers')
          .doc(userId)
          .collection('addresses')
          .add({
            'address': newAddress,
            'createdAt': FieldValue.serverTimestamp(),
          });
      setState(() {
        _shippingAddress = newAddress;
      });
      await _loadAddresses();
    } catch (_) {}
  }

  Future<void> _deleteAddress(String docId, String addressVal) async {
    final userId = _userId;
    if (userId == null) return;
    try {
      await FirebaseFirestore.instance
          .collection('customers')
          .doc(userId)
          .collection('addresses')
          .doc(docId)
          .delete();
      if (_shippingAddress == addressVal) {
        _shippingAddress = null;
      }
      await _loadAddresses();
    } catch (_) {}
  }

  void _showAddAddressDialog() {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.cardBackground,
        title: const Text(
          'Add New Address',
          style: TextStyle(color: AppColors.textPrimary),
        ),
        content: TextField(
          controller: controller,
          style: const TextStyle(color: AppColors.textPrimary),
          decoration: InputDecoration(
            hintText: 'Enter your address',
            hintStyle: const TextStyle(color: AppColors.textSecondary),
            filled: true,
            fillColor: AppColors.inputFill,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Cancel',
              style: TextStyle(color: AppColors.textSecondary),
            ),
          ),
          TextButton(
            onPressed: () {
              if (controller.text.trim().isNotEmpty) {
                _addAddress(controller.text.trim());
                Navigator.pop(context);
                if (Navigator.canPop(context)) {
                  Navigator.pop(
                    context,
                  ); // close bottom sheet if opened from it
                }
              }
            },
            child: const Text(
              'Save',
              style: TextStyle(color: AppColors.primary),
            ),
          ),
        ],
      ),
    );
  }

  void _showAddressBottomSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.cardBackground,
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Container(
                padding: const EdgeInsets.all(16),
                height: 400,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Saved Addresses',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const Gap(16),
                    Expanded(
                      child: _addresses.isEmpty
                          ? const Center(
                              child: Text(
                                'No addresses found.',
                                style: TextStyle(
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            )
                          : ListView.builder(
                              itemCount: _addresses.length,
                              itemBuilder: (context, index) {
                                final doc = _addresses[index];
                                final addressStr = doc['address'] as String;
                                return ListTile(
                                  title: Text(
                                    addressStr,
                                    style: const TextStyle(
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                  leading: Radio<String>(
                                    value: addressStr,
                                    groupValue: _shippingAddress,
                                    onChanged: (val) {
                                      setState(() {
                                        _shippingAddress = val;
                                      });
                                      Navigator.pop(context);
                                    },
                                    activeColor: AppColors.primary,
                                  ),
                                  trailing: IconButton(
                                    icon: const Icon(
                                      Icons.delete_outline,
                                      color: AppColors.accentRed,
                                    ),
                                    onPressed: () {
                                      _deleteAddress(doc.id, addressStr);
                                      Navigator.pop(context);
                                    },
                                  ),
                                );
                              },
                            ),
                    ),
                    const Gap(16),
                    AppButton(
                      text: 'Add New Address',
                      onPressed: _showAddAddressDialog,
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 30)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: AppColors.primary,
              onPrimary: Colors.white,
              surface: AppColors.cardBackground,
              onSurface: AppColors.textPrimary,
            ),
            dialogTheme: const DialogThemeData(
              backgroundColor: AppColors.cardBackground,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime ?? TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: AppColors.primary,
              onPrimary: Colors.white,
              surface: AppColors.cardBackground,
              onSurface: AppColors.textPrimary,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  String get _formattedDate {
    return DateFormat('dd MMM, yyyy (EEEE)').format(_selectedDate);
  }

  String get _formattedTime {
    if (_selectedTime == null) return 'Select a time';
    return _selectedTime!.format(context);
  }

  void _submitForm() {
    if (_shippingAddress == null || _shippingAddress!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select or add an address.'),
          backgroundColor: AppColors.accentRed,
        ),
      );
      return;
    }

    if (_selectedTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select an appointment time.'),
          backgroundColor: AppColors.accentRed,
        ),
      );
      return;
    }

    final newRequest = ServiceRequestEntity(
      id: 'REQ-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
      address: _shippingAddress!,
      date: DateFormat('dd MMM, yyyy').format(_selectedDate),
      timeSlot: _formattedTime,
      description: _descriptionController.text.trim().isEmpty
          ? 'Regular service and maintenance request.'
          : _descriptionController.text.trim(),
      status: 'Pending',
    );

    context.read<ServicesBloc>().add(SubmitServiceRequest(newRequest));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_rounded,
            color: AppColors.textPrimary,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Service Request',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: false,
      ),
      body: BlocListener<ServicesBloc, ServicesState>(
        listener: (context, state) {
          if (state is ServiceRequestSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Service request submitted successfully!'),
                backgroundColor: AppColors.accentGreen,
                behavior: SnackBarBehavior.floating,
              ),
            );
            Navigator.pop(context);
          } else if (state is ServicesError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppColors.accentRed,
              ),
            );
          }
        },
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics(),
          ),
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Address Shipping section
                const Text(
                  'Address Shipping',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 11.5,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Gap(6),
                AppCard(
                  padding: const EdgeInsets.all(12),
                  child: _isLoadingAddresses
                      ? const Center(
                          child: CircularProgressIndicator(
                            color: AppColors.primary,
                          ),
                        )
                      : _shippingAddress == null
                      ? Center(
                          child: AppButton(
                            text: 'Add Address',
                            onPressed: _showAddAddressDialog,
                            height: 36,
                          ),
                        )
                      : Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: AppColors.primary.withValues(
                                  alpha: 0.15,
                                ),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.home_outlined,
                                color: AppColors.primary,
                                size: 18,
                              ),
                            ),
                            const Gap(12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Selected Address',
                                    style: TextStyle(
                                      color: AppColors.textSecondary,
                                      fontSize: 11,
                                    ),
                                  ),
                                  const Gap(2),
                                  Text(
                                    _shippingAddress!,
                                    style: const TextStyle(
                                      color: AppColors.textPrimary,
                                      fontSize: 12.5,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Gap(6),
                            TextButton.icon(
                              onPressed: _showAddressBottomSheet,
                              style: TextButton.styleFrom(
                                foregroundColor: AppColors.secondary,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                              ),
                              icon: const Text(
                                '✏️',
                                style: TextStyle(fontSize: 12),
                              ),
                              label: const Text(
                                'Change',
                                style: TextStyle(
                                  fontSize: 11.5,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                ),

                const Gap(20),

                // Appointment Date field
                const Text(
                  'Appointment Date',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 11.5,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Gap(6),
                InkWell(
                  onTap: _selectDate,
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.inputFill,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.divider),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.calendar_today_outlined,
                          color: AppColors.secondary,
                          size: 18,
                        ),
                        const Gap(10),
                        Text(
                          _formattedDate,
                          style: const TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 12.5,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const Spacer(),
                        const Icon(
                          Icons.edit_calendar_outlined,
                          color: AppColors.textSecondary,
                          size: 16,
                        ),
                      ],
                    ),
                  ),
                ),

                const Gap(20),

                // Appointment Time field
                const Text(
                  'Appointment Time',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 11.5,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Gap(6),
                InkWell(
                  onTap: _selectTime,
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.inputFill,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.divider),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.access_time_rounded,
                          color: AppColors.secondary,
                          size: 18,
                        ),
                        const Gap(10),
                        Text(
                          _formattedTime,
                          style: const TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 12.5,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const Spacer(),
                        const Icon(
                          Icons.edit_outlined,
                          color: AppColors.textSecondary,
                          size: 16,
                        ),
                      ],
                    ),
                  ),
                ),

                const Gap(20),

                // Problem Description (Optional) field
                const Text(
                  'Problem Description (Optional)',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 11.5,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Gap(6),
                TextFormField(
                  controller: _descriptionController,
                  maxLines: 4,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 12.5,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Please describe the issue in detail',
                    hintStyle: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 12,
                    ),
                    filled: true,
                    fillColor: AppColors.inputFill,
                    contentPadding: const EdgeInsets.all(12),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: AppColors.divider),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: AppColors.divider),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: AppColors.primary),
                    ),
                  ),
                ),

                const Gap(24),

                // Submit Request Button
                BlocBuilder<ServicesBloc, ServicesState>(
                  builder: (context, state) {
                    final isSubmitting = state is ServiceRequestSubmitting;
                    return AppButton(
                      text: 'Submit Request',
                      isLoading: isSubmitting,
                      onPressed: _submitForm,
                      height: 44,
                      borderRadius: 12,
                    );
                  },
                ),
                const Gap(20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
