
import 'package:flutter/material.dart';

import 'bottom_navigation.dart';

class UserPage extends StatefulWidget {
  const UserPage({
    super.key,
    this.onBerandaTap,
    this.onRencanaTap,
    this.onChatTap,
  });

  final VoidCallback? onBerandaTap;
  final VoidCallback? onRencanaTap;
  final VoidCallback? onChatTap;

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  // WARNA APLIKASI
  static const Color _rose = Color(0xFFC58A85);
  static const Color _dark = Color(0xFF3D3533);
  static const Color _hint = Color(0xFF9A8985);
  static const Color _line = Color(0xFFF0DCD8);

  // ==================================================
  // DATA PROFIL
  // TODO BACKEND:
  // Isi variabel ini dari response API profil pengguna.
  // ==================================================

  String? fullName;
  String? nickname;
  String? age;
  String? gender;
  String? domicile;
  String? email;
  String? phone;
  String? profileImage;

  // ==================================================
  // DATA PERNIKAHAN
  // TODO BACKEND:
  // Isi variabel ini dari response API data pernikahan.
  // ==================================================

  String? partnerName;
  String? weddingDate;
  String? weddingLocation;

  // ==================================================
  // FUNGSI MENAMPILKAN DATA KOSONG
  // ==================================================

  String _display(String? value) {
    if (value == null || value.trim().isEmpty) {
      return '-';
    }

    return value;
  }

  // ==================================================
  // INIT STATE
  // ==================================================

  @override
  void initState() {
    super.initState();

    // TODO BACKEND:
    // Panggil fungsi pengambilan data profil dari API.
    // Contoh: _fetchUserProfile();
    //
    // Panggil juga fungsi pengambilan data pernikahan.
    // Contoh: _fetchWeddingData();
  }

