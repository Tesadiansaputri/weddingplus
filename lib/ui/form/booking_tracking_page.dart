
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:smart_wedding_planning_system/ui/bottom_navigation.dart';


enum BookingStatus {
  waitingDate,
  approved,
  rejected,
  verifyingPayment,
  needsCorrection,
  confirmed,
}

class BookingTrackingPage extends StatefulWidget {
  final String packageName;
  final String packageLocation;
  final String packageCapacity;
  final String selectedDate;
  final String namaPria;
  final String namaWanita;
  final String whatsapp;
  final String email;
  final String jumlahTamu;
  final String alamat;
  final String detailAlamat;
  final String catatan;

  final BookingStatus initialStatus;

  const BookingTrackingPage({
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
    required this.alamat,
    required this.detailAlamat,
    required this.catatan,
    this.initialStatus = BookingStatus.waitingDate,
  });

  @override
  State<BookingTrackingPage> createState() =>
      _BookingTrackingPageState();
}

class _BookingTrackingPageState extends State<BookingTrackingPage> {
  static const Color rose = Color(0xFFC58A85);
  static const Color pink = Color(0xFFE7B6B0);
  static const Color dark = Color(0xFF493B38);
  static const Color brown = Color(0xFF8A5A55);
  static const Color hint = Color(0xFFA18F89);
  static const String serif = 'PlayfairDisplay';

  late BookingStatus _status;
  bool _hasNotification = true;

