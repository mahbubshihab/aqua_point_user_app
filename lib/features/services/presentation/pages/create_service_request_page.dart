import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/services/cloudinary_service.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_shadows.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../auth/data/datasources/auth_local_datasource.dart';
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
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _descriptionController = TextEditingController();

  File? _selectedFilterImage;
  bool _isUploadingImage = false;
  final ImagePicker _imagePicker = ImagePicker();

  String? _shippingAddress;
  List<DocumentSnapshot> _addresses = [];
  bool _isLoadingAddresses = true;

  DateTime _selectedDate = DateTime.now();
  TimeOfDay? _selectedTime;

  @override
  void initState() {
    super.initState();
    _loadAddresses();
    _loadCustomerInfo();
  }

  Future<void> _loadCustomerInfo() async {
    try {
      final localPhone = await AuthLocalDatasource().getUserPhone();
      final localUserId = await AuthLocalDatasource().getUserId();
      final authUser = FirebaseAuth.instance.currentUser;

      String? foundName = authUser?.displayName;
      String? foundPhone = localPhone ?? authUser?.phoneNumber;

      final candidateId = _userId ?? localUserId ?? authUser?.uid;
      if (candidateId != null && candidateId.isNotEmpty) {
        final doc = await FirebaseFirestore.instance.collection('customers').doc(candidateId).get();
        if (doc.exists) {
          final data = doc.data();
          if (data != null) {
            final nameVal = data['name']?.toString();
            if (nameVal != null && nameVal.isNotEmpty && !nameVal.toLowerCase().contains('customer ')) {
              foundName = nameVal;
            } else if (foundName == null || foundName.isEmpty) {
              foundName = nameVal;
            }
            if (data['phone'] != null && data['phone'].toString().isNotEmpty) {
              foundPhone = data['phone'].toString();
            } else if (data['phoneNumber'] != null && data['phoneNumber'].toString().isNotEmpty) {
              foundPhone = data['phoneNumber'].toString();
            }
          }
        }
      }

      if ((foundName == null || foundName.isEmpty) && foundPhone != null && foundPhone.isNotEmpty) {
        final query = await FirebaseFirestore.instance
            .collection('customers')
            .where('phone', isEqualTo: foundPhone)
            .limit(1)
            .get();
        if (query.docs.isNotEmpty) {
          final data = query.docs.first.data();
          foundName = data['name']?.toString();
        }
      }

      if (mounted) {
        setState(() {
          if (foundName != null && foundName.isNotEmpty && _nameController.text.isEmpty) {
            _nameController.text = foundName;
          }
          if (foundPhone != null && foundPhone.isNotEmpty && _phoneController.text.isEmpty) {
            _phoneController.text = foundPhone;
          }
        });
      }
    } catch (_) {}
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

  void _showAddAddressDialog({bool fromBottomSheet = false}) {
    const textColorPrimary = Color(0xFF0F172A);
    const textColorSecondary = Color(0xFF64748B);
    const surfaceColor = Colors.white;
    const inputBg = Color(0xFFF8FAFC);
    const borderColor = Color(0xFFE2E8F0);
    const accentColor = AppColors.primary;

    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: surfaceColor,
        title: Text(
          'Add New Address',
          style: GoogleFonts.outfit(
            color: textColorPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        content: TextField(
          controller: controller,
          style: GoogleFonts.inter(color: textColorPrimary),
          decoration: InputDecoration(
            hintText: 'Enter your address',
            hintStyle: GoogleFonts.inter(color: textColorSecondary),
            filled: true,
            fillColor: inputBg,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: borderColor),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: borderColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: accentColor),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(
              'Cancel',
              style: GoogleFonts.inter(color: textColorSecondary),
            ),
          ),
          TextButton(
            onPressed: () {
              if (controller.text.trim().isNotEmpty) {
                _addAddress(controller.text.trim());
                Navigator.pop(dialogContext);
                if (fromBottomSheet && Navigator.canPop(context)) {
                  Navigator.pop(context);
                }
              }
            },
            child: Text(
              'Save',
              style: GoogleFonts.inter(
                color: accentColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showAddressBottomSheet() {
    const textColorPrimary = Color(0xFF0F172A);
    const textColorSecondary = Color(0xFF64748B);
    const surfaceColor = Colors.white;
    const accentColor = AppColors.primary;

    showModalBottomSheet(
      context: context,
      backgroundColor: surfaceColor,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
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
                    Text(
                      'Saved Addresses',
                      style: GoogleFonts.outfit(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: textColorPrimary,
                      ),
                    ),
                    const Gap(16),
                    Expanded(
                      child: _addresses.isEmpty
                          ? Center(
                              child: Text(
                                'No addresses found.',
                                style: GoogleFonts.inter(
                                  color: textColorSecondary,
                                ),
                              ),
                            )
                          : ListView.builder(
                              itemCount: _addresses.length,
                              itemBuilder: (context, index) {
                                final doc = _addresses[index];
                                final addressStr = doc['address'] as String;
                                return ListTile(
                                  onTap: () {
                                    setState(() {
                                      _shippingAddress = addressStr;
                                    });
                                    Navigator.pop(context);
                                  },
                                  title: Text(
                                    addressStr,
                                    style: GoogleFonts.inter(
                                      color: textColorPrimary,
                                    ),
                                  ),
                                  leading: Icon(
                                    _shippingAddress == addressStr
                                        ? Icons.radio_button_checked_rounded
                                        : Icons.radio_button_unchecked_rounded,
                                    color: _shippingAddress == addressStr
                                        ? accentColor
                                        : textColorSecondary,
                                    size: 22,
                                  ),
                                  trailing: IconButton(
                                    icon: const Icon(
                                      Icons.delete_outline,
                                      color: AppColors.error,
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
                      onPressed: () => _showAddAddressDialog(fromBottomSheet: true),
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
    _nameController.dispose();
    _phoneController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final pickedFile = await _imagePicker.pickImage(
        source: source,
        imageQuality: 75,
        maxWidth: 1024,
        maxHeight: 1024,
      );
      if (pickedFile != null) {
        setState(() {
          _selectedFilterImage = File(pickedFile.path);
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to pick image: $e', style: GoogleFonts.inter()),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  void _showImageSourceDialog() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Add Filter / Purifier Photo',
                style: GoogleFonts.outfit(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF0F172A),
                ),
              ),
              const Gap(6),
              Text(
                'Upload a photo of your purifier or filter (Optional)',
                style: GoogleFonts.inter(
                  fontSize: 13,
                  color: const Color(0xFF64748B),
                ),
              ),
              const Gap(20),
              Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        Navigator.pop(context);
                        _pickImage(ImageSource.camera);
                      },
                      borderRadius: BorderRadius.circular(16),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF8FAFC),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: const Color(0xFFE2E8F0)),
                        ),
                        child: Column(
                          children: [
                            const Icon(Icons.camera_alt_rounded, color: AppColors.primary, size: 28),
                            const Gap(8),
                            Text(
                              'Take Photo',
                              style: GoogleFonts.inter(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF0F172A),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const Gap(16),
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        Navigator.pop(context);
                        _pickImage(ImageSource.gallery);
                      },
                      borderRadius: BorderRadius.circular(16),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF8FAFC),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: const Color(0xFFE2E8F0)),
                        ),
                        child: Column(
                          children: [
                            const Icon(Icons.photo_library_rounded, color: AppColors.secondary, size: 28),
                            const Gap(8),
                            Text(
                              'Choose Gallery',
                              style: GoogleFonts.inter(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF0F172A),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
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
            colorScheme: const ColorScheme.light(
              primary: AppColors.primary,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Color(0xFF0F172A),
            ),
            dialogTheme: const DialogThemeData(
              backgroundColor: Colors.white,
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
            colorScheme: const ColorScheme.light(
              primary: AppColors.primary,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Color(0xFF0F172A),
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

  Future<void> _submitForm() async {
    final name = _nameController.text.trim();
    final phone = _phoneController.text.trim();

    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please enter your name.', style: GoogleFonts.inter()),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    if (phone.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please enter your contact phone number.', style: GoogleFonts.inter()),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    if (_shippingAddress == null || _shippingAddress!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please select or add an address.', style: GoogleFonts.inter()),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    if (_selectedTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please select an appointment time.', style: GoogleFonts.inter()),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    setState(() => _isUploadingImage = true);

    String? uploadedImageUrl;
    if (_selectedFilterImage != null) {
      try {
        uploadedImageUrl = await CloudinaryService().uploadImage(_selectedFilterImage!);
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Image upload failed. Submitting request without image...', style: GoogleFonts.inter()),
              backgroundColor: AppColors.warning,
            ),
          );
        }
      }
    }

    if (!mounted) return;
    setState(() => _isUploadingImage = false);

    final newRequest = ServiceRequestEntity(
      id: 'REQ-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
      customerName: name,
      phone: phone,
      filterImageUrl: uploadedImageUrl,
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
    const textColorPrimary = Color(0xFF0F172A);
    const textColorSecondary = Color(0xFF64748B);
    const cardBgColor = Colors.white;
    const cardBorderColor = Color(0xFFE2E8F0);
    const accentColor = AppColors.primary;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_rounded,
            color: textColorPrimary,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Service Request',
          style: GoogleFonts.outfit(
            color: textColorPrimary,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: false,
      ),
      body: BlocListener<ServicesBloc, ServicesState>(
        listener: (context, state) {
          if (state is ServiceRequestSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Service request submitted successfully!', style: GoogleFonts.inter()),
                backgroundColor: AppColors.success,
                behavior: SnackBarBehavior.floating,
              ),
            );
            Navigator.pop(context);
          } else if (state is ServicesError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message, style: GoogleFonts.inter()),
                backgroundColor: AppColors.error,
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
                // Contact Information Section
                Text(
                  'Contact Information',
                  style: GoogleFonts.inter(
                    color: textColorSecondary,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Gap(8),
                Container(
                  decoration: BoxDecoration(
                    color: cardBgColor,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: cardBorderColor),
                    boxShadow: AppShadows.soft,
                  ),
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Full Name',
                        style: GoogleFonts.inter(
                          color: textColorSecondary,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const Gap(6),
                      TextFormField(
                        controller: _nameController,
                        style: GoogleFonts.inter(
                          color: textColorPrimary,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                        decoration: InputDecoration(
                          hintText: 'Enter your full name',
                          hintStyle: GoogleFonts.inter(
                            color: textColorSecondary,
                            fontSize: 14,
                          ),
                          filled: true,
                          fillColor: const Color(0xFFF8FAFC),
                          prefixIcon: const Icon(
                            Icons.person_outline_rounded,
                            color: accentColor,
                            size: 20,
                          ),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: cardBorderColor),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: cardBorderColor),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: accentColor),
                          ),
                        ),
                      ),
                      const Gap(14),
                      Text(
                        'Phone Number',
                        style: GoogleFonts.inter(
                          color: textColorSecondary,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const Gap(6),
                      TextFormField(
                        controller: _phoneController,
                        keyboardType: TextInputType.phone,
                        style: GoogleFonts.inter(
                          color: textColorPrimary,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                        decoration: InputDecoration(
                          hintText: 'Enter your phone number',
                          hintStyle: GoogleFonts.inter(
                            color: textColorSecondary,
                            fontSize: 14,
                          ),
                          filled: true,
                          fillColor: const Color(0xFFF8FAFC),
                          prefixIcon: const Icon(
                            Icons.phone_outlined,
                            color: accentColor,
                            size: 20,
                          ),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: cardBorderColor),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: cardBorderColor),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: accentColor),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const Gap(24),

                // Address Shipping section
                Text(
                  'Address Shipping',
                  style: GoogleFonts.inter(
                    color: textColorSecondary,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Gap(8),
                Container(
                  decoration: BoxDecoration(
                    color: cardBgColor,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: cardBorderColor),
                    boxShadow: AppShadows.soft,
                  ),
                  padding: const EdgeInsets.all(16),
                  child: _isLoadingAddresses
                      ? const Center(
                          child: CircularProgressIndicator(
                            color: accentColor,
                          ),
                        )
                      : _shippingAddress == null
                      ? Center(
                          child: AppButton(
                            text: 'Add Address',
                            onPressed: _showAddAddressDialog,
                            height: 40,
                          ),
                        )
                      : Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: accentColor.withValues(alpha: 0.15),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.home_outlined,
                                color: accentColor,
                                size: 20,
                              ),
                            ),
                            const Gap(16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Selected Address',
                                    style: GoogleFonts.inter(
                                      color: textColorSecondary,
                                      fontSize: 12,
                                    ),
                                  ),
                                  const Gap(4),
                                  Text(
                                    _shippingAddress!,
                                    style: GoogleFonts.inter(
                                      color: textColorPrimary,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Gap(8),
                            TextButton.icon(
                              onPressed: _showAddressBottomSheet,
                              style: TextButton.styleFrom(
                                foregroundColor: AppColors.secondary,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                              ),
                              icon: const Text(
                                '✏️',
                                style: TextStyle(fontSize: 12),
                              ),
                              label: Text(
                                'Change',
                                style: GoogleFonts.inter(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                ),

                const Gap(24),

                // Appointment Date field
                Text(
                  'Appointment Date',
                  style: GoogleFonts.inter(
                    color: textColorSecondary,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Gap(8),
                InkWell(
                  onTap: _selectDate,
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 16,
                    ),
                    decoration: BoxDecoration(
                      color: cardBgColor,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: cardBorderColor),
                      boxShadow: AppShadows.soft,
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.calendar_today_outlined,
                          color: accentColor,
                          size: 20,
                        ),
                        const Gap(12),
                        Text(
                          _formattedDate,
                          style: GoogleFonts.inter(
                            color: textColorPrimary,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const Spacer(),
                        const Icon(
                          Icons.edit_calendar_outlined,
                          color: textColorSecondary,
                          size: 18,
                        ),
                      ],
                    ),
                  ),
                ),

                const Gap(24),

                // Appointment Time field
                Text(
                  'Appointment Time',
                  style: GoogleFonts.inter(
                    color: textColorSecondary,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Gap(8),
                InkWell(
                  onTap: _selectTime,
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 16,
                    ),
                    decoration: BoxDecoration(
                      color: cardBgColor,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: cardBorderColor),
                      boxShadow: AppShadows.soft,
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.access_time_rounded,
                          color: accentColor,
                          size: 20,
                        ),
                        const Gap(12),
                        Text(
                          _formattedTime,
                          style: GoogleFonts.inter(
                            color: textColorPrimary,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const Spacer(),
                        const Icon(
                          Icons.edit_outlined,
                          color: textColorSecondary,
                          size: 18,
                        ),
                      ],
                    ),
                  ),
                ),

                const Gap(24),

                // Filter / Purifier Photo (Optional)
                Row(
                  children: [
                    Text(
                      'Filter / Purifier Photo',
                      style: GoogleFonts.inter(
                        color: textColorSecondary,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Gap(8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF1F5F9),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        'Optional',
                        style: GoogleFonts.inter(
                          color: textColorSecondary,
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
                const Gap(8),
                if (_selectedFilterImage == null)
                  InkWell(
                    onTap: _showImageSourceDialog,
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
                      decoration: BoxDecoration(
                        color: cardBgColor,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: cardBorderColor,
                        ),
                        boxShadow: AppShadows.soft,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: accentColor.withValues(alpha: 0.1),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.add_a_photo_outlined,
                              color: accentColor,
                              size: 26,
                            ),
                          ),
                          const Gap(10),
                          Text(
                            'Attach Filter Photo (Optional)',
                            style: GoogleFonts.inter(
                              color: textColorPrimary,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const Gap(4),
                          Text(
                            'Take a picture or choose from gallery to help us diagnose',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.inter(
                              color: textColorSecondary,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                else
                  Container(
                    decoration: BoxDecoration(
                      color: cardBgColor,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: cardBorderColor),
                      boxShadow: AppShadows.soft,
                    ),
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Stack(
                            children: [
                              Image.file(
                                _selectedFilterImage!,
                                width: double.infinity,
                                height: 180,
                                fit: BoxFit.cover,
                              ),
                              Positioned(
                                top: 8,
                                right: 8,
                                child: InkWell(
                                  onTap: () {
                                    setState(() {
                                      _selectedFilterImage = null;
                                    });
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(6),
                                    decoration: const BoxDecoration(
                                      color: Colors.black54,
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.close,
                                      color: Colors.white,
                                      size: 18,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Gap(10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Photo attached',
                              style: GoogleFonts.inter(
                                color: AppColors.success,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            TextButton.icon(
                              onPressed: _showImageSourceDialog,
                              icon: const Icon(Icons.edit, size: 14, color: accentColor),
                              label: Text(
                                'Change Photo',
                                style: GoogleFonts.inter(
                                  color: accentColor,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                const Gap(24),

                // Problem Description (Optional) field
                Text(
                  'Problem Description (Optional)',
                  style: GoogleFonts.inter(
                    color: textColorSecondary,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Gap(8),
                Container(
                  decoration: BoxDecoration(
                    boxShadow: AppShadows.soft,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: TextFormField(
                    controller: _descriptionController,
                    maxLines: 4,
                    style: GoogleFonts.inter(
                      color: textColorPrimary,
                      fontSize: 14,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Please describe the issue in detail',
                      hintStyle: GoogleFonts.inter(
                        color: textColorSecondary,
                        fontSize: 14,
                      ),
                      filled: true,
                      fillColor: const Color(0xFFF8FAFC),
                      contentPadding: const EdgeInsets.all(16),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: const BorderSide(color: cardBorderColor),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: const BorderSide(color: cardBorderColor),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: const BorderSide(color: accentColor),
                      ),
                    ),
                  ),
                ),

                const Gap(32),

                // Submit Request Button
                BlocBuilder<ServicesBloc, ServicesState>(
                  builder: (context, state) {
                    final isSubmitting = state is ServiceRequestSubmitting || _isUploadingImage;
                    return AppButton(
                      text: _isUploadingImage ? 'Uploading Photo...' : 'Submit Request',
                      isLoading: isSubmitting,
                      onPressed: _submitForm,
                      height: 52,
                      borderRadius: 16,
                    );
                  },
                ),
                const Gap(32),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
