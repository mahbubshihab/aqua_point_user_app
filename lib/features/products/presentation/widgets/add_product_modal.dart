import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter/material.dart';
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
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final CloudinaryService _cloudinaryService = CloudinaryService();
  String? _selectedImagePath;
  bool _isUploadingImage = false;
  bool _isSubmitting = false;

  @override
  void dispose() {
    _nameController.dispose();
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

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).viewInsets.bottom;

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
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
          child: Container(
            padding: EdgeInsets.only(
              left: 20,
              right: 20,
              top: 20,
              bottom: bottomPadding + 24,
            ),
            decoration: const BoxDecoration(
              color: Color(0x1F1A2236),
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              border: Border(
                top: BorderSide(color: Color(0x2B00E5FF), width: 1.5),
                left: BorderSide(color: Color(0x2B00E5FF), width: 1),
                right: BorderSide(color: Color(0x2B00E5FF), width: 1),
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
                    // Modal Handle Bar
                    Center(
                      child: Container(
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          color: AppColors.divider,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    const Gap(16),

                    // Header Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Add Custom Product',
                          style: TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        IconButton(
                          onPressed: () => Navigator.of(context).pop(),
                          icon: const Icon(
                            Icons.close_rounded,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                    const Gap(16),

                    // Field 1: Product Name
                    AppTextField(
                      label: 'Product Name',
                      hintText: 'Enter your product name',
                      controller: _nameController,
                      prefixIcon: const Icon(
                        Icons.inventory_2_outlined,
                        color: AppColors.textSecondary,
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter product name';
                        }
                        return null;
                      },
                    ),
                    const Gap(16),

                    // Field 2: Warranty Card / Product Photo
                    const Text(
                      'Warranty Card / Product Photo',
                      style: TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const Gap(6),
                    InkWell(
                      onTap: (_isUploadingImage || _isSubmitting)
                          ? null
                          : _pickAndUploadImage,
                      borderRadius: BorderRadius.circular(12),
                      child: CustomPaint(
                        painter: _DashedBorderPainter(
                          color: _selectedImagePath != null
                              ? AppColors.primary
                              : AppColors.divider,
                        ),
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          decoration: BoxDecoration(
                            color: AppColors.inputFill,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: _isUploadingImage
                              ? Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
                                    SizedBox(
                                      width: 24,
                                      height: 24,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: AppColors.primary,
                                      ),
                                    ),
                                    Gap(8),
                                    Text(
                                      'Uploading to Cloudinary...',
                                      style: TextStyle(
                                        color: AppColors.textSecondary,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
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
                                        borderRadius:
                                            BorderRadius.circular(8),
                                        child: Image.network(
                                          _selectedImagePath!,
                                          height: 60,
                                          width: 60,
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
                                            : AppColors.secondary,
                                      ),
                                      const Gap(6),
                                    ],
                                    Text(
                                      _selectedImagePath != null
                                          ? 'Cloudinary Image Ready (Tap to change)'
                                          : 'Tap to select & upload image',
                                      style: TextStyle(
                                        color: _selectedImagePath != null
                                            ? AppColors.textPrimary
                                            : AppColors.textSecondary,
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

                    // Save Product Button
                    Container(
                      width: double.infinity,
                      height: 44,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        gradient: const LinearGradient(
                          colors: [Color(0xFF60A5FA), Color(0xFF8B5CF6)],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color:
                                const Color(0xFF8B5CF6).withValues(alpha: 0.3),
                            blurRadius: 10,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap:
                              (_isSubmitting || _isUploadingImage)
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
                                : const Text(
                                    'SAVE PRODUCT',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 13.5,
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