  // ==================================================
  // BUILD UTAMA
  // ==================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5D8D2),
      body: Stack(
        children: [
          // BACKGROUND
          Positioned.fill(
            child: Image.asset(
              'assets/images/home.png',
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color(0xFFFFF8F5),
                        Color(0xFFF1CBC5),
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
                      20, 16, 20, 20,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildHeader(),
                        const SizedBox(height: 25),

                        _buildTitle(),
                        const SizedBox(height: 14),

                        _buildProfileCard(),
                        const SizedBox(height: 15),

                        _buildBiodataCard(),
                        const SizedBox(height: 15),

                        _buildWeddingCard(),
                        const SizedBox(height: 15),

                        _buildAccountMenu(),
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
  // HEADER
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
    onTap: _showEditProfile,
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
      child: Row(
        children: [
          _profileImage(size: 28),
          const SizedBox(width: 5),
          const Icon(
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
  // JUDUL HALAMAN
  // ==================================================

  Widget _buildTitle() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Profil Saya',
          style: TextStyle(
            fontFamily: 'PlayfairDisplay',
            fontSize: 26,
            color: _dark,
          ),
        ),
        SizedBox(height: 3),
        Text(
          'Tentang dirimu dan hari bahagiamu.',
          style: TextStyle(
            fontSize: 11,
            color: _hint,
          ),
        ),
      ],
    );
  }

  // ==================================================
  // FOTO PROFIL
  // ==================================================

  Widget _profileImage({double size = 55}) {
    if (profileImage != null && profileImage!.isNotEmpty) {
      return ClipOval(
        child: Image.network(
          profileImage!,
          width: size,
          height: size,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return _profilePlaceholder(size);
          },
        ),
      );
    }

    return _profilePlaceholder(size);
  }

  Widget _profilePlaceholder(double size) {
    return Container(
      width: size,
      height: size,
      decoration: const BoxDecoration(
        color: Color(0xFFF5E4E0),
        shape: BoxShape.circle,
      ),
      child: Icon(
        Icons.person_outline,
        size: size * 0.65,
        color: _rose,
      ),
    );
  }

  // ==================================================
  // KARTU PROFIL
  // ==================================================

  Widget _buildProfileCard() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.94),
        borderRadius: BorderRadius.circular(13),
      ),
      child: Row(
        children: [
          _profileImage(size: 55),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _display(nickname),
                  style: const TextStyle(
                    fontFamily: 'PlayfairDisplay',
                    fontSize: 21,
                    color: _dark,
                  ),
                ),
                const SizedBox(height: 2),
                const Text(
                  'Calon pengantin',
                  style: TextStyle(
                    fontSize: 10,
                    color: _hint,
                  ),
                ),
              ],
            ),
          ),

          GestureDetector(
            onTap: _showEditProfile,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 11,
                vertical: 9,
              ),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF0ED),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Row(
                children: [
                  Icon(
                    Icons.edit_outlined,
                    size: 14,
                    color: _rose,
                  ),
                  SizedBox(width: 5),
                  Text(
                    'Edit profil',
                    style: TextStyle(
                      fontSize: 10,
                      color: _rose,
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

  // ==================================================
  // BIODATA DIRI
  // ==================================================

  Widget _buildBiodataCard() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Biodata Diri',
          style: TextStyle(
            fontFamily: 'PlayfairDisplay',
            fontSize: 19,
            color: _dark,
          ),
        ),

        const SizedBox(height: 7),

        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.94),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _biodataItem(
                'Nama lengkap',
                fullName,
              ),

              const SizedBox(height: 13),

              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: _biodataItem(
                      'Nama panggilan',
                      nickname,
                    ),
                  ),
                  Expanded(
                    child: _biodataItem(
                      'Usia',
                      age,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 13),

              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: _biodataItem(
                      'Gender',
                      gender,
                    ),
                  ),
                  Expanded(
                    child: _biodataItem(
                      'Domisili',
                      domicile,
                    ),
                  ),
                ],
              ),

              const Padding(
                padding: EdgeInsets.symmetric(vertical: 12),
                child: Divider(
                  color: _line,
                  height: 1,
                ),
              ),

              _biodataItem(
                'Email',
                email,
              ),

              const SizedBox(height: 12),

              _biodataItem(
                'No. handphone',
                phone,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _biodataItem(
    String label,
    String? value,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 10,
            color: _hint,
          ),
        ),

        const SizedBox(height: 3),

        Text(
          _display(value),
          style: const TextStyle(
            fontSize: 12,
            color: _dark,
          ),
        ),
      ],
    );
  }

  // ==================================================
  // PERNIKAHAN KITA
  // ==================================================

  Widget _buildWeddingCard() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Expanded(
              child: Text(
                'Pernikahan Kita',
                style: TextStyle(
                  fontFamily: 'PlayfairDisplay',
                  fontSize: 19,
                  color: _dark,
                ),
              ),
            ),

            GestureDetector(
              onTap: _showEditWedding,
              child: const Text(
                'Kelola',
                style: TextStyle(
                  fontSize: 10,
                  color: _rose,
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 7),

        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.95),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 35,
                    height: 35,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFF0ED),
                      borderRadius: BorderRadius.circular(9),
                    ),
                    child: const Icon(
                      Icons.favorite_border,
                      color: _rose,
                      size: 20,
                    ),
                  ),

                  const SizedBox(width: 9),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _display(partnerName),
                          style: const TextStyle(
                            fontFamily: 'PlayfairDisplay',
                            fontSize: 17,
                            color: _dark,
                          ),
                        ),
                        const Text(
                          'Merencanakan hari bahagia bersama',
                          style: TextStyle(
                            fontSize: 9,
                            color: _hint,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 11),

              Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: 8,
                children: [
                  const Icon(
                    Icons.calendar_month,
                    size: 13,
                    color: _rose,
                  ),
                  Text(
                    _display(weddingDate),
                    style: const TextStyle(
                      fontSize: 10,
                      color: _dark,
                    ),
                  ),
                  const Text(
                    '·',
                    style: TextStyle(color: _hint),
                  ),
                  const Icon(
                    Icons.location_on_outlined,
                    size: 13,
                    color: _rose,
                  ),
                  Text(
                    _display(weddingLocation),
                    style: const TextStyle(
                      fontSize: 10,
                      color: _dark,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ==================================================
  // KELOLA PERNIKAHAN
  // ==================================================

  void _showEditWedding() {
    _showMessage(
      'Fitur Kelola Pernikahan akan dihubungkan ke backend.',
    );

    // TODO BACKEND:
    // Hubungkan ke halaman pengelolaan data pernikahan.
  }

  // ==================================================
  // EDIT PROFIL
  // ==================================================

  void _showEditProfile() {
    _showMessage(
      'Fitur Edit Profil akan dihubungkan ke backend.',
    );

    // TODO BACKEND:
    // Hubungkan ke halaman edit profil.
    // Gunakan API PUT/PATCH untuk memperbarui data pengguna.
  }

  // ==================================================
  // KEAMANAN AKUN DAN PUSAT BANTUAN
  // ==================================================

  Widget _buildAccountMenu() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 15,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.94),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: _accountItem(
              Icons.shield_outlined,
              'Keamanan akun',
              () {
                _showMessage(
                  'Halaman Keamanan Akun belum dihubungkan.',
                );
              },
            ),
          ),

          Container(
            height: 25,
            width: 1,
            color: _line,
          ),

          const SizedBox(width: 10),

          Expanded(
            child: _accountItem(
              Icons.help_outline,
              'Pusat bantuan',
              () {
                _showMessage(
                  'Halaman Pusat Bantuan belum dihubungkan.',
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _accountItem(
    IconData icon,
    String title,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          Icon(
            icon,
            size: 16,
            color: _rose,
          ),

          const SizedBox(width: 7),

          Expanded(
            child: Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 10,
                color: _dark,
              ),
            ),
          ),

          const Icon(
            Icons.chevron_right,
            size: 17,
            color: _hint,
          ),
        ],
      ),
    );
  }

  // ==================================================
  // BOTTOM NAVIGATION
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
          false,
          widget.onBerandaTap ??
              () => navigateToBottomTab(
                context,
                AppRoutes.home,
              ),
        ),

        _navItem(
          Icons.calendar_month_outlined,
          'Rencana',
          false,
          widget.onRencanaTap ??
              () => navigateToBottomTab(
                context,
                AppRoutes.rencana,
              ),
        ),

        _navItem(
          Icons.chat_bubble_outline,
          'Chat',
          false,
          widget.onChatTap ??
              () => navigateToBottomTab(
                context,
                AppRoutes.chat,
              ),
        ),

        _navItem(
          Icons.person_outline,
          'User',
          true,
          () => navigateToBottomTab(
            context,
            AppRoutes.user,
            isCurrent: true,
          ),
        ),
      ],
    ),
  );
}

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
      padding: const EdgeInsets.symmetric(horizontal: 9),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 23,
            color: selected
                ? _dark
                : const Color(0xFF8E8582),
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
}
