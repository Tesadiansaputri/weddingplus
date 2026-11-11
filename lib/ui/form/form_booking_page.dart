import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

import '../bottom_navigation.dart';
import 'form_booking_tahap_2.dart';

class FormBookingPage extends StatefulWidget {
  final String packageName;
  final String packageLocation;
  final String packageCapacity;
  final VoidCallback? onNext;

  const FormBookingPage({
    super.key,
    this.packageName = 'Paket belum dipilih',
    this.packageLocation = '-',
    this.packageCapacity = '-',
    this.onNext,
  });

  @override
  State<FormBookingPage> createState() => _FormBookingPageState();
}

class _FormBookingPageState extends State<FormBookingPage> {
  static const Color _rose = Color(0xFFC58A85);
  static const Color _pink = Color(0xFFE7B6B0);
  static const Color _dark = Color(0xFF493B38);
  static const Color _brown = Color(0xFF8A5A55);
  static const Color _hint = Color(0xFFA18F89);
  static const String _serif = 'PlayfairDisplay';

  DateTime? _selectedDate;
  bool _hasNotification = true;
  bool _localeReady = false;

  @override
  void initState() {
    super.initState();
    _initializeLocale();
  }

  // Inisialisasi format tanggal Bahasa Indonesia.
  Future<void> _initializeLocale() async {
    try {
      await initializeDateFormatting('id_ID', null);
      if (mounted) {
        setState(() {
          _localeReady = true;
        });
      }
    } catch (e) {
      debugPrint('Gagal menginisialisasi format tanggal: $e');
    }
  }

