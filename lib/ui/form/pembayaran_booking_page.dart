import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

import '../bottom_navigation.dart';
import 'booking_confirmation_page.dart';

enum PaymentProofStatus { empty, uploaded, pending, rejected }

class PembayaranBookingPage extends StatefulWidget {
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
  final String provinsi;
  final String kota;
  final String kecamatan;
  final String totalPrice;

  // Gunakan rejected jika status bukti dari server ditolak.
  final PaymentProofStatus initialStatus;

  const PembayaranBookingPage({
    super.key,
    required this.packageName,
    this.packageLocation = '-',
    this.packageCapacity = '-',
    required this.selectedDate,
    required this.namaPria,
    required this.namaWanita,
    required this.whatsapp,
    this.email = '-',
    this.jumlahTamu = '-',
    this.alamat = '-',
    this.detailAlamat = '-',
    this.catatan = '',
    this.provinsi = '-',
    this.kota = '-',
    this.kecamatan = '-',
    this.totalPrice = 'Rp100.000.000',
    this.initialStatus = PaymentProofStatus.empty,
  });

  @override
  State<PembayaranBookingPage> createState() => _PembayaranBookingPageState();
}

class _PembayaranBookingPageState extends State<PembayaranBookingPage> {
  static const Color _rose = Color(0xFFC58A85);
  static const Color _pink = Color(0xFFE7B6B0);
  static const Color _dark = Color(0xFF493B38);
  static const Color _brown = Color(0xFF8A5A55);
  static const Color _hint = Color(0xFFA18F89);
  static const Color _light = Color(0xFFFBF1EE);
  static const String _serif = 'PlayfairDisplay';

  bool _hasNotification = true;

  final ImagePicker _picker = ImagePicker();

  File? _proofImage;

  late PaymentProofStatus _status;

  static const String _bankName = 'Bank BCA';
  static const String _accountNumber = '0000 0000 00';
  static const String _accountHolder = 'PT Royale Hall';

  @override
  void initState() {
    super.initState();
    _status = widget.initialStatus;
  }


  // NOTIFIKASI
  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: _brown,
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


