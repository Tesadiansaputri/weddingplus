import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:smart_wedding_planning_system/ui/chat_page.dart';
import 'package:smart_wedding_planning_system/ui/home_page.dart';

import '../helpers/google_auth.dart';
import '../helpers/session.dart';
import 'login_page.dart';

class _Task {
  String title;
  DateTime date;
  String priority;
  bool done;

  _Task({required this.title, required this.date, required this.priority})
    : done = false;
}

class RencanaPage extends StatefulWidget {
  const RencanaPage({super.key});

  @override
  State<RencanaPage> createState() => _RencanaPageState();
}

class _RencanaPageState extends State<RencanaPage> {
  // Warna disamakan dengan HomePage.
  static const Color _rose = Color(0xFFC58A85);
  static const Color _pink = Color(0xFFE7B6B0);
  static const Color _textDark = Color(0xFF3D3533);
  static const Color _brown = Color(0xFF8A5A55);
  static const Color _hint = Color(0xFF7A6F6D);
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

  // Tanggal pernikahan sementara.
  DateTime? _weddingDate;

  // Data tugas dimulai kosong agar user menambahkan sendiri.
  final List<_Task> _tasks = [];

  String _selectedFilter = 'Semua';
  bool hasNotification = true;

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  String _formatDate(DateTime date) {
    return '${date.day} ${_months[date.month - 1]} ${date.year}';
  }

