import 'package:flutter/material.dart';
import 'package:smart_wedding_planning_system/ui/form/pembayaran_booking_page.dart';

import '../bottom_navigation.dart';
import 'booking_tracking_page.dart';

class ReviewBookingPage extends StatelessWidget {
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
  final String alamat;
  final String detailAlamat;
  final String catatan;

  const ReviewBookingPage({
    super.key,
    required this.packageName,
    required this.packageLocation,
    required this.packageCapacity,
    required this.selectedDate,
    required this.namaPria,
    required this.namaWanita,
    required this.whatsapp,
    required this.email,
    required this.jumlahTamu,
    required this.provinsi,
    required this.kota,
    required this.kecamatan,
    required this.alamat,
    required this.detailAlamat,
    required this.catatan,
  });

  static const Color rose = Color(0xFFC58A85);
  static const Color pink = Color(0xFFE7B6B0);
  static const Color dark = Color(0xFF493B38);
  static const Color brown = Color(0xFF8A5A55);
  static const Color hint = Color(0xFFA18F89);
  static const String serif = 'PlayfairDisplay';

  Widget _info(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 9),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 8, color: hint)),
          const SizedBox(height: 3),
          Text(
            value.isEmpty ? '-' : value,
            style: const TextStyle(fontSize: 10, color: dark),
          ),
        ],
      ),
    );
  }

  Widget _section({
    required BuildContext context,
    required String title,
    required Widget child,
  }) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(11),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.94),
        borderRadius: BorderRadius.circular(13),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontFamily: serif,
                  fontSize: 13,
                  color: dark,
                ),
              ),
              OutlinedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                style: OutlinedButton.styleFrom(
                  foregroundColor: rose,
                  side: const BorderSide(color: pink),
                  minimumSize: const Size(40, 25),
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: const Text('Edit', style: TextStyle(fontSize: 9)),
              ),
            ],
          ),
          const SizedBox(height: 5),
          child,
        ],
      ),
    );
  }

  Widget _navItem(
    BuildContext context,
    IconData icon,
    String label,
    String route,
  ) {
    return GestureDetector(
      onTap: () => navigateToBottomTab(context, route),
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 21, color: hint),
            const SizedBox(height: 2),
            Text(label, style: const TextStyle(fontSize: 8, color: hint)),
          ],
        ),
      ),
    );
  }

  void _submitBooking(BuildContext context) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => PembayaranBookingPage(
        packageName: packageName,
        packageLocation: packageLocation,
        packageCapacity: packageCapacity,
        selectedDate: selectedDate,
        namaPria: namaPria,
        namaWanita: namaWanita,
        whatsapp: whatsapp,
        email: email,

        // DATA DETAIL ACARA
        jumlahTamu: jumlahTamu,
        provinsi: provinsi,
        kota: kota,
        kecamatan: kecamatan,
        alamat: alamat,
        detailAlamat: detailAlamat,
        catatan: catatan,

        totalPrice: 'Rp100.000.000',
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
              errorBuilder: (_, __, ___) =>
                  Container(color: const Color(0xFFFBF1EE)),
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                // HEADER
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Image.asset(
                        'assets/images/logo_header.png',
                        height: 40,
                        errorBuilder: (_, __, ___) => const Text(
                          '♡ wedding+',
                          style: TextStyle(
                            fontFamily: serif,
                            fontSize: 18,
                            color: rose,
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          Container(
                            width: 35,
                            height: 35,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.notifications_none,
                              color: dark,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 8),
                          const CircleAvatar(
                            radius: 16,
                            backgroundColor: pink,
                            child: Icon(
                              Icons.person,
                              size: 18,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // ISI HALAMAN
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(16, 5, 16, 100),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // JUDUL
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () => Navigator.pop(context),
                              child: const Icon(
                                Icons.arrow_back,
                                size: 18,
                                color: brown,
                              ),
                            ),
                            const SizedBox(width: 10),
                            const Text(
                              'Periksa Booking Kamu',
                              style: TextStyle(
                                fontFamily: serif,
                                fontSize: 17,
                                color: dark,
                              ),
                            ),
                          ],
                        ),
                        const Padding(
                          padding: EdgeInsets.only(left: 28, top: 4),
                          child: Text(
                            'Pastikan semua detail sudah sesuai sebelum '
                            'mengajukan booking ke penyedia.',
                            style: TextStyle(fontSize: 8, color: hint),
                          ),
                        ),
                        const SizedBox(height: 14),

                        // RINGKASAN PAKET
                        _section(
                          context: context,
                          title: 'Ringkasan Paket',
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                height: 105,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF3DDD7),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Icon(
                                  Icons.image_outlined,
                                  color: rose,
                                  size: 35,
                                ),
                              ),
                              const SizedBox(height: 7),
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 7,
                                      vertical: 3,
                                    ),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFF8E3DF),
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: const Text(
                                      'Paket',
                                      style: TextStyle(
                                        fontSize: 8,
                                        color: brown,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 7),
                                  Expanded(
                                    child: Text(
                                      packageName,
                                      style: const TextStyle(
                                        fontFamily: serif,
                                        fontSize: 12,
                                        color: dark,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 5),
                              Text(
                                packageLocation,
                                style: const TextStyle(
                                  fontSize: 9,
                                  color: dark,
                                ),
                              ),
                              const Divider(color: Color(0xFFEADBD7)),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    'Kapasitas maksimal',
                                    style: TextStyle(fontSize: 8, color: hint),
                                  ),
                                  Text(
                                    packageCapacity,
                                    style: const TextStyle(
                                      fontSize: 9,
                                      color: dark,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              const Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Estimasi harga / paket',
                                    style: TextStyle(fontSize: 8, color: hint),
                                  ),
                                  Text(
                                    '-',
                                    style: TextStyle(fontSize: 11, color: rose),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        // TANGGAL PERNIKAHAN
                        _section(
                          context: context,
                          title: 'Tanggal Pernikahan',
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                selectedDate,
                                style: const TextStyle(
                                  fontFamily: serif,
                                  fontSize: 12,
                                  color: dark,
                                ),
                              ),
                              const SizedBox(height: 6),
                              const Text(
                                'Ketersediaan tanggal akan divalidasi penyedia.',
                                style: TextStyle(fontSize: 8, color: hint),
                              ),
                            ],
                          ),
                        ),

                        // DATA CALON PENGANTIN
                        _section(
                          context: context,
                          title: 'Data Calon Pengantin',
                          child: Column(
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: _info(
                                      'Calon pengantin pria',
                                      namaPria,
                                    ),
                                  ),
                                  Expanded(
                                    child: _info(
                                      'Calon pengantin wanita',
                                      namaWanita,
                                    ),
                                  ),
                                ],
                              ),
                              _info('Nomor WhatsApp', whatsapp),
                              _info('Email', email),
                            ],
                          ),
                        ),

                        // DETAIL ACARA
                        _section(
                          context: context,
                          title: 'Detail Acara',
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _info('Jumlah tamu', '$jumlahTamu tamu'),
                              _info(
                                'Alamat lengkap acara',
                                '$alamat, $kecamatan, $kota, $provinsi',
                              ),
                              _info('Detail alamat', detailAlamat),
                            ],
                          ),
                        ),

                        // CATATAN TAMBAHAN
                        _section(
                          context: context,
                          title: 'Catatan Tambahan',
                          child: Text(
                            catatan.isEmpty
                                ? 'Belum ada catatan tambahan.'
                                : catatan,
                            style: const TextStyle(fontSize: 9, color: dark),
                          ),
                        ),
                        // INFORMASI VALIDASI
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(11),
                          margin: const EdgeInsets.only(bottom: 10),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFF1ED),
                            border: Border.all(color: pink),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Menunggu validasi tanggal dari penyedia',
                                style: TextStyle(
                                  fontSize: 9,
                                  color: brown,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(height: 6),
                              Text(
                                'Setelah diajukan, penyedia akan '
                                'memvalidasi tanggal pilihanmu. Pengajuan '
                                'ini belum merupakan konfirmasi booking.',
                                style: TextStyle(
                                  fontSize: 8,
                                  color: dark,
                                  height: 1.5,
                                ),
                              ),
                            ],
                          ),
                        ),

                        // TOMBOL AKSI
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton.icon(
                                onPressed: () => Navigator.pop(context),
                                icon: const Icon(Icons.arrow_back, size: 12),
                                label: const Text(
                                  'Kembali',
                                  style: TextStyle(fontSize: 9),
                                ),
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: brown,
                                  backgroundColor: Colors.white,
                                  side: const BorderSide(color: pink),
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 13,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              flex: 2,
                              child: ElevatedButton(
                                onPressed: () => _submitBooking(context),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: rose,
                                  foregroundColor: Colors.white,
                                  elevation: 0,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 14,
                                  ),
                                ),
                                child: const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Ajukan Booking',
                                      style: TextStyle(fontSize: 9),
                                    ),
                                    SizedBox(width: 5),
                                    Icon(Icons.chevron_right, size: 15),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
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
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.94),
                    borderRadius: BorderRadius.circular(28),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _navItem(
                        context,
                        Icons.home_outlined,
                        'Beranda',
                        AppRoutes.home,
                      ),
                      _navItem(
                        context,
                        Icons.calendar_month_outlined,
                        'Rencana',
                        AppRoutes.rencana,
                      ),
                      _navItem(
                        context,
                        Icons.chat_bubble_outline,
                        'Chat',
                        AppRoutes.chat,
                      ),
                      _navItem(
                        context,
                        Icons.person_outline,
                        'User',
                        AppRoutes.user,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