  String get _formattedDate {
    if (_selectedDate == null) {
      return 'Pilih tanggal pernikahan';
    }

    if (!_localeReady) {
      return DateFormat('dd/MM/yyyy').format(_selectedDate!);
    }

    return DateFormat('d MMMM yyyy', 'id_ID').format(_selectedDate!);
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

  // Memilih tanggal melalui dialog kalender.
  Future<void> _selectDate() async {
    final now = DateTime.now();

    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? now,
      firstDate: DateTime(now.year, now.month, now.day),
      lastDate: DateTime(now.year + 5, 12, 31),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
              primary: _rose,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: _dark,
            ),
          ),
          child: child!,
        );
      },
    );

    if (!mounted) return;

    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Widget _glass({
    required Widget child,
    double radius = 24,
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
            color: const Color(0x99FFFFFF),
            borderRadius: BorderRadius.circular(radius),
            border: Border.all(color: const Color(0x99FFFFFF)),
          ),
          child: child,
        ),
      ),
    );
  }

  // HEADER
  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Image.asset(
          'assets/images/logo_header.png',
          height: 45,
          errorBuilder: (_, __, ___) {
            return const Text(
              '♡ wedding+',
              style: TextStyle(fontFamily: _serif, fontSize: 19, color: _rose),
            );
          },
        ),
        Row(
          children: [
            GestureDetector(
              onTap: () {
                setState(() {
                  _hasNotification = false;
                });
                _showMessage('Belum ada notifikasi baru');
              },
              child: Container(
                width: 38,
                height: 38,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(color: Color(0x22000000), blurRadius: 8),
                  ],
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    const Icon(
                      Icons.notifications_none,
                      color: _dark,
                      size: 21,
                    ),
                    if (_hasNotification)
                      Positioned(
                        top: 8,
                        right: 9,
                        child: Container(
                          width: 7,
                          height: 7,
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 8),
            PopupMenuButton<String>(
              onSelected: (value) {
                if (value == 'logout') {
                  _showMessage('Silakan keluar melalui halaman Home');
                }
              },
              itemBuilder: (context) => const [
                PopupMenuItem(value: 'logout', child: Text('Keluar')),
              ],
              child: Container(
                height: 38,
                padding: const EdgeInsets.symmetric(horizontal: 5),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(22),
                  boxShadow: const [
                    BoxShadow(color: Color(0x22000000), blurRadius: 8),
                  ],
                ),
                child: const Row(
                  children: [
                    CircleAvatar(
                      radius: 14,
                      backgroundColor: _pink,
                      child: Icon(Icons.person, size: 17, color: Colors.white),
                    ),
                    SizedBox(width: 3),
                    Icon(Icons.keyboard_arrow_down, color: _dark, size: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // JUDUL
  Widget _buildTitle() {
    return Row(
      children: [
        GestureDetector(
          onTap: () => Navigator.pop(context),
          child: const Icon(Icons.arrow_back, size: 20, color: _brown),
        ),
        const SizedBox(width: 12),
        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Form Booking',
              style: TextStyle(fontFamily: _serif, fontSize: 21, color: _dark),
            ),
            Text(
              'Lengkapi rencana hari bahagiamu',
              style: TextStyle(fontSize: 9, color: _hint),
            ),
          ],
        ),
      ],
    );
  }

  // STEPPER
  Widget _buildStepper() {
    return Row(
      children: [
        _buildStepItem('1', 'Tanggal', true),
        Expanded(
          child: Container(
            height: 1,
            color: _pink,
            margin: const EdgeInsets.only(bottom: 18),
          ),
        ),
        _buildStepItem('2', 'Calon pengantin', false),
        Expanded(
          child: Container(
            height: 1,
            color: _pink,
            margin: const EdgeInsets.only(bottom: 18),
          ),
        ),
        _buildStepItem('3', 'Detail acara', false),
      ],
    );
  }

  Widget _buildStepItem(String number, String title, bool active) {
    return SizedBox(
      width: 76,
      child: Column(
        children: [
          Container(
            width: 21,
            height: 21,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: active ? _rose : Colors.white,
              shape: BoxShape.circle,
              border: Border.all(color: _rose),
            ),
            child: Text(
              number,
              style: TextStyle(
                fontSize: 10,
                color: active ? Colors.white : _rose,
              ),
            ),
          ),
          const SizedBox(height: 5),
          Text(
            title,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: 8, color: active ? _brown : _hint),
          ),
        ],
      ),
    );
  }

  // RINGKASAN PAKET
  Widget _buildPackageSummary() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.88),
        borderRadius: BorderRadius.circular(13),
        boxShadow: const [
          BoxShadow(
            color: Color(0x10000000),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'PAKET TERPILIH · SMART RECOMMENDATION',
            style: TextStyle(
              fontSize: 7,
              color: _rose,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            widget.packageName,
            style: const TextStyle(
              fontFamily: _serif,
              fontSize: 13,
              color: _dark,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            '${widget.packageLocation} · ${widget.packageCapacity}',
            style: const TextStyle(fontSize: 8, color: _hint),
          ),
        ],
      ),
    );
  }

  // INPUT TANGGAL
  Widget _buildDateField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Tanggal pernikahan *',
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w600,
            color: _dark,
          ),
        ),
        const SizedBox(height: 7),
        GestureDetector(
          onTap: _selectDate,
          child: Container(
            height: 42,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              color: const Color(0xFFFFFAF8),
              border: Border.all(color: _pink),
              borderRadius: BorderRadius.circular(9),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    _formattedDate,
                    style: TextStyle(
                      fontSize: 10,
                      color: _selectedDate == null ? _hint : _dark,
                    ),
                  ),
                ),
                const Icon(
                  Icons.calendar_month_outlined,
                  color: _brown,
                  size: 18,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // KALENDER
  Widget _buildCalendar() {
    final now = DateTime.now();

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(13),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(
          colorScheme: Theme.of(context).colorScheme.copyWith(
            primary: _rose,
            onPrimary: Colors.white,
            surface: Colors.white,
            onSurface: _dark,
          ),
        ),
        child: CalendarDatePicker(
          initialDate: _selectedDate ?? now,
          firstDate: DateTime(now.year, now.month, now.day),
          lastDate: DateTime(now.year + 5, 12, 31),
          currentDate: now,
          onDateChanged: (date) {
            setState(() {
              _selectedDate = date;
            });
          },
        ),
      ),
    );
  }

  // INFORMASI VALIDASI
  Widget _buildValidationInfo() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(11),
      decoration: BoxDecoration(
        color: const Color(0xFFF8EAE6),
        borderRadius: BorderRadius.circular(10),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Menunggu validasi penyedia',
            style: TextStyle(
              fontSize: 9,
              color: _brown,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 4),
          Text(
            'Tanggal belum dianggap tersedia sebelum disetujui oleh penyedia.',
            style: TextStyle(fontSize: 8, color: _hint),
          ),
        ],
      ),
    );
  }

  // TOMBOL KEMBALI DAN SELANJUTNYA
  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: OutlinedButton.icon(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back, size: 14),
            label: const Text('Kembali', style: TextStyle(fontSize: 9)),
            style: OutlinedButton.styleFrom(
              foregroundColor: _brown,
              side: const BorderSide(color: _pink),
              backgroundColor: Colors.white.withOpacity(0.8),
              padding: const EdgeInsets.symmetric(vertical: 13, horizontal: 5),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(9),
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          flex: 2,
          child: ElevatedButton(
            onPressed: () {
              if (_selectedDate == null) {
                _showMessage(
                  'Silakan pilih tanggal pernikahan terlebih dahulu.',
                );
                return;
              }
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FormBookingTahap2(
                    packageName: widget.packageName,
                    selectedDate: _formattedDate,
                  ),
                ),
              );

              // TODO BACKEND:
              // Simpan tanggal booking dan lanjutkan ke tahap 2.
              if (widget.onNext != null) {
                widget.onNext!();
              } else {
                _showMessage(
                  'Tanggal berhasil dipilih. Tahap 2 akan dibuat berikutnya.',
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: _rose,
              foregroundColor: Colors.white,
              elevation: 0,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(9),
              ),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Selanjutnya',
                  style: TextStyle(fontSize: 9, fontWeight: FontWeight.w600),
                ),
                SizedBox(width: 6),
                Icon(Icons.chevron_right, size: 15),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // BOTTOM NAVIGATION
  Widget _navItem(IconData icon, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 22, color: _hint),
            const SizedBox(height: 2),
            Text(label, style: const TextStyle(fontSize: 9, color: _hint)),
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
          _navItem(
            Icons.home_outlined,
            'Beranda',
            () => navigateToBottomTab(context, AppRoutes.home),
          ),
          _navItem(
            Icons.calendar_month_outlined,
            'Rencana',
            () => navigateToBottomTab(context, AppRoutes.rencana),
          ),
          _navItem(
            Icons.chat_bubble_outline,
            'Chat',
            () => navigateToBottomTab(context, AppRoutes.chat),
          ),
          _navItem(
            Icons.person_outline,
            'User',
            () => navigateToBottomTab(context, AppRoutes.user),
          ),
        ],
      ),
    );
  }

  // BUILD
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
              errorBuilder: (_, __, ___) {
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
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                  child: _buildHeader(),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(20, 4, 20, 100),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildTitle(),
                        const SizedBox(height: 18),
                        _buildStepper(),
                        const SizedBox(height: 14),
                        _buildPackageSummary(),
                        const SizedBox(height: 17),
                        const Text(
                          'Tanggal Pernikahan',
                          style: TextStyle(
                            fontFamily: _serif,
                            fontSize: 15,
                            color: _dark,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Pilih tanggal untuk diajukan kepada penyedia.',
                          style: TextStyle(fontSize: 9, color: _hint),
                        ),
                        const SizedBox(height: 10),
                        _buildDateField(),
                        const SizedBox(height: 7),
                        _buildCalendar(),
                        const SizedBox(height: 10),
                        _buildValidationInfo(),
                        const SizedBox(height: 10),
                        _buildActionButtons(),
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
