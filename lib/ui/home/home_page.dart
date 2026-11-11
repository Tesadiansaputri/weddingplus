import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:smart_wedding_planning_system/ui/asisten/asisten_page.dart';
import '../bottom_navigation.dart';
import '../../helpers/google_auth.dart';
import '../../helpers/session.dart';
import '../login_page.dart';
import '../pencarian/pencarian_page.dart';
import '../tabungan_pages.dart';
import 'chat_page.dart';
import '../atur_tanggal_page.dart';
import '../user_page.dart';
import 'package:smart_wedding_planning_system/ui/rencana/berkas_booking.dart';


// Data tugas sementara (dummy). TODO: ganti dengan data dari API.
class _Task {
  final String title;
  final String date;
  final String priority;
  bool done;

  _Task({required this.title, required this.date, required this.priority})
    : done = false;
}

// Satu kotak di menu "Lainnya".
class _MenuItem {
  final IconData icon;
  final String label;

  const _MenuItem(this.icon, this.label);
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Warna ditebak dari screenshot Figma.
  // Ganti dengan kode hex asli dari Figma kalau berbeda.
  static const Color _rose = Color(0xFFC58A85);
  static const Color _pink = Color(0xFFE7B6B0);
  static const Color _textDark = Color(0xFF3D3533);
  static const Color _brown = Color(0xFF8A5A55);
  static const Color _hint = Color(0xFF7A6F6D);

  // Font judul (serif) di desain. Kalau font PlayfairDisplay belum
  // dipasang, Flutter otomatis memakai font bawaan.
  static const String _serif = 'PlayfairDisplay';

  static const List<String> _months = [
    'Januari',
    'Februari',
    'Maret',
    'April',
    'Mei',
    'Juni',
    'Juli',
    'Agustus',
    'September',
    'Oktober',
    'November',
    'Desember',
  ];

  final List<_Task> _tasks = [];

  // Isi menu "Lainnya". Tambah atau ubah kotak di sini.
  // TODO: arahkan tiap kotak ke halaman fiturnya dengan Navigator.push.
  final List<_MenuItem> _menuItems = const [
    _MenuItem(Icons.calendar_month_outlined, 'Atur Tanggal'),
    _MenuItem(Icons.search, 'Cari Layanan'),
    _MenuItem(Icons.monetization_on_outlined, 'Tabungan'),
    _MenuItem(Icons.headset_mic_outlined, 'Asisten'),
    _MenuItem(Icons.chat_bubble_outline, 'Chat'),
    _MenuItem(Icons.event_note_outlined, 'Jadwal'),
    _MenuItem(Icons.folder_open_outlined, 'Berkas'),
  ];

  DateTime? _weddingDate;

  // true = menu "Lainnya" terbuka (panel kaca menggantikan isi Home).
  bool _menuOpen = false;

  // Titik merah di lonceng. Ubah jadi false kalau tidak ada notifikasi.
  bool hasNotification = true;

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
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

  String _formatDate(DateTime date) {
    return '${date.day} ${_months[date.month - 1]} ${date.year}';
  }

  String _progressMessage(double progress) {
    if (progress >= 1) {
      return 'Semua tugas selesai. Selamat!';
    }
    if (progress >= 0.5) {
      return 'Setengah perjalanan terlewati. Kamu hebat!';
    }
    return 'Ayo mulai persiapannya, pelan-pelan saja!';
  }

  void _handleMenuTap(String menu) {
  switch (menu) {
    case 'Cari Layanan':
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const PencarianPage(),
        ),
      );
      break;

