import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gap/gap.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_shadows.dart';
import '../../../../core/services/cloudinary_service.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_state.dart';
import '../../../auth/presentation/bloc/auth_event.dart';

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

  List<DocumentSnapshot> _addresses = [];
  bool _isLoadingAddresses = false;

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
      _loadAddresses();
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

        // Cleanup old root address field if present
        if (data.containsKey('address')) {
          await FirebaseFirestore.instance
              .collection('customers')
              .doc(_userId)
              .update({'address': FieldValue.delete()})
              .catchError((_) {});
        }

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

  Future<void> _loadAddresses() async {
    setState(() => _isLoadingAddresses = true);
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('customers')
          .doc(_userId)
          .collection('addresses')
          .orderBy('createdAt', descending: true)
          .get();

      final docs = List<DocumentSnapshot>.from(snapshot.docs);
      docs.sort((a, b) {
        final aData = a.data() as Map<String, dynamic>? ?? {};
        final bData = b.data() as Map<String, dynamic>? ?? {};
        final aPrimary = aData['isPrimary'] == true ? 1 : 0;
        final bPrimary = bData['isPrimary'] == true ? 1 : 0;
        return bPrimary.compareTo(aPrimary);
      });

      setState(() {
        _addresses = docs;
        if (_addresses.isNotEmpty) {
          final firstData =
              _addresses.first.data() as Map<String, dynamic>? ?? {};
          _addressController.text = firstData['address'] as String? ?? '';
        }
      });
    } catch (e) {
      debugPrint('Error loading addresses: $e');
    } finally {
      setState(() => _isLoadingAddresses = false);
    }
  }

  Future<void> _setPrimaryAddress(String targetDocId, String addressStr) async {
    try {
      final batch = FirebaseFirestore.instance.batch();
      for (var doc in _addresses) {
        final ref = FirebaseFirestore.instance
            .collection('customers')
            .doc(_userId)
            .collection('addresses')
            .doc(doc.id);

        if (doc.id == targetDocId) {
          batch.update(ref, {'isPrimary': true});
        } else {
          batch.update(ref, {'isPrimary': false});
        }
      }
      await batch.commit();

      _addressController.text = addressStr;
      await _loadAddresses();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Primary address updated',
              style: GoogleFonts.inter(),
            ),
            backgroundColor: AppColors.success,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      debugPrint('Error setting primary address: $e');
    }
  }

  Future<void> _addAddress(String newAddressStr) async {
    if (newAddressStr.trim().isEmpty) return;
    try {
      final isFirst = _addresses.isEmpty;
      await FirebaseFirestore.instance
          .collection('customers')
          .doc(_userId)
          .collection('addresses')
          .add({
            'address': newAddressStr.trim(),
            'isPrimary': isFirst,
            'createdAt': FieldValue.serverTimestamp(),
          });

      _addressController.text = newAddressStr.trim();
      await _loadAddresses();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Address added successfully',
              style: GoogleFonts.inter(),
            ),
            backgroundColor: AppColors.success,
          ),
        );
      }
    } catch (e) {
      debugPrint('Error adding address: $e');
    }
  }

  Future<void> _deleteAddress(String docId, String addressVal) async {
    try {
      await FirebaseFirestore.instance
          .collection('customers')
          .doc(_userId)
          .collection('addresses')
          .doc(docId)
          .delete();

      if (_addressController.text == addressVal) {
        _addressController.text = '';
      }
      await _loadAddresses();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Address removed', style: GoogleFonts.inter()),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } catch (e) {
      debugPrint('Error deleting address: $e');
    }
  }

  void _showAddAddressDialog() {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final textColorPrimary = isDark ? Colors.white : const Color(0xFF0F172A);
    final textColorSecondary = isDark ? Colors.white60 : const Color(0xFF64748B);
    final surfaceColor = isDark ? const Color(0xFF1E293B) : Colors.white;
    final inputBg = isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC);
    final borderColor = isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0);
    final accentColor = isDark ? const Color(0xFF00BCE1) : AppColors.primary;

    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: surfaceColor,
        title: Text(
          'Add New Address',
          style: GoogleFonts.outfit(
            color: textColorPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: TextField(
          controller: controller,
          autofocus: true,
          style: GoogleFonts.inter(color: textColorPrimary),
          decoration: InputDecoration(
            hintText: 'Enter complete address',
            hintStyle: GoogleFonts.inter(color: textColorSecondary),
            filled: true,
            fillColor: inputBg,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: borderColor),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: borderColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: accentColor),
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
              }
            },
            child: Text(
              'Save',
              style: GoogleFonts.inter(
                color: accentColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
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
        await FirebaseFirestore.instance
            .collection('customers')
            .doc(_userId)
            .set({'avatarUrl': url}, SetOptions(merge: true));

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Avatar updated', style: GoogleFonts.inter()),
              backgroundColor: AppColors.success,
            ),
          );
        }
      }
    } catch (e) {
      debugPrint('Error uploading image: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Upload failed: $e', style: GoogleFonts.inter()),
            backgroundColor: AppColors.error,
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
        'phone': _phoneNumber,
        'updatedAt': FieldValue.serverTimestamp(),
        'address': FieldValue.delete(),
      };

      await FirebaseFirestore.instance
          .collection('customers')
          .doc(_userId)
          .set(profileData, SetOptions(merge: true));

      // Save typed address in addresses sub-collection
      if (_addressController.text.trim().isNotEmpty) {
        final existing = _addresses.any(
          (doc) =>
              (doc['address'] as String).trim() ==
              _addressController.text.trim(),
        );
        if (!existing) {
          await FirebaseFirestore.instance
              .collection('customers')
              .doc(_userId)
              .collection('addresses')
              .add({
                'address': _addressController.text.trim(),
                'createdAt': FieldValue.serverTimestamp(),
              });
          await _loadAddresses();
        }
      }

      setState(() => _isEditing = false);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Profile saved', style: GoogleFonts.inter()),
            backgroundColor: AppColors.success,
          ),
        );
      }
    } catch (e) {
      debugPrint('Error saving profile: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to save', style: GoogleFonts.inter()),
            backgroundColor: AppColors.error,
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
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final textColorPrimary = isDark ? Colors.white : const Color(0xFF0F172A);
    final textColorSecondary = isDark
        ? Colors.white.withValues(alpha: 0.65)
        : const Color(0xFF64748B);
    final cardBgColor = isDark ? const Color(0xFF1E293B) : Colors.white;
    final primaryCardBg = isDark
        ? const Color(0xFF0F2942)
        : const Color(0xFFE0F2FE);
    final cardBorderColor = isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0);
    final accentColor = isDark ? const Color(0xFF00BCE1) : AppColors.primary;

    if (_isLoading) {
      return Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        body: Center(
          child: CircularProgressIndicator(color: accentColor),
        ),
      );
    }

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: RefreshIndicator(
        color: accentColor,
        backgroundColor: theme.cardColor,
        onRefresh: () async {
          await _loadProfile();
          await _loadAddresses();
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(
            parent: BouncingScrollPhysics(),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Gradient Header
              Container(
                decoration: BoxDecoration(
                  gradient: isDark
                      ? const LinearGradient(
                          colors: [Color(0xFF0F172A), Color(0xFF0284C7)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        )
                      : const LinearGradient(
                          colors: [AppColors.primary, AppColors.secondary],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                ),
                padding: EdgeInsets.only(
                  top: MediaQuery.of(context).padding.top + 16,
                  bottom: 32,
                  left: 24,
                  right: 24,
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Profile',
                          style: TextStyle(color: Colors.transparent),
                        ), // Spacer
                        Text(
                          'Personal Info',
                          style: GoogleFonts.outfit(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                          icon: Icon(
                            _isEditing ? Icons.close : Icons.edit_rounded,
                            color: Colors.white,
                          ),
                          onPressed: _isSaving
                              ? null
                              : () {
                                  if (_isEditing) {
                                    setState(() => _isEditing = false);
                                    _loadProfile();
                                  } else {
                                    setState(() => _isEditing = true);
                                  }
                                },
                        ),
                      ],
                    ),
                    const Gap(24),
                    GestureDetector(
                      onTap: _isEditing ? _pickAndUploadImage : null,
                      child: Stack(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 4),
                              boxShadow: isDark
                                  ? [
                                      BoxShadow(
                                        color: accentColor.withValues(alpha: 0.35),
                                        blurRadius: 16,
                                      ),
                                    ]
                                  : AppShadows.medium,
                            ),
                            child: CircleAvatar(
                              radius: 50,
                              backgroundColor: cardBgColor,
                              backgroundImage: _avatarUrl != null
                                  ? NetworkImage(_avatarUrl!)
                                  : null,
                              child: _avatarUrl == null
                                  ? Text(
                                      _nameController.text.isNotEmpty
                                          ? _nameController.text[0]
                                                .toUpperCase()
                                          : '?',
                                      style: GoogleFonts.outfit(
                                        fontSize: 36,
                                        fontWeight: FontWeight.bold,
                                        color: accentColor,
                                      ),
                                    )
                                  : null,
                            ),
                          ),
                          if (_isUploadingAvatar)
                            Positioned.fill(
                              child: Container(
                                decoration: const BoxDecoration(
                                  color: Colors.black54,
                                  shape: BoxShape.circle,
                                ),
                                child: const Center(
                                  child: SizedBox(
                                    width: 24,
                                    height: 24,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
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
                                decoration: BoxDecoration(
                                  color: cardBgColor,
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.camera_alt,
                                  color: accentColor,
                                  size: 20,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                    const Gap(16),
                    Text(
                      _nameController.text.isEmpty
                          ? 'Add Your Name'
                          : _nameController.text,
                      style: GoogleFonts.outfit(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Gap(4),
                    Text(
                      _phoneNumber,
                      style: GoogleFonts.inter(
                        color: Colors.white.withValues(alpha: 0.9),
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
              ),

              // Form Section
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (_isEditing) ...[
                      Text(
                        'Edit Details',
                        style: GoogleFonts.outfit(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: textColorPrimary,
                        ),
                      ),
                      const Gap(16),
                      _buildTextField(
                        label: 'Full Name',
                        controller: _nameController,
                        hintText: 'Enter your name',
                        isDark: isDark,
                      ),
                      const Gap(16),
                      _buildTextField(
                        label: 'Email Address',
                        controller: _emailController,
                        hintText: 'Enter your email',
                        keyboardType: TextInputType.emailAddress,
                        isDark: isDark,
                      ),
                      const Gap(24),
                      SizedBox(
                        height: 52,
                        child: ElevatedButton(
                          onPressed: _isSaving ? null : _saveProfile,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: accentColor,
                            foregroundColor: isDark ? const Color(0xFF020810) : Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: _isSaving
                              ? SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(
                                    color: isDark ? const Color(0xFF020810) : Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                              : Text(
                                  'Save Changes',
                                  style: GoogleFonts.inter(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                        ),
                      ),
                      const Gap(32),
                    ] else ...[
                      if (_emailController.text.isNotEmpty) ...[
                        _buildInfoTile(
                          icon: Icons.email_outlined,
                          title: 'Email Address',
                          subtitle: _emailController.text,
                          isDark: isDark,
                        ),
                        const Gap(16),
                      ],
                    ],

                    // Saved Addresses Section
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Saved Addresses',
                          style: GoogleFonts.outfit(
                            color: textColorPrimary,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        InkWell(
                          onTap: _showAddAddressDialog,
                          borderRadius: BorderRadius.circular(8),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.add_circle_outline_rounded,
                                  color: accentColor,
                                  size: 18,
                                ),
                                const Gap(4),
                                Text(
                                  'Add New',
                                  style: GoogleFonts.inter(
                                    color: accentColor,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Gap(16),

                    if (_isLoadingAddresses)
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: CircularProgressIndicator(
                            color: accentColor,
                            strokeWidth: 2,
                          ),
                        ),
                      )
                    else if (_addresses.isEmpty)
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: cardBgColor,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: cardBorderColor),
                          boxShadow: isDark
                              ? [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.2),
                                    blurRadius: 8,
                                  ),
                                ]
                              : AppShadows.soft,
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: accentColor.withValues(alpha: 0.15),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.location_off_outlined,
                                color: accentColor,
                                size: 24,
                              ),
                            ),
                            const Gap(16),
                            Expanded(
                              child: Text(
                                'No saved addresses yet. Tap "+ Add New" to add one.',
                                style: GoogleFonts.inter(
                                  color: textColorSecondary,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    else
                      Column(
                        children: _addresses.map((doc) {
                          final data =
                              doc.data() as Map<String, dynamic>? ?? {};
                          final addressStr = data['address'] as String? ?? '';
                          final isPrimary =
                              data['isPrimary'] == true ||
                              _addressController.text == addressStr;

                          return Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            decoration: BoxDecoration(
                              color: isPrimary ? primaryCardBg : cardBgColor,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: isPrimary
                                    ? accentColor.withValues(alpha: 0.5)
                                    : cardBorderColor,
                                width: 1,
                              ),
                              boxShadow: isDark
                                  ? [
                                      BoxShadow(
                                        color: Colors.black.withValues(alpha: 0.2),
                                        blurRadius: 8,
                                      ),
                                    ]
                                  : AppShadows.soft,
                            ),
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                borderRadius: BorderRadius.circular(16),
                                onTap: () {
                                  if (!isPrimary) {
                                    _setPrimaryAddress(doc.id, addressStr);
                                  }
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Row(
                                    children: [
                                      Radio<bool>(
                                        value: true,
                                        groupValue: isPrimary,
                                        activeColor: accentColor,
                                        onChanged: (_) {
                                          if (!isPrimary) {
                                            _setPrimaryAddress(
                                              doc.id,
                                              addressStr,
                                            );
                                          }
                                        },
                                      ),
                                      const Gap(8),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              addressStr,
                                              style: GoogleFonts.inter(
                                                color: textColorPrimary,
                                                fontSize: 15,
                                                fontWeight: isPrimary
                                                    ? FontWeight.w600
                                                    : FontWeight.normal,
                                              ),
                                            ),
                                            if (isPrimary) ...[
                                              const Gap(4),
                                              Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 8,
                                                      vertical: 2,
                                                    ),
                                                decoration: BoxDecoration(
                                                  color: accentColor,
                                                  borderRadius:
                                                      BorderRadius.circular(4),
                                                ),
                                                child: Text(
                                                  'Primary',
                                                  style: GoogleFonts.inter(
                                                    color: isDark ? const Color(0xFF020810) : Colors.white,
                                                    fontSize: 10,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ],
                                        ),
                                      ),
                                      IconButton(
                                        icon: const Icon(
                                          Icons.delete_outline,
                                          color: AppColors.error,
                                          size: 24,
                                        ),
                                        onPressed: () =>
                                            _deleteAddress(doc.id, addressStr),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),

                    const Gap(32),

                    // Logout Button
                    SizedBox(
                      height: 52,
                      child: OutlinedButton.icon(
                        onPressed: _logout,
                        icon: const Icon(Icons.logout, color: AppColors.error),
                        label: Text(
                          'Logout',
                          style: GoogleFonts.inter(
                            color: AppColors.error,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: AppColors.error),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                    const Gap(100),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool isDark,
  }) {
    final textColorPrimary = isDark ? Colors.white : const Color(0xFF0F172A);
    final textColorSecondary = isDark
        ? Colors.white.withValues(alpha: 0.65)
        : const Color(0xFF64748B);
    final cardBgColor = isDark ? const Color(0xFF1E293B) : Colors.white;
    final cardBorderColor = isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0);
    final accentColor = isDark ? const Color(0xFF00BCE1) : AppColors.primary;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardBgColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: cardBorderColor),
        boxShadow: isDark
            ? [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.2),
                  blurRadius: 8,
                ),
              ]
            : AppShadows.soft,
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: accentColor.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: accentColor, size: 24),
          ),
          const Gap(16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.inter(
                    color: textColorSecondary,
                    fontSize: 12,
                  ),
                ),
                const Gap(4),
                Text(
                  subtitle,
                  style: GoogleFonts.inter(
                    color: textColorPrimary,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    TextInputType? keyboardType,
    String? hintText,
    required bool isDark,
  }) {
    final textColorPrimary = isDark ? Colors.white : const Color(0xFF0F172A);
    final textColorSecondary = isDark ? Colors.white60 : const Color(0xFF64748B);
    final inputBgColor = isDark ? const Color(0xFF1E293B) : Colors.white;
    final cardBorderColor = isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0);
    final accentColor = isDark ? const Color(0xFF00BCE1) : AppColors.primary;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            color: textColorPrimary,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        const Gap(8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          style: GoogleFonts.inter(color: textColorPrimary, fontSize: 15),
          decoration: InputDecoration(
            filled: true,
            fillColor: inputBgColor,
            hintText: hintText,
            hintStyle: GoogleFonts.inter(
              color: textColorSecondary,
              fontSize: 14,
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: cardBorderColor),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: cardBorderColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: accentColor),
            ),
          ),
        ),
      ],
    );
  }
}
