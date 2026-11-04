import 'dart:ui';
import 'package:flutter/material.dart';
import '../helpers/google_auth.dart';
import '../helpers/session.dart';
import 'login_page.dart';

// Data tugas sementara (dummy). TODO: ganti dengan data dari API.
class _Task {
  final String title;
  final String date;
  final String priority;
  bool done = false;

  _Task({
    required this.title,
    required this.date,
    required this.priority,
  });
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

  final List<_Task> _tasks = [
    _Task(title: 'Task 1', date: '19 Mei 2026', priority: 'Sangat Penting'),
    _Task(title: 'Task 2', date: '23 Mei 2026', priority: 'Penting'),
    _Task(title: 'Task 3', date: '10 April 2026', priority: 'Penting'),
  ];

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
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

  // 1. Pastikan kamu punya variabel status ini di dalam kelas State kamu (di luar method, sejajar dengan variabel lain)
bool hasNotification = true; // Ubah jadi false kalau sedang tidak ada notifikasi

// 2. Widget _buildBell dengan ikon bawaan & titik merah dinamis
Widget _buildBell() {
  return GestureDetector(
    onTap: () {
      setState(() {
        // Contoh: Saat bel diklik, notifikasi dianggap sudah dibaca, jadi titik merahnya hilang
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
          // Tetap pakai ikon bawaan (tidak pakai image)
          const Icon(Icons.notifications_none, color: _textDark, size: 22),
          
          // Titik merah hanya akan muncul HANYA JIKA hasNotification bernilai true
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
          boxShadow: const [
            BoxShadow(color: Color(0x22000000), blurRadius: 8),
          ],
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
        
        // Geser posisi bell & profile ke atas menggunakan Transform.translate
        Transform.translate(
          offset: const Offset(0, -8), // Sesuaikan angka ini (-20, -25, atau -30) sampai posisinya pas sejajar
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
  // Fitur Cepat
  // ---------------------------------------------------------------
  Widget _quickItem(IconData icon, String label) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          // TODO: pindah ke halaman fitur dengan Navigator.push
          _showMessage('$label (segera hadir)');
        },
        child: _glass(
          radius: 16,
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
          child: Column(
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
        ),
      ),
    );
  }

  Widget _buildQuickFeatures() {
    return Row(
      children: [
        _quickItem(Icons.calendar_month_outlined, 'Atur Rencana'),
        const SizedBox(width: 10),
        _quickItem(Icons.search, 'Cari Layanan'),
        const SizedBox(width: 10),
        _quickItem(Icons.groups_outlined, 'Bersama'),
        const SizedBox(width: 10),
        _quickItem(Icons.headset_mic_outlined, 'Asisten'),
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
                    decoration:
                        task.done ? TextDecoration.lineThrough : null,
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
                          Row(
                            children: [_chip('Venue'), _chip('Tegal')],
                          ),
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
          _navItem(Icons.home_outlined, 'Beranda', true, () {}),
          _navItem(Icons.calendar_month_outlined, 'Rencana', false, () {
            _showMessage('Rencana (segera hadir)');
          }),
          _navItem(Icons.favorite_border, 'Favorit', false, () {
            _showMessage('Favorit (segera hadir)');
          }),
          _navItem(Icons.menu, 'Lainnya', false, () {
            // TODO: menu "Lainnya" (frame kedua di Figma)
            _showMessage('Lainnya (segera hadir)');
          }),
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
                // Padding kiri-kanan dihapus agar header bisa mentok kiri
                Padding(
                  padding: const EdgeInsets.only(top: 16, bottom: 12, left: 16),
                  child: _buildHeader(),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 110),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildGreeting(),
                        const SizedBox(height: 16),
                        // Kartu kaca besar (kosong di desain).
                        // TODO: isi dengan hitung mundur hari H / banner.
                        _glass(child: const SizedBox(height: 150)),
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
                  ),
                ),
              ],
            ),
          ),
          // Navigasi bawah mengambang di atas konten.
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