    case 'Atur Tanggal':
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const AturTanggalPage(),
        ),
      );
      break;

    case 'Tabungan':
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const TabunganPage(),
        ),
      );
      break;

    case 'Asisten':
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const AsistenPage(),
        ),
      );
      break;

    case 'scanberkas':
    case 'Berkas':
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const BerkasBookingPage(),
        ),
      );
      break;

    case 'Chat':
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const ChatPage(),
        ),
      );
      break;

    case 'Jadwal':
      _showMessage('Fitur Jadwal segera hadir');
      break;
  }
}

  // Kotak kaca (blur + putih transparan) yang dipakai di banyak tempat.
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
            color: const Color(0x66FFFFFF),
            borderRadius: BorderRadius.circular(radius),
            border: Border.all(color: const Color(0x99FFFFFF)),
          ),
          child: child,
        ),
      ),
    );
  }

  // ---------------------------------------------------------------
  // Header: logo, lonceng, dan menu profil
  // ---------------------------------------------------------------
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

  // ---------------------------------------------------------------
  // Sapaan
  // ---------------------------------------------------------------
  Widget _buildGreeting() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Halo, ${Session.userName}!',
          style: const TextStyle(
            fontFamily: _serif,
            fontSize: 28,
            color: _textDark,
          ),
        ),
        const SizedBox(height: 4),
        const Text(
          'Mari lanjutkan persiapan pernikahanmu\nbersama Wedding+',
          style: TextStyle(fontSize: 12, color: _textDark),
        ),
      ],
    );
  }

  // ---------------------------------------------------------------
  // Kartu "Hari Bahagia": tanggal, progres tugas, pesan semangat
  // ---------------------------------------------------------------

  Widget _buildBannerCard() {
    // Hitung tugas yang sudah selesai.
    final doneTasks = _tasks.where((task) => task.done).length;
    final totalTasks = _tasks.length;

    final progress = totalTasks == 0 ? 0.0 : doneTasks / totalTasks;

    final percent = (progress * 100).round();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: _weddingDate == null
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 12),
                const Center(
                  child: Column(
                    children: [
                      Icon(
                        Icons.calendar_month_outlined,
                        size: 30,
                        color: _rose,
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Belum ada rencana pernikahan',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: _textDark,
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        'Mulai buat rencana pernikahanmu untuk '
                        'melihat tanggal bahagia dan progres '
                        'persiapan di sini.',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 10, color: _hint),
                      ),
                    ],
                  ),
                ),
              ],
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'HARI BAHAGIA ${Session.userName?.toUpperCase() ?? ''}',
                  style: const TextStyle(
                    fontSize: 10,
                    letterSpacing: 0.8,
                    color: _textDark,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(
                      Icons.calendar_month_outlined,
                      size: 16,
                      color: _rose,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      _formatDate(_weddingDate!),
                      style: const TextStyle(
                        fontFamily: _serif,
                        fontSize: 20,
                        color: _textDark,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '$doneTasks dari $totalTasks tugas selesai',
                      style: const TextStyle(fontSize: 11, color: _textDark),
                    ),
                    Text(
                      '$percent%',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: _rose,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 6,
                    color: _rose,
                    backgroundColor: const Color(0xFFF3D6D0),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  _progressMessage(progress),
                  style: const TextStyle(fontSize: 10, color: _hint),
                ),
              ],
            ),
    );
  }

  // ---------------------------------------------------------------
  // Judul bagian + "Lihat Semua"
  // ---------------------------------------------------------------
  Widget _sectionHeader(String title, {String? action}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontFamily: _serif,
            fontSize: 14,
            color: _brown,
          ),
        ),
        if (action != null)
          GestureDetector(
            onTap: () {
              _showMessage('$action (segera hadir)');
            },
            child: Text(
              action,
              style: const TextStyle(fontSize: 10, color: _textDark),
            ),
          ),
      ],
    );
  }

  // ---------------------------------------------------------------
  // Kotak fitur (dipakai di Fitur Cepat dan menu Lainnya)
  // ---------------------------------------------------------------
  Widget _featureTile(IconData icon, String label) {
    return _glass(
      radius: 16,
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: _textDark, size: 28),
          const SizedBox(height: 6),
          SizedBox(
            height: 28,
            child: Center(
              child: Text(
                label,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 10, color: _textDark),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _quickItem(IconData icon, String label) {
    return Expanded(
      child: GestureDetector(
        onTap: () => _handleMenuTap(label),
        child: _featureTile(icon, label),
      ),
    );
  }

  Widget _buildQuickFeatures() {
    return Row(
      children: [
        _quickItem(Icons.calendar_month_outlined, 'Atur Tanggal'),
        const SizedBox(width: 10),
        _quickItem(Icons.search, 'Cari Layanan'),
        const SizedBox(width: 10),
        _quickItem(Icons.monetization_on_outlined, 'Tabungan'),
        const SizedBox(width: 10),
        _quickItem(Icons.headset_mic_outlined, 'Asisten'),
        const SizedBox(width: 10),
       _quickItem(Icons.document_scanner, 'Berkas'),
        const SizedBox(width: 10),
      ],
    );
  }

  // ---------------------------------------------------------------
  // Tugas Mendatang
  // ---------------------------------------------------------------
  Widget _buildTaskRow(_Task task) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 12, 4),
      child: Row(
        children: [
          SizedBox(
            width: 28,
            height: 28,
            child: Checkbox(
              value: task.done,
              shape: const CircleBorder(),
              activeColor: _rose,
              side: const BorderSide(color: _textDark, width: 1.2),
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              visualDensity: VisualDensity.compact,
              onChanged: (value) {
                setState(() {
                  task.done = value ?? false;
                });
              },
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  task.title,
                  style: TextStyle(
                    fontSize: 14,
                    color: _textDark,
                    decoration: task.done ? TextDecoration.lineThrough : null,
                  ),
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    const Icon(
                      Icons.calendar_month_outlined,
                      size: 11,
                      color: _textDark,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      task.date,
                      style: const TextStyle(fontSize: 9, color: _hint),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Text(
            task.priority,
            style: const TextStyle(fontSize: 10, color: _rose),
          ),
        ],
      ),
    );
  }

  Widget _buildTasks() {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: const Color(0xFFF8E3E0),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Tugas Mendatang',
                  style: TextStyle(
                    fontFamily: _serif,
                    fontSize: 14,
                    color: _brown,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    _showMessage('Lihat Semua Tugas (segera hadir)');
                  },
                  child: const Text(
                    'Lihat Semua',
                    style: TextStyle(fontSize: 10, color: _rose),
                  ),
                ),
              ],
            ),
          ),
          for (final task in _tasks) _buildTaskRow(task),
          const SizedBox(height: 6),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------
  // Rekomendasi
  // ---------------------------------------------------------------
  Widget _chip(String text) {
    return Container(
      margin: const EdgeInsets.only(right: 6),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: const Color(0xFFF8E3E0),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(text, style: const TextStyle(fontSize: 8, color: _rose)),
    );
  }

  Widget _buildRecommendation() {
    // Data sementara (dummy). TODO: ganti dengan data Rekomendasi WO dari API.
    return GestureDetector(
      onTap: () {
        _showMessage('The Royale Hall (segera hadir)');
      },
      child: Container(
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Image.asset(
              'assets/images/royale_hall.png',
              width: 120,
              height: 85,
              fit: BoxFit.cover,
              // Kalau foto belum ada, tampilkan kotak pengganti.
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: 120,
                  height: 85,
                  color: const Color(0xFFF3D6D0),
                  child: const Icon(Icons.image_outlined, color: _rose),
                );
              },
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 8, 8, 8),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'The Royale Hall',
                            style: TextStyle(
                              fontFamily: _serif,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: _textDark,
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Row(
                            children: [
                              Icon(Icons.star, size: 13, color: Colors.amber),
                              SizedBox(width: 4),
                              Text(
                                '4.9 (1.9k ulasan)',
                                style: TextStyle(fontSize: 10, color: _hint),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Row(children: [_chip('Venue'), _chip('Tegal')]),
                        ],
                      ),
                    ),
                    Container(
                      width: 26,
                      height: 26,
                      decoration: const BoxDecoration(
                        color: _rose,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.chevron_right,
                        color: Colors.white,
                        size: 18,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------
  // Navigasi bawah (kaca)
  // ---------------------------------------------------------------
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
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 26, color: selected ? _textDark : _hint),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                color: selected ? _textDark : _hint,
                decoration: selected ? TextDecoration.underline : null,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNav() {
    return _glass(
      radius: 28,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _navItem(Icons.home_outlined, 'Beranda', true, () {
            navigateToBottomTab(context, AppRoutes.home, isCurrent: true);
          }),
          _navItem(Icons.calendar_month_outlined, 'Rencana', false, () {
            navigateToBottomTab(context, AppRoutes.rencana);
          }),
          _navItem(Icons.chat_bubble_outline, 'Chat', false, () {
            navigateToBottomTab(context, AppRoutes.chat);
          }),
          _navItem(Icons.person_outline, 'User', false, () {
            navigateToBottomTab(context, AppRoutes.user);
          }),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------
  // Menu "Lainnya": panel kaca berisi kotak-kotak fitur
  // ---------------------------------------------------------------
  Widget _buildMenuPanel() {
    return _glass(
      radius: 28,
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 10),
      child: Column(
        children: [
          Expanded(
            child: GridView.count(
              crossAxisCount: 4,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              childAspectRatio: 0.85,
              children: _menuItems.map((item) {
                return GestureDetector(
                  onTap: () => _handleMenuTap(item.label),
                  child: _featureTile(item.icon, item.label),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _navItem(Icons.cancel_outlined, 'Tutup', false, () {
                setState(() {
                  _menuOpen = false;
                });
              }),
              _navItem(Icons.person_outline, 'User', true, () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const UserPage()),
                );
              }),
            ],
          ),
        ],
      ),
    );
  }

  // Tampilan saat menu User terbuka: sapaan, kartu, lalu panel menu.
  Widget _buildMenuView() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildGreeting(),
          const SizedBox(height: 16),
          _buildBannerCard(),
          const SizedBox(height: 16),
          Expanded(child: _buildMenuPanel()),
        ],
      ),
    );
  }

  // Tampilan Home biasa (bisa di-scroll).
  Widget _buildHomeScroll() {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 110),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildGreeting(),
          const SizedBox(height: 16),
          _buildBannerCard(),
          const SizedBox(height: 18),
          _sectionHeader('Fitur Cepat', action: 'Lihat Semua'),
          const SizedBox(height: 10),
          _buildQuickFeatures(),
          const SizedBox(height: 18),
          _buildTasks(),
          const SizedBox(height: 18),
          _sectionHeader('Rekomendasi'),
          const SizedBox(height: 10),
          _buildRecommendation(),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------
  // Halaman
  // ---------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFBF1EE),
      body: Stack(
        children: [
          // Latar: gradien krem ke pink + bunga (hasil ekspor Figma).
          Positioned.fill(
            child: Image.asset(
              'assets/images/home.png',
              fit: BoxFit.cover,
              // Kalau gambar belum ada, pakai gradien sederhana.
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  decoration: const BoxDecoration(
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
                // Padding kanan dihapus agar header bisa mentok kiri
                Padding(
                  padding: const EdgeInsets.only(top: 16, bottom: 12, left: 16),
                  child: _buildHeader(),
                ),
                Expanded(
                  child: _menuOpen ? _buildMenuView() : _buildHomeScroll(),
                ),
              ],
            ),
          ),
          // Navigasi bawah mengambang (disembunyikan saat menu Lainnya terbuka).
          if (!_menuOpen)
            Align(
              alignment: Alignment.bottomCenter,
              child: SafeArea(
                top: false,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                  child: _buildBottomNav(),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
