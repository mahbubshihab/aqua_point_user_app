import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import '../../../../core/services/cloudinary_service.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../bloc/products_bloc.dart';
import '../bloc/products_event.dart';
import '../bloc/products_state.dart';

class AddProductModal extends StatefulWidget {
  const AddProductModal({super.key});

  static Future<void> show(BuildContext context) {
    final bloc = context.read<ProductsBloc>();
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => BlocProvider.value(
        value: bloc,
        child: const AddProductModal(),
      ),
    );
  }

  @override
  State<AddProductModal> createState() => _AddProductModalState();
}

class _AddProductModalState extends State<AddProductModal> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _warrantyController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final CloudinaryService _cloudinaryService = CloudinaryService();
  String? _selectedImagePath;
  bool _isUploadingImage = false;
  bool _isSubmitting = false;

  @override
  void dispose() {
    _nameController.dispose();
    _categoryController.dispose();
    _priceController.dispose();
    _warrantyController.dispose();
    _descController.dispose();
    super.dispose();
  }

  void _onSaveProduct() {
    if (_formKey.currentState?.validate() ?? false) {
      final name = _nameController.text.trim();
      context.read<ProductsBloc>().add(AddProduct(name, _selectedImagePath));
    }
  }

  Future<void> _pickAndUploadImage() async {
    final messenger = ScaffoldMessenger.of(context);
    setState(() {
      _isUploadingImage = true;
    });

    try {
      const demoPath =
          '/Users/mahbubshihab/Development/AQUA_POINT/demo_files/WhatsApp Image 2026-08-06 at 22.10.24.jpeg';
      final file = File(demoPath);

      String? url;
      if (await file.exists()) {
        url = await _cloudinaryService.uploadImage(file);
      } else {
        final bytes = Uint8List.fromList([
          137, 80, 78, 71, 13, 10, 26, 10, 0, 0, 0, 13, 73, 72, 68, 82, 0, 0, 0, 1,
          0, 0, 0, 1, 8, 6, 0, 0, 0, 31, 213, 196, 200, 0, 0, 0, 13, 73, 68, 65, 84,
          120, 156, 99, 96, 248, 15, 0, 1, 5, 1, 2, 210, 221, 143, 203, 0, 0, 0, 0,
          73, 69, 78, 68, 174, 66, 96, 130
        ]);
        url = await _cloudinaryService.uploadImageBytes(
          bytes,
          'product_${DateTime.now().millisecondsSinceEpoch}.png',
        );
      }

      if (mounted) {
        setState(() {
          _selectedImagePath = url;
          _isUploadingImage = false;
        });
        messenger.showSnackBar(
          const SnackBar(
            content: Text('Image uploaded to Cloudinary successfully!'),
            backgroundColor: AppColors.accentGreen,
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isUploadingImage = false;
        });
        messenger.showSnackBar(
          SnackBar(
            content: Text('Cloudinary upload failed: $e'),
            backgroundColor: AppColors.accentRed,
          ),
        );
      }
    }
  }

  Widget _buildLabel(String text, Color color) {
    return Text(
      text,
      style: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: color,
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required Color textColor,
    required Color hintColor,
    required Color surfaceColor,
    required Color dividerColor,
    required Color accentColor,
    TextInputType? keyboardType,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return AppTextField(
      controller: controller,
      hintText: hint,
      keyboardType: keyboardType,
      maxLines: maxLines,
      validator: validator,
    );
  }

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).viewInsets.bottom;

    const textColorPrimary = Color(0xFF0F172A);
    const textColorSecondary = Color(0xFF64748B);
    const surfaceColor = Colors.white;
    const uploadBoxBg = Color(0xFFF8FAFC);
    const dividerColor = Color(0xFFE2E8F0);
    const accentColor = AppColors.primary;

    return BlocListener<ProductsBloc, ProductsState>(
      listener: (context, state) {
        if (state is ProductAdding) {
          setState(() {
            _isSubmitting = true;
          });
        } else if (state is ProductAddSuccess) {
          setState(() {
            _isSubmitting = false;
          });
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Custom product saved successfully!'),
              backgroundColor: AppColors.accentGreen,
            ),
          );
        } else if (state is ProductsError) {
          setState(() {
            _isSubmitting = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: AppColors.accentRed,
            ),
          );
        }
      },
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        child: Container(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 20,
            bottom: bottomPadding + 24,
          ),
          decoration: const BoxDecoration(
            color: surfaceColor,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            border: Border.fromBorderSide(
              BorderSide(color: dividerColor, width: 1),
            ),
          ),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: dividerColor,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const Gap(16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Add Custom Product',
                        style: GoogleFonts.outfit(
                          color: textColorPrimary,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const Icon(Icons.close_rounded),
                        color: textColorSecondary,
                        splashRadius: 20,
                      ),
                    ],
                  ),
                  const Gap(16),
                  _buildLabel('Product Name *', textColorSecondary),
                  const Gap(6),
                  _buildTextField(
                    controller: _nameController,
                    hint: 'e.g. Aqua Grand Plus 12L',
                    textColor: textColorPrimary,
                    hintColor: textColorSecondary,
                    surfaceColor: uploadBoxBg,
                    dividerColor: dividerColor,
                    accentColor: accentColor,
                    validator: (val) {
                      if (val == null || val.trim().isEmpty) {
                        return 'Please enter a product name';
                      }
                      return null;
                    },
                  ),
                  const Gap(14),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildLabel('Category', textColorSecondary),
                            const Gap(6),
                            _buildTextField(
                              controller: _categoryController,
                              hint: 'e.g. RO Filter',
                              textColor: textColorPrimary,
                              hintColor: textColorSecondary,
                              surfaceColor: uploadBoxBg,
                              dividerColor: dividerColor,
                              accentColor: accentColor,
                            ),
                          ],
                        ),
                      ),
                      const Gap(12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildLabel('Price (৳)', textColorSecondary),
                            const Gap(6),
                            _buildTextField(
                              controller: _priceController,
                              hint: 'e.g. 15000',
                              keyboardType: TextInputType.number,
                              textColor: textColorPrimary,
                              hintColor: textColorSecondary,
                              surfaceColor: uploadBoxBg,
                              dividerColor: dividerColor,
                              accentColor: accentColor,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const Gap(14),
                  _buildLabel('Warranty Details', textColorSecondary),
                  const Gap(6),
                  _buildTextField(
                    controller: _warrantyController,
                    hint: 'e.g. 1 Year Official Brand Warranty',
                    textColor: textColorPrimary,
                    hintColor: textColorSecondary,
                    surfaceColor: uploadBoxBg,
                    dividerColor: dividerColor,
                    accentColor: accentColor,
                  ),
                  const Gap(14),
                  _buildLabel('Description (Optional)', textColorSecondary),
                  const Gap(6),
                  _buildTextField(
                    controller: _descController,
                    hint: 'Add custom notes or specs...',
                    maxLines: 3,
                    textColor: textColorPrimary,
                    hintColor: textColorSecondary,
                    surfaceColor: uploadBoxBg,
                    dividerColor: dividerColor,
                    accentColor: accentColor,
                  ),
                  const Gap(16),
                  _buildLabel('Product Image', textColorSecondary),
                  const Gap(6),
                  GestureDetector(
                    onTap: _isUploadingImage ? null : _pickAndUploadImage,
                    child: CustomPaint(
                      painter: _DashedBorderPainter(
                        color: _selectedImagePath != null
                            ? AppColors.accentGreen
                            : dividerColor,
                      ),
                      child: Container(
                        width: double.infinity,
                        height: 90,
                        decoration: BoxDecoration(
                          color: uploadBoxBg,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: _isUploadingImage
                            ? Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const SizedBox(
                                    width: 24,
                                    height: 24,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2.5,
                                      color: accentColor,
                                    ),
                                  ),
                                  const Gap(8),
                                  Text(
                                    'Uploading to Cloudinary...',
                                    style: GoogleFonts.inter(
                                      color: textColorSecondary,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              )
                            : Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  if (_selectedImagePath != null &&
                                      _selectedImagePath!.startsWith('http')) ...[
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: Image.network(
                                        _selectedImagePath!,
                                        width: 44,
                                        height: 44,
                                        fit: BoxFit.cover,
                                        cacheWidth: 600,
                                        cacheHeight: 600,
                                      ),
                                    ),
                                    const Gap(6),
                                  ] else ...[
                                    Icon(
                                      _selectedImagePath != null
                                          ? Icons.check_circle_rounded
                                          : Icons.camera_alt_outlined,
                                      size: 30,
                                      color: _selectedImagePath != null
                                          ? AppColors.accentGreen
                                          : accentColor,
                                    ),
                                    const Gap(6),
                                  ],
                                  Text(
                                    _selectedImagePath != null
                                        ? 'Image Ready (Tap to change)'
                                        : 'Tap to upload image',
                                    style: GoogleFonts.inter(
                                      color: _selectedImagePath != null
                                          ? textColorPrimary
                                          : textColorSecondary,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                      ),
                    ),
                  ),
                  const Gap(24),
                  Container(
                    width: double.infinity,
                    height: 48,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      gradient: const LinearGradient(
                        colors: [Color(0xFF60A5FA), Color(0xFF8B5CF6)],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF8B5CF6).withValues(alpha: 0.3),
                          blurRadius: 10,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: (_isSubmitting || _isUploadingImage)
                            ? null
                            : _onSaveProduct,
                        borderRadius: BorderRadius.circular(12),
                        child: Center(
                          child: _isSubmitting
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : Text(
                                  'SAVE PRODUCT',
                                  style: GoogleFonts.inter(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _DashedBorderPainter extends CustomPainter {
  final Color color;

  const _DashedBorderPainter({
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    const double strokeWidth = 1.5;
    const double dash = 6.0;
    const double gap = 4.0;
    const double borderRadius = 12.0;

    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final RRect rrect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.width, size.height),
      const Radius.circular(borderRadius),
    );

    final Path path = Path()..addRRect(rrect);
    final Path dashPath = Path();

    for (final PathMetric metric in path.computeMetrics()) {
      double distance = 0.0;
      while (distance < metric.length) {
        dashPath.addPath(
          metric.extractPath(distance, distance + dash),
          Offset.zero,
        );
        distance += dash + gap;
      }
    }

    canvas.drawPath(dashPath, paint);
  }

  @override
  bool shouldRepaint(covariant _DashedBorderPainter oldDelegate) {
    return oldDelegate.color != color;
  }
}