  @override
  void initState() {
    super.initState();
    _status = widget.initialStatus;
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: brown,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _changeStatus(BookingStatus status) {
    setState(() {
      _status = status;
    });
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Image.asset(
          'assets/images/logo_header.png',
          height: 45,
          errorBuilder: (_, __, ___) => const Text(
            '♡ wedding+',
            style: TextStyle(
              fontFamily: serif,
              fontSize: 19,
              color: rose,
            ),
          ),
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
                      color: dark,
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
                      backgroundColor: pink,
                      child: Icon(
                        Icons.person,
                        size: 17,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(width: 3),
                    Icon(
                      Icons.keyboard_arrow_down,
                      color: dark,
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

  Widget _section({
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
          Text(
            title,
            style: const TextStyle(
              fontFamily: serif,
              fontSize: 13,
              color: dark,
            ),
          ),
          const SizedBox(height: 10),
          child,
        ],
      ),
    );
  }

  Widget _packageCard() {
    return _section(
      title: 'Ringkasan Paket',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 55,
                height: 55,
                decoration: BoxDecoration(
                  color: const Color(0xFFF3DDD7),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.image_outlined,
                  color: rose,
                  size: 25,
                ),
              ),
              const SizedBox(width: 9),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Gold · Paket',
                      style: TextStyle(
                        fontSize: 8,
                        color: brown,
                      ),
                    ),
                    Text(
                      widget.packageName,
                      style: const TextStyle(
                        fontFamily: serif,
                        fontSize: 12,
                        color: dark,
                      ),
                    ),
                    Text(
                      widget.packageLocation,
                      style: const TextStyle(
                        fontSize: 8,
                        color: hint,
                      ),
                    ),
                    Text(
                      'ID Booking · WP-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
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
          const Divider(color: Color(0xFFEADBD7)),
          Row(
            children: [
              Expanded(
                child: _smallInfo('Tanggal acara', widget.selectedDate),
              ),
              Expanded(
                child: _smallInfo('Jumlah tamu', '${widget.jumlahTamu} tamu'),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Estimasi biaya',
                style: TextStyle(fontSize: 8, color: hint),
              ),
              const Text(
                'Rp100.000.000',
                style: TextStyle(
                  fontSize: 12,
                  color: rose,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _smallInfo(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 7, color: hint),
        ),
        const SizedBox(height: 3),
        Text(
          value,
          style: const TextStyle(fontSize: 8, color: dark),
        ),
      ],
    );
  }

  String get _statusLabel {
    switch (_status) {
      case BookingStatus.waitingDate:
        return 'MENUNGGU PENYEDIA';
      case BookingStatus.approved:
        return 'TANGGAL TERSEDIA';
      case BookingStatus.rejected:
        return 'PERLU GANTI TANGGAL';
      case BookingStatus.verifyingPayment:
        return 'PEMBAYARAN DIPERIKSA';
      case BookingStatus.needsCorrection:
        return 'PERLU UPLOAD ULANG';
      case BookingStatus.confirmed:
        return 'BOOKING BERHASIL';
    }
  }

  String get _statusTitle {
    switch (_status) {
      case BookingStatus.waitingDate:
        return 'Menunggu Validasi Tanggal';
      case BookingStatus.approved:
        return 'Tanggal Disetujui';
      case BookingStatus.rejected:
        return 'Tanggal Ditolak';
      case BookingStatus.verifyingPayment:
        return 'Menunggu Verifikasi Pembayaran';
      case BookingStatus.needsCorrection:
        return 'Perlu Perbaikan Bukti';
      case BookingStatus.confirmed:
        return 'Terkonfirmasi';
    }
  }

  String get _statusDescription {
    switch (_status) {
      case BookingStatus.waitingDate:
        return 'Penyedia sedang memeriksa ketersediaan tanggal ${widget.selectedDate}. Pembaruan akan muncul di halaman ini.';
      case BookingStatus.approved:
        return 'Tanggal ${widget.selectedDate} telah disetujui penyedia. Lanjutkan pembayaran untuk memproses booking kamu.';
      case BookingStatus.rejected:
        return 'Tanggal yang kamu pilih tidak tersedia. Silakan pilih tanggal lain.';
      case BookingStatus.verifyingPayment:
        return 'Bukti transfer telah diterima. Penyedia sedang memeriksa pembayaran dan akan mengonfirmasi booking.';
      case BookingStatus.needsCorrection:
        return 'Bukti pembayaran perlu diperbaiki. Pastikan nominal dan nama pengirim sesuai dengan instruksi penyedia.';
      case BookingStatus.confirmed:
        return 'Booking kamu untuk ${widget.selectedDate} berhasil dikonfirmasi. Semua tahap pengajuan sudah selesai.';
    }
  }

  Color get _statusColor {
    if (_status == BookingStatus.rejected ||
        _status == BookingStatus.needsCorrection) {
      return const Color(0xFFB86A60);
    }
    return rose;
  }

  IconData get _statusIcon {
    switch (_status) {
      case BookingStatus.waitingDate:
      case BookingStatus.verifyingPayment:
        return Icons.more_horiz;
      case BookingStatus.approved:
      case BookingStatus.confirmed:
        return Icons.check;
      case BookingStatus.rejected:
        return Icons.close;
      case BookingStatus.needsCorrection:
        return Icons.priority_high;
    }
  }

  Widget _statusCard() {
    return _section(
      title: _statusTitle,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 7,
            ),
            decoration: BoxDecoration(
              color: const Color(0xFFF2DAD6),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Row(
              children: [
                Icon(_statusIcon, size: 11, color: _statusColor),
                const SizedBox(width: 7),
                Text(
                  _statusLabel,
                  style: TextStyle(
                    fontSize: 7,
                    color: _statusColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Text(
            _statusDescription,
            style: const TextStyle(
              fontSize: 8,
              color: dark,
              height: 1.6,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            _statusMessage,
            style: TextStyle(
              fontSize: 8,
              color: _statusColor,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 10),
          _statusButton(),
        ],
      ),
    );
  }

  String get _statusMessage {
    switch (_status) {
      case BookingStatus.waitingDate:
        return 'Pengajuan terkirim · Data booking tersimpan';
      case BookingStatus.approved:
        return 'Tanggal disetujui · Menunggu pembayaran';
      case BookingStatus.rejected:
        return 'Tanggal tidak tersedia · Ajukan tanggal baru';
      case BookingStatus.verifyingPayment:
        return 'Bukti transfer terkirim · Menunggu pemeriksaan';
      case BookingStatus.needsCorrection:
        return 'Bukti transfer · Perlu diperbaiki';
      case BookingStatus.confirmed:
        return 'Booking berhasil · Siap menuju hari bahagia';
    }
  }

  Widget _statusButton() {
    switch (_status) {
      case BookingStatus.waitingDate:
        return _wideButton(
          'Menunggu validasi tanggal',
          () {},
          disabled: true,
        );
      case BookingStatus.approved:
        return _wideButton(
          'Lanjutkan Pembayaran',
          () => _changeStatus(BookingStatus.verifyingPayment),
        );
      case BookingStatus.rejected:
        return _wideButton(
          'Ganti Tanggal',
          () => _showMessage(
            'Silakan hubungi penyedia untuk memilih tanggal baru.',
          ),
        );
      case BookingStatus.verifyingPayment:
        return _wideButton(
          'Menunggu verifikasi penyedia',
          () {},
          disabled: true,
        );
      case BookingStatus.needsCorrection:
        return _wideButton(
          'Upload Ulang Bukti',
          () => _changeStatus(BookingStatus.verifyingPayment),
        );
      case BookingStatus.confirmed:
        return _wideButton(
          'Booking telah terkonfirmasi',
          () {},
          disabled: true,
        );
    }
  }

  Widget _wideButton(
    String label,
    VoidCallback onPressed, {
    bool disabled = false,
  }) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: disabled ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: disabled ? const Color(0xFFF2DAD6) : rose,
          disabledBackgroundColor: const Color(0xFFF2DAD6),
          disabledForegroundColor: brown,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(vertical: 10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: Text(
          label,
          style: const TextStyle(fontSize: 8),
        ),
      ),
    );
  }

  Widget _trackingStep({
    required int number,
    required String title,
    required String description,
    required bool completed,
    required bool active,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                color: completed ? rose : const Color(0xFFF4E5E1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                completed ? Icons.check : Icons.circle,
                size: completed ? 13 : 7,
                color: completed ? Colors.white : pink,
              ),
            ),
            if (number != 4)
              Container(
                width: 1,
                height: 23,
                color: const Color(0xFFE8D1CC),
              ),
          ],
        ),
        const SizedBox(width: 9),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 2),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 8,
                    color: active ? dark : hint,
                    fontWeight: active ? FontWeight.w600 : FontWeight.normal,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 7,
                    color: hint,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _progressCard() {
    int currentStep;

    switch (_status) {
      case BookingStatus.waitingDate:
      case BookingStatus.approved:
      case BookingStatus.rejected:
        currentStep = 2;
        break;
      case BookingStatus.verifyingPayment:
      case BookingStatus.needsCorrection:
        currentStep = 3;
        break;
      case BookingStatus.confirmed:
        currentStep = 4;
        break;
    }

    return _section(
      title: 'Perkembangan Booking',
      child: Column(
        children: [
          _trackingStep(
            number: 1,
            title: 'Pengajuan dikirim',
            description: 'Data booking telah diterima',
            completed: true,
            active: currentStep == 1,
          ),
          _trackingStep(
            number: 2,
            title: 'Validasi tanggal',
            description: _status == BookingStatus.rejected
                ? 'Tanggal ditolak · Ajukan tanggal baru'
                : _status == BookingStatus.approved
                    ? 'Tanggal ${widget.selectedDate} disetujui'
                    : 'Menunggu ketersediaan tanggal',
            completed: currentStep >= 2 &&
                _status != BookingStatus.waitingDate,
            active: currentStep == 2,
          ),
          _trackingStep(
            number: 3,
            title: 'Verifikasi pembayaran',
            description: _status == BookingStatus.needsCorrection
                ? 'Bukti perlu diperbaiki'
                : 'Menunggu proses pembayaran',
            completed: currentStep >= 3 &&
                _status != BookingStatus.verifyingPayment &&
                _status != BookingStatus.needsCorrection,
            active: currentStep == 3,
          ),
          _trackingStep(
            number: 4,
            title: 'Booking terkonfirmasi',
            description: _status == BookingStatus.confirmed
                ? 'Booking berhasil dikonfirmasi'
                : 'Setelah pembayaran diverifikasi',
            completed: _status == BookingStatus.confirmed,
            active: currentStep == 4,
          ),
        ],
      ),
    );
  }

  Widget _vendorCard() {
    return _section(
      title: 'Penyedia Layanan',
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 43,
                height: 43,
                decoration: BoxDecoration(
                  color: const Color(0xFFF3DDD7),
                  borderRadius: BorderRadius.circular(7),
                ),
                child: const Icon(
                  Icons.hotel_outlined,
                  color: rose,
                  size: 22,
                ),
              ),
              const SizedBox(width: 9),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'The Royale Hall',
                      style: TextStyle(
                        fontFamily: serif,
                        fontSize: 11,
                        color: dark,
                      ),
                    ),
                    Text(
                      'Vendor venue · ${widget.packageLocation}',
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
          OutlinedButton.icon(
            onPressed: () {
              _showMessage('Fitur chat penyedia menunggu koneksi backend.');
            },
            icon: const Icon(Icons.chat_bubble_outline, size: 13),
            label: const Text(
              'Hubungi Penyedia',
              style: TextStyle(fontSize: 8),
            ),
            style: OutlinedButton.styleFrom(
              foregroundColor: brown,
              side: const BorderSide(color: pink),
              minimumSize: const Size(double.infinity, 34),
              padding: const EdgeInsets.symmetric(vertical: 7),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _navItem(
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
            Icon(icon, size: 22, color: hint),
            const SizedBox(height: 2),
            Text(
              label,
              style: const TextStyle(
                fontSize: 9,
                color: hint,
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
          _navItem(Icons.home_outlined, 'Beranda', AppRoutes.home),
          _navItem(Icons.calendar_month_outlined, 'Rencana', AppRoutes.rencana),
          _navItem(Icons.chat_bubble_outline, 'Chat', AppRoutes.chat),
          _navItem(Icons.person_outline, 'User', AppRoutes.user),
        ],
      ),
    );
  }

  Widget _buildTitle() {
    return Row(
      children: [
        GestureDetector(
          onTap: () => Navigator.pop(context),
          child: const Icon(
            Icons.arrow_back,
            size: 20,
            color: brown,
          ),
        ),
        const SizedBox(width: 12),
        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Status Booking',
              style: TextStyle(
                fontFamily: serif,
                fontSize: 21,
                color: dark,
              ),
            ),
            Text(
              'Pantau perjalanan menuju hari bahagiamu',
              style: TextStyle(
                fontSize: 9,
                color: hint,
              ),
            ),
          ],
        ),
      ],
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
              errorBuilder: (_, __, ___) => Container(
                color: const Color(0xFFFBF1EE),
              ),
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
                        const SizedBox(height: 14),
                        _packageCard(),
                        _statusCard(),
                        _progressCard(),
                        _vendorCard(),
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
