import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/glass_card.dart';
import '../bloc/inbox_support_bloc.dart';
import '../bloc/inbox_support_event.dart';
import '../bloc/inbox_support_state.dart';
import 'chat_conversation_page.dart';

class HelpSupportPage extends StatefulWidget {
  const HelpSupportPage({super.key});

  @override
  State<HelpSupportPage> createState() => _HelpSupportPageState();
}

class _HelpSupportPageState extends State<HelpSupportPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _subjectController = TextEditingController();
  final _messageController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _subjectController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<InboxSupportBloc>().add(
            SubmitSupportInquiry(
              fullName: _nameController.text.trim(),
              phoneNumber: _phoneController.text.trim(),
              subject: _subjectController.text.trim(),
              message: _messageController.text.trim(),
            ),
          );
    }
  }

  Future<void> _openUrl(String urlString) async {
    if (urlString.isEmpty) return;
    Uri? uri;
    if (urlString.startsWith('http://') ||
        urlString.startsWith('https://') ||
        urlString.startsWith('tel:') ||
        urlString.startsWith('mailto:')) {
      uri = Uri.parse(urlString);
    } else {
      uri = Uri.parse('https://$urlString');
    }

    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Could not open link: $urlString'),
            backgroundColor: AppColors.accentRed,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  Future<void> _makePhoneCall(String phone) async {
    final cleanPhone = phone.replaceAll(RegExp(r'[^\d+]'), '');
    await _openUrl('tel:$cleanPhone');
  }

  Future<void> _openWhatsApp(String rawNumber) async {
    final cleanNumber = rawNumber.replaceAll(RegExp(r'[^\d]'), '');
    String whatsappUrl = 'https://wa.me/$cleanNumber';
    if (rawNumber.startsWith('http://') || rawNumber.startsWith('https://')) {
      whatsappUrl = rawNumber;
    }
    await _openUrl(whatsappUrl);
  }

  Future<void> _sendEmail(String email) async {
    await _openUrl('mailto:$email');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Help & Dynamic Support',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: false,
      ),
      body: BlocListener<InboxSupportBloc, InboxSupportState>(
        listener: (context, state) {
          if (state is InquirySubmittedSuccess) {
            _nameController.clear();
            _phoneController.clear();
            _subjectController.clear();
            _messageController.clear();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Row(
                  children: [
                    const Icon(Icons.check_circle_rounded, color: Colors.white),
                    const SizedBox(width: 12),
                    Expanded(child: Text(state.message)),
                  ],
                ),
                backgroundColor: AppColors.accentGreen,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
            );
          } else if (state is InboxSupportError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppColors.accentRed,
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
        },
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Live Chat Banner Callout
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const ChatConversationPage()),
                  );
                },
                borderRadius: BorderRadius.circular(16),
                child: GlassCard(
                  padding: const EdgeInsets.all(16),
                  borderRadius: 16,
                  borderColor: AppColors.primary.withValues(alpha: 0.5),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.2),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.support_agent_rounded,
                          color: AppColors.primary,
                          size: 28,
                        ),
                      ),
                      const SizedBox(width: 14),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Need Immediate Assistance?',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            SizedBox(height: 2),
                            Text(
                              'Chat live with our customer support team',
                              style: TextStyle(
                                fontSize: 12,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: 16,
                        color: AppColors.primary,
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Dynamic Firestore Contact Info & Social Media Links Section
              const Text(
                'Contact Information',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Real-time contact info & office operating hours',
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 12),

              StreamBuilder<DocumentSnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('company_info')
                    .doc('main')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(20),
                        child: CircularProgressIndicator(color: AppColors.primary),
                      ),
                    );
                  }

                  final data = snapshot.data?.data() as Map<String, dynamic>? ?? {};

                  final phone1 = data['helpline'] as String? ?? data['phone1'] as String? ?? '01780-885841';
                  final phone2 = data['phone2'] as String? ?? '';
                  final whatsapp = data['whatsapp'] as String? ?? '01780885841';
                  final email = data['email'] as String? ?? 'info@aquapointbd.com';
                  final address = data['address'] as String? ?? 'House 12, Road 5, Block D, Banani, Dhaka';
                  final aboutUs = data['aboutUs'] as String? ?? '';
                  final workingHours = data['workingHours'] as String? ?? 'Sat - Thu: 9:00 AM - 8:00 PM';

                  final facebook = data['facebookUrl'] as String? ?? data['facebook'] as String? ?? 'https://facebook.com/aquapointbd';
                  final youtube = data['youtubeUrl'] as String? ?? data['youtube'] as String? ?? 'https://youtube.com/@aquapointbd';
                  final instagram = data['instagramUrl'] as String? ?? data['instagram'] as String? ?? 'https://instagram.com/aquapointbd';
                  final linkedin = data['linkedinUrl'] as String? ?? data['linkedin'] as String? ?? 'https://linkedin.com/company/aquapointbd';
                  final website = data['website'] as String? ?? 'https://aquapointbd.com';

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (aboutUs.isNotEmpty) ...[
                        const Text(
                          'About Us',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          aboutUs,
                          style: const TextStyle(
                            fontSize: 13,
                            color: AppColors.textSecondary,
                            height: 1.5,
                          ),
                        ),
                        const SizedBox(height: 24),
                      ],
                      // Hotline 1 & 2 Cards
                      _buildContactCard(
                        icon: Icons.phone_in_talk_rounded,
                        iconColor: AppColors.primary,
                        title: 'Hotline 1',
                        subtitle: phone1,
                        actionLabel: 'Call Now',
                        onTap: () => _makePhoneCall(phone1),
                      ),
                      if (phone2.isNotEmpty) ...[
                        const SizedBox(height: 10),
                        _buildContactCard(
                          icon: Icons.call_rounded,
                          iconColor: AppColors.secondary,
                          title: 'Hotline 2',
                          subtitle: phone2,
                          actionLabel: 'Call Now',
                          onTap: () => _makePhoneCall(phone2),
                        ),
                      ],

                      const SizedBox(height: 10),
                      // WhatsApp Direct Link Card
                      _buildContactCard(
                        icon: Icons.chat_rounded,
                        iconColor: const Color(0xFF25D366), // WhatsApp Green
                        title: 'WhatsApp Direct',
                        subtitle: whatsapp,
                        actionLabel: 'Chat on WhatsApp',
                        onTap: () => _openWhatsApp(whatsapp),
                      ),

                      const SizedBox(height: 10),
                      // Email Card
                      _buildContactCard(
                        icon: Icons.email_rounded,
                        iconColor: AppColors.accentGold,
                        title: 'Official Email',
                        subtitle: email,
                        actionLabel: 'Send Mail',
                        onTap: () => _sendEmail(email),
                      ),

                      const SizedBox(height: 10),
                      // Address Card
                      _buildContactCard(
                        icon: Icons.location_on_rounded,
                        iconColor: AppColors.accentRed,
                        title: 'Corporate Office',
                        subtitle: address,
                        actionLabel: 'View Map',
                        onTap: () => _openUrl(website),
                      ),

                      const SizedBox(height: 10),
                      // Working Hours Card
                      _buildContactCard(
                        icon: Icons.access_time_filled_rounded,
                        iconColor: AppColors.accentGreen,
                        title: 'Working Hours',
                        subtitle: workingHours,
                        actionLabel: 'Open Days',
                        onTap: null,
                      ),

                      const SizedBox(height: 24),

                      // Social Media Links Row
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Connect With Us',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),

                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                        decoration: BoxDecoration(
                          color: AppColors.cardBackground,
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(color: AppColors.cardBorder),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _buildSocialButton(
                              icon: Icons.facebook_rounded,
                              color: const Color(0xFF1877F2),
                              label: 'Facebook',
                              onTap: () => _openUrl(facebook),
                            ),
                            _buildSocialButton(
                              icon: Icons.play_circle_fill_rounded,
                              color: const Color(0xFFFF0000),
                              label: 'YouTube',
                              onTap: () => _openUrl(youtube),
                            ),
                            _buildSocialButton(
                              icon: Icons.camera_alt_rounded,
                              color: const Color(0xFFE4405F),
                              label: 'Instagram',
                              onTap: () => _openUrl(instagram),
                            ),
                            _buildSocialButton(
                              icon: Icons.business_rounded,
                              color: const Color(0xFF0A66C2),
                              label: 'LinkedIn',
                              onTap: () => _openUrl(linkedin),
                            ),
                            _buildSocialButton(
                              icon: Icons.language_rounded,
                              color: AppColors.primary,
                              label: 'Website',
                              onTap: () => _openUrl(website),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),

              const SizedBox(height: 32),

              // Support Inquiry Form Section
              const Text(
                'Send Us a Ticket Inquiry',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Submit an inquiry ticket for detailed technical assistance',
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 16),

              Form(
                key: _formKey,
                child: Column(
                  children: [
                    _buildInputField(
                      controller: _nameController,
                      label: 'Full Name',
                      hint: 'Enter your full name',
                      icon: Icons.person_outline_rounded,
                      validator: (val) =>
                          val == null || val.trim().isEmpty ? 'Full name is required' : null,
                    ),
                    const SizedBox(height: 14),
                    _buildInputField(
                      controller: _phoneController,
                      label: 'Phone Number',
                      hint: 'Enter your phone number',
                      icon: Icons.phone_outlined,
                      keyboardType: TextInputType.phone,
                      validator: (val) => val == null || val.trim().isEmpty
                          ? 'Phone number is required'
                          : null,
                    ),
                    const SizedBox(height: 14),
                    _buildInputField(
                      controller: _subjectController,
                      label: 'Subject',
                      hint: 'What is this regarding?',
                      icon: Icons.subject_rounded,
                      validator: (val) =>
                          val == null || val.trim().isEmpty ? 'Subject is required' : null,
                    ),
                    const SizedBox(height: 14),
                    _buildInputField(
                      controller: _messageController,
                      label: 'Message',
                      hint: 'Type your message here...',
                      icon: Icons.edit_note_rounded,
                      maxLines: 4,
                      validator: (val) =>
                          val == null || val.trim().isEmpty ? 'Message is required' : null,
                    ),
                    const SizedBox(height: 24),

                    BlocBuilder<InboxSupportBloc, InboxSupportState>(
                      builder: (context, state) {
                        final isSubmitting = state is InquirySubmitting;
                        return SizedBox(
                          width: double.infinity,
                          height: 52,
                          child: ElevatedButton(
                            onPressed: isSubmitting ? null : _submitForm,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              disabledBackgroundColor: AppColors.primary.withValues(alpha: 0.6),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                              elevation: 2,
                            ),
                            child: isSubmitting
                                ? const SizedBox(
                                    height: 22,
                                    width: 22,
                                    child: CircularProgressIndicator(
                                      color: Colors.black,
                                      strokeWidth: 2.5,
                                    ),
                                  )
                                : const Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.send_rounded, color: Colors.black, size: 18),
                                      SizedBox(width: 8),
                                      Text(
                                        'Submit Inquiry Ticket',
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ],
                                  ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContactCard({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required String actionLabel,
    VoidCallback? onTap,
  }) {
    return GlassCard(
      padding: EdgeInsets.zero,
      borderRadius: 16,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: iconColor.withValues(alpha: 0.15),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: iconColor, size: 22),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: AppColors.textSecondary,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 2),
          child: Text(
            subtitle,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
        ),
        trailing: onTap != null
            ? Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: iconColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      actionLabel,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: iconColor,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Icon(Icons.open_in_new_rounded, size: 12, color: iconColor),
                  ],
                ),
              )
            : null,
        onTap: onTap,
      ),
    );
  }

  Widget _buildSocialButton({
    required IconData icon,
    required Color color,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              shape: BoxShape.circle,
              border: Border.all(color: color.withValues(alpha: 0.3)),
            ),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          maxLines: maxLines,
          style: const TextStyle(color: AppColors.textPrimary, fontSize: 13),
          validator: validator,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
            prefixIcon: Icon(icon, color: AppColors.secondary, size: 18),
            filled: true,
            fillColor: AppColors.inputFill,
            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.cardBorder),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.accentRed),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.accentRed, width: 1.5),
            ),
          ),
        ),
      ],
    );
  }
}
