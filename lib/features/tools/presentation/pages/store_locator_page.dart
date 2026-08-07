import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/glass_card.dart';

class StoreBranch {
  final String name;
  final String address;
  final List<String> phones;
  final String hours;
  final String distance;
  final bool isOpen;

  const StoreBranch({
    required this.name,
    required this.address,
    required this.phones,
    required this.hours,
    required this.distance,
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

  final List<StoreBranch> _branches = const [
    StoreBranch(
      name: 'Aqua Point Main Branch (Headquarters)',
      address: 'House 72, Janata Housing Road, 3 Ring Road, Dhaka 1219',
      phones: ['01780-885841', '09613 700 750'],
      hours: 'Sun - Thu: 9:00 AM - 8:00 PM | Fri: 10:00 AM - 6:00 PM',
      distance: '1.2 km away',
      isOpen: true,
    ),
    StoreBranch(
      name: 'Aqua Point Dhanmondi Experience Center',
      address: 'House 42, Road 2A, Dhanmondi R/A, Dhaka 1209',
      phones: ['01780-885842', '09613 700 751'],
      hours: 'Sat - Thu: 10:00 AM - 9:00 PM',
      distance: '3.8 km away',
      isOpen: true,
    ),
    StoreBranch(
      name: 'Aqua Point Uttara Service Hub',
      address: 'Sector 7, Sonargaon Janapath Road, Uttara, Dhaka 1230',
      phones: ['01780-885843'],
      hours: 'Sat - Thu: 9:30 AM - 8:30 PM',
      distance: '11.5 km away',
      isOpen: true,
    ),
    StoreBranch(
      name: 'Aqua Point Chattogram Branch',
      address: 'GEC Circle, CDA Avenue, Nasirabad, Chattogram',
      phones: ['01780-885844', '09613 700 752'],
      hours: 'Sat - Thu: 9:00 AM - 7:30 PM',
      distance: '240 km away',
      isOpen: true,
    ),
    StoreBranch(
      name: 'Aqua Point Sylhet Service Point',
      address: 'Zindabazar Main Road, Chowhatta, Sylhet',
      phones: ['01780-885845'],
      hours: 'Sat - Thu: 10:00 AM - 7:00 PM',
      distance: '210 km away',
      isOpen: false,
    ),
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _makePhoneCall(StoreBranch branch) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.cardBackground,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Call ${branch.name}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const Gap(6),
              const Text(
                'Select a contact number to initiate direct phone call:',
                style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
              ),
              const Gap(16),
              ...branch.phones.map((phone) => ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.phone_rounded, color: AppColors.primary, size: 18),
                ),
                title: Text(
                  phone,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: AppColors.textSecondary),
                onTap: () {
                  Navigator.pop(context);
                  Clipboard.setData(ClipboardData(text: phone));
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Calling $phone (copied number to clipboard) 📞'),
                      backgroundColor: AppColors.primary,
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
              )),
              const Gap(10),
            ],
          ),
        );
      },
    );
  }

  void _openDirections(StoreBranch branch) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.cardBackground,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        title: Row(
          children: const [
            Icon(Icons.directions_rounded, color: AppColors.primary),
            Gap(8),
            Text(
              'Get Directions',
              style: TextStyle(color: AppColors.textPrimary, fontSize: 16),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              branch.name,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
                fontSize: 13,
              ),
            ),
            const Gap(6),
            Text(
              branch.address,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 12,
              ),
            ),
            const Gap(12),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.inputFill,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: const [
                  Icon(Icons.map_rounded, color: AppColors.accentGreen, size: 20),
                  Gap(8),
                  Expanded(
                    child: Text(
                      'Opening Google Maps navigation route...',
                      style: TextStyle(color: AppColors.textSecondary, fontSize: 11),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close', style: TextStyle(color: AppColors.textSecondary)),
          ),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            icon: const Icon(Icons.navigation_rounded, size: 16, color: Colors.white),
            label: const Text('Open Maps', style: TextStyle(color: Colors.white)),
            onPressed: () {
              Navigator.pop(context);
              Clipboard.setData(ClipboardData(text: branch.address));
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Copied store address & opening navigation route 🗺️'),
                  backgroundColor: AppColors.primary,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filteredBranches = _branches.where((branch) {
      final query = _searchQuery.toLowerCase();
      return branch.name.toLowerCase().contains(query) ||
          branch.address.toLowerCase().contains(query);
    }).toList();

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
          'Aqua Point Store Locator',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: false,
      ),
      body: Column(
        children: [
          // Search & Filter Header Bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: TextField(
              controller: _searchController,
              onChanged: (val) => setState(() => _searchQuery = val),
              style: const TextStyle(color: AppColors.textPrimary, fontSize: 13),
              decoration: InputDecoration(
                hintText: 'Search by city, branch or address...',
                hintStyle: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
                prefixIcon: const Icon(Icons.search_rounded, color: AppColors.textSecondary, size: 20),
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
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(color: AppColors.cardBorder),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(color: AppColors.cardBorder),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(color: AppColors.primary),
                ),
              ),
            ),
          ),

          // Branch List View
          Expanded(
            child: filteredBranches.isEmpty
                ? const Center(
                    child: Text(
                      'No Aqua Point branches match your search.',
                      style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    physics: const BouncingScrollPhysics(),
                    itemCount: filteredBranches.length,
                    itemBuilder: (context, index) {
                      final branch = filteredBranches[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 14),
                        child: GlassCard(
                          padding: const EdgeInsets.all(16),
                          borderRadius: 18,
                          borderColor: AppColors.primary.withValues(alpha: 0.25),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Branch Name & Status Badge
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Text(
                                      branch.name,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.textPrimary,
                                      ),
                                    ),
                                  ),
                                  const Gap(8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: (branch.isOpen ? AppColors.accentGreen : AppColors.accentRed)
                                          .withValues(alpha: 0.15),
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                        color: (branch.isOpen ? AppColors.accentGreen : AppColors.accentRed)
                                            .withValues(alpha: 0.4),
                                      ),
                                    ),
                                    child: Text(
                                      branch.isOpen ? 'OPEN NOW' : 'CLOSED',
                                      style: TextStyle(
                                        color: branch.isOpen ? AppColors.accentGreen : AppColors.accentRed,
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const Gap(10),

                              // Address
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Icon(Icons.location_on_outlined, color: AppColors.primary, size: 16),
                                  const Gap(8),
                                  Expanded(
                                    child: Text(
                                      branch.address,
                                      style: const TextStyle(
                                        color: AppColors.textSecondary,
                                        fontSize: 12,
                                        height: 1.3,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const Gap(8),

                              // Operating Hours
                              Row(
                                children: [
                                  const Icon(Icons.access_time_rounded, color: AppColors.accentGold, size: 16),
                                  const Gap(8),
                                  Expanded(
                                    child: Text(
                                      branch.hours,
                                      style: const TextStyle(
                                        color: AppColors.textSecondary,
                                        fontSize: 11.5,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const Gap(8),

                              // Phone & Distance Info
                              Row(
                                children: [
                                  const Icon(Icons.phone_outlined, color: Color(0xFF60A5FA), size: 16),
                                  const Gap(8),
                                  Text(
                                    branch.phones.join(' / '),
                                    style: const TextStyle(
                                      color: Color(0xFF60A5FA),
                                      fontSize: 11.5,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const Spacer(),
                                  Text(
                                    branch.distance,
                                    style: const TextStyle(
                                      color: AppColors.textSecondary,
                                      fontSize: 11,
                                      fontStyle: FontStyle.italic,
                                    ),
                                  ),
                                ],
                              ),
                              const Gap(14),

                              // Action Buttons: Call & Directions
                              Row(
                                children: [
                                  Expanded(
                                    child: OutlinedButton.icon(
                                      onPressed: () => _makePhoneCall(branch),
                                      style: OutlinedButton.styleFrom(
                                        padding: const EdgeInsets.symmetric(vertical: 10),
                                        side: const BorderSide(color: AppColors.primary),
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                      ),
                                      icon: const Icon(Icons.call_rounded, size: 16, color: AppColors.primary),
                                      label: const Text(
                                        'Direct Call',
                                        style: TextStyle(
                                          color: AppColors.primary,
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const Gap(10),
                                  Expanded(
                                    child: ElevatedButton.icon(
                                      onPressed: () => _openDirections(branch),
                                      style: ElevatedButton.styleFrom(
                                        padding: const EdgeInsets.symmetric(vertical: 10),
                                        backgroundColor: AppColors.primary,
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                      ),
                                      icon: const Icon(Icons.directions_rounded, size: 16, color: Colors.white),
                                      label: const Text(
                                        'Directions',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
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
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
