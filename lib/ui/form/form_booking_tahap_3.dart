
import 'dart:ui';
import 'package:flutter/material.dart';

import 'package:smart_wedding_planning_system/ui/bottom_navigation.dart';
import 'review_booking_page.dart';

class FormBookingTahap3 extends StatefulWidget {
  final String packageName;
  final String packageLocation;
  final String packageCapacity;
  final String selectedDate;
  final String namaPria;
  final String namaWanita;
  final String whatsapp;
  final String email;

  const FormBookingTahap3({
    super.key,
    required this.packageName,
    this.packageLocation = '-',
    this.packageCapacity = '-',
    required this.selectedDate,
    required this.namaPria,
    required this.namaWanita,
    required this.whatsapp,
    this.email = '-',
  });

  @override
  State<FormBookingTahap3> createState() => _FormBookingTahap3State();
}

class _FormBookingTahap3State extends State<FormBookingTahap3> {
  static const Color _rose = Color(0xFFC58A85);
  static const Color _pink = Color(0xFFE7B6B0);
  static const Color _dark = Color(0xFF493B38);
  static const Color _brown = Color(0xFF8A5A55);
  static const Color _hint = Color(0xFFA18F89);
  static const String _serif = 'PlayfairDisplay';

  bool _hasNotification = true;

  final _formKey = GlobalKey<FormState>();

  final TextEditingController _jumlahTamuController =
      TextEditingController(text: '450');

  final TextEditingController _alamatController =
      TextEditingController(
    text: 'Jl. Mayjen Sutoyo No. 12,\nKelurahan Panggung',
  );

  final TextEditingController _detailAlamatController =
      TextEditingController(
    text: 'Gedung utama, pintu masuk sebelah timur',
  );

  final TextEditingController _catatanController =
      TextEditingController();

  String _provinsi = 'Jawa Tengah';
  String _kota = 'Kota Tegal';
  String _kecamatan = 'Tegal Timur';

