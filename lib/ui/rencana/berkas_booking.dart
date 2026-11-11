
import 'package:flutter/material.dart';

import '../bottom_navigation.dart';

class BerkasBookingPage extends StatefulWidget {
  const BerkasBookingPage({
    super.key,
    this.onBerandaTap,
    this.onRencanaTap,
    this.onChatTap,
    this.onUserTap,
  });

  final VoidCallback? onBerandaTap;
  final VoidCallback? onRencanaTap;
  final VoidCallback? onChatTap;
  final VoidCallback? onUserTap;

  @override
  State<BerkasBookingPage> createState() => _BerkasBookingPageState();
}

class _BerkasBookingPageState extends State<BerkasBookingPage> {
  static const Color _rose = Color(0xFFC58A85);
  static const Color _dark = Color(0xFF493B38);
  static const Color _hint = Color(0xFFA18F89);
  static const Color _line = Color(0xFFF0DFDA);
  static const Color _pink = Color(0xFFF9EAE6);

  // ==================================================
  // DATA BERKAS
  // TODO BACKEND:
  // Ganti status dan data ini dengan response API.
  // ==================================================

  bool? ktpUploaded;
  bool? familyCardUploaded;
  bool? marriageLetterUploaded;
  bool? transferUploaded;

  // ==================================================
  // DATA BOOKING
  // TODO BACKEND:
  // Ambil data paket dan vendor dari API booking.
  // ==================================================

  String? packageName;
  String? vendorName;

  bool? vendorValidated;

  int get _completedTasks {
    return [
      ktpUploaded,
      familyCardUploaded,
      marriageLetterUploaded,
      transferUploaded,
    ].where((value) => value == true).length;
  }

  int get _progress => ((_completedTasks / 4) * 100).round();

  @override
  void initState() {
    super.initState();

    // TODO BACKEND:
    // _fetchWeddingDocuments();
    // _fetchBookingData();
  }

