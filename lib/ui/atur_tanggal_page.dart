
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:smart_wedding_planning_system/helpers/google_auth.dart';
import 'package:smart_wedding_planning_system/helpers/session.dart';
import 'package:smart_wedding_planning_system/ui/home_page.dart';
import 'package:smart_wedding_planning_system/ui/login_page.dart';
import 'rencana_page.dart';

class AturTanggalPage extends StatefulWidget {
  const AturTanggalPage({super.key});

  @override
  State<AturTanggalPage> createState() => _AturTanggalPageState();
}

class _AturTanggalPageState extends State<AturTanggalPage> {
  static const Color _rose = Color(0xFFC58A85);
  static const Color _pink = Color(0xFFE7B6B0);
  static const Color _textDark = Color(0xFF3D3533);
  static const Color _brown = Color(0xFF8A5A55);
  static const Color _hint = Color(0xFF9A8985);
  static const String _serif = 'PlayfairDisplay';

  // BACKEND:
  // Ganti tanggal awal sesuai data tanggal pernikahan dari API.
  DateTime _currentMonth = DateTime(2026, 6);
  DateTime _selectedDate = DateTime(2026, 6, 20);
  DateTime _weddingDate = DateTime(2026, 6, 20);

  // BACKEND:
  // Ganti data dummy ini dengan response API daftar acara.
  // date = null berarti acara belum ditentukan tanggalnya.
  final List<_ScheduleEvent> _events = [
    _ScheduleEvent(
      title: 'Fitting busana',
      category: 'Studio busana',
      date: DateTime(2026, 6, 6),
      time: '13.00',
      icon: Icons.checkroom_outlined,
    ),
    _ScheduleEvent(
      title: 'Kunjungan ke KUA',
      category: 'Verifikasi berkas',
      date: DateTime(2026, 6, 9),
      time: '09.00',
      icon: Icons.description_outlined,
    ),
    _ScheduleEvent(
      title: 'Technical meeting',
      category: 'Bersama vendor',
      date: DateTime(2026, 6, 18),
      time: '15.00',
      icon: Icons.groups_outlined,
    ),
    _ScheduleEvent(
      title: 'Hari pernikahan',
      category: 'Akad & resepsi',
      date: DateTime(2026, 6, 20),
      time: '08.00',
      icon: Icons.favorite_border,
      isWedding: true,
    ),
    _ScheduleEvent(
      title: 'Sesi prewedding',
      category: 'Foto & video',
      date: null,
      icon: Icons.camera_alt_outlined,
    ),
    _ScheduleEvent(
      title: 'Food tasting',
      category: 'Katering',
      date: null,
      icon: Icons.restaurant_outlined,
    ),
    _ScheduleEvent(
      title: 'Uji coba makeup',
      category: 'Rias pengantin',
      date: null,
      icon: Icons.auto_awesome_outlined,
    ),
  ];

  final List<String> _months = const [
    'Januari', 'Februari', 'Maret', 'April',
    'Mei', 'Juni', 'Juli', 'Agustus',
    'September', 'Oktober', 'November', 'Desember',
  ];

  final List<String> _days = const [
    'Sen', 'Sel', 'Rab', 'Kam', 'Jum', 'Sab', 'Min',
  ];

  String _monthName(int month) => _months[month - 1];

