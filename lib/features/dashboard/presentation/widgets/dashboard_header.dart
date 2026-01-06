import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:async'; // Untuk Timer


class DashboardHeader extends StatefulWidget {
  final String userName;
  final String userRole;
  final String? profileImageUrl;
  final VoidCallback? onProfileTap;
  final VoidCallback? onNotificationTap;
  final int? notificationCount;

  const DashboardHeader({
    super.key,
    required this.userName,
    this.userRole = 'Polda Jatim',
    this.profileImageUrl,
    this.onProfileTap,
    this.onNotificationTap,
    this.notificationCount = 0,
  });

  @override
  State<DashboardHeader> createState() => _DashboardHeaderState();
}

class _DashboardHeaderState extends State<DashboardHeader> {
  late String _currentTime;
  late String _currentDate;
  late String _greeting;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _updateDateTime();
    _setupTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _setupTimer() {
    _timer = Timer.periodic(const Duration(minutes: 1), (timer) {
      if (mounted) {
        setState(() {
          _updateDateTime();
        });
      }
    });
  }

  void _updateDateTime() {
    final now = DateTime.now();
    
    // Format waktu
    _currentTime = DateFormat('HH:mm').format(now);
    
    // Format tanggal
    _currentDate = DateFormat('EEEE, d MMMM y', 'id_ID').format(now);
    
    // Tentukan greeting berdasarkan waktu
    final hour = now.hour;
    if (hour < 12) {
      _greeting = 'Selamat Pagi';
    } else if (hour < 15) {
      _greeting = 'Selamat Siang';
    } else if (hour < 18) {
      _greeting = 'Selamat Sore';
    } else {
      _greeting = 'Selamat Malam';
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 768;
    final isSmallMobile = screenWidth < 400;

    return Container(
      width: double.infinity,
      padding: isMobile 
          ? const EdgeInsets.symmetric(horizontal: 16, vertical: 12)
          : const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(isMobile ? 18 : 21),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 4),
            spreadRadius: 1,
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white,
            const Color(0xFFF8FAFC),
          ],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Baris pertama: Greeting + Action Buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Greeting Section
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        // Greeting Icon
                        Icon(
                          _getGreetingIcon(),
                          color: const Color(0xFF3B82F6),
                          size: isMobile ? 18 : 20,
                        ),
                        const SizedBox(width: 8),
                        // Greeting Text
                        Expanded(
                          child: Text(
                            _greeting,
                            style: TextStyle(
                              fontSize: isMobile ? 14 : 16,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF1E293B),
                              letterSpacing: 0.3,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    // User Name
                    Text(
                      widget.userName.toUpperCase(),
                      style: TextStyle(
                        fontSize: isMobile ? 18 : 22,
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFF0F172A),
                        letterSpacing: 0.5,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),

              // Action Buttons
              if (!isSmallMobile)
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Notification Button
                    _buildNotificationButton(context),
                    const SizedBox(width: 12),
                    // Profile Button
                    _buildProfileButton(context),
                  ],
                ),
            ],
          ),

          const SizedBox(height: 16),

          // Baris kedua: Date & Time + Quick Stats (jika ada)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // Date & Time Section
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Date
                    Row(
                      children: [
                        Icon(
                          Icons.calendar_today_rounded,
                          color: const Color(0xFF64748B),
                          size: isMobile ? 14 : 16,
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            _currentDate,
                            style: TextStyle(
                              fontSize: isMobile ? 12 : 14,
                              color: const Color(0xFF64748B),
                              fontWeight: FontWeight.w500,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    // Time
                    Row(
                      children: [
                        Icon(
                          Icons.access_time_rounded,
                          color: const Color(0xFF64748B),
                          size: isMobile ? 14 : 16,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          _currentTime,
                          style: TextStyle(
                            fontSize: isMobile ? 14 : 18,
                            color: const Color(0xFF0F172A),
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'WIB',
                          style: TextStyle(
                            fontSize: isMobile ? 10 : 12,
                            color: const Color(0xFF94A3B8),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // User Role Badge (hanya untuk desktop/tablet)
              if (!isMobile)
                Container(
                  margin: const EdgeInsets.only(left: 12),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF10B981).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: const Color(0xFF10B981).withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: Text(
                    widget.userRole,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF047857),
                    ),
                  ),
                ),
            ],
          ),

          // Action Buttons untuk mobile kecil (jika ada)
          if (isSmallMobile) ...[
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                _buildNotificationButton(context),
                const SizedBox(width: 12),
                _buildProfileButton(context),
              ],
            ),
          ],

          // Separator Line (opsional)
          const SizedBox(height: 16),
          Container(
            height: 1,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  Colors.transparent,
                  Colors.grey.shade200,
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  IconData _getGreetingIcon() {
    final hour = DateTime.now().hour;
    if (hour < 12) return Icons.wb_sunny_outlined;
    if (hour < 15) return Icons.wb_sunny;
    if (hour < 18) return Icons.wb_twilight_outlined;
    return Icons.nightlight_round_outlined;
  }

  Widget _buildNotificationButton(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 768;
    final hasNotifications = widget.notificationCount! > 0;

    return SizedBox(
      width: isMobile ? 40 : 44,
      height: isMobile ? 40 : 44,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
              border: Border.all(
                color: Colors.grey.shade200,
                width: 1,
              ),
            ),
            child: Material(
              color: Colors.transparent,
              shape: const CircleBorder(),
              child: InkWell(
                onTap: widget.onNotificationTap ?? () {},
                borderRadius: BorderRadius.circular(30),
                child: Center(
                  child: Icon(
                    Icons.notifications_outlined,
                    color: const Color(0xFF475569),
                    size: isMobile ? 20 : 22,
                  ),
                ),
              ),
            ),
          ),
          // Notification Badge
          if (hasNotifications)
            Positioned(
              right: 0,
              top: 0,
              child: Container(
                width: 18,
                height: 18,
                decoration: const BoxDecoration(
                  color: Color(0xFFEF4444),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Color(0xFFEF4444),
                      blurRadius: 4,
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    widget.notificationCount! > 9
                        ? '9+'
                        : widget.notificationCount.toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildProfileButton(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 768;

    return SizedBox(
      width: isMobile ? 40 : 44,
      height: isMobile ? 40 : 44,
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: const Color(0xFF3B82F6).withOpacity(0.3),
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF3B82F6).withOpacity(0.2),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Material(
          shape: const CircleBorder(),
          color: Colors.transparent,
          child: InkWell(
            onTap: widget.onProfileTap ?? () {},
            borderRadius: BorderRadius.circular(30),
            child: widget.profileImageUrl != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(30),
                    child: Image.network(
                      widget.profileImageUrl!,
                      width: isMobile ? 40 : 44,
                      height: isMobile ? 40 : 44,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          _buildDefaultAvatar(),
                    ),
                  )
                : _buildDefaultAvatar(),
          ),
        ),
      ),
    );
  }

  Widget _buildDefaultAvatar() {
    final isMobile = MediaQuery.of(context).size.width < 768;
    final nameParts = widget.userName.split(' ');
    final initials = nameParts.length >= 2
        ? '${nameParts[0][0]}${nameParts[1][0]}'
        : nameParts.isNotEmpty && nameParts[0].isNotEmpty
            ? nameParts[0][0]
            : 'U';

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF3B82F6),
            const Color(0xFF1D4ED8),
          ],
        ),
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          initials.toUpperCase(),
          style: TextStyle(
            color: Colors.white,
            fontSize: isMobile ? 14 : 16,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.5,
          ),
        ),
      ),
    );
  }
}

// Versi alternatif yang lebih sederhana (tanpa state)
class DashboardHeaderSimple extends StatelessWidget {
  final String userName;
  final String greeting;
  final String date;

  const DashboardHeaderSimple({
    super.key,
    required this.userName,
    required this.greeting,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF6366F1),
            const Color(0xFF8B5CF6),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF6366F1).withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            greeting,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w500,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            userName.toUpperCase(),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.w800,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(Icons.calendar_today, color: Colors.white, size: 16),
              const SizedBox(width: 8),
              Text(
                date,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}