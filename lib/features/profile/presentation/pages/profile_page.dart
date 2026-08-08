import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/services/cloudinary_service.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_state.dart';
import '../../../auth/presentation/bloc/auth_event.dart';
import 'package:gap/gap.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _addressController = TextEditingController();

  String? _avatarUrl;
  bool _isLoading = true;
  bool _isSaving = false;
  bool _isEditing = false;
  bool _isUploadingAvatar = false;

  late String _userId;
  late String _phoneNumber;

  @override
  void initState() {
    super.initState();
    _initUserData();
  }

  void _initUserData() {
    final authState = context.read<AuthBloc>().state;
    if (authState is Authenticated) {
      _userId = authState.userId;
      _phoneNumber = authState.phoneNumber;
      _loadProfile();
    } else {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _loadProfile() async {
    try {
      final doc = await FirebaseFirestore.instance
          .collection('customers')
          .doc(_userId)
          .get();

      if (doc.exists) {
        final data = doc.data() as Map<String, dynamic>;
        _nameController.text = data['name'] ?? '';
        _emailController.text = data['email'] ?? '';
        _addressController.text = data['address'] ?? '';
        setState(() {
          _avatarUrl = data['avatarUrl'];
        });
      }
    } catch (e) {
      debugPrint('Error loading profile: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _pickAndUploadImage() async {
    if (!_isEditing) return;

    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 512,
      maxHeight: 512,
      imageQuality: 80,
    );
    if (pickedFile == null) return;

    setState(() => _isUploadingAvatar = true);

    try {
      final bytes = await pickedFile.readAsBytes();
      final filename = pickedFile.name;
      final cloudinary = CloudinaryService();
      final url = await cloudinary.uploadImageBytes(bytes, filename);
      if (url != null) {
        setState(() {
          _avatarUrl = url;
        });
        // Save avatar immediately
        await FirebaseFirestore.instance
            .collection('customers')
            .doc(_userId)
            .set({'avatarUrl': url}, SetOptions(merge: true));

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Avatar updated'),
              backgroundColor: AppColors.primary,
            ),
          );
        }
      }
    } catch (e) {
      debugPrint('Error uploading image: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Upload failed: $e'),
            backgroundColor: AppColors.accentRed,
          ),
        );
      }
    } finally {
      setState(() => _isUploadingAvatar = false);
    }
  }

  Future<void> _saveProfile() async {
    setState(() => _isSaving = true);
    try {
      final profileData = {
        'name': _nameController.text.trim(),
        'email': _emailController.text.trim(),
        'address': _addressController.text.trim(),
        'phone': _phoneNumber,
        'updatedAt': FieldValue.serverTimestamp(),
      };

      await FirebaseFirestore.instance
          .collection('customers')
          .doc(_userId)
          .set(profileData, SetOptions(merge: true));

      setState(() => _isEditing = false);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Profile saved'),
            backgroundColor: AppColors.primary,
          ),
        );
      }
    } catch (e) {
      debugPrint('Error saving profile: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to save'),
            backgroundColor: AppColors.accentRed,
          ),
        );
      }
    } finally {
      setState(() => _isSaving = false);
    }
  }

  void _logout() {
    context.read<AuthBloc>().add(LogoutEvent());
    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Personal Info',
          style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold),
        ),
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Avatar
                  Center(
                    child: GestureDetector(
                      onTap: _isEditing ? _pickAndUploadImage : null,
                      child: Stack(
                        children: [
                          CircleAvatar(
                            radius: 50,
                            backgroundColor: AppColors.cardBackground,
                            backgroundImage:
                                _avatarUrl != null ? NetworkImage(_avatarUrl!) : null,
                            child: _avatarUrl == null
                                ? Text(
                                    _nameController.text.isNotEmpty
                                        ? _nameController.text[0].toUpperCase()
                                        : '?',
                                    style: const TextStyle(
                                      fontSize: 36,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.primary,
                                    ),
                                  )
                                : null,
                          ),
                          if (_isUploadingAvatar)
                            Positioned.fill(
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.black54,
                                  shape: BoxShape.circle,
                                ),
                                child: const Center(
                                  child: SizedBox(
                                    width: 24,
                                    height: 24,
                                    child: CircularProgressIndicator(
                                      color: AppColors.primary,
                                      strokeWidth: 2,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          if (_isEditing && !_isUploadingAvatar)
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: const BoxDecoration(
                                  color: AppColors.primary,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.camera_alt,
                                    color: Colors.white, size: 16),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                  const Gap(32),

                  // Phone Number (always read-only)
                  _buildTextField(
                    label: 'Phone Number',
                    initialValue: _phoneNumber,
                    readOnly: true,
                    icon: Icons.lock_outline,
                  ),
                  const Gap(16),

                  // Name
                  _buildTextField(
                    label: 'Full Name',
                    controller: _nameController,
                    readOnly: !_isEditing,
                    hintText: 'Enter your name',
                  ),
                  const Gap(16),

                  // Email
                  _buildTextField(
                    label: 'Email',
                    controller: _emailController,
                    readOnly: !_isEditing,
                    hintText: 'Enter your email',
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const Gap(16),

                  // Address
                  _buildTextField(
                    label: 'Address',
                    controller: _addressController,
                    readOnly: !_isEditing,
                    hintText: 'Enter your address',
                    maxLines: 2,
                  ),

                  const Gap(32),

                  // Edit / Save Button
                  ElevatedButton.icon(
                    onPressed: _isSaving
                        ? null
                        : _isEditing
                            ? _saveProfile
                            : () => setState(() => _isEditing = true),
                    icon: _isSaving
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : Icon(
                            _isEditing ? Icons.save_rounded : Icons.edit_rounded,
                            size: 18,
                          ),
                    label: Text(
                      _isSaving
                          ? 'Saving...'
                          : _isEditing
                              ? 'Save Profile'
                              : 'Edit Profile',
                      style: const TextStyle(
                          fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          _isEditing ? AppColors.primary : AppColors.cardBackground,
                      foregroundColor:
                          _isEditing ? Colors.black : AppColors.textPrimary,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                        side: _isEditing
                            ? BorderSide.none
                            : const BorderSide(
                                color: AppColors.primary, width: 1),
                      ),
                    ),
                  ),

                  if (_isEditing) ...[
                    const Gap(12),
                    TextButton(
                      onPressed: () {
                        setState(() => _isEditing = false);
                        _loadProfile(); // Reset to saved values
                      },
                      child: const Text(
                        'Cancel',
                        style: TextStyle(color: AppColors.textSecondary),
                      ),
                    ),
                  ],

                  const Gap(24),

                  // Logout
                  OutlinedButton.icon(
                    onPressed: _logout,
                    icon: const Icon(Icons.logout, color: AppColors.accentRed),
                    label: const Text('Logout',
                        style: TextStyle(color: AppColors.accentRed)),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: AppColors.accentRed),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildTextField({
    required String label,
    TextEditingController? controller,
    String? initialValue,
    bool readOnly = false,
    IconData? icon,
    int maxLines = 1,
    TextInputType? keyboardType,
    String? hintText,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: AppColors.textSecondary,
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
        const Gap(6),
        TextFormField(
          controller: controller,
          initialValue: initialValue,
          readOnly: readOnly,
          maxLines: maxLines,
          keyboardType: keyboardType,
          style: TextStyle(
            color: readOnly ? AppColors.textSecondary : AppColors.textPrimary,
            fontSize: 15,
          ),
          decoration: InputDecoration(
            filled: true,
            fillColor: readOnly
                ? AppColors.inputFill.withValues(alpha: 0.5)
                : AppColors.inputFill,
            hintText: readOnly ? null : hintText,
            hintStyle: const TextStyle(
                color: AppColors.textSecondary, fontSize: 14),
            suffixIcon: icon != null
                ? Icon(icon, color: AppColors.textSecondary, size: 18)
                : null,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: readOnly
                  ? BorderSide.none
                  : const BorderSide(
                      color: AppColors.cardBorder, width: 0.5),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide:
                  const BorderSide(color: AppColors.primary, width: 1),
            ),
          ),
        ),
      ],
    );
  }
}
