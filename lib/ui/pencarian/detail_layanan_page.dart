
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:smart_wedding_planning_system/ui/form/form_booking_page.dart';

import '../bottom_navigation.dart';

class DetailLayananPage extends StatefulWidget {
  const DetailLayananPage({super.key});

  @override
  State<DetailLayananPage> createState() => _DetailLayananPageState();
}

class _DetailLayananPageState extends State<DetailLayananPage> {
  static const Color _rose = Color(0xFFC58A85);
  static const Color _pink = Color(0xFFE7B6B0);
  static const Color _dark = Color(0xFF493B38);
  static const Color _hint = Color(0xFF9A8985);
  static const Color _brown = Color(0xFF8A5A55);
  static const String _serif = 'PlayfairDisplay';

  // TODO BACKEND:
  // Ganti data sementara berikut dengan data dari API/database.

  String? serviceName = 'The Royale Hall';
  String? serviceCategory = 'Pernikahan di Hotel';
  String? location = 'Tegal';
  String? rating = '4.9';
  String? reviewCount = '1.2k ulasan';
  String? capacity = '500 Tamu';

  String? packageName = 'Gold · Paket Hotel Basic';
  String? packageDescription = 'Venue hotel · katering · dekorasi dasar';

  String? packagePrice = 'Rp100.000.000';
  String? priceNote =
      'Harga dan ketersediaan dapat dikonfirmasi oleh vendor.';

  String? serviceImage = 'assets/images/royale_hall.png';

  // TODO BACKEND:
  // Ambil daftar fasilitas dari response API.
  List<String> facilities = [
    'Venue hotel',
    'Katering',
    'Dekorasi dasar',
  ];

  List<String> facilityDescriptions = [
    'Ruang resepsi nyaman untuk momen istimewamu.',
    'Sajian prasmanan untuk menjamu para tamu.',
    'Pelaminan dan dekorasi area resepsi.',
  ];

