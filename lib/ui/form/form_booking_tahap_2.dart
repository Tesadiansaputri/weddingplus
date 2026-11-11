
import 'dart:ui';
import 'package:flutter/material.dart';

import '../bottom_navigation.dart';
import 'form_booking_tahap_3.dart';

class FormBookingTahap2 extends StatefulWidget {
  final String packageName;
  final String packageLocation;
  final String packageCapacity;
  final String selectedDate;

  const FormBookingTahap2({
    super.key,
    this.packageName = 'Paket belum dipilih',
    this.packageLocation = '-',
    this.packageCapacity = '-',
    this.selectedDate = '-',
  });

  @override
  State<FormBookingTahap2> createState() => _FormBookingTahap2State();
}

class _FormBookingTahap2State extends State<FormBookingTahap2> {
  static const Color _rose = Color(0xFFC58A85);
  static const Color _pink = Color(0xFFE7B6B0);
  static const Color _dark = Color(0xFF493B38);
  static const Color _brown = Color(0xFF8A5A55);
  static const Color _hint = Color(0xFFA18F89);
  static const String _serif = 'PlayfairDisplay';

  final _formKey = GlobalKey<FormState>();

  final TextEditingController _namaPriaController = TextEditingController();
  final TextEditingController _namaWanitaController = TextEditingController();
  final TextEditingController _whatsappController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  bool _hasNotification = true;

