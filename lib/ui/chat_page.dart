
import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'rencana_page.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  static const Color _rose = Color(0xFFC58A85);
  static const Color _pink = Color(0xFFE7B6B0);
  static const Color _textDark = Color(0xFF3D3533);
  static const Color _brown = Color(0xFF8A5A55);
  static const Color _hint = Color(0xFF9A8985);
  static const String _serif = 'PlayfairDisplay';

  // ============================================================
  // TODO BACKEND 1:
  // Sesuaikan alamat IP dan port dengan backend NestJS.
  // Android Emulator menggunakan 10.0.2.2 untuk localhost komputer.
  // ============================================================

  static const String _baseUrl = 'http://10.0.2.2:3000';

  // ============================================================
  // TODO BACKEND 2:
  // Sesuaikan endpoint GET daftar percakapan.
  // ============================================================

  static const String _chatEndpoint = '/chats';

  // TODO BACKEND 3:
  // Isi token JWT dari hasil login jika API membutuhkan autentikasi.
  String? _token;

  final TextEditingController _searchController =
      TextEditingController();

  List<_ChatConversation> _conversations = [];

  bool _isLoading = false;
  String? _errorMessage;

  String _selectedFilter = 'Semua';

  final List<String> _filters = [
    'Semua',
    'Belum dibaca',
    'Vendor',
  ];

  @override
  void initState() {
    super.initState();
    _fetchConversations();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // ============================================================
  // TODO BACKEND 4:
  // MENGAMBIL DAFTAR PERCAKAPAN DARI BACKEND (HTTP GET)
  //
  // Asumsi response:
  // {
  //   "data": [
  //     {
  //       "id": 1,
  //       "name": "The Royale Hall",
  //       "category": "Rani · Venue · Tegal",
  //       "message": "Sudah, Kak, termasuk venue...",
  //       "time": "09.44",
  //       "unreadCount": 1,
  //       "initial": "TR",
  //       "type": "vendor",
  //       "isUnread": true
  //     }
  //   ]
  // }
  //
  // Sesuaikan nama field dengan response API milikmu.
  // ============================================================

  Future<void> _fetchConversations() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final response = await http.get(
        Uri.parse('$_baseUrl$_chatEndpoint'),
        headers: {
          'Content-Type': 'application/json',
          if (_token != null)
            'Authorization': 'Bearer $_token',
        },
      );

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);

        // TODO BACKEND:
        // Sesuaikan jika response backend menggunakan
        // decoded['data']['items'] atau struktur lainnya.
        final dynamic rawData =
            decoded is List ? decoded : decoded['data'];

        if (rawData is! List) {
          throw Exception(
            'Format response daftar chat tidak sesuai',
          );
        }

        final loadedConversations =
            rawData.map<_ChatConversation>((item) {
          // TODO BACKEND:
          // Sesuaikan setiap nama field dengan response API.
          return _ChatConversation(
            id: item['id'].toString(),
            name: (item['name'] ?? '').toString(),
            category: (item['category'] ?? '').toString(),
            message: (item['message'] ?? '').toString(),
            time: (item['time'] ?? '').toString(),
            initial: (item['initial'] ?? '').toString(),
            unreadCount:
                (item['unreadCount'] as num?)?.toInt() ?? 0,
            type: (item['type'] ?? 'vendor').toString(),
            isUnread: item['isUnread'] == true,
          );
        }).toList();

        if (!mounted) return;

        setState(() {
          _conversations = loadedConversations;
        });
      } else {
        throw Exception(
          'Gagal mengambil percakapan: '
          '${response.statusCode} ${response.body}',
        );
      }
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _errorMessage = e.toString();
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  // ============================================================
  // PENCARIAN DAN FILTER
  // ============================================================

  List<_ChatConversation> get _filteredConversations {
    final keyword = _searchController.text.toLowerCase();

    return _conversations.where((chat) {
      final matchesSearch =
          chat.name.toLowerCase().contains(keyword) ||
          chat.message.toLowerCase().contains(keyword) ||
          chat.category.toLowerCase().contains(keyword);

      bool matchesFilter = true;

      if (_selectedFilter == 'Belum dibaca') {
        matchesFilter = chat.isUnread || chat.unreadCount > 0;
      } else if (_selectedFilter == 'Vendor') {
        matchesFilter = chat.type == 'vendor';
      }

      return matchesSearch && matchesFilter;
    }).toList();
  }

  int get _unreadTotal {
    return _conversations.fold(
      0,
      (total, chat) => total + chat.unreadCount,
    );
  }

  int get _vendorTotal {
    return _conversations
        .where((chat) => chat.type == 'vendor')
        .length;
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

  // ============================================================
  // KOMPONEN GLASS
  // ============================================================

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

  // ============================================================
  // HEADER
  // ============================================================

  Widget _buildHeader() {
    return Row(
      children: [
        Image.asset(
          'assets/images/logo_header.png',
          width: 125,
          height: 42,
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) {
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
            color: Colors.white.withValues(alpha: 0.9),
            borderRadius: BorderRadius.circular(25),
            boxShadow: [
              BoxShadow(
                color: _brown.withValues(alpha: 0.12),
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
                color: _textDark,
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
              color: _brown.withValues(alpha: 0.12),
              blurRadius: 10,
            ),
          ],
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Icon(
              icon,
              size: 19,
              color: _textDark,
            ),
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

  // ============================================================
  // JUDUL DAN PENCARIAN
  // ============================================================

  Widget _buildTitle() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Chat',
          style: TextStyle(
            fontFamily: _serif,
            fontSize: 25,
            color: _textDark,
          ),
        ),
        SizedBox(height: 2),
        Text(
          'Semua cerita menuju hari bahagiamu.',
          style: TextStyle(
            fontSize: 10,
            color: _hint,
          ),
        ),
      ],
    );
  }

  Widget _buildSearch() {
    return _glass(
      radius: 30,
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 2,
      ),
      child: Row(
        children: [
          const Icon(
            Icons.search,
            size: 18,
            color: _brown,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: _searchController,
              onChanged: (_) {
                setState(() {});
              },
              style: const TextStyle(
                fontSize: 10,
                color: _textDark,
              ),
              decoration: const InputDecoration(
                hintText: 'Cari nama atau pesan...',
                hintStyle: TextStyle(
                  fontSize: 9,
                  color: _hint,
                ),
                border: InputBorder.none,
                isDense: true,
              ),
            ),
          ),
          if (_searchController.text.isNotEmpty)
            GestureDetector(
              onTap: () {
                _searchController.clear();
                setState(() {});
              },
              child: const Icon(
                Icons.close,
                size: 15,
                color: _hint,
              ),
            ),
        ],
      ),
    );
  }

  // ============================================================
  // FILTER CHAT
  // ============================================================

  Widget _buildFilters() {
    return Row(
      children: _filters.map((filter) {
        final selected = _selectedFilter == filter;

        String label = filter;

        if (filter == 'Belum dibaca') {
          label = 'Belum dibaca · $_unreadTotal';
        } else if (filter == 'Vendor') {
          label = 'Vendor';
        }

        return Padding(
          padding: const EdgeInsets.only(right: 6),
          child: GestureDetector(
            onTap: () {
              setState(() {
                _selectedFilter = filter;
              });
            },
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 7,
              ),
              decoration: BoxDecoration(
                color: selected ? _rose : Colors.white.withValues(
                  alpha: 0.65,
                ),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: selected
                      ? _rose
                      : _pink.withValues(alpha: 0.5),
                ),
              ),
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 8,
                  color: selected ? Colors.white : _brown,
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  // ============================================================
  // KARTU ASISTEN WEDDING+
  // ============================================================

  Widget _buildAssistantCard() {
    return GestureDetector(
      onTap: () {
        // TODO BACKEND:
        // Arahkan ke halaman chatbot AI.
        // Kirim ID user atau conversation ID jika diperlukan.
        _showMessage('Asisten Wedding+ segera hadir');
      },
      child: _glass(
        radius: 13,
        padding: const EdgeInsets.all(10),
        child: Row(
          children: [
            Container(
              width: 37,
              height: 37,
              decoration: const BoxDecoration(
                color: Color(0xFFF0D7D2),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.auto_awesome,
                color: _rose,
                size: 20,
              ),
            ),
            const SizedBox(width: 9),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Asisten Wedding+',
                    style: TextStyle(
                      fontFamily: _serif,
                      fontSize: 13,
                      color: _textDark,
                    ),
                  ),
                  SizedBox(height: 3),
                  Text(
                    'Yuk, fokus ke tiga prioritas persiapanmu minggu ini.',
                    style: TextStyle(
                      fontSize: 8,
                      height: 1.4,
                      color: _hint,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 5),
            Column(
              children: [
                const Text(
                  '09.42',
                  style: TextStyle(
                    fontSize: 7,
                    color: _hint,
                  ),
                ),
                const SizedBox(height: 8),
                Icon(
                  Icons.chevron_right,
                  color: _rose,
                  size: 18,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // DAFTAR PERCAKAPAN
  // ============================================================

  Widget _buildConversationList() {
    if (_isLoading) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(25),
          child: CircularProgressIndicator(
            color: _rose,
          ),
        ),
      );
    }

    if (_errorMessage != null) {
      return _glass(
        radius: 14,
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Icon(
              Icons.error_outline,
              color: _rose,
              size: 25,
            ),
            const SizedBox(height: 8),
            const Text(
              'Gagal memuat percakapan',
              style: TextStyle(
                fontSize: 10,
                color: _textDark,
              ),
            ),
            const SizedBox(height: 5),
            TextButton(
              onPressed: _fetchConversations,
              child: const Text(
                'Coba Lagi',
                style: TextStyle(
                  color: _rose,
                  fontSize: 10,
                ),
              ),
            ),
          ],
        ),
      );
    }

    final conversations = _filteredConversations;

    if (conversations.isEmpty) {
      return _glass(
        radius: 14,
        padding: const EdgeInsets.all(22),
        child: const Center(
          child: Text(
            'Belum ada percakapan.',
            style: TextStyle(
              fontSize: 10,
              color: _hint,
            ),
          ),
        ),
      );
    }

    return _glass(
      radius: 14,
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 2,
      ),
      child: Column(
        children: conversations.map((chat) {
          return _buildConversationItem(chat);
        }).toList(),
      ),
    );
  }

  Widget _buildConversationItem(_ChatConversation chat) {
    return GestureDetector(
      onTap: () {
        // TODO BACKEND:
        // Navigasikan ke halaman detail chat.
        // Gunakan chat.id sebagai ID percakapan.
        // Contoh: ChatDetailPage(conversationId: chat.id)
        _showMessage('Membuka percakapan ${chat.name}');
      },
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: 10,
          horizontal: 0,
        ),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: _pink.withValues(alpha: 0.35),
            ),
          ),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundColor: _avatarColor(chat.name),
              child: Text(
                chat.initial.isNotEmpty
                    ? chat.initial
                    : _makeInitial(chat.name),
                style: const TextStyle(
                  fontFamily: _serif,
                  fontSize: 13,
                  color: _rose,
                ),
              ),
            ),
            const SizedBox(width: 9),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    chat.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontFamily: _serif,
                      fontSize: 12,
                      color: _textDark,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    chat.category,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 7,
                      color: _hint,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    chat.message,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 8,
                      color: chat.isUnread
                          ? _textDark
                          : _hint,
                      fontWeight: chat.isUnread
                          ? FontWeight.w600
                          : FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 7),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  chat.time,
                  style: const TextStyle(
                    fontSize: 7,
                    color: _brown,
                  ),
                ),
                const SizedBox(height: 9),
                if (chat.unreadCount > 0)
                  Container(
                    width: 15,
                    height: 15,
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(
                      color: _rose,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      chat.unreadCount > 9
                          ? '9+'
                          : '${chat.unreadCount}',
                      style: const TextStyle(
                        fontSize: 8,
                        color: Colors.white,
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _avatarColor(String name) {
    final colors = [
      const Color(0xFFF0D8D3),
      const Color(0xFFEEDFD9),
      const Color(0xFFECE8DC),
      const Color(0xFFF2E0DE),
    ];

    return colors[name.length % colors.length];
  }

  String _makeInitial(String name) {
    final words = name.trim().split(' ');

    if (words.isEmpty || words.first.isEmpty) {
      return '?';
    }

    if (words.length == 1) {
      return words.first.substring(0, 1).toUpperCase();
    }

    return '${words[0][0]}${words[1][0]}'.toUpperCase();
  }

  // ============================================================
  // BOTTOM NAVIGATION
  // ============================================================

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
              size: 23,
              color: selected ? _textDark : _hint,
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                fontSize: 9,
                color: selected ? _textDark : _hint,
                decoration: selected
                    ? TextDecoration.underline
                    : null,
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
            false,
            () {
              Navigator.pop(context);
            },
          ),
          _navItem(
            Icons.calendar_month_outlined,
            'Rencana',
            false,
            () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const RencanaPage(),
                ),
              );
            },
          ),
          _navItem(
            Icons.chat_bubble_outline,
            'Chat',
            true,
            () {},
          ),
          _navItem(
            Icons.menu,
            'Lainnya',
            false,
            () {
              _showMessage('Menu Lainnya segera hadir');
            },
          ),
        ],
      ),
    );
  }

  // ============================================================
  // BUILD HALAMAN
  // ============================================================

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
                  padding: const EdgeInsets.fromLTRB(
                    16,
                    8,
                    16,
                    8,
                  ),
                  child: _buildHeader(),
                ),

                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(
                      16,
                      4,
                      16,
                      105,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildTitle(),

                        const SizedBox(height: 12),

                        _buildSearch(),

                        const SizedBox(height: 10),

                        _buildFilters(),

                        const SizedBox(height: 12),

                        _buildAssistantCard(),

                        const SizedBox(height: 12),

                        Row(
                          mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Percakapan terbaru',
                              style: TextStyle(
                                fontFamily: _serif,
                                fontSize: 14,
                                color: _brown,
                              ),
                            ),
                            Text(
                              '$_vendorTotal vendor',
                              style: const TextStyle(
                                fontSize: 8,
                                color: _hint,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 8),

                        _buildConversationList(),
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

// ============================================================
// MODEL DATA PERCAKAPAN
// ============================================================

class _ChatConversation {
  final String id;
  final String name;
  final String category;
  final String message;
  final String time;
  final String initial;
  final int unreadCount;
  final String type;
  final bool isUnread;

  const _ChatConversation({
    required this.id,
    required this.name,
    required this.category,
    required this.message,
    required this.time,
    required this.initial,
    required this.unreadCount,
    required this.type,
    required this.isUnread,
  });
}
