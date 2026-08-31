import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_shadows.dart';

/// Dedicated full-screen Notifications Page fetching real-time data from Firestore.
class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  // Stream query with fallback in case index on 'createdAt' is not created yet
  Stream<QuerySnapshot<Map<String, dynamic>>> _getNotificationsStream() {
    return FirebaseFirestore.instance
        .collection('notifications')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .handleError((error) {
      debugPrint('Firestore orderBy createdAt query error, using base collection snapshot: $error');
      return FirebaseFirestore.instance.collection('notifications').snapshots();
    });
  }

  DateTime? _parseTimestamp(dynamic val) {
    if (val == null) return null;
    if (val is Timestamp) return val.toDate();
    if (val is DateTime) return val;
    if (val is int) {
      // Milliseconds or seconds epoch
      if (val > 10000000000) {
        return DateTime.fromMillisecondsSinceEpoch(val);
      } else {
        return DateTime.fromMillisecondsSinceEpoch(val * 1000);
      }
    }
    if (val is String) {
      return DateTime.tryParse(val);
    }
    return null;
  }

  String _formatTimeAgo(DateTime? dateTime) {
    if (dateTime == null) return 'Recently';
    final now = DateTime.now();
    final diff = now.difference(dateTime);

    if (diff.isNegative || diff.inSeconds < 45) {
      return 'Just now';
    } else if (diff.inMinutes < 60) {
      return '${diff.inMinutes}m ago';
    } else if (diff.inHours < 24) {
      return '${diff.inHours}h ago';
    } else if (diff.inDays == 1) {
      return 'Yesterday, ${DateFormat('h:mm a').format(dateTime)}';
    } else if (diff.inDays < 7) {
      return '${diff.inDays}d ago • ${DateFormat('h:mm a').format(dateTime)}';
    } else {
      return DateFormat('d MMM yyyy, h:mm a').format(dateTime);
    }
  }

  _NotificationTypeConfig _getTypeConfig(String? rawType) {
    final type = (rawType ?? '').trim().toLowerCase();

    switch (type) {
      case 'service':
      case 'servicing':
      case 'maintenance':
      case 'repair':
      case 'amc':
        return const _NotificationTypeConfig(
          icon: Icons.build_rounded,
          iconColor: Color(0xFF0284C7),
          bgColor: Color(0xFFE0F2FE),
          label: 'Service',
        );

      case 'offer':
      case 'offers':
      case 'discount':
      case 'promo':
      case 'promotion':
      case 'deal':
      case 'special':
        return const _NotificationTypeConfig(
          icon: Icons.local_offer_rounded,
          iconColor: Color(0xFFD97706),
          bgColor: Color(0xFFFEF3C7),
          label: 'Offer',
        );

      case 'order':
      case 'orders':
      case 'delivery':
      case 'purchase':
      case 'product':
      case 'shop':
        return const _NotificationTypeConfig(
          icon: Icons.shopping_bag_rounded,
          iconColor: Color(0xFF10B981),
          bgColor: Color(0xFFECFDF5),
          label: 'Order',
        );

      case 'reminder':
      case 'reminders':
      case 'water':
      case 'hydration':
      case 'tds':
        return const _NotificationTypeConfig(
          icon: Icons.water_drop_rounded,
          iconColor: Color(0xFF00B4DB),
          bgColor: Color(0xFFDEF3FC),
          label: 'Reminder',
        );

      case 'message':
      case 'messages':
      case 'chat':
      case 'support':
      case 'help':
        return const _NotificationTypeConfig(
          icon: Icons.chat_bubble_rounded,
          iconColor: Color(0xFF8B5CF6),
          bgColor: Color(0xFFEDE9FE),
          label: 'Support',
        );

      case 'alert':
      case 'warning':
      case 'urgent':
        return const _NotificationTypeConfig(
          icon: Icons.warning_amber_rounded,
          iconColor: Color(0xFFEF4444),
          bgColor: Color(0xFFFEE2E2),
          label: 'Alert',
        );

      case 'general':
      case 'system':
      case 'announcement':
      default:
        return const _NotificationTypeConfig(
          icon: Icons.notifications_rounded,
          iconColor: Color(0xFF0083B0),
          bgColor: Color(0xFFE0F7FA),
          label: 'Update',
        );
    }
  }

  Future<void> _markAsRead(String docId, bool currentReadStatus) async {
    if (currentReadStatus) return;
    try {
      await FirebaseFirestore.instance
          .collection('notifications')
          .doc(docId)
          .update({'isRead': true, 'read': true});
    } catch (e) {
      debugPrint('Error marking notification as read: $e');
    }
  }

  Future<void> _markAllAsRead(List<QueryDocumentSnapshot<Map<String, dynamic>>> docs) async {
    final unreadDocs = docs.where((doc) {
      final data = doc.data();
      final isRead = data['isRead'] == true || data['read'] == true;
      return !isRead;
    }).toList();

    if (unreadDocs.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'All notifications are already marked as read.',
            style: GoogleFonts.poppins(fontSize: 13),
          ),
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 2),
        ),
      );
      return;
    }

    try {
      final batch = FirebaseFirestore.instance.batch();
      for (final doc in unreadDocs) {
        batch.update(doc.reference, {'isRead': true, 'read': true});
      }
      await batch.commit();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Marked ${unreadDocs.length} notifications as read.',
              style: GoogleFonts.poppins(fontSize: 13),
            ),
            behavior: SnackBarBehavior.floating,
            backgroundColor: const Color(0xFF0083B0),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      debugPrint('Error marking all notifications as read: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    const backgroundColor = Color(0xFFF8FAFC);
    const textColorPrimary = Color(0xFF1E293B);
    const textColorSecondary = Color(0xFF64748B);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 1.0,
        centerTitle: false,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            size: 20,
            color: textColorPrimary,
          ),
          onPressed: () => Navigator.pop(context),
          tooltip: 'Back',
        ),
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Notifications',
              style: GoogleFonts.poppins(
                fontSize: 19,
                fontWeight: FontWeight.w700,
                color: textColorPrimary,
                letterSpacing: -0.3,
              ),
            ),
            const SizedBox(width: 8),
            StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: _getNotificationsStream(),
              builder: (context, snapshot) {
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const SizedBox.shrink();
                }

                final docs = snapshot.data!.docs;
                final unreadCount = docs.where((d) {
                  final data = d.data();
                  return data['isRead'] != true && data['read'] != true;
                }).length;

                if (unreadCount == 0) {
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF1F5F9),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      '${docs.length}',
                      style: GoogleFonts.poppins(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: textColorSecondary,
                      ),
                    ),
                  );
                }

                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2.5),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEFF6FF),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: const Color(0xFFBFDBFE),
                      width: 1,
                    ),
                  ),
                  child: Text(
                    '$unreadCount New',
                    style: GoogleFonts.poppins(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF0284C7),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
        actions: [
          StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
            stream: _getNotificationsStream(),
            builder: (context, snapshot) {
              final docs = snapshot.data?.docs ?? [];
              final hasUnread = docs.any((d) {
                final data = d.data();
                return data['isRead'] != true && data['read'] != true;
              });

              if (!hasUnread) return const SizedBox.shrink();

              return Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: TextButton.icon(
                  onPressed: () => _markAllAsRead(docs),
                  icon: const Icon(
                    Icons.done_all_rounded,
                    size: 18,
                    color: Color(0xFF0083B0),
                  ),
                  label: Text(
                    'Read all',
                    style: GoogleFonts.poppins(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF0083B0),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: _getNotificationsStream(),
        builder: (context, snapshot) {
          // Loading state
          if (snapshot.connectionState == ConnectionState.waiting && !snapshot.hasData) {
            return _buildShimmerLoadingList();
          }

          // Error handling or empty collection
          final docs = snapshot.data?.docs ?? [];

          if (docs.isEmpty) {
            return _buildEmptyState(context);
          }

          // Sort documents client-side by createdAt descending to guarantee order
          final sortedDocs = List<QueryDocumentSnapshot<Map<String, dynamic>>>.from(docs)
            ..sort((a, b) {
              final dateA = _parseTimestamp(a.data()['createdAt'] ?? a.data()['timestamp'] ?? a.data()['date']);
              final dateB = _parseTimestamp(b.data()['createdAt'] ?? b.data()['timestamp'] ?? b.data()['date']);
              if (dateA == null && dateB == null) return 0;
              if (dateA == null) return 1;
              if (dateB == null) return -1;
              return dateB.compareTo(dateA);
            });

          return RefreshIndicator(
            color: const Color(0xFF0083B0),
            backgroundColor: Colors.white,
            onRefresh: () async {
              await Future.delayed(const Duration(milliseconds: 500));
            },
            child: ListView.separated(
              physics: const AlwaysScrollableScrollPhysics(
                parent: BouncingScrollPhysics(),
              ),
              padding: EdgeInsets.only(
                left: 16,
                right: 16,
                top: 16,
                bottom: MediaQuery.of(context).padding.bottom + 24,
              ),
              itemCount: sortedDocs.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final doc = sortedDocs[index];
                final data = doc.data();

                final title = (data['title'] ?? 'Notification').toString();
                final body = (data['message'] ??
                        data['body'] ??
                        data['description'] ??
                        data['content'] ??
                        '')
                    .toString();
                final rawType = (data['type'] ?? data['category'])?.toString();
                final typeConfig = _getTypeConfig(rawType);
                final tag = data['tag']?.toString() ?? data['badge']?.toString();

                final isRead = data['isRead'] == true || data['read'] == true;
                final createdAt = _parseTimestamp(
                    data['createdAt'] ?? data['timestamp'] ?? data['date']);
                final timeAgoStr = _formatTimeAgo(createdAt);

                return _NotificationCard(
                  docId: doc.id,
                  title: title,
                  body: body,
                  timeAgo: timeAgoStr,
                  typeConfig: typeConfig,
                  tag: tag,
                  isRead: isRead,
                  onTap: () => _markAsRead(doc.id, isRead),
                );
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return RefreshIndicator(
          color: const Color(0xFF0083B0),
          backgroundColor: Colors.white,
          onRefresh: () async {
            await Future.delayed(const Duration(milliseconds: 500));
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(
              parent: BouncingScrollPhysics(),
            ),
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 40.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Modern Multi-layered Empty Icon Container
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            width: 140,
                            height: 140,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: RadialGradient(
                                colors: [
                                  const Color(0xFF0083B0).withValues(alpha: 0.08),
                                  Colors.transparent,
                                ],
                              ),
                            ),
                          ),
                          Container(
                            width: 96,
                            height: 96,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: const Color(0xFFF0F9FF),
                              border: Border.all(
                                color: const Color(0xFFBAE6FD).withValues(alpha: 0.6),
                                width: 2,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFF0083B0).withValues(alpha: 0.10),
                                  blurRadius: 20,
                                  offset: const Offset(0, 8),
                                ),
                              ],
                            ),
                            child: const Center(
                              child: Icon(
                                Icons.notifications_off_outlined,
                                size: 44,
                                color: Color(0xFF0284C7),
                              ),
                            ),
                          ),
                          Positioned(
                            top: 10,
                            right: 18,
                            child: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: const BoxDecoration(
                                color: Color(0xFF00B4DB),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.water_drop_rounded,
                                size: 14,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 28),

                      // Title
                      Text(
                        'No Notifications Yet',
                        style: GoogleFonts.poppins(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF1E293B),
                          letterSpacing: -0.3,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 10),

                      // Subtitle
                      Text(
                        "You're all caught up! New updates, service schedules, and announcements will appear here.",
                        style: GoogleFonts.poppins(
                          fontSize: 13.5,
                          fontWeight: FontWeight.w400,
                          color: const Color(0xFF64748B),
                          height: 1.5,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 32),

                      // Pull down hint
                      const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.arrow_downward_rounded,
                            size: 15,
                            color: Color(0xFF94A3B8),
                          ),
                          SizedBox(width: 6),
                          Text(
                            'Pull down to refresh',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF94A3B8),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildShimmerLoadingList() {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 5,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) => const _ShimmerCard(),
    );
  }
}

class _NotificationTypeConfig {
  final IconData icon;
  final Color iconColor;
  final Color bgColor;
  final String label;

  const _NotificationTypeConfig({
    required this.icon,
    required this.iconColor,
    required this.bgColor,
    required this.label,
  });
}

class _NotificationCard extends StatelessWidget {
  final String docId;
  final String title;
  final String body;
  final String timeAgo;
  final _NotificationTypeConfig typeConfig;
  final String? tag;
  final bool isRead;
  final VoidCallback onTap;

  const _NotificationCard({
    required this.docId,
    required this.title,
    required this.body,
    required this.timeAgo,
    required this.typeConfig,
    this.tag,
    required this.isRead,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cardBgColor = isRead ? Colors.white : const Color(0xFFF8FAFC);
    final borderColor = isRead ? const Color(0xFFE2E8F0) : const Color(0xFFBAE6FD);

    const titleColor = Color(0xFF0F172A);
    const bodyColor = Color(0xFF475569);
    const timeColor = Color(0xFF94A3B8);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          decoration: BoxDecoration(
            color: cardBgColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: borderColor,
              width: isRead ? 1.0 : 1.3,
            ),
            boxShadow: isRead ? AppShadows.soft : AppShadows.medium,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Dynamic Icon Container
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: typeConfig.bgColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Icon(
                    typeConfig.icon,
                    color: typeConfig.iconColor,
                    size: 22,
                  ),
                ),
              ),
              const SizedBox(width: 14),

              // Notification Title, Body & Time
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Top row: Title + Tag / Unread Dot
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            title,
                            style: GoogleFonts.poppins(
                              fontSize: 14.5,
                              fontWeight: isRead ? FontWeight.w600 : FontWeight.w700,
                              color: titleColor,
                              letterSpacing: -0.2,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),

                        // Optional Tag or Unread Indicator
                        if (tag != null && tag!.isNotEmpty)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2.5),
                            decoration: BoxDecoration(
                              color: typeConfig.bgColor,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              tag!,
                              style: GoogleFonts.poppins(
                                fontSize: 9.5,
                                fontWeight: FontWeight.w700,
                                color: typeConfig.iconColor,
                              ),
                            ),
                          )
                        else if (!isRead)
                          Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: Color(0xFF0284C7),
                              shape: BoxShape.circle,
                            ),
                          ),
                      ],
                    ),

                    if (body.isNotEmpty) ...[
                      const SizedBox(height: 5),
                      Text(
                        body,
                        style: GoogleFonts.poppins(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w400,
                          color: bodyColor,
                          height: 1.4,
                        ),
                      ),
                    ],

                    const SizedBox(height: 8),

                    // Timestamp & Category
                    Row(
                      children: [
                        const Icon(
                          Icons.schedule_rounded,
                          size: 13,
                          color: timeColor,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          timeAgo,
                          style: GoogleFonts.poppins(
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            color: timeColor,
                          ),
                        ),
                        if (!isRead) ...[
                          const SizedBox(width: 8),
                          Container(
                            width: 4,
                            height: 4,
                            decoration: const BoxDecoration(
                              color: timeColor,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Unread',
                            style: GoogleFonts.poppins(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF0284C7),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ShimmerCard extends StatefulWidget {
  const _ShimmerCard();

  @override
  State<_ShimmerCard> createState() => _ShimmerCardState();
}

class _ShimmerCardState extends State<_ShimmerCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const baseColor = Color(0xFFF1F5F9);
    const highlightColor = Color(0xFFE2E8F0);

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final shimmerValue = _controller.value;
        final color = Color.lerp(baseColor, highlightColor, shimmerValue)!;

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: const Color(0xFFE2E8F0),
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      height: 14,
                      decoration: BoxDecoration(
                        color: color,
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      width: 180,
                      height: 12,
                      decoration: BoxDecoration(
                        color: color,
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      width: 80,
                      height: 10,
                      decoration: BoxDecoration(
                        color: color,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
