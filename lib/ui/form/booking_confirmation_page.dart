
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:smart_wedding_planning_system/ui/bottom_navigation.dart';

class BookingConfirmationPage extends StatefulWidget {
  final String packageName;
  final String packageLocation;
  final String packageCapacity;
  final String selectedDate;
  final String namaPria;
  final String namaWanita;
  final String whatsapp;
  final String email;

  final String jumlahTamu;
  final String provinsi;
  final String kota;
  final String kecamatan;
  final String alamatLengkap;
  final String detailAlamat;
  final String catatan;

  final String providerName;
  final String providerLocation;
  final String totalPrice;
  final String bookingCode;

  const BookingConfirmationPage({
    super.key,
    required this.packageName,
    required this.packageLocation,
    required this.packageCapacity,
    required this.selectedDate,
    required this.namaPria,
    required this.namaWanita,
    required this.whatsapp,
    required this.email,
    this.jumlahTamu = '-',
    this.provinsi = '-',
    this.kota = '-',
    this.kecamatan = '-',
    this.alamatLengkap = '-',
    this.detailAlamat = '-',
    this.catatan = '-',
    this.providerName = 'The Royale Hall',
    this.providerLocation = 'Tegal',
    this.totalPrice = 'Rp100.000.000',
    this.bookingCode = 'WDP-0019',
  });

  @override
  State<BookingConfirmationPage> createState() =>
      _BookingConfirmationPageState();
}

