import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gap/gap.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/glass_card.dart';
import '../../../../core/widgets/app_card.dart';

class StoreBranch {
  final String id;
  final String name;
  final String address;
  final String phone;
  final String hours;
  final String mapUrl;
  final bool isOpen;

  const StoreBranch({
    required this.id,
    required this.name,
    required this.address,
    required this.phone,
    required this.hours,
    required this.mapUrl,
    required this.isOpen,
  });
}

class StoreLocatorPage extends StatefulWidget {
  const StoreLocatorPage({super.key});

  @override
  State<StoreLocatorPage> createState() => _StoreLocatorPageState();
}

class _StoreLocatorPageState extends State<StoreLocatorPage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _makePhoneCall(StoreBranch branch) async {
    if (branch.phone.isEmpty) return;
    final uri = Uri.parse('tel:${branch.phone}');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      Clipboard.setData(ClipboardData(text: branch.phone));
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Copied phone number: ${branch.phone}'),
            backgroundColor: AppColors.primary,
          ),
        );
      }
    }
  }

  void _openDirections(StoreBranch branch) async {
    if (branch.mapUrl.isNotEmpty) {
      final uri = Uri.parse(branch.mapUrl);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
        return;
      }
    }

    final query = Uri.encodeComponent('${branch.name}, ${branch.address}');
    final googleMapsUrl = Uri.parse('https://www.google.com/maps/search/?api=1&query=$query');
    if (await canLaunchUrl(googleMapsUrl)) {
      await launchUrl(googleMapsUrl);
    } else {
      Clipboard.setData(ClipboardData(text: branch.address));
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Address copied to clipboard'),
            backgroundColor: AppColors.primary,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.textPrimary, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Store Locator',
          style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold, fontSize: 18),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Search Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: TextField(
              controller: _searchController,
              onChanged: (val) => setState(() => _searchQuery = val.trim().toLowerCase()),
              style: const TextStyle(color: AppColors.textPrimary, fontSize: 14),
              decoration: InputDecoration(
                hintText: 'Search branch name or area...',
                hintStyle: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
                prefixIcon: const Icon(Icons.search_rounded, color: AppColors.primary, size: 20),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear_rounded, color: AppColors.textSecondary, size: 18),
                        onPressed: () {
                          _searchController.clear();
                          setState(() => _searchQuery = '');
                        },
                      )
                    : null,
                filled: true,
                fillColor: AppColors.inputFill,
                contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(color: AppColors.cardBorder, width: 0.5),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(color: AppColors.primary, width: 1.2),
                ),
              ),
            ),
          ),

          // Real-time Firestore Stores Stream
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('stores')
                  .where('isActive', isEqualTo: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(color: AppColors.primary),
                  );
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      'Error loading store outlets: ${snapshot.error}',
                      style: const TextStyle(color: AppColors.accentRed, fontSize: 13),
                    ),
                  );
                }

                final docs = snapshot.data?.docs ?? [];
                final branches = docs.map((doc) {
                  final data = doc.data() as Map<String, dynamic>;
                  return StoreBranch(
                    id: doc.id,
                    name: data['name'] as String? ?? 'Aqua Point Branch',
                    address: data['address'] as String? ?? '',
                    phone: data['phone'] as String? ?? '',
                    hours: data['openingHours'] as String? ?? '9:00 AM - 8:00 PM',
                    mapUrl: data['googleMapUrl'] as String? ?? '',
                    isOpen: data['isActive'] !== false,
                  );
                }).where((b) {
                  if (_searchQuery.isEmpty) return true;
                  return b.name.toLowerCase().contains(_searchQuery) ||
                      b.address.toLowerCase().contains(_searchQuery);
                }).toList();

                if (branches.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          _searchQuery.isNotEmpty ? Icons.search_off_rounded : Icons.storefront_outlined,
                          size: 48,
                          color: AppColors.textSecondary.withValues(alpha: 0.5),
                        ),
                        const Gap(12),
                        Text(
                          _searchQuery.isNotEmpty
                              ? 'No branches match "$_searchQuery"'
                              : 'No store branches registered yet',
                          style: const TextStyle(color: AppColors.textSecondary, fontSize: 14),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  physics: const BouncingScrollPhysics(),
                  itemCount: branches.length,
                  itemBuilder: (context, index) {
                    final branch = branches[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: AppCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: AppColors.primary.withValues(alpha: 0.15),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: const Icon(Icons.storefront_rounded, color: AppColors.primary, size: 22),
                                ),
                                const Gap(12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        branch.name,
                                        style: const TextStyle(
                                          color: AppColors.textPrimary,
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const Gap(4),
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.circle,
                                            size: 8,
                                            color: branch.isOpen ? AppColors.accentGreen : AppColors.accentRed,
                                          ),
                                          const Gap(6),
                                          Text(
                                            branch.isOpen ? 'Open Now' : 'Closed',
                                            style: TextStyle(
                                              fontSize: 11,
                                              fontWeight: FontWeight.bold,
                                              color: branch.isOpen ? AppColors.accentGreen : AppColors.accentRed,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const Gap(12),
                            const Divider(color: AppColors.cardBorder, height: 1),
                            const Gap(12),

                            // Address
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Icon(Icons.location_on_outlined, color: AppColors.primary, size: 16),
                                const Gap(8),
                                Expanded(
                                  child: Text(
                                    branch.address,
                                    style: const TextStyle(color: AppColors.textSecondary, fontSize: 13, height: 1.3),
                                  ),
                                ),
                              ],
                            ),
                            const Gap(8),

                            // Hours
                            Row(
                              children: [
                                const Icon(Icons.access_time_rounded, color: AppColors.textSecondary, size: 16),
                                const Gap(8),
                                Expanded(
                                  child: Text(
                                    branch.hours,
                                    style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
                                  ),
                                ),
                              ],
                            ),

                            if (branch.phone.isNotEmpty) ...[
                              const Gap(8),
                              Row(
                                children: [
                                  const Icon(Icons.phone_outlined, color: AppColors.textSecondary, size: 16),
                                  const Gap(8),
                                  Text(
                                    branch.phone,
                                    style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
                                  ),
                                ],
                              ),
                            ],

                            const Gap(16),

                            // Action Buttons
                            Row(
                              children: [
                                Expanded(
                                  child: OutlinedButton.icon(
                                    onPressed: branch.phone.isNotEmpty ? () => _makePhoneCall(branch) : null,
                                    icon: const Icon(Icons.phone_rounded, size: 16),
                                    label: const Text('Call Store'),
                                    style: OutlinedButton.styleFrom(
                                      foregroundColor: AppColors.primary,
                                      side: const BorderSide(color: AppColors.primary),
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                      padding: const EdgeInsets.symmetric(vertical: 10),
                                    ),
                                  ),
                                ),
                                const Gap(12),
                                Expanded(
                                  child: ElevatedButton.icon(
                                    onPressed: () => _openDirections(branch),
                                    icon: const Icon(Icons.directions_rounded, size: 16),
                                    label: const Text('Directions'),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColors.primary,
                                      foregroundColor: AppColors.cardBackground,
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                      padding: const EdgeInsets.symmetric(vertical: 10),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
