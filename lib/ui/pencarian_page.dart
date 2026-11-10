import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:smart_wedding_planning_system/ui/rencana_page.dart';



class _WeddingPackage {
  final String name;
  final String category;
  final String location;
  final String description;
  final int price;
  final String image;
  final String label;

  const _WeddingPackage({
    required this.name,
    required this.category,
    required this.location,
    required this.description,
    required this.price,
    required this.image,
    required this.label,
  });
}

class PencarianPage extends StatefulWidget {
  const PencarianPage({super.key});

  @override
  State<PencarianPage> createState() => _PencarianPageState();
}

class _PencarianPageState extends State<PencarianPage> {
  static const Color _rose = Color(0xFFC58A85);
  static const Color _pink = Color(0xFFE7B6B0);
  static const Color _textDark = Color(0xFF3D3533);
  static const Color _brown = Color(0xFF8A5A55);
  static const Color _hint = Color(0xFF9A8F8D);
  static const String _serif = 'PlayfairDisplay';

  final TextEditingController _budgetController =
      TextEditingController(text: '100000000');

  final List<String> _categories = [
    'Rumah',
    'Hotel',
    'Outdoor',
    'Hybrid',
  ];

  String _selectedCategory = 'Rumah';
  bool _hasNotification = true;

  final List<_WeddingPackage> _packages = const [
    _WeddingPackage(
      name: 'Platinum - Paket Intimate Home',
      category: 'Rumah',
      location: 'Tegal',
      description: 'Dekorasi premium - katering - rias',
      price: 100000000,
      label: 'Pernikahan di Rumah',
      image:
          'https://images.unsplash.com/photo-1519741497674-611481863552?w=500',
    ),
    _WeddingPackage(
      name: 'Gold - Paket Hotel Basic',
      category: 'Hotel',
      location: 'Tegal',
      description: 'Venue hotel - katering - dekorasi dasar',
      price: 75000000,
      label: 'Pernikahan di Hotel',
      image:
          'https://images.unsplash.com/photo-1519167758481-83f550bb49b3?w=500',
    ),
    _WeddingPackage(
      name: 'Silver - Paket Garden Party',
      category: 'Outdoor',
      location: 'Semarang',
      description: 'Area taman - dekorasi - katering',
      price: 50000000,
      label: 'Outdoor',
      image:
          'https://images.unsplash.com/photo-1464366400600-7168b8af9bc3?w=500',
    ),
    _WeddingPackage(
      name: 'Gold - Paket Wedding Hybrid',
      category: 'Hybrid',
      location: 'Tegal',
      description: 'Venue indoor dan outdoor - dekorasi',
      price: 90000000,
      label: 'Pernikahan Hybrid',
      image:
          'https://images.unsplash.com/photo-1511795409834-ef04bbd61622?w=500',
    ),
  ];

  int get _budget {
    final value = _budgetController.text.replaceAll(
      RegExp(r'[^0-9]'),
      '',
    );
    return int.tryParse(value) ?? 0;
  }

  List<_WeddingPackage> get _filteredPackages {
    return _packages.where((package) {
      return package.price <= _budget;
    }).toList();
  }