  // GLASS CONTAINER


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
          child: const Icon(Icons.arrow_back, size: 19, color: _brown),
        ),
        const SizedBox(width: 12),
        const Text(
          'Pembayaran Booking',
          style: TextStyle(fontFamily: _serif, fontSize: 20, color: _dark),
        ),
      ],
    );
  }

  // ==============================
  // KARTU RINGKASAN PAKET
  // ==============================

  Widget _buildPackageCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.93),
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
            'Ringkasan Paket',
            style: TextStyle(fontFamily: _serif, fontSize: 14, color: _dark),
          ),

          const SizedBox(height: 9),

          Row(
            children: [
              Container(
                width: 48,
                height: 45,
                decoration: BoxDecoration(
                  color: const Color(0xFFF3DDD7),
                  borderRadius: BorderRadius.circular(7),
                ),
                child: const Icon(Icons.image_outlined, color: _rose, size: 25),
              ),

              const SizedBox(width: 9),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Gold · ${widget.packageName}',
                      style: const TextStyle(
                        fontFamily: _serif,
                        fontSize: 11,
                        color: _dark,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      widget.packageLocation,
                      style: const TextStyle(fontSize: 8, color: _hint),
                    ),
                    Text(
                      '${widget.selectedDate} · ${widget.jumlahTamu} tamu',
                      style: const TextStyle(fontSize: 8, color: _hint),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          Container(
            padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFFF5E1DC),
              borderRadius: BorderRadius.circular(7),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Total biaya',
                  style: TextStyle(fontSize: 9, color: _brown),
                ),
                Text(
                  widget.totalPrice,
                  style: const TextStyle(
                    fontSize: 11,
                    color: _rose,
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

  // INFORMASI PEMBAYARAN

  Widget _buildPaymentNotice() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(11),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFBFA),
        border: Border.all(color: _pink),
        borderRadius: BorderRadius.circular(10),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Pembayaran langsung ke penyedia',
            style: TextStyle(
              fontSize: 9,
              color: _brown,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 5),
          Text(
            'Transfer ke rekening penyedia di bawah ini, '
            'bukan melalui payment gateway Wedding+.',
            style: TextStyle(fontSize: 8, color: _dark, height: 1.5),
          ),
        ],
      ),
    );
  }

  // ==============================
  // REKENING PENYEDIA
  // ==============================

  Widget _buildBankCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.94),
        borderRadius: BorderRadius.circular(13),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Rekening Penyedia',
            style: TextStyle(fontFamily: _serif, fontSize: 15, color: _dark),
          ),

          const SizedBox(height: 7),

          const Text(
            _bankName,
            style: TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.bold,
              color: _dark,
            ),
          ),

          const SizedBox(height: 10),

          const Text(
            'Nomor rekening',
            style: TextStyle(fontSize: 8, color: _hint),
          ),

          const SizedBox(height: 3),

          Row(
            children: [
              Expanded(
                child: Text(
                  _accountNumber,
                  style: const TextStyle(
                    fontSize: 15,
                    color: _brown,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                  ),
                ),
              ),

              OutlinedButton.icon(
                onPressed: () async {
                  await Clipboard.setData(
                    const ClipboardData(text: _accountNumber),
                  );

                  if (mounted) {
                    _showMessage('Nomor rekening berhasil disalin');
                  }
                },
                icon: const Icon(Icons.copy, size: 12),
                label: const Text('Salin', style: TextStyle(fontSize: 9)),
                style: OutlinedButton.styleFrom(
                  foregroundColor: _rose,
                  side: const BorderSide(color: _pink),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 7,
                  ),
                  minimumSize: const Size(0, 30),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          const Text('Atas nama', style: TextStyle(fontSize: 8, color: _hint)),

          const SizedBox(height: 3),

          const Text(
            _accountHolder,
            style: TextStyle(
              fontSize: 9,
              color: _dark,
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: 8),

          const Text(
            'Data rekening contoh - konfirmasi rekening resmi '
            'kepada penyedia sebelum melakukan transfer.',
            style: TextStyle(fontSize: 7, color: _rose),
          ),
        ],
      ),
    );
  }

  // ==============================
  // CARA TRANSFER
  // ==============================

  Widget _buildTransferGuide() {
    final instructions = [
      'Pastikan bank, nomor rekening, dan nama penerima sesuai dengan data penyedia.',
      'Transfer tepat Rp100.000.000 melalui mobile banking, ATM, atau teller.',
      'Simpan bukti transfer, lalu unggah gambar yang jelas untuk diverifikasi penyedia.',
    ];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.94),
        borderRadius: BorderRadius.circular(13),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Cara Transfer',
            style: TextStyle(fontFamily: _serif, fontSize: 15, color: _dark),
          ),

          const SizedBox(height: 9),

          ...List.generate(
            instructions.length,
            (index) => Padding(
              padding: const EdgeInsets.only(bottom: 7),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 19,
                    height: 19,
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(
                      color: Color(0xFFF5DDD8),
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      '${index + 1}',
                      style: const TextStyle(
                        fontSize: 9,
                        color: _brown,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  const SizedBox(width: 8),

                  Expanded(
                    child: Text(
                      instructions[index],
                      style: const TextStyle(
                        fontSize: 8,
                        color: _dark,
                        height: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // STATUS BUKTI PEMBAYARAN

  Widget _buildStatusBox() {
    if (_status == PaymentProofStatus.empty) {
      return const SizedBox.shrink();
    }

    late String title;
    late String description;
    late IconData icon;

    Color background = const Color(0xFFF5DDD8);

    switch (_status) {
      case PaymentProofStatus.uploaded:
        title = 'Bukti siap dikirim';
        description = 'Preview tersimpan. Bukti belum dikirim ke penyedia.';
        icon = Icons.check_circle_outline;

      case PaymentProofStatus.pending:
        title = 'Menunggu Verifikasi Penyedia';
        description = 'Bukti sedang diperiksa. Pembayaran belum dikonfirmasi.';
        icon = Icons.access_time;

      case PaymentProofStatus.rejected:
        title = 'Perlu Perbaikan Bukti';
        description = 'Bukti kurang jelas atau nama pengirim tidak terbaca. Silakan upload ulang.';
        icon = Icons.error_outline;

      case PaymentProofStatus.empty:
        return const SizedBox.shrink();
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(9),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: _rose, size: 17),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 9,
                    color: _brown,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 8,
                    color: _dark,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ==============================
  // PILIH GAMBAR
  // ==============================

  Future<void> _pickImage() async {
    if (_status == PaymentProofStatus.pending) {
      _showMessage('Bukti sedang menunggu verifikasi penyedia.');
      return;
    }

    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );

      if (pickedFile == null) return;

      final file = File(pickedFile.path);

      final int fileSize = await file.length();

      if (fileSize > 5 * 1024 * 1024) {
        _showMessage('Ukuran gambar maksimal 5 MB.');
        return;
      }

      if (!mounted) return;

      setState(() {
        _proofImage = file;
        _status = PaymentProofStatus.uploaded;
      });

      _showMessage('Bukti transfer berhasil dipilih.');
    } on PlatformException catch (e) {
      debugPrint('IMAGE PICKER ERROR: ${e.code} - ${e.message}');

      _showMessage('Gagal membuka galeri: ${e.message ?? e.code}');
    } catch (e, stackTrace) {
      debugPrint('UPLOAD ERROR: $e');
      debugPrintStack(stackTrace: stackTrace);

      _showMessage('Gagal memilih gambar: $e');
    }
  }


  // KARTU UPLOAD

  Widget _buildUploadCard() {
    final bool isPending = _status == PaymentProofStatus.pending;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.94),
        borderRadius: BorderRadius.circular(13),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Bukti Pembayaran',
            style: TextStyle(fontFamily: _serif, fontSize: 15, color: _dark),
          ),

          const SizedBox(height: 4),

          const Text(
            'Gambar JPG atau PNG · Maksimal 5 MB',
            style: TextStyle(fontSize: 8, color: _hint),
          ),

          const SizedBox(height: 10),

          _buildStatusBox(),

          if (_status != PaymentProofStatus.empty) const SizedBox(height: 9),

          if (_proofImage == null) ...[
            GestureDetector(
              onTap: isPending ? null : _pickImage,
              child: Container(
                width: double.infinity,
                height: 135,
                decoration: BoxDecoration(
                  color: const Color(0xFFFFFBFA),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: _pink, style: BorderStyle.solid),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 37,
                      height: 37,
                      decoration: const BoxDecoration(
                        color: Color(0xFFF5DDD8),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.upload_file,
                        color: _rose,
                        size: 20,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      isPending
                          ? 'Bukti sedang diperiksa'
                          : 'Upload Bukti Transfer',
                      style: const TextStyle(
                        fontSize: 9,
                        color: _rose,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 5),
                    const Text(
                      'Ketuk untuk memilih gambar dari galeri atau kamera',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 8, color: _hint),
                    ),
                  ],
                ),
              ),
            ),
          ] else ...[
            Container(
              padding: const EdgeInsets.all(9),
              decoration: BoxDecoration(
                color: const Color(0xFFFFFBFA),
                borderRadius: BorderRadius.circular(9),
                border: Border.all(color: const Color(0xFFEADBD7)),
              ),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: Image.file(
                      _proofImage!,
                      width: 65,
                      height: 75,
                      fit: BoxFit.cover,
                    ),
                  ),

                  const SizedBox(width: 10),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'bukti-transfer',
                          style: TextStyle(
                            fontSize: 9,
                            color: _dark,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${(_proofImage!.lengthSync() / 1024).toStringAsFixed(0)} KB',
                          style: const TextStyle(fontSize: 8, color: _hint),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          _status == PaymentProofStatus.pending
                              ? 'Menunggu pemeriksaan'
                              : _status == PaymentProofStatus.rejected
                              ? 'Silakan perbaiki bukti'
                              : 'Siap dikirim ke penyedia',
                          style: const TextStyle(fontSize: 8, color: _rose),
                        ),
                      ],
                    ),
                  ),

                  IconButton(
                    onPressed: isPending ? null : _pickImage,
                    icon: const Icon(
                      Icons.edit_outlined,
                      color: _rose,
                      size: 19,
                    ),
                    tooltip: 'Ganti gambar',
                  ),
                ],
              ),
            ),
          ],

          const SizedBox(height: 8),

          const Text(
            'Pastikan nominal, nama pengirim, tanggal, dan tujuan transfer terlihat jelas.',
            style: TextStyle(fontSize: 8, color: _hint, height: 1.4),
          ),
        ],
      ),
    );
  }

  // TOMBOL KIRIM

  Widget _buildSubmitButton() {
    final bool isPending = _status == PaymentProofStatus.pending;

    // Bukti gambar bersifat opsional. Tombol aktif selama belum menunggu verifikasi.
    final bool canSubmit = _status != PaymentProofStatus.pending;

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: isPending
            ? null
            : canSubmit
            ? _submitPayment
            : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: _rose,
          disabledBackgroundColor: const Color(0xFFEEDBD7),
          foregroundColor: Colors.white,
          disabledForegroundColor: _hint,
          elevation: 0,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(9)),
        ),
        child: Text(
          isPending ? 'Menunggu Verifikasi' : 'Kirim Bukti Pembayaran',
          style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  void _submitPayment() {
    // Cegah pengiriman berulang saat status sudah menunggu verifikasi.
    if (_status == PaymentProofStatus.pending) return;

    // Upload bukti tidak wajib. Pengajuan tetap diteruskan tanpa gambar.
    setState(() {
      _status = PaymentProofStatus.pending;
    });

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => BookingConfirmationPage(
          packageName: widget.packageName,
          packageLocation: widget.packageLocation,
          packageCapacity: widget.packageCapacity,
          namaPria: widget.namaPria,
          namaWanita: widget.namaWanita,
          whatsapp: widget.whatsapp,
          email: widget.email,
          selectedDate: widget.selectedDate,

          // DATA DETAIL ACARA
          jumlahTamu: widget.jumlahTamu,
          provinsi: widget.provinsi,
          kota: widget.kota,
          kecamatan: widget.kecamatan,
          alamatLengkap: widget.alamat,
          detailAlamat: widget.detailAlamat,
          catatan: widget.catatan,

          totalPrice: widget.totalPrice,
        ),
      ),
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
      backgroundColor: _light,
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
                // HEADER TETAP SAMA
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                  child: _buildHeader(),
                ),

                // ISI HALAMAN
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(16, 5, 16, 100),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildTitle(),

                        const Padding(
                          padding: EdgeInsets.only(left: 29, top: 4),
                          child: Text(
                            'Tanggal disetujui · Silakan selesaikan pembayaran',
                            style: TextStyle(fontSize: 8, color: _hint),
                          ),
                        ),

                        const SizedBox(height: 14),

                        _buildPackageCard(),

                        const SizedBox(height: 10),

                        _buildPaymentNotice(),

                        const SizedBox(height: 10),

                        _buildBankCard(),

                        const SizedBox(height: 10),

                        _buildTransferGuide(),

                        const SizedBox(height: 10),

                        _buildUploadCard(),

                        const SizedBox(height: 12),

                        _buildSubmitButton(),

                        const SizedBox(height: 7),

                        Center(
                          child: Text(
                            _status == PaymentProofStatus.pending
                                ? 'Bukti pembayaran sedang diperiksa oleh penyedia.'
                                : 'Bukti transfer opsional. Kamu tetap bisa melanjutkan tanpa gambar.',
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 8, color: _hint),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // BOTTOM NAVIGATION TETAP SAMA
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
