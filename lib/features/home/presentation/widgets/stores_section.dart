import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gap/gap.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../tools/presentation/pages/store_locator_page.dart';

class StoresSection extends StatelessWidget {
  const StoresSection({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('stores')
          .where('isActive', isEqualTo: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError || !snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const SizedBox.shrink();
        }

        final docs = snapshot.data!.docs;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Row(
                  children: [
                    Icon(
                      Icons.storefront_rounded,
                      color: AppColors.primary,
                      size: 20,
                    ),
                    Gap(8),
                    Text(
                      'Aqua Point Outlets',
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const StoreLocatorPage()),
                    );
                  },
                  child: const Text(
                    'View All',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const Gap(12),
            SizedBox(
              height: 140,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                itemCount: docs.length,
                itemBuilder: (context, index) {
                  final data = docs[index].data() as Map<String, dynamic>;
                  final name = data['name'] as String? ?? 'Aqua Point Branch';
                  final address = data['address'] as String? ?? '';
                  final phone = data['phone'] as String? ?? '';
                  final hours = data['openingHours'] as String? ?? '9:00 AM - 8:00 PM';
                  final mapUrl = data['googleMapUrl'] as String? ?? '';

                  return Container(
                    width: 260,
                    margin: const EdgeInsets.only(right: 12),
                    child: AppCard(
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(6),
                                  decoration: BoxDecoration(
                                    color: AppColors.primary.withValues(alpha: 0.15),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Icon(
                                    Icons.location_on_rounded,
                                    color: AppColors.primary,
                                    size: 16,
                                  ),
                                ),
                                const Gap(8),
                                Expanded(
                                  child: Text(
                                    name,
                                    style: const TextStyle(
                                      color: AppColors.textPrimary,
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              address,
                              style: const TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: 11.5,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.access_time_rounded,
                                      color: AppColors.textSecondary,
                                      size: 13,
                                    ),
                                    const Gap(4),
                                    Text(
                                      hours,
                                      style: const TextStyle(
                                        color: AppColors.textSecondary,
                                        fontSize: 10.5,
                                      ),
                                    ),
                                  ],
                                ),
                                if (phone.isNotEmpty || mapUrl.isNotEmpty)
                                  GestureDetector(
                                    onTap: () async {
                                      if (mapUrl.isNotEmpty) {
                                        final uri = Uri.parse(mapUrl);
                                        if (await canLaunchUrl(uri)) {
                                          await launchUrl(uri);
                                        }
                                      } else if (phone.isNotEmpty) {
                                        final uri = Uri.parse('tel:$phone');
                                        if (await canLaunchUrl(uri)) {
                                          await launchUrl(uri);
                                        }
                                      }
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: AppColors.primary.withValues(alpha: 0.15),
                                        borderRadius: BorderRadius.circular(6),
                                        border: Border.all(
                                          color: AppColors.primary.withValues(alpha: 0.3),
                                        ),
                                      ),
                                      child: const Text(
                                        'Directions',
                                        style: TextStyle(
                                          color: AppColors.primary,
                                          fontSize: 10.5,
                                          fontWeight: FontWeight.bold,
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
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