  String _formatRupiah(int value) {
    final text = value.toString();
    final result = StringBuffer();

    for (int i = 0; i < text.length; i++) {
      result.write(text[i]);

      final remaining = text.length - i - 1;
      if (remaining > 0 && remaining % 3 == 0) {
        result.write('.');
      }
    }

    return 'Rp$result';
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
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
            border: Border.all(
              color: const Color(0x99FFFFFF),
            ),
          ),
          child: child,
        ),
      ),
    );
  }

  // Header halaman
  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Image.asset(
          'assets/images/logo_header.png',
          height: 45,
          errorBuilder: (context, error, stackTrace) {
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
                _showMessage('Belum ada notifikasi');
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
                      color: _textDark,
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
                      color: _textDark,
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

  // Input anggaran dan tombol pencarian
  Widget _buildBudgetSearch() {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 42,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: TextField(
              controller: _budgetController,
              keyboardType: TextInputType.number,
              style: const TextStyle(
                color: _rose,
                fontSize: 13,
              ),
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: 'Masukkan anggaran',
                hintStyle: TextStyle(
                  color: _hint,
                  fontSize: 12,
                ),
                prefixText: 'Rp',
                prefixStyle: TextStyle(
                  color: _rose,
                  fontSize: 13,
                ),
              ),
              onChanged: (value) {
                setState(() {});
              },
            ),
          ),
        ),
        const SizedBox(width: 6),
        GestureDetector(
          onTap: () {
            setState(() {});
            _showMessage('Rekomendasi berhasil diperbarui');
          },
          child: Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.search,
              size: 25,
              color: Colors.black,
            ),
          ),
        ),
      ],
    );
  }

  // Kategori paket
  Widget _buildCategories() {
    return Row(
      children: _categories.map((category) {
        final selected = _selectedCategory == category;

        return Expanded(
          child: GestureDetector(
            onTap: () {
              setState(() {
                _selectedCategory = category;
              });
            },
            child: Container(
              margin: const EdgeInsets.only(right: 5),
              padding: const EdgeInsets.symmetric(vertical: 9),
              decoration: BoxDecoration(
                color: selected ? _rose : Colors.white,
                borderRadius: BorderRadius.circular(9),
              ),
              child: Text(
                category,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 9,
                  color: selected ? Colors.white : _hint,
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  // Kartu rekomendasi paket
  Widget _buildPackageCard(_WeddingPackage package) {
    return Container(
      margin: const EdgeInsets.only(bottom: 9),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(13),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(9),
            child: Image.network(
              package.image,
              width: 76,
              height: 92,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: 76,
                  height: 92,
                  color: const Color(0xFFF3D6D0),
                  child: const Icon(
                    Icons.image_outlined,
                    color: _rose,
                    size: 28,
                  ),
                );
              },
            ),
          ),
          const SizedBox(width: 9),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFF1EE),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          package.label,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 7,
                            color: _rose,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 5),
                    Text(
                      package.location,
                      style: const TextStyle(
                        fontSize: 7,
                        color: _hint,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                Text(
                  package.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontFamily: _serif,
                    fontSize: 11,
                    color: _textDark,
                  ),
                ),
                const SizedBox(height: 4),
                const Row(
                  children: [
                    Icon(
                      Icons.star_outline,
                      color: _rose,
                      size: 10,
                    ),
                    SizedBox(width: 3),
                    Text(
                      'Dekorasi premium - katering - rias',
                      style: TextStyle(
                        fontSize: 7,
                        color: _hint,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 3),
                Text(
                  'Cocok untuk anggaran ${_formatRupiah(_budget)}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 7,
                    color: _hint,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Anggaran contoh',
                          style: TextStyle(
                            fontSize: 7,
                            color: _hint,
                          ),
                        ),
                        Text(
                          _formatRupiah(package.price),
                          style: const TextStyle(
                            fontSize: 9,
                            color: _rose,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    GestureDetector(
                      onTap: () {
                        _showMessage(
                          'Detail ${package.name} segera hadir',
                        );
                      },
                      child: Container(
                        width: 23,
                        height: 23,
                        decoration: const BoxDecoration(
                          color: Color(0xFFFFF0ED),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.chevron_right,
                          color: _rose,
                          size: 18,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Daftar rekomendasi
  Widget _buildRecommendations() {
    final packages = _filteredPackages;

    if (packages.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(25),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
        ),
        child: const Column(
          children: [
            Icon(
              Icons.search_off,
              size: 35,
              color: _pink,
            ),
            SizedBox(height: 8),
            Text(
              'Paket tidak ditemukan',
              style: TextStyle(
                fontSize: 12,
                color: _textDark,
              ),
            ),
            SizedBox(height: 4),
            Text(
              'Coba masukkan anggaran yang berbeda.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 9,
                color: _hint,
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      children: packages.map(_buildPackageCard).toList(),
    );
  }

  // Navigasi bawah
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
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 26,
            color: selected ? _textDark : _hint,
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              color: selected ? _textDark : _hint,
              decoration: selected ? TextDecoration.underline : null,
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
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _navItem(Icons.home_outlined, 'Beranda', false, () {
          Navigator.pop(context);
        }),
        _navItem(Icons.calendar_month_outlined, 'Rencana', false, () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const RencanaPage(),
            ),
          );
        }),
        _navItem(Icons.chat_bubble_outline, 'Chat', false, () {
          _showMessage('Chat (segera hadir)');
        }),
        _navItem(Icons.menu, 'Lainnya', false, () {
          _showMessage('Menu Lainnya (segera hadir)');
        }),
      ],
    ),
  );
}
  @override
  void dispose() {
    _budgetController.dispose();
    super.dispose();
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
              errorBuilder: (context, error, stackTrace) {
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
                    padding: const EdgeInsets.fromLTRB(
                      20,
                      4,
                      20,
                      100,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 4),

                        Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.pop(context);
                              },
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
                                  'Pencarian',
                                  style: TextStyle(
                                    fontFamily: _serif,
                                    fontSize: 21,
                                    color: _textDark,
                                  ),
                                ),
                                Text(
                                  'Cari semua layanan atau cari sesuai anggaran',
                                  style: TextStyle(
                                    fontSize: 9,
                                    color: _hint,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),

                        const SizedBox(height: 25),

                        _buildBudgetSearch(),

                        const SizedBox(height: 7),

                        _buildCategories(),

                        const SizedBox(height: 16),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Hasil Rekomendasi',
                              style: TextStyle(
                                fontFamily: _serif,
                                fontSize: 14,
                                color: _brown,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                _showMessage(
                                  'Fitur simulasi paket segera hadir',
                                );
                              },
                              child: const Row(
                                children: [
                                  Icon(
                                    Icons.tune,
                                    size: 12,
                                    color: _rose,
                                  ),
                                  SizedBox(width: 3),
                                  Text(
                                    'Simulasi',
                                    style: TextStyle(
                                      fontSize: 8,
                                      color: _hint,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 10),

                        _buildRecommendations(),
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
                padding: const EdgeInsets.fromLTRB(
                  16,
                  0,
                  16,
                  12,
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