  // ==================================================
  // BUILD UTAMA
  // ==================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4DAD4),
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
                        Color(0xFFFFF9F6),
                        Color(0xFFF1D0C9),
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
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(
                      17, 15, 17, 18,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildHeader(),
                        const SizedBox(height: 24),
                        _buildBackButton(),
                        const SizedBox(height: 13),
                        _buildTitle(),
                        const SizedBox(height: 13),
                        _buildProgressCard(),
                        const SizedBox(height: 17),
                        _buildDocumentSection(),
                        const SizedBox(height: 25),
                        _buildBookingSection(),
                      ],
                    ),
                  ),
                ),
                _buildBottomNav(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ==================================================
  // HEADER - SAMA DENGAN HOME PAGE
  // ==================================================

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

  Widget _buildLogo() {
    return Image.asset(
      'assets/images/logo_header.png',
      width: 145,
      height: 55,
      fit: BoxFit.contain,
      alignment: Alignment.centerLeft,
      errorBuilder: (context, error, stackTrace) {
        return const Text(
          'wedding+',
          style: TextStyle(
            fontFamily: 'PlayfairDisplay',
            fontSize: 22,
            color: _rose,
          ),
        );
      },
    );
  }

  Widget _buildBell() {
    return GestureDetector(
      onTap: () => _showMessage('Notifikasi belum tersedia'),
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: _rose.withOpacity(0.15),
              blurRadius: 12,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            const Icon(
              Icons.notifications_none,
              size: 22,
              color: _dark,
            ),
            Positioned(
              top: 9,
              right: 9,
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
    return GestureDetector(
      onTap: () => _showMessage('Menu profil belum dihubungkan'),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 5,
          vertical: 5,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: _rose.withOpacity(0.15),
              blurRadius: 12,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: const Row(
          children: [
            CircleAvatar(
              radius: 14,
              backgroundColor: Color(0xFFE7B6B0),
              child: Icon(
                Icons.person,
                size: 17,
                color: Colors.white,
              ),
            ),
            SizedBox(width: 5),
            Icon(
              Icons.keyboard_arrow_down,
              size: 19,
              color: _dark,
            ),
          ],
        ),
      ),
    );
  }

  // ==================================================
  // TOMBOL KEMBALI
  // ==================================================

  Widget _buildBackButton() {
    return GestureDetector(
      onTap: () => Navigator.pop(context),
      child: const Row(
        children: [
          Icon(
            Icons.arrow_back,
            size: 16,
            color: _rose,
          ),
          SizedBox(width: 7),
          Text(
            'Rencana pernikahan',
            style: TextStyle(
              fontSize: 10,
              color: _rose,
            ),
          ),
        ],
      ),
    );
  }

  // ==================================================
  // JUDUL
  // ==================================================

  Widget _buildTitle() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Berkas & kepastian hari\nbahagia',
          style: TextStyle(
            fontFamily: 'PlayfairDisplay',
            fontSize: 23,
            height: 1.12,
            color: _dark,
          ),
        ),
        SizedBox(height: 5),
        Text(
          'Lengkapi berkasmu, selangkah lebih dekat ke hari itu.',
          style: TextStyle(
            fontSize: 10,
            color: _hint,
          ),
        ),
      ],
    );
  }

  // ==================================================
  // PROGRESS
  // ==================================================

  Widget _buildProgressCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.95),
        borderRadius: BorderRadius.circular(13),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  '$_completedTasks dari 4 tugas sudah dipindai',
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: _dark,
                  ),
                ),
              ),
              Text(
                '$_progress%',
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: _rose,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: _completedTasks / 4,
              minHeight: 4,
              backgroundColor: _line,
              valueColor: const AlwaysStoppedAnimation<Color>(_rose),
            ),
          ),
          const SizedBox(height: 9),
          const Text(
            'Centang otomatis setelah hasil scan tersimpan, bukan dicentang manual.',
            style: TextStyle(
              fontSize: 9,
              height: 1.4,
              color: _hint,
            ),
          ),
        ],
      ),
    );
  }

  // ==================================================
  // DAFTAR BERKAS PERNIKAHAN
  // ==================================================

  Widget _buildDocumentSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Expanded(
              child: Text(
                'Berkas pernikahan',
                style: TextStyle(
                  fontFamily: 'PlayfairDisplay',
                  fontSize: 17,
                  color: _dark,
                ),
              ),
            ),
            Text(
              '$_completedTasks/3 tersimpan',
              style: const TextStyle(
                fontSize: 9,
                color: _hint,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),

        Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.96),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              _buildDocumentItem(
                title: 'KTP kedua calon pengantin',
                uploaded: ktpUploaded,
                onScan: () => _scanDocument('KTP kedua calon pengantin'),
                onResult: () => _showMessage('Hasil scan KTP belum tersedia'),
                isLast: false,
              ),
              _buildDocumentItem(
                title: 'Kartu Keluarga kedua calon',
                uploaded: familyCardUploaded,
                onScan: () => _scanDocument('Kartu Keluarga'),
                onResult: () => _showMessage('Hasil scan KK belum tersedia'),
                isLast: false,
              ),
              _buildDocumentItem(
                title: 'Surat pengantar nikah',
                uploaded: marriageLetterUploaded,
                onScan: () => _scanDocument('Surat pengantar nikah'),
                onResult: () => _showMessage('Hasil scan surat belum tersedia'),
                isLast: true,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDocumentItem({
    required String title,
    required bool? uploaded,
    required VoidCallback onScan,
    required VoidCallback onResult,
    required bool isLast,
  }) {
    final isUploaded = uploaded == true;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 11,
        vertical: 11,
      ),
      decoration: BoxDecoration(
        border: isLast
            ? null
            : const Border(
                bottom: BorderSide(color: _line),
              ),
      ),
      child: Row(
        children: [
          Container(
            width: 16,
            height: 16,
            decoration: BoxDecoration(
              color: isUploaded ? _rose : Colors.white,
              border: Border.all(
                color: isUploaded ? _rose : const Color(0xFFD9BEB7),
              ),
              borderRadius: BorderRadius.circular(4),
            ),
            child: isUploaded
                ? const Icon(
                    Icons.check,
                    color: Colors.white,
                    size: 13,
                  )
                : null,
          ),
          const SizedBox(width: 9),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.w600,
                    color: _dark,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  isUploaded
                      ? 'Sudah dipindai · hasil tersimpan'
                      : 'Belum dipindai',
                  style: TextStyle(
                    fontSize: 8,
                    color: isUploaded
                        ? const Color(0xFF8AA28A)
                        : _hint,
                  ),
                ),
              ],
            ),
          ),

          if (isUploaded)
            GestureDetector(
              onTap: onResult,
              child: const Text(
                'Lihat hasil',
                style: TextStyle(
                  fontSize: 9,
                  color: _rose,
                  fontWeight: FontWeight.w600,
                ),
              ),
            )
          else
            GestureDetector(
              onTap: onScan,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: _pink,
                  borderRadius: BorderRadius.circular(9),
                ),
                child: const Text(
                  'Scan',
                  style: TextStyle(
                    fontSize: 9,
                    color: _rose,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  // ==================================================
  // VALIDASI AKHIR BOOKING
  // ==================================================

  Widget _buildBookingSection() {
    final isTransferUploaded = transferUploaded == true;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Expanded(
              child: Text(
                'Validasi akhir booking',
                style: TextStyle(
                  fontFamily: 'PlayfairDisplay',
                  fontSize: 17,
                  color: _dark,
                ),
              ),
            ),
            Text(
              isTransferUploaded ? '1/1 tersimpan' : '0/1 tersimpan',
              style: const TextStyle(
                fontSize: 9,
                color: _hint,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),

        Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.96),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(11, 11, 11, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${_display(packageName)} · Paket',
                      style: const TextStyle(
                        fontFamily: 'PlayfairDisplay',
                        fontSize: 11,
                        color: _dark,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      _display(vendorName),
                      style: const TextStyle(
                        fontSize: 8,
                        color: _hint,
                      ),
                    ),
                  ],
                ),
              ),

              _buildDocumentItem(
                title: 'Bukti / struk transfer',
                uploaded: transferUploaded,
                onScan: () => _scanDocument('Bukti / struk transfer'),
                onResult: () => _showMessage('Bukti transfer belum tersedia'),
                isLast: true,
              ),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 11,
                  vertical: 10,
                ),
                decoration: const BoxDecoration(
                  color: Color(0xFFF8F0E2),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(12),
                    bottomRight: Radius.circular(12),
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.access_time,
                      color: Color(0xFFAD7B36),
                      size: 14,
                    ),
                    const SizedBox(width: 7),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            vendorValidated == true
                                ? 'Booking telah divalidasi vendor'
                                : 'Menunggu validasi vendor',
                            style: const TextStyle(
                              fontSize: 9,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF9B6B2E),
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            vendorValidated == true
                                ? 'Booking sudah terkonfirmasi.'
                                : 'Booking belum terkonfirmasi.',
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
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ==================================================
  // SCAN BERKAS
  // ==================================================

  void _scanDocument(String documentName) {
    _showMessage(
      'Fitur scan $documentName akan dihubungkan ke backend.',
    );

    // TODO BACKEND:
    // 1. Buka kamera atau galeri.
    // 2. Pilih / ambil gambar dokumen.
    // 3. Upload gambar ke API.
    // 4. Simpan hasil scan.
    // 5. Perbarui status dokumen berdasarkan response API.
    //
    // Jangan mengubah status uploaded menjadi true
    // sebelum backend mengonfirmasi dokumen tersimpan.
  }

  // ==================================================
  // BOTTOM NAVIGATION - KONSISTEN DENGAN HOME & ASISTEN
  // ==================================================

  Widget _buildBottomNav() {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 11,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.70),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
          color: Colors.white,
          width: 1.2,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _navItem(
            Icons.home_outlined,
            'Beranda',
            widget.onBerandaTap ??
                () => navigateToBottomTab(context, AppRoutes.home),
          ),
          _navItem(
            Icons.calendar_month_outlined,
            'Rencana',
            widget.onRencanaTap ??
                () => navigateToBottomTab(context, AppRoutes.rencana),
            selected: true,
          ),
          _navItem(
            Icons.chat_bubble_outline,
            'Chat',
            widget.onChatTap ??
                () => navigateToBottomTab(context, AppRoutes.chat),
          ),
          _navItem(
            Icons.person_outline,
            'User',
            widget.onUserTap ??
                () => navigateToBottomTab(context, AppRoutes.user),
          ),
        ],
      ),
    );
  }

  Widget _navItem(
    IconData icon,
    String label,
    VoidCallback onTap, {
    bool selected = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 9),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 23,
              color: selected ? _dark : const Color(0xFF8E8582),
            ),
            const SizedBox(height: 3),
            Text(
              label,
              style: TextStyle(
                fontSize: 9,
                color: selected ? _dark : _hint,
                decoration: selected
                    ? TextDecoration.underline
                    : TextDecoration.none,
                decorationThickness: 2,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ==================================================
  // PESAN SEMENTARA
  // ==================================================

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  String _display(String? value) {
    if (value == null || value.trim().isEmpty) {
      return '-';
    }

    return value;
  }
}