  String _formatDate(DateTime date) {
    return '${date.day} ${_monthName(date.month)} ${date.year}';
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: _brown,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _previousMonth() {
    setState(() {
      _currentMonth = DateTime(
        _currentMonth.year,
        _currentMonth.month - 1,
      );
    });
  }

  void _nextMonth() {
    setState(() {
      _currentMonth = DateTime(
        _currentMonth.year,
        _currentMonth.month + 1,
      );
    });
  }

  Future<void> _logout() async {
    Session.isLoggedIn = false;
    await GoogleAuth.signOut();
    if (!mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
      (route) => false,
    );
  }

  bool _sameDate(DateTime a, DateTime b) {
    return a.year == b.year &&
        a.month == b.month &&
        a.day == b.day;
  }

  bool _hasEvent(DateTime date) {
    return _events.any(
      (event) => event.date != null &&
          _sameDate(event.date!, date) &&
          !event.isWedding,
    );
  }

  bool hasNotification = true;

  List<_ScheduleEvent> get _scheduledEvents {
    return _events.where((event) => event.date != null).toList()
      ..sort((a, b) => a.date!.compareTo(b.date!));
  }

  List<_ScheduleEvent> get _unscheduledEvents {
    return _events.where((event) => event.date == null).toList();
  }

  // BACKEND:
  // Saat memilih tanggal, kirim event ID dan tanggal pilihan
  // ke endpoint update jadwal acara.
  Future<void> _chooseEventDate(_ScheduleEvent event) async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2035),
      helpText: 'Tentukan tanggal acara',
      cancelText: 'Batal',
      confirmText: 'Pilih',
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: _rose,
              onPrimary: Colors.white,
              surface: Color(0xFFFFF8F5),
              onSurface: _textDark,
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate == null) return;

    setState(() {
      event.date = pickedDate;
      _selectedDate = pickedDate;
      _currentMonth = DateTime(
        pickedDate.year,
        pickedDate.month,
      );
    });

    // BACKEND:
    // Panggil API untuk menyimpan tanggal acara.
    // Contoh data yang dikirim:
    // {
    //   "event_id": event.id,
    //   "event_date": pickedDate.toIso8601String()
    // }

    _showMessage(
      '${event.title} dijadwalkan pada ${_formatDate(pickedDate)}',
    );
  }

  Widget _glass({
    required Widget child,
    double radius = 20,
    EdgeInsetsGeometry padding = EdgeInsets.zero,
  }) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          width: double.infinity,
          padding: padding,
          decoration: BoxDecoration(
            color: const Color(0xCCFFFFFF),
            borderRadius: BorderRadius.circular(radius),
            border: Border.all(
              color: const Color(0x99FFFFFF),
            ),
          ),
          child: child,
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return Transform.translate(
      offset: const Offset(-30.0, -23.0), // Geser ke kiri dan ke atas
      child: Image.asset(
        'assets/images/logo_header.png',
        height: 60,
        // Kalau gambar belum ada, tampilkan logo sementara.
        errorBuilder: (context, error, stackTrace) {
          return const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.favorite, color: _rose, size: 26),
              SizedBox(width: 6),
              Text('wedding+', style: TextStyle(color: _rose, fontSize: 20)),
            ],
          );
        },
      ),
    );
  }

  Widget _buildBell() {
    return GestureDetector(
      onTap: () {
        setState(() {
          // Saat bel diklik, notifikasi dianggap sudah dibaca,
          // jadi titik merahnya hilang.
          hasNotification = false;
        });
        _showMessage('Belum ada notifikasi');
      },
      child: Container(
        width: 40,
        height: 40,
        decoration: const BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [BoxShadow(color: Color(0x22000000), blurRadius: 8)],
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            const Icon(Icons.notifications_none, color: _textDark, size: 22),
            // Titik merah hanya muncul kalau hasNotification bernilai true.
            if (hasNotification)
              Positioned(
                top: 9,
                right: 10,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileMenu() {
    return PopupMenuButton<String>(
      offset: const Offset(0, 46),
      onSelected: (value) {
        if (value == 'logout') {
          _logout();
        }
      },
      itemBuilder: (context) => const [
        PopupMenuItem<String>(value: 'logout', child: Text('Keluar')),
      ],
      child: Container(
        height: 40,
        padding: const EdgeInsets.fromLTRB(4, 4, 10, 4),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [BoxShadow(color: Color(0x22000000), blurRadius: 8)],
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: 16,
              backgroundColor: _pink,
              child: Icon(Icons.person, size: 18, color: Colors.white),
            ),
            SizedBox(width: 4),
            Icon(Icons.keyboard_arrow_down, color: _textDark),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Logo di sebelah kiri
        _buildLogo(),

        // Geser posisi bell dan profil ke atas dengan Transform.translate
        Transform.translate(
          offset: const Offset(0, -8),
          child: Padding(
            padding: const EdgeInsets.only(right: 20),
            child: Row(
              children: [
                _buildBell(),
                const SizedBox(width: 10),
                _buildProfileMenu(),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _headerButton(
    IconData icon,
    VoidCallback onTap, {
    bool notification = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 35,
        height: 35,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: _brown.withValues(alpha: 0.12),
              blurRadius: 10,
            ),
          ],
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Icon(icon, size: 19, color: _textDark),
            if (notification)
              Positioned(
                top: 7,
                right: 8,
                child: Container(
                  width: 6,
                  height: 6,
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Text(
          'Atur Tanggal',
          style: TextStyle(
            fontFamily: _serif,
            fontSize: 25,
            color: _textDark,
          ),
        ),
        SizedBox(height: 3),
        Text(
          'Setiap momen menuju hari bahagiamu, Deka.',
          style: TextStyle(
            fontSize: 11,
            color: _hint,
          ),
        ),
      ],
    );
  }

  Widget _buildCalendar() {
    final firstDay = DateTime(
      _currentMonth.year,
      _currentMonth.month,
      1,
    );

    // Kalender dimulai dari hari Senin.
    final offset = firstDay.weekday - 1;
    final daysInMonth = DateTime(
      _currentMonth.year,
      _currentMonth.month + 1,
      0,
    ).day;

    final totalCells = ((offset + daysInMonth) <= 35) ? 35 : 42;

    return _glass(
      radius: 16,
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 10),
      child: Column(
        children: [
          Row(
            children: [
              IconButton(
                onPressed: _previousMonth,
                icon: const Icon(
                  Icons.chevron_left,
                  color: _rose,
                  size: 22,
                ),
              ),
              Expanded(
                child: Text(
                  '${_monthName(_currentMonth.month)} ${_currentMonth.year}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontFamily: _serif,
                    fontSize: 18,
                    color: _textDark,
                  ),
                ),
              ),
              IconButton(
                onPressed: _nextMonth,
                icon: const Icon(
                  Icons.chevron_right,
                  color: _rose,
                  size: 22,
                ),
              ),
            ],
          ),
          const SizedBox(height: 3),
          Row(
            children: _days.map((day) {
              return Expanded(
                child: Center(
                  child: Text(
                    day,
                    style: TextStyle(
                      fontSize: 10,
                      color: day == 'Sab' || day == 'Min'
                          ? _rose
                          : _hint,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 8),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: totalCells,
            gridDelegate:
                const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              mainAxisSpacing: 3,
              crossAxisSpacing: 2,
              childAspectRatio: 1.05,
            ),
            itemBuilder: (context, index) {
              final dayNumber = index - offset + 1;
              final date = DateTime(
                _currentMonth.year,
                _currentMonth.month,
                dayNumber,
              );

              final isCurrentMonth =
                  date.month == _currentMonth.month;
              final isSelected = _sameDate(date, _selectedDate);
              final isWedding = _sameDate(date, _weddingDate);
              final hasEvent = _hasEvent(date);

              return GestureDetector(
                onTap: isCurrentMonth
                    ? () {
                        setState(() {
                          _selectedDate = date;
                        });
                      }
                    : null,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 29,
                      height: 29,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: isWedding
                            ? _rose
                            : isSelected
                                ? const Color(0xFFF8E8E5)
                                : Colors.transparent,
                        borderRadius: BorderRadius.circular(9),
                      ),
                      child: Text(
                        '${date.day}',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: isSelected || isWedding
                              ? FontWeight.w600
                              : FontWeight.normal,
                          color: !isCurrentMonth
                              ? const Color(0xFFCFC2BF)
                              : isWedding
                                  ? Colors.white
                                  : date.weekday >= 6
                                      ? _rose
                                      : _textDark,
                        ),
                      ),
                    ),
                    const SizedBox(height: 1),
                    if (isWedding)
                      Container(
                        width: 4,
                        height: 4,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                      )
                    else if (hasEvent)
                      Container(
                        width: 4,
                        height: 4,
                        decoration: const BoxDecoration(
                          color: _rose,
                          shape: BoxShape.circle,
                        ),
                      )
                    else
                      const SizedBox(height: 4),
                  ],
                ),
              );
            },
          ),
          const SizedBox(height: 7),
          Divider(
            color: _pink.withValues(alpha: 0.5),
            height: 1,
          ),
          const SizedBox(height: 9),
          Row(
            children: [
              Container(
                width: 6,
                height: 6,
                decoration: const BoxDecoration(
                  color: _rose,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 6),
              const Text(
                'Acara persiapan',
                style: TextStyle(fontSize: 9, color: _hint),
              ),
              const SizedBox(width: 18),
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: _rose,
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
              const SizedBox(width: 6),
              const Text(
                'Hari pernikahan',
                style: TextStyle(fontSize: 9, color: _hint),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildScheduledEvents() {
    final events = _scheduledEvents
        .where((event) =>
            event.date!.year == _currentMonth.year &&
            event.date!.month == _currentMonth.month)
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Terjadwal di bulan ini',
              style: TextStyle(
                fontFamily: _serif,
                fontSize: 16,
                color: _textDark,
              ),
            ),
            Text(
              '${events.length} acara',
              style: const TextStyle(
                fontSize: 9,
                color: _hint,
              ),
            ),
          ],
        ),
        const SizedBox(height: 9),
        _glass(
          radius: 13,
          padding: const EdgeInsets.symmetric(
            horizontal: 11,
            vertical: 7,
          ),
          child: events.isEmpty
              ? const Padding(
                  padding: EdgeInsets.all(15),
                  child: Center(
                    child: Text(
                      'Belum ada acara di bulan ini',
                      style: TextStyle(
                        fontSize: 11,
                        color: _hint,
                      ),
                    ),
                  ),
                )
              : Column(
                  children: events.map((event) {
                    final date = event.date!;
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 3),
                      child: Row(
                        children: [
                          Container(
                            width: 31,
                            height: 35,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: event.isWedding
                                  ? _rose
                                  : const Color(0xFFF9EAE7),
                              borderRadius: BorderRadius.circular(9),
                            ),
                            child: Text(
                              date.day.toString().padLeft(2, '0'),
                              style: TextStyle(
                                fontSize: 12,
                                color: event.isWedding
                                    ? Colors.white
                                    : _rose,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Flexible(
                                      child: Text(
                                        event.title,
                                        style: const TextStyle(
                                          fontSize: 11,
                                          color: _textDark,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                    if (event.isWedding) ...[
                                      const SizedBox(width: 4),
                                      const Icon(
                                        Icons.favorite,
                                        size: 10,
                                        color: _rose,
                                      ),
                                    ],
                                  ],
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  '${_days[date.weekday - 1]} · ${event.time ?? 'Belum ditentukan'} · ${event.category}',
                                  style: const TextStyle(
                                    fontSize: 8,
                                    color: _hint,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
        ),
      ],
    );
  }

  Widget _buildUnscheduledEvents() {
    final events = _unscheduledEvents;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Belum ditentukan',
              style: TextStyle(
                fontFamily: _serif,
                fontSize: 16,
                color: _textDark,
              ),
            ),
            Text(
              '${events.length} acara',
              style: const TextStyle(
                fontSize: 9,
                color: _hint,
              ),
            ),
          ],
        ),
        const SizedBox(height: 9),
        ...events.map((event) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 7),
            child: _glass(
              radius: 12,
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 9,
              ),
              child: Row(
                children: [
                  Icon(
                    event.icon,
                    color: _rose,
                    size: 19,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          event.title,
                          style: const TextStyle(
                            fontSize: 11,
                            color: _textDark,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          event.category,
                          style: const TextStyle(
                            fontSize: 9,
                            color: _hint,
                          ),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () => _chooseEventDate(event),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 9,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8EAE7),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Row(
                        children: [
                          Text(
                            'Tentukan tanggal',
                            style: TextStyle(
                              fontSize: 9,
                              color: _brown,
                            ),
                          ),
                          SizedBox(width: 3),
                          Icon(
                            Icons.chevron_right,
                            color: _brown,
                            size: 14,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }

  Widget _navItem(
    IconData icon,
    String label,
    bool selected,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 9),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 25,
              color: selected ? Colors.black : _textDark,
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                color: selected ? _textDark : _hint,
                decoration:
                    selected ? TextDecoration.underline : null,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNav() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(28),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 12,
          ),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFFFCF4F0), Color(0xFFF3D6D0)],
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _navItem(Icons.home_outlined, 'Beranda', false, () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const HomePage()),
                );
              }),
              _navItem(
                Icons.calendar_month_outlined,
                'Rencana',
                false,
                () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const RencanaPage()),
                  );
                },
              ),
              _navItem(
                Icons.chat_bubble_outline,
                'Chat',
                false,
                () => _showMessage('Fitur Chat segera hadir'),
              ),
              _navItem(
                Icons.menu,
                'Lainnya',
                false,
                () => _showMessage('Menu Lainnya segera hadir'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFBF1EE),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/home.png',
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return const DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Color(0xFFFCF4F0), Color(0xFFF3D6D0)],
                    ),
                  ),
                );
              },
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 16, bottom: 12, left: 16),
                  child: _buildHeader(),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(
                      22, 5, 22, 110,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildTitle(),
                        const SizedBox(height: 16),
                        _buildCalendar(),
                        const SizedBox(height: 13),
                        _buildScheduledEvents(),
                        const SizedBox(height: 14),
                        _buildUnscheduledEvents(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
                child: _buildBottomNav(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ScheduleEvent {
  // BACKEND:
  // Tambahkan field ID sesuai primary key dari tabel acara.
  // Contoh: final int id;

  final String title;
  final String category;
  DateTime? date;
  final String? time;
  final IconData icon;
  final bool isWedding;

  _ScheduleEvent({
    required this.title,
    required this.category,
    required this.date,
    this.time,
    required this.icon,
    this.isWedding = false,
  });
}