  @override
  void dispose() {
    _jumlahTamuController.dispose();
    _alamatController.dispose();
    _detailAlamatController.dispose();
    _catatanController.dispose();
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

  // HEADER TETAP SAMA
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
        Expanded(child: _stepLine()),
        _buildStepItem('2', 'Calon pengantin', true),
        Expanded(child: _stepLine()),
        _buildStepItem('3', 'Detail acara', true),
      ],
    );
  }

  Widget _stepLine() {
    return Container(
      height: 1,
      color: _pink,
      margin: const EdgeInsets.only(bottom: 18),
    );
  }

  Widget _buildStepItem(
    String number,
    String title,
    bool active,
  ) {
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

  // KARTU PAKET
  Widget _buildPackageCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(11),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.90),
        borderRadius: BorderRadius.circular(13),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'PAKET TERPILIH • SMART RECOMMENDATION',
            style: TextStyle(
              fontSize: 7,
              color: _rose,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            'Gold · ${widget.packageName}',
            style: const TextStyle(
              fontFamily: _serif,
              fontSize: 13,
              color: _dark,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            '${widget.packageLocation} · Maksimal ${widget.packageCapacity}',
            style: const TextStyle(
              fontSize: 8,
              color: _hint,
            ),
          ),
        ],
      ),
    );
  }

  // JUDUL BAGIAN
  Widget _buildSectionTitle(
    String title,
    String subtitle,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontFamily: _serif,
            fontSize: 16,
            color: _dark,
          ),
        ),
        const SizedBox(height: 3),
        Text(
          subtitle,
          style: const TextStyle(
            fontSize: 9,
            color: _hint,
          ),
        ),
      ],
    );
  }

  // LABEL INPUT
  Widget _buildLabel(
    String title, {
    bool required = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: RichText(
        text: TextSpan(
          style: const TextStyle(
            fontSize: 9,
            color: _dark,
            fontWeight: FontWeight.w600,
          ),
          children: [
            TextSpan(text: title),
            if (required)
              const TextSpan(
                text: ' *',
                style: TextStyle(color: _rose),
              ),
          ],
        ),
      ),
    );
  }

  // INPUT TEXT
  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    bool required = false,
    String? hintText,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
    String? helperText,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel(label, required: required),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          keyboardType: keyboardType,
          style: const TextStyle(
            fontSize: 10,
            color: _dark,
          ),
          validator: required
              ? (value) {
                  if (value == null || value.trim().isEmpty) {
                    return '$label wajib diisi';
                  }
                  return null;
                }
              : null,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: const TextStyle(
              fontSize: 9,
              color: Color(0xFFB5A6A1),
            ),
            filled: true,
            fillColor: const Color(0xFFFFFBFA),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 12,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(9),
              borderSide: const BorderSide(color: _pink),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(9),
              borderSide: const BorderSide(
                color: _rose,
                width: 1.2,
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
        if (helperText != null) ...[
          const SizedBox(height: 4),
          Text(
            helperText,
            style: const TextStyle(
              fontSize: 8,
              color: _hint,
            ),
          ),
        ],
      ],
    );
  }

  // DROPDOWN
  Widget _buildDropdown({
    required String label,
    required String value,
    required List<String> options,
    required ValueChanged<String?> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel(label, required: true),
        DropdownButtonFormField<String>(
          value: value,
          isExpanded: true,
          icon: const Icon(
            Icons.keyboard_arrow_down,
            color: _rose,
            size: 18,
          ),
          style: const TextStyle(
            fontSize: 10,
            color: _dark,
          ),
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color(0xFFFFFBFA),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 2,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(9),
              borderSide: const BorderSide(color: _pink),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(9),
              borderSide: const BorderSide(color: _rose),
            ),
          ),
          items: options.map((item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(
                item,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 10),
              ),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ],
    );
  }

  // TOMBOL
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
            onPressed: _nextToReview,
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
                SizedBox(width: 5),
                Icon(Icons.chevron_right, size: 16),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // LANJUT KE REVIEW BOOKING
  void _nextToReview() {
  if (!_formKey.currentState!.validate()) {
    return;
  }

  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => ReviewBookingPage(
        packageName: widget.packageName,
        packageLocation: widget.packageLocation,
        packageCapacity: widget.packageCapacity,
        selectedDate: widget.selectedDate,
        namaPria: widget.namaPria,
        namaWanita: widget.namaWanita,
        whatsapp: widget.whatsapp,
        email: widget.email,

        // DATA DETAIL ACARA
        jumlahTamu: _jumlahTamuController.text.trim(),
        provinsi: _provinsi,
        kota: _kota,
        kecamatan: _kecamatan,
        alamat: _alamatController.text.trim(),
        detailAlamat: _detailAlamatController.text.trim(),
        catatan: _catatanController.text.trim(),
      ),
    ),
  );
}

  // BOTTOM NAVIGATION TETAP SAMA
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
          // BACKGROUND
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
                // HEADER
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                  child: _buildHeader(),
                ),

                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(
                      20,
                      4,
                      20,
                      100,
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildTitle(),
                          const SizedBox(height: 18),

                          _buildStepper(),
                          const SizedBox(height: 14),

                          _buildPackageCard(),
                          const SizedBox(height: 15),

                          // DETAIL ACARA
                          _buildSectionTitle(
                            'Detail Acara',
                            'Sesuaikan jumlah tamu dan lokasi perayaanmu.',
                          ),
                          const SizedBox(height: 12),

                          _buildTextField(
                            label: 'Jumlah tamu',
                            controller: _jumlahTamuController,
                            required: true,
                            keyboardType: TextInputType.number,
                            helperText:
                                'Maksimal 500 tamu sesuai kapasitas paket.',
                          ),
                          const SizedBox(height: 17),

                          // ALAMAT ACARA
                          _buildSectionTitle(
                            'Alamat lengkap acara',
                            '',
                          ),
                          const SizedBox(height: 12),

                          _buildDropdown(
                            label: 'Provinsi',
                            value: _provinsi,
                            options: const [
                              'Jawa Tengah',
                              'Jawa Barat',
                              'Jawa Timur',
                              'DI Yogyakarta',
                              'DKI Jakarta',
                            ],
                            onChanged: (value) {
                              setState(() {
                                _provinsi = value!;
                              });
                            },
                          ),
                          const SizedBox(height: 13),

                          _buildDropdown(
                            label: 'Kota / Kabupaten',
                            value: _kota,
                            options: const [
                              'Kota Tegal',
                              'Kabupaten Tegal',
                              'Kabupaten Brebes',
                              'Kabupaten Pemalang',
                            ],
                            onChanged: (value) {
                              setState(() {
                                _kota = value!;
                              });
                            },
                          ),
                          const SizedBox(height: 13),

                          _buildDropdown(
                            label: 'Kecamatan',
                            value: _kecamatan,
                            options: const [
                              'Tegal Timur',
                              'Tegal Barat',
                              'Tegal Selatan',
                              'Margadana',
                            ],
                            onChanged: (value) {
                              setState(() {
                                _kecamatan = value!;
                              });
                            },
                          ),
                          const SizedBox(height: 13),

                          _buildTextField(
                            label: 'Alamat lengkap',
                            controller: _alamatController,
                            required: true,
                            maxLines: 2,
                            hintText: 'Masukkan alamat lengkap acara',
                          ),
                          const SizedBox(height: 12),

                          _buildTextField(
                            label: 'Detail alamat (opsional)',
                            controller: _detailAlamatController,
                            maxLines: 1,
                            hintText: 'Masukkan detail lokasi acara',
                          ),
                          const SizedBox(height: 13),

                          _buildTextField(
                            label: 'Catatan tambahan (opsional)',
                            controller: _catatanController,
                            maxLines: 3,
                            hintText:
                                'Tambahkan kebutuhan khusus untuk acara',
                            helperText:
                                'Selanjutnya tinjau pemesanan.',
                          ),
                          const SizedBox(height: 15),

                          _buildActionButtons(),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // BOTTOM NAVIGATION
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