  String _display(String? value) {
    if (value == null || value.trim().isEmpty) {
      return '-';
    }
    return value;
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

  // =====================================================
  // NAVIGASI BOOKING
  // =====================================================

  void _openBookingForm() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const FormBookingPage(),
      ),
    );
  }

  // =====================================================
  // HEADER
  // =====================================================

  Widget _buildHeader() {
    return Row(
      children: [
        Image.asset(
          'assets/images/logo_header.png',
          width: 125,
          height: 42,
          fit: BoxFit.contain,
          errorBuilder: (_, __, ___) {
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
            color: Colors.white,
            borderRadius: BorderRadius.circular(25),
            boxShadow: [
              BoxShadow(
                color: _brown.withOpacity(0.12),
                blurRadius: 10,
              ),
            ],
          ),
          child: const Row(
            children: [
              CircleAvatar(
                radius: 11,
                backgroundColor: _pink,
                child: Icon(
                  Icons.person,
                  size: 15,
                  color: Colors.white,
                ),
              ),
              SizedBox(width: 5),
              Icon(
                Icons.keyboard_arrow_down,
                size: 17,
                color: _dark,
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
              color: _brown.withOpacity(0.12),
              blurRadius: 10,
            ),
          ],
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Icon(icon, size: 19, color: _dark),
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

  // =====================================================
  // JUDUL
  // =====================================================

  Widget _buildTitle() {
    return Row(
      children: [
        GestureDetector(
          onTap: () => Navigator.pop(context),
          child: const Icon(
            Icons.arrow_back,
            color: _rose,
            size: 22,
          ),
        ),
        const SizedBox(width: 13),
        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Detail Layanan',
              style: TextStyle(
                fontFamily: _serif,
                fontSize: 22,
                color: _dark,
              ),
            ),
            Text(
              'Pilihan istimewa untuk hari bahagiamu',
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

  // =====================================================
  // FOTO DAN INFORMASI LAYANAN
  // =====================================================

  Widget _buildServiceCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(13),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              SizedBox(
                width: double.infinity,
                height: 137,
                child: Image.asset(
                  serviceImage ?? '',
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) {
                    return Container(
                      color: const Color(0xFFF0D8D3),
                      child: const Icon(
                        Icons.image_outlined,
                        color: _rose,
                        size: 45,
                      ),
                    );
                  },
                ),
              ),
              Positioned(
                top: 10,
                left: 10,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 9,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.95),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Text(
                    _display(serviceCategory),
                    style: const TextStyle(
                      fontSize: 8,
                      color: _rose,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(11, 9, 11, 11),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        _display(serviceName),
                        style: const TextStyle(
                          fontFamily: _serif,
                          fontSize: 17,
                          color: _dark,
                        ),
                      ),
                    ),
                    const Icon(
                      Icons.location_on_outlined,
                      color: _rose,
                      size: 12,
                    ),
                    Text(
                      _display(location),
                      style: const TextStyle(
                        fontSize: 8,
                        color: _hint,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 3),
                Row(
                  children: [
                    const Icon(
                      Icons.star,
                      color: Color(0xFFE9B65B),
                      size: 12,
                    ),
                    const SizedBox(width: 3),
                    Text(
                      '${_display(rating)} (${_display(reviewCount)})',
                      style: const TextStyle(
                        fontSize: 8,
                        color: _hint,
                      ),
                    ),
                    const SizedBox(width: 5),
                    Text(
                      _display(capacity),
                      style: const TextStyle(
                        fontSize: 8,
                        color: _hint,
                      ),
                    ),
                  ],
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 7),
                  child: Divider(
                    height: 1,
                    color: Color(0xFFF0DCD8),
                  ),
                ),
                Text(
                  _display(packageName),
                  style: const TextStyle(
                    fontFamily: _serif,
                    fontSize: 14,
                    color: _brown,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  _display(packageDescription),
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
  }

  // =====================================================
  // FASILITAS PAKET
  // =====================================================

  Widget _buildFacilities() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Sudah termasuk dalam paket',
          style: TextStyle(
            fontFamily: _serif,
            fontSize: 15,
            color: _brown,
          ),
        ),
        const SizedBox(height: 7),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(11),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.95),
            borderRadius: BorderRadius.circular(13),
          ),
          child: facilities.isEmpty
              ? const Text(
                  'Belum ada informasi fasilitas.',
                  style: TextStyle(
                    fontSize: 9,
                    color: _hint,
                  ),
                )
              : Column(
                  children: List.generate(facilities.length, (index) {
                    final description =
                        index < facilityDescriptions.length
                            ? facilityDescriptions[index]
                            : '-';

                    return Padding(
                      padding: EdgeInsets.only(
                        bottom: index == facilities.length - 1 ? 0 : 9,
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 15,
                            height: 15,
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFEDEA),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: const Icon(
                              Icons.check,
                              size: 11,
                              color: _rose,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  facilities[index],
                                  style: const TextStyle(
                                    fontSize: 9,
                                    fontWeight: FontWeight.w600,
                                    color: _dark,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  description,
                                  style: const TextStyle(
                                    fontSize: 7,
                                    color: _hint,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ),
        ),
      ],
    );
  }

  // =====================================================
  // HARGA PAKET
  // =====================================================

  Widget _buildPrice() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Anggaran contoh',
          style: TextStyle(
            fontSize: 8,
            color: _hint,
          ),
        ),
        const SizedBox(height: 3),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Text(
                _display(packagePrice),
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: _rose,
                ),
              ),
            ),
            const Text(
              '/ paket',
              style: TextStyle(
                fontSize: 8,
                color: _hint,
              ),
            ),
          ],
        ),
        const SizedBox(height: 5),
        Text(
          _display(priceNote),
          style: const TextStyle(
            fontSize: 7,
            color: _hint,
          ),
        ),
      ],
    );
  }

  // =====================================================
  // TOMBOL CHAT DAN BOOKING
  // =====================================================

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: SizedBox(
            height: 38,
            child: OutlinedButton.icon(
              onPressed: () {
                _showMessage('Fitur chat vendor menunggu koneksi backend.');
              },
              icon: const Icon(
                Icons.chat_outlined,
                size: 14,
              ),
              label: const Text(
                'Chat Vendor',
                style: TextStyle(fontSize: 9),
              ),
              style: OutlinedButton.styleFrom(
                foregroundColor: _rose,
                side: const BorderSide(color: _rose),
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(9),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: SizedBox(
            height: 38,
            child: ElevatedButton(
              onPressed: _openBookingForm,
              style: ElevatedButton.styleFrom(
                backgroundColor: _rose,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(9),
                ),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Booking Sekarang',
                    style: TextStyle(fontSize: 9),
                  ),
                  SizedBox(width: 5),
                  Icon(
                    Icons.chevron_right,
                    size: 16,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  // =====================================================
  // BOTTOM NAVIGATION
  // =====================================================

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
            Icon(icon, size: 23, color: _hint),
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

  // =====================================================
  // BUILD
  // =====================================================

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
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                  child: _buildHeader(),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(18, 3, 18, 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildTitle(),
                        const SizedBox(height: 12),
                        _buildServiceCard(),
                        const SizedBox(height: 13),
                        _buildFacilities(),
                        const SizedBox(height: 13),
                        _buildPrice(),
                        const SizedBox(height: 8),
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
