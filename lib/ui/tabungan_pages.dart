
import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

import 'bottom_navigation.dart';

class TabunganPage extends StatefulWidget {
  const TabunganPage({super.key});

  @override
  State<TabunganPage> createState() => _TabunganPageState();
}

class _TabunganPageState extends State<TabunganPage> {
  static const Color _rose = Color(0xFFC58A85);
  static const Color _pink = Color(0xFFE7B6B0);
  static const Color _textDark = Color(0xFF3D3533);
  static const Color _brown = Color(0xFF8A5A55);
  static const Color _hint = Color(0xFF9A8985);
  static const String _serif = 'PlayfairDisplay';

  // ============================================================
  // TODO BACKEND 1:
  // Sesuaikan alamat IP dan port dengan backend NestJS.
  // Android Emulator menggunakan 10.0.2.2 untuk localhost komputer.
  // ============================================================

  static const String _baseUrl = 'http://10.0.2.2:3000';

  // ============================================================
  // TODO BACKEND 2:
  // Sesuaikan endpoint GET dan POST dengan route NestJS.
  // ============================================================

  static const String _tabunganEndpoint = '/tabungan';
  static const String _createEndpoint = '/tabungan';

  // TODO BACKEND 3:
  // Isi token JWT dari hasil login jika endpoint membutuhkan autentikasi.
  String? _token;

  final TextEditingController _budgetController =
      TextEditingController();

  // Data akan diisi dari backend, bukan data contoh.
  List<_SavingRecord> _records = [];