  @override
  void dispose() {
    _namaPriaController.dispose();
    _namaWanitaController.dispose();
    _whatsappController.dispose();
    _emailController.dispose();
    super.dispose();
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

  // HEADER SAMA DENGAN FORM 1
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
              style: TextStyle(
                fontFamily: _serif,
                fontSize: 19,
                color: _rose,
              ),
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
                    BoxShadow(
                      color: Color(0x22000000),
                      blurRadius: 8,
                    ),
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
                PopupMenuItem(
                  value: 'logout',
                  child: Text('Keluar'),
                ),
              ],
              child: Container(
                height: 38,
                padding: const EdgeInsets.symmetric(horizontal: 5),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(22),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x22000000),
                      blurRadius: 8,
                    ),
                  ],
                ),
                child: const Row(
                  children: [
                    CircleAvatar(
                      radius: 14,
                      backgroundColor: _pink,
                      child: Icon(
                        Icons.person,
                        size: 17,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(width: 3),
                    Icon(
                      Icons.keyboard_arrow_down,
                      color: _dark,
                      size: 20,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // GLASS CONTAINER SAMA DENGAN FORM 1
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

  // JUDUL
  Widget _buildTitle() {
    return Row(
      children: [
        GestureDetector(
          onTap: () => Navigator.pop(context),
          child: const Icon(
            Icons.arrow_back,
            size: 20,
            color: _brown,
          ),
        ),
        const SizedBox(width: 12),
        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Form Booking',
              style: TextStyle(
                fontFamily: _serif,
                fontSize: 21,
                color: _dark,
              ),
            ),
            Text(
              'Lengkapi rencana hari bahagiamu',
              style: TextStyle(
                fontSize: 9,
                color: _hint,
              ),
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
        _buildStepItem('2', 'Calon pengantin', true),
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
            style: TextStyle(
              fontSize: 8,
              color: active ? _brown : _hint,
            ),
          ),
        ],
      ),
    );
  }

  // RINGKASAN PAKET
  Widget _buildPackageSummary() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 10,
      ),
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
            style: const TextStyle(
              fontSize: 8,
              color: _hint,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            'Tanggal acara: ${widget.selectedDate}',
            style: const TextStyle(
              fontSize: 8,
              color: _hint,
            ),
          ),
        ],
      ),
    );
  }

  // INPUT FIELD
  Widget _buildTextField({
    required String label,
    required String hint,
    required TextEditingController controller,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w600,
            color: _dark,
          ),
        ),
        const SizedBox(height: 7),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          validator: validator,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(
              color: _hint,
              fontSize: 10,
            ),
            prefixIcon: Icon(
              icon,
              color: _brown,
              size: 18,
            ),
            filled: true,
            fillColor: const Color(0xFFFFFAF8),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 13,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(9),
              borderSide: const BorderSide(color: _pink),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(9),
              borderSide: const BorderSide(color: _pink),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(9),
              borderSide: const BorderSide(
                color: _rose,
                width: 1.5,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(9),
              borderSide: const BorderSide(color: Colors.redAccent),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(9),
              borderSide: const BorderSide(color: Colors.redAccent),
            ),
          ),
        ),
      ],
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
            label: const Text(
              'Kembali',
              style: TextStyle(fontSize: 9),
            ),
            style: OutlinedButton.styleFrom(
              foregroundColor: _brown,
              side: const BorderSide(color: _pink),
              backgroundColor: Colors.white.withOpacity(0.8),
              padding: const EdgeInsets.symmetric(
                vertical: 13,
                horizontal: 5,
              ),
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
            onPressed: _lanjutkan,
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
                  style: TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.w600,
                  ),
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

  // LANJUT KE TAHAP 3
  void _lanjutkan() {
    if (!_formKey.currentState!.validate()) return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FormBookingTahap3(
          packageName: widget.packageName,
          packageLocation: widget.packageLocation,
          packageCapacity: widget.packageCapacity,
          selectedDate: widget.selectedDate,
          namaPria: _namaPriaController.text.trim(),
          namaWanita: _namaWanitaController.text.trim(),
          whatsapp: _whatsappController.text.trim(),
          email: _emailController.text.trim(),
        ),
      ),
    );
  }

  // BOTTOM NAVIGATION SAMA DENGAN FORM 1
  Widget _navItem(
    IconData icon,
    String label,
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
            Icon(icon, size: 22, color: _hint),
            const SizedBox(height: 2),
            Text(
              label,
              style: const TextStyle(
                fontSize: 9,
                color: _hint,
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
                          'Data Calon Pengantin',
                          style: TextStyle(
                            fontFamily: _serif,
                            fontSize: 15,
                            color: _dark,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Lengkapi informasi calon pengantin untuk proses booking.',
                          style: TextStyle(
                            fontSize: 9,
                            color: _hint,
                          ),
                        ),
                        const SizedBox(height: 15),

                        Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildTextField(
                                label: 'Nama calon pengantin pria *',
                                hint: 'Masukkan nama lengkap pria',
                                controller: _namaPriaController,
                                icon: Icons.person_outline,
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return 'Nama calon pengantin pria wajib diisi';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 14),
                              _buildTextField(
                                label: 'Nama calon pengantin wanita *',
                                hint: 'Masukkan nama lengkap wanita',
                                controller: _namaWanitaController,
                                icon: Icons.person_outline,
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return 'Nama calon pengantin wanita wajib diisi';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 14),
                              _buildTextField(
                                label: 'Nomor WhatsApp *',
                                hint: 'Contoh: 081234567890',
                                controller: _whatsappController,
                                icon: Icons.phone_outlined,
                                keyboardType: TextInputType.phone,
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return 'Nomor WhatsApp wajib diisi';
                                  }
                                  if (!RegExp(r'^[0-9+]{9,15}$')
                                      .hasMatch(value.trim())) {
                                    return 'Masukkan nomor WhatsApp yang valid';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 14),
                              _buildTextField(
                                label: 'Email (Opsional)',
                                hint: 'Masukkan alamat email',
                                controller: _emailController,
                                icon: Icons.email_outlined,
                                keyboardType: TextInputType.emailAddress,
                                validator: (value) {
                                  if (value != null &&
                                      value.trim().isNotEmpty &&
                                      !RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$')
                                          .hasMatch(value.trim())) {
                                    return 'Format email tidak valid';
                                  }
                                  return null;
                                },
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 18),
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