  // Memilih tanggal pernikahan.
  Future<void> _pickWeddingDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _weddingDate ?? DateTime.now(),
      firstDate: DateTime(2024),
      lastDate: DateTime(2035),
    );

    if (picked != null) {
      setState(() {
        _weddingDate = picked;
      });
    }
  }

  // Memilih tanggal tugas.
  Future<DateTime?> _pickTaskDate() async {
    return await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2024),
      lastDate: DateTime(2035),
    );
  }

  // Menambahkan tugas baru.
  Future<void> _addTask() async {
    final titleController = TextEditingController();
    DateTime selectedDate = DateTime.now();
    String selectedPriority = 'Penting';

    await showDialog(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              title: const Text(
                'Tambah Tugas',
                style: TextStyle(fontFamily: _serif, color: _brown),
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: titleController,
                      decoration: InputDecoration(
                        labelText: 'Nama tugas',
                        hintText: 'Masukkan nama tugas',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: const Icon(
                        Icons.calendar_month_outlined,
                        color: _rose,
                      ),
                      title: const Text('Tanggal tugas'),
                      subtitle: Text(_formatDate(selectedDate)),
                      onTap: () async {
                        final picked = await _pickTaskDate();
                        if (picked != null) {
                          setDialogState(() {
                            selectedDate = picked;
                          });
                        }
                      },
                    ),
                    DropdownButtonFormField<String>(
                      value: selectedPriority,
                      decoration: InputDecoration(
                        labelText: 'Prioritas',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      items: const [
                        DropdownMenuItem(
                          value: 'Sangat Penting',
                          child: Text('Sangat Penting'),
                        ),
                        DropdownMenuItem(
                          value: 'Penting',
                          child: Text('Penting'),
                        ),
                        DropdownMenuItem(value: 'Biasa', child: Text('Biasa')),
                      ],
                      onChanged: (value) {
                        if (value != null) {
                          setDialogState(() {
                            selectedPriority = value;
                          });
                        }
                      },
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(dialogContext),
                  child: const Text('Batal', style: TextStyle(color: _hint)),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _rose,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () {
                    if (titleController.text.trim().isEmpty) {
                      return;
                    }

                    setState(() {
                      _tasks.add(
                        _Task(
                          title: titleController.text.trim(),
                          date: selectedDate,
                          priority: selectedPriority,
                        ),
                      );
                    });

                    Navigator.pop(dialogContext);
                    _showMessage('Tugas berhasil ditambahkan');
                  },
                  child: const Text('Simpan'),
                ),
              ],
            );
          },
        );
      },
    );

    titleController.dispose();
  }

  // Menghitung progres tugas.

  List<_Task> get _filteredTasks {
    if (_selectedFilter == 'Belum selesai') {
      return _tasks.where((task) => !task.done).toList();
    }

    if (_selectedFilter == 'Selesai') {
      return _tasks.where((task) => task.done).toList();
    }

    return _tasks;
  }

  // Efek kaca sama seperti HomePage.
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

  // Logo sama seperti HomePage.
  Widget _buildLogo() {
    return Transform.translate(
      offset: const Offset(-30.0, -23.0),
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

  // Tombol notifikasi sama seperti HomePage.
  Widget _buildBell() {
    return GestureDetector(
      onTap: () {
        setState(() {
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

  // Menu profil sama seperti HomePage.
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

  // Susunan header sama seperti HomePage.
  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _buildLogo(),
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

  // Kartu tanggal pernikahan.
  Widget _buildWeddingDateCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'HARI BAHAGIA',
                style: TextStyle(fontSize: 9, letterSpacing: 0.8, color: _hint),
              ),
              GestureDetector(
                onTap: _pickWeddingDate,
                child: Container(
                  width: 28,
                  height: 28,
                  decoration: const BoxDecoration(
                    color: Color(0xFFF8E3E0),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.edit_outlined,
                    size: 15,
                    color: _rose,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          const Icon(Icons.calendar_month_outlined, size: 22, color: _rose),
          const SizedBox(height: 5),
          Text(
            _weddingDate == null
                ? 'Belum ada rencana pernikahan'
                : _formatDate(_weddingDate!),
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontFamily: _serif,
              fontSize: 12,
              color: _textDark,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            _weddingDate == null
                ? 'Tentukan tanggal pernikahanmu untuk melihat progres persiapan.'
                : 'Tanggal hari bahagiamu sudah ditentukan.',
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 9, color: _hint),
          ),
        ],
      ),
    );
  }

  // Filter daftar tugas.
  Widget _buildFilter() {
    const filters = ['Semua', 'Belum selesai', 'Selesai'];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: filters.map((filter) {
          final selected = _selectedFilter == filter;

          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedFilter = filter;
              });
            },
            child: Container(
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
              decoration: BoxDecoration(
                color: selected ? _rose : Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: selected ? _rose : const Color(0xFFE8D6D2),
                ),
              ),
              child: Text(
                filter,
                style: TextStyle(
                  fontSize: 11,
                  color: selected ? Colors.white : _textDark,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  // Satu baris tugas.
  Widget _buildTaskItem(_Task task) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Checkbox(
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
          const SizedBox(width: 6),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  task.title,
                  style: TextStyle(
                    fontSize: 13,
                    color: _textDark,
                    decoration: task.done ? TextDecoration.lineThrough : null,
                  ),
                ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    const Icon(
                      Icons.calendar_month_outlined,
                      size: 12,
                      color: _hint,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      _formatDate(task.date),
                      style: const TextStyle(fontSize: 10, color: _hint),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 6),
          Flexible(
            child: Text(
              task.priority,
              textAlign: TextAlign.end,
              style: const TextStyle(fontSize: 9, color: _rose),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTaskList() {
    final tasks = _filteredTasks;

    if (tasks.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 22),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
        ),
        child: const Column(
          children: [
            Icon(Icons.checklist, size: 32, color: _pink),
            SizedBox(height: 8),
            Text(
              'Belum ada tugas persiapan',
              style: TextStyle(
                fontSize: 11,
                color: _textDark,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 5),
            Text(
              'Daftar tugas persiapan pernikahanmu akan ditampilkan di sini.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 9, color: _hint),
            ),
          ],
        ),
      );
    }

    return Column(children: tasks.map(_buildTaskItem).toList());
  }

  int get _completedTasks {
    return _tasks.where((task) => task.done).length;
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

  // Rencana aktif pada halaman ini.
  Widget _buildBottomNav() {
    return _glass(
      radius: 28,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _navItem(Icons.home_outlined, 'Beranda', false, () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const HomePage()),
            );
          }),
          _navItem(Icons.calendar_month_outlined, 'Rencana', false, () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const RencanaPage()),
            );
          }),
          _navItem(Icons.chat_bubble_outline, 'Chat', false, () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const ChatPage(),
              ),
            );
          }),
          _navItem(Icons.menu, 'Lainnya', false, () {
            _showMessage('Menu Lainnya belum tersedia');
          }),
        ],
      ),
    );
  }

  // Logout sama seperti HomePage.
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

  // Tampilan halaman Rencana.
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
                Padding(
                  padding: const EdgeInsets.only(top: 16, bottom: 12, left: 16),
                  child: _buildHeader(),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildWeddingDateCard(),
                        const SizedBox(height: 14),
                        _buildFilter(),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Tugas Persiapan',
                              style: TextStyle(
                                fontFamily: _serif,
                                fontSize: 14,
                                color: _textDark,
                              ),
                            ),
                            Text(
                              '$_completedTasks/${_tasks.length} selesai',
                              style: const TextStyle(fontSize: 9, color: _hint),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        _buildTaskList(),
                        const SizedBox(height: 10),
                        SizedBox(
                          width: double.infinity,
                          height: 42,
                          child: ElevatedButton.icon(
                            onPressed: _addTask,
                            icon: const Icon(Icons.add, size: 16),
                            label: const Text(
                              'Tambah Tugas',
                              style: TextStyle(fontSize: 11),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _rose,
                              foregroundColor: Colors.white,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        ),
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