  bool _isLoading = false;
  bool _isSaving = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchTabungan();
  }

  @override
  void dispose() {
    _budgetController.dispose();
    super.dispose();
  }

  // ============================================================
  // PERHITUNGAN TOTAL TABUNGAN
  // ============================================================

  int get _totalSavings {
    return _records.fold(
      0,
      (sum, item) => sum + item.amount,
    );
  }

  String _formatRupiah(int amount) {
    final formatted = amount.toString().replaceAllMapped(
      RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
      (match) => '${match[1]}.',
    );

    return 'Rp$formatted';
  }

  String _formatDate(DateTime date) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'Mei',
      'Jun',
      'Jul',
      'Agu',
      'Sep',
      'Okt',
      'Nov',
      'Des',
    ];

    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }

  String _formatTime(DateTime date) {
    return '${date.hour.toString().padLeft(2, '0')}.'
        '${date.minute.toString().padLeft(2, '0')} WIB';
  }

  void _showMessage(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: _brown,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  // ============================================================
  // TODO BACKEND 4:
  // MENGAMBIL DATA TABUNGAN DARI BACKEND (HTTP GET)
  //
  // Asumsi response:
  // [
  //   {
  //     "id": 1,
  //     "nominal": 1500000,
  //     "nama": "Nadia",
  //     "createdAt": "2026-11-07T09:30:00"
  //   }
  // ]
  //
  // Jika backend menggunakan response.data atau response.items,
  // ubah bagian pengambilan data di bawah.
  // ============================================================

  Future<void> _fetchTabungan() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final response = await http.get(
        Uri.parse('$_baseUrl$_tabunganEndpoint'),
        headers: {
          'Content-Type': 'application/json',
          if (_token != null)
            'Authorization': 'Bearer $_token',
        },
      );

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);

        // TODO BACKEND:
        // Sesuaikan dengan struktur JSON response NestJS.
        final dynamic rawData = decoded is List
            ? decoded
            : decoded['data'];

        if (rawData is! List) {
          throw Exception(
            'Format response backend bukan berupa List',
          );
        }

        final List<_SavingRecord> loadedRecords =
            rawData.map<_SavingRecord>((item) {
          // TODO BACKEND:
          // Sesuaikan nama field berikut dengan response API.
          final nominal = (item['nominal'] as num).toInt();

          final nama = (item['nama'] ?? 'Anda').toString();

          final createdAt = DateTime.parse(
            item['createdAt'].toString(),
          );

          return _SavingRecord(
            initial: nama.isNotEmpty
                ? nama.substring(0, 1).toUpperCase()
                : 'A',
            amount: nominal,
            date: _formatDate(createdAt),
            time: _formatTime(createdAt),
            owner: nama,
          );
        }).toList();

        if (!mounted) return;

        setState(() {
          _records = loadedRecords;
        });
      } else {
        throw Exception(
          'Gagal mengambil data: ${response.statusCode} '
          '${response.body}',
        );
      }
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _errorMessage = e.toString();
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  // ============================================================
  // TODO BACKEND 5:
  // MENAMBAHKAN TABUNGAN KE BACKEND (HTTP POST)
  //
  // Asumsi body:
  // {
  //   "nominal": 500000
  // }
  //
  // Sesuaikan dengan DTO yang digunakan NestJS.
  // ============================================================

  Future<void> _addSaving() async {
    final amount = int.tryParse(_budgetController.text);

    if (amount == null || amount <= 0) {
      _showMessage(
        'Masukkan nominal tabungan terlebih dahulu',
      );
      return;
    }

    setState(() {
      _isSaving = true;
    });

    try {
      final response = await http.post(
        Uri.parse('$_baseUrl$_createEndpoint'),
        headers: {
          'Content-Type': 'application/json',
          if (_token != null)
            'Authorization': 'Bearer $_token',
        },

        // TODO BACKEND:
        // Tambahkan field lain jika DTO membutuhkannya.
        body: jsonEncode({
          'nominal': amount,
        }),
      );

      if (response.statusCode == 200 ||
          response.statusCode == 201) {
        _budgetController.clear();

        // Ambil ulang data setelah berhasil menyimpan.
        await _fetchTabungan();

        if (!mounted) return;

        _showMessage(
          'Catatan tabungan berhasil ditambahkan',
        );
      } else {
        throw Exception(
          'Gagal menyimpan data: ${response.statusCode} '
          '${response.body}',
        );
      }
    } catch (e) {
      _showMessage('Terjadi kesalahan: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  // ============================================================
  // KOMPONEN TAMPILAN
  // ============================================================

  Widget _glass({
    required Widget child,
    double radius = 24,
    EdgeInsetsGeometry padding = EdgeInsets.zero,
  }) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: 10,
          sigmaY: 10,
        ),
        child: Container(
          width: double.infinity,
          padding: padding,
          decoration: BoxDecoration(
            color: const Color(0x99FFFFFF),
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

  Widget _buildHeader() {
    return Row(
      children: [
        Image.asset(
          'assets/images/logo_header.png',
          width: 125,
          height: 42,
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) {
            return const Text(
              'wedding+',
              style: TextStyle(
                fontFamily: _serif,
                fontSize: 23,
                color: _rose,
              ),
            );
          },
        ),
        const Spacer(),
        _headerButton(
          Icons.notifications_none,
          () => _showMessage('Belum ada notifikasi'),
          notification: true,
        ),
        const SizedBox(width: 7),
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 7,
            vertical: 5,
          ),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.9),
            borderRadius: BorderRadius.circular(25),
            boxShadow: [
              BoxShadow(
                color: _brown.withValues(alpha: 0.12),
                blurRadius: 10,
              ),
            ],
          ),
          child: Row(
            children: [
              const CircleAvatar(
                radius: 11,
                backgroundColor: _pink,
                child: Icon(
                  Icons.person,
                  size: 15,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 5),
              const Icon(
                Icons.keyboard_arrow_down,
                size: 17,
                color: _textDark,
              ),
            ],
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
        width: 34,
        height: 34,
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
            Icon(
              icon,
              size: 19,
              color: _textDark,
            ),
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
          'Tabungan Bersama',
          style: TextStyle(
            fontFamily: _serif,
            fontSize: 23,
            color: _textDark,
          ),
        ),
        SizedBox(height: 3),
        Text(
          'Catat langkah kecil menuju hari bahagia',
          style: TextStyle(
            fontSize: 11,
            color: _hint,
          ),
        ),
      ],
    );
  }

  Widget _buildTotalCard() {
    return _glass(
      radius: 14,
      padding: const EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Tabungan pernikahan Nadia & Arif',
                  style: TextStyle(
                    fontSize: 10,
                    color: _hint,
                  ),
                ),
              ),
              const Icon(
                Icons.favorite_border,
                color: _rose,
                size: 18,
              ),
            ],
          ),
          const SizedBox(height: 5),
          Text(
            _formatRupiah(_totalSavings),
            style: const TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
              color: _rose,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total nominal tercatat bersama',
                style: TextStyle(
                  fontSize: 10,
                  color: _hint,
                ),
              ),
              Text(
                '${_records.length} pencatat${_records.length > 1 ? 'an' : ''}',
                style: const TextStyle(
                  fontSize: 9,
                  color: _rose,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPartnerCard() {
    return _glass(
      radius: 14,
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.people_outline,
                size: 17,
                color: _rose,
              ),
              const SizedBox(width: 6),
              const Expanded(
                child: Text(
                  'Rencanakan berdua',
                  style: TextStyle(
                    fontFamily: _serif,
                    fontSize: 15,
                    color: _textDark,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  _showMessage(
                    'Fitur undang pasangan segera hadir',
                  );
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF0ED),
                    borderRadius: BorderRadius.circular(9),
                  ),
                  child: const Text(
                    'Undang Pasangan',
                    style: TextStyle(
                      fontSize: 9,
                      color: _rose,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 9),
          const Text(
            'Pasangan yang diundang dapat mencatat dan memantau satu tabungan yang sama.',
            style: TextStyle(
              fontSize: 10,
              height: 1.5,
              color: _hint,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputCard() {
    return _glass(
      radius: 12,
      padding: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 9,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Nominal yang ingin dicatat',
            style: TextStyle(
              fontSize: 9,
              color: _hint,
            ),
          ),
          Row(
            children: [
              const Text(
                'Rp',
                style: TextStyle(
                  fontSize: 16,
                  color: _rose,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TextField(
                  controller: _budgetController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  style: const TextStyle(
                    fontSize: 16,
                    color: _textDark,
                  ),
                  decoration: const InputDecoration(
                    hintText: '0',
                    hintStyle: TextStyle(
                      color: _hint,
                    ),
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAddButton() {
    return SizedBox(
      width: double.infinity,
      height: 42,
      child: ElevatedButton.icon(
        onPressed: _isSaving ? null : _addSaving,
        icon: _isSaving
            ? const SizedBox(
                width: 15,
                height: 15,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
            : const Icon(
                Icons.add,
                size: 18,
              ),
        label: Text(
          _isSaving
              ? 'Menyimpan...'
              : 'Catat Tabungan',
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
          ),
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
    );
  }

  Widget _buildHistory() {
    if (_isLoading) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: CircularProgressIndicator(
            color: _rose,
          ),
        ),
      );
    }

    if (_errorMessage != null) {
      return _glass(
        radius: 13,
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Icon(
              Icons.error_outline,
              color: _rose,
              size: 25,
            ),
            const SizedBox(height: 7),
            const Text(
              'Gagal memuat riwayat tabungan',
              style: TextStyle(
                fontSize: 11,
                color: _textDark,
              ),
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: _fetchTabungan,
              child: const Text(
                'Coba Lagi',
                style: TextStyle(color: _rose),
              ),
            ),
          ],
        ),
      );
    }

    if (_records.isEmpty) {
      return _glass(
        radius: 13,
        padding: const EdgeInsets.all(20),
        child: const Center(
          child: Text(
            'Belum ada catatan tabungan',
            style: TextStyle(
              fontSize: 10,
              color: _hint,
            ),
          ),
        ),
      );
    }

    return _glass(
      radius: 13,
      child: Column(
        children: List.generate(_records.length, (index) {
          final record = _records[index];

          return Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 10,
            ),
            decoration: BoxDecoration(
              border: index == _records.length - 1
                  ? null
                  : Border(
                      bottom: BorderSide(
                        color: _pink.withValues(alpha: 0.5),
                      ),
                    ),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 14,
                  backgroundColor: const Color(0xFFFFEFEC),
                  child: Text(
                    record.initial,
                    style: const TextStyle(
                      fontSize: 9,
                      color: _rose,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _formatRupiah(record.amount),
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: _textDark,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        '${record.date} · ${record.time}',
                        style: const TextStyle(
                          fontSize: 8,
                          color: _hint,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  'Oleh ${record.owner}',
                  style: const TextStyle(
                    fontSize: 8,
                    color: _hint,
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }

  // ============================================================
  // BOTTOM NAVIGATION
  // ============================================================

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
            Icon(
              icon,
              size: 26,
              color: selected ? _textDark : _hint,
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                color: selected ? _textDark : _hint,
                decoration: selected
                    ? TextDecoration.underline
                    : null,
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
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 10,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _navItem(
            Icons.home_outlined,
            'Beranda',
            false,
            () => navigateToBottomTab(context, AppRoutes.home),
          ),
          _navItem(
            Icons.calendar_month_outlined,
            'Rencana',
            true,
            () => navigateToBottomTab(
              context,
              AppRoutes.rencana,
              isCurrent: true,
            ),
          ),
          _navItem(
            Icons.chat_bubble_outline,
            'Chat',
            false,
            () => navigateToBottomTab(context, AppRoutes.chat),
          ),
          _navItem(
            Icons.person_outline,
            'User',
            false,
            () => navigateToBottomTab(context, AppRoutes.user),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // BUILD HALAMAN
  // ============================================================

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
                      colors: [
                        Color(0xFFFCF4F0),
                        Color(0xFFF3D6D0),
                      ],
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
                  padding: const EdgeInsets.fromLTRB(
                    20,
                    8,
                    20,
                    8,
                  ),
                  child: _buildHeader(),
                ),

                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(
                      22,
                      4,
                      22,
                      110,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildTitle(),

                        const SizedBox(height: 12),

                        _buildTotalCard(),

                        const SizedBox(height: 10),

                        _buildPartnerCard(),

                        const SizedBox(height: 15),

                        const Text(
                          'Catat tabunganmu',
                          style: TextStyle(
                            fontFamily: _serif,
                            fontSize: 15,
                            color: _textDark,
                          ),
                        ),

                        const SizedBox(height: 7),

                        _buildInputCard(),

                        const SizedBox(height: 8),

                        _buildAddButton(),

                        const SizedBox(height: 8),

                        const Row(
                          children: [
                            Icon(
                              Icons.info_outline,
                              size: 12,
                              color: _hint,
                            ),
                            SizedBox(width: 5),
                            Expanded(
                              child: Text(
                                'Hanya pencatatan, bukan penyimpanan atau pemindahan uang.',
                                style: TextStyle(
                                  fontSize: 8,
                                  color: _hint,
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 15),

                        Row(
                          mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Riwayat pencatatan',
                              style: TextStyle(
                                fontFamily: _serif,
                                fontSize: 15,
                                color: _textDark,
                              ),
                            ),
                            Text(
                              '${_records.length} catatan',
                              style: const TextStyle(
                                fontSize: 9,
                                color: _hint,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 9),

                        _buildHistory(),
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
                padding: const EdgeInsets.fromLTRB(
                  16,
                  0,
                  16,
                  12,
                ),
                child: _buildBottomNav(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// MODEL DATA TABUNGAN
// ============================================================

class _SavingRecord {
  final String initial;
  final int amount;
  final String date;
  final String time;
  final String owner;

  const _SavingRecord({
    required this.initial,
    required this.amount,
    required this.date,
    required this.time,
    required this.owner,
  });
}