class _BookingConfirmationPageState
    extends State<BookingConfirmationPage> {

  static const Color rose = Color(0xFFC58A85);
  static const Color pink = Color(0xFFE7B6B0);
  static const Color dark = Color(0xFF493B38);
  static const Color brown = Color(0xFF8A5A55);
  static const Color hint = Color(0xFFA18F89);
  static const String serif = 'PlayfairDisplay';

  bool hasNotification = true;

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: brown,
        behavior: SnackBarBehavior.floating,
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
          height: 40,
          errorBuilder: (_, __, ___) {
            return const Text(
              '♡ wedding+',
              style: TextStyle(
                fontFamily: serif,
                fontSize: 19,
                color: rose,
              ),
            );
          },
        ),

        Row(
          children: [
            GestureDetector(
              onTap: () {
                setState(() {
                  hasNotification = false;
                });
                _showMessage('Belum ada notifikasi baru');
              },
              child: Container(
                width: 35,
                height: 35,
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
                      size: 20,
                      color: dark,
                    ),
                    if (hasNotification)
                      Positioned(
                        top: 7,
                        right: 8,
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
                  _showMessage(
                    'Silakan keluar melalui halaman Home',
                  );
                }
              },
              itemBuilder: (context) => const [
                PopupMenuItem(
                  value: 'logout',
                  child: Text('Keluar'),
                ),
              ],
              child: Container(
                height: 35,
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
                      radius: 13,
                      backgroundColor: pink,
                      child: Icon(
                        Icons.person,
                        size: 16,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(width: 3),
                    Icon(
                      Icons.keyboard_arrow_down,
                      color: dark,
                      size: 18,
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

  // KARTU GLASS
  Widget _glass({
    required Widget child,
    double radius = 18,
    EdgeInsetsGeometry padding = const EdgeInsets.all(12),
  }) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: 8,
          sigmaY: 8,
        ),
        child: Container(
          width: double.infinity,
          padding: padding,
          decoration: BoxDecoration(
            color: const Color(0xF7FFFFFF),
            borderRadius: BorderRadius.circular(radius),
            border: Border.all(
              color: Colors.white,
            ),
          ),
          child: child,
        ),
      ),
    );
  }

  // JUDUL BAGIAN
  Widget _sectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontFamily: serif,
        fontSize: 13,
        color: dark,
      ),
    );
  }

  // INFORMASI KECIL
  Widget _smallInfo(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 7,
            color: hint,
          ),
        ),
        const SizedBox(height: 3),
        Text(
          value.isEmpty ? '-' : value,
          style: const TextStyle(
            fontSize: 8,
            color: dark,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  // HEADER KONFIRMASI
  Widget _buildConfirmation() {
    return Column(
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: rose,
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.white,
              width: 4,
            ),
            boxShadow: const [
              BoxShadow(
                color: Color(0x338A5A55),
                blurRadius: 12,
              ),
            ],
          ),
          child: const Icon(
            Icons.check,
            color: Colors.white,
            size: 35,
          ),
        ),

        const SizedBox(height: 10),

        const Text(
          'Booking Berhasil\nDikonfirmasi',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: serif,
            fontSize: 17,
            color: dark,
            height: 1.15,
          ),
        ),

        const SizedBox(height: 7),

        const Text(
          'Pembayaran telah diverifikasi oleh penyedia.\n'
          'Booking kamu kini resmi dikonfirmasi\n'
          'untuk tanggal yang dipilih.',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 8,
            color: hint,
            height: 1.5,
          ),
        ),

        const SizedBox(height: 7),

        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 13,
            vertical: 5,
          ),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.85),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Text(
            'Nomor booking : ${widget.bookingCode}',
            style: const TextStyle(
              fontSize: 8,
              color: dark,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  // RINGKASAN PAKET
  Widget _buildPackageCard() {
    return _glass(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle('Ringkasan Paket'),
          const SizedBox(height: 8),

          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: Image.asset(
                  'assets/images/package.png',
                  width: 42,
                  height: 42,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) {
                    return Container(
                      width: 42,
                      height: 42,
                      color: const Color(0xFFF3DDD7),
                      child: const Icon(
                        Icons.image_outlined,
                        color: rose,
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(width: 8),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 7,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF5E0DD),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: const Text(
                        'Gold',
                        style: TextStyle(
                          fontSize: 7,
                          color: brown,
                        ),
                      ),
                    ),

                    const SizedBox(height: 3),

                    Text(
                      widget.packageName,
                      style: const TextStyle(
                        fontFamily: serif,
                        fontSize: 10,
                        color: dark,
                      ),
                    ),

                    const SizedBox(height: 2),

                    Text(
                      widget.packageLocation,
                      style: const TextStyle(
                        fontSize: 7,
                        color: hint,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 8,
              vertical: 7,
            ),
            decoration: BoxDecoration(
              color: const Color(0xFFF4DEDA),
              borderRadius: BorderRadius.circular(7),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Total biaya',
                  style: TextStyle(
                    fontSize: 7,
                    color: dark,
                  ),
                ),
                Text(
                  widget.totalPrice,
                  style: const TextStyle(
                    fontSize: 11,
                    color: rose,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // DETAIL ACARA
  Widget _buildEventCard() {
    return _glass(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle('Detail Acara'),
          const SizedBox(height: 9),

          Row(
            children: [
              Expanded(
                child: _smallInfo(
                  'Tanggal acara',
                  widget.selectedDate,
                ),
              ),
              Expanded(
                child: _smallInfo(
                  'Jumlah tamu',
                  '${widget.jumlahTamu} tamu',
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          const Divider(
            color: Color(0xFFEEDDD8),
            height: 1,
          ),

          const SizedBox(height: 9),

          const Text(
            'Alamat lengkap acara',
            style: TextStyle(
              fontSize: 7,
              color: hint,
            ),
          ),

          const SizedBox(height: 5),

          Text(
            '${widget.alamatLengkap}, '
            '${widget.kecamatan}, '
            '${widget.kota}, '
            '${widget.provinsi}',
            style: const TextStyle(
              fontSize: 8,
              color: hint,
              height: 1.5,
            ),
          ),

          if (widget.detailAlamat.isNotEmpty &&
              widget.detailAlamat != '-') ...[
            const SizedBox(height: 5),
            Text(
              widget.detailAlamat,
              style: const TextStyle(
                fontSize: 8,
                color: hint,
              ),
            ),
          ],
        ],
      ),
    );
  }

  // PENYEDIA LAYANAN
  Widget _buildProviderCard() {
    return _glass(
      padding: const EdgeInsets.all(11),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle('Penyedia Layanan'),
          const SizedBox(height: 8),

          Row(
            children: [
              Container(
                width: 26,
                height: 26,
                decoration: BoxDecoration(
                  color: const Color(0xFFF3DDD7),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Icon(
                  Icons.business,
                  color: rose,
                  size: 17,
                ),
              ),

              const SizedBox(width: 8),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.providerName,
                      style: const TextStyle(
                        fontFamily: serif,
                        fontSize: 10,
                        color: brown,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Vendor venue · ${widget.providerLocation}',
                      style: const TextStyle(
                        fontSize: 7,
                        color: hint,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // STATUS PEMBAYARAN
  Widget _buildPaymentStatus() {
    return _glass(
      padding: const EdgeInsets.all(11),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle('Status Pembayaran'),
          const SizedBox(height: 8),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(
              horizontal: 8,
              vertical: 6,
            ),
            decoration: BoxDecoration(
              color: const Color(0xFFF3DCD8),
              borderRadius: BorderRadius.circular(6),
            ),
            child: const Row(
              children: [
                Icon(
                  Icons.check_circle,
                  size: 14,
                  color: rose,
                ),
                SizedBox(width: 6),
                Text(
                  'Terverifikasi oleh penyedia',
                  style: TextStyle(
                    fontSize: 8,
                    color: dark,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // TOMBOL LIHAT DETAIL
  Widget _buildDetailButton() {
    return SizedBox(
      width: double.infinity,
      height: 39,
      child: ElevatedButton(
        onPressed: _showBookingDetails,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFAE716B),
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(7),
          ),
        ),
        child: const Text(
          'Lihat Detail Booking',
          style: TextStyle(
            fontSize: 9,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  // DETAIL BOOKING
  void _showBookingDetails() {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text(
            'Detail Booking',
            style: TextStyle(
              fontFamily: serif,
              color: dark,
            ),
          ),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                _dialogInfo('Nomor booking', widget.bookingCode),
                _dialogInfo('Paket', widget.packageName),
                _dialogInfo('Tanggal', widget.selectedDate),
                _dialogInfo('Nama pria', widget.namaPria),
                _dialogInfo('Nama wanita', widget.namaWanita),
                _dialogInfo('WhatsApp', widget.whatsapp),
                _dialogInfo('Email', widget.email),
                _dialogInfo('Jumlah tamu', widget.jumlahTamu),
                _dialogInfo('Alamat', widget.alamatLengkap),
                _dialogInfo('Catatan', widget.catatan),
                _dialogInfo('Total pembayaran', widget.totalPrice),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text(
                'Tutup',
                style: TextStyle(color: rose),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _dialogInfo(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 9),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 9,
              color: hint,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            value.isEmpty ? '-' : value,
            style: const TextStyle(
              fontSize: 11,
              color: dark,
            ),
          ),
        ],
      ),
    );
  }

  // KEMBALI KE BERANDA
  Widget _buildHomeButton() {
    return SizedBox(
      width: double.infinity,
      height: 38,
      child: OutlinedButton(
        onPressed: () {
          Navigator.popUntil(
            context,
            (route) => route.isFirst,
          );
        },
        style: OutlinedButton.styleFrom(
          foregroundColor: rose,
          backgroundColor: Colors.white,
          side: const BorderSide(color: pink),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(7),
          ),
        ),
        child: const Text(
          'Kembali ke Beranda Wedding+',
          style: TextStyle(fontSize: 8),
        ),
      ),
    );
  }

  // BOTTOM NAVIGATION
  Widget _navItem(
    IconData icon,
    String label,
    String route,
  ) {
    return GestureDetector(
      onTap: () {
        navigateToBottomTab(context, route);
      },
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 20,
              color: hint,
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: const TextStyle(
                fontSize: 8,
                color: hint,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNav() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(25),
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: 10,
          sigmaY: 10,
        ),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 8,
            vertical: 10,
          ),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.85),
            borderRadius: BorderRadius.circular(25),
            border: Border.all(
              color: Colors.white,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _navItem(
                Icons.home_outlined,
                'Beranda',
                AppRoutes.home,
              ),
              _navItem(
                Icons.calendar_month_outlined,
                'Rencana',
                AppRoutes.rencana,
              ),
              _navItem(
                Icons.chat_bubble_outline,
                'Chat',
                AppRoutes.chat,
              ),
              _navItem(
                Icons.person_outline,
                'User',
                AppRoutes.user,
              ),
            ],
          ),
        ),
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
                  padding: const EdgeInsets.fromLTRB(
                    16, 8, 16, 8,
                  ),
                  child: _buildHeader(),
                ),

                // CONTENT
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(
                      14, 10, 14, 100,
                    ),
                    child: Column(
                      children: [
                        _buildConfirmation(),

                        const SizedBox(height: 10),

                        _buildPackageCard(),

                        const SizedBox(height: 9),

                        _buildEventCard(),

                        const SizedBox(height: 9),

                        _buildProviderCard(),

                        const SizedBox(height: 9),

                        _buildPaymentStatus(),

                        const SizedBox(height: 10),

                        _buildDetailButton(),

                        const SizedBox(height: 7),

                        _buildHomeButton(),
                      ],
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
                padding: const EdgeInsets.fromLTRB(
                  16, 0, 16, 10,
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
