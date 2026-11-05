
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'dashboard_page.dart';
import 'guru_page.dart';
import 'login_page.dart';
import 'siswa_page.dart';
import 'surat_masuk_page.dart';

class SuratKeluarPage extends StatefulWidget {
  const SuratKeluarPage({super.key});

  @override
  State<SuratKeluarPage> createState() => _SuratKeluarPageState();
}

class _SuratKeluarPageState extends State<SuratKeluarPage> {
  static const Color navy = Color(0xFF193F68);
  static const Color blue = Color(0xFF2F83BA);
  static const Color background = Color(0xFFF1F5F9);
  static const Color textDark = Color(0xFF26364A);
  static const Color textGrey = Color(0xFF718096);
  static const Color green = Color(0xFF38D39F);
  static const Color red = Color(0xFFE85D75);
  static const Color orange = Color(0xFFF4A340);

  final String _apiUrl =
      'http://localhost/sia_tu_api/surat_keluar.php';

  List<Map<String, String>> _suratKeluar = [];

  bool _loading = true;
  bool _saving = false;

  final TextEditingController _searchController =
      TextEditingController();

  final TextEditingController _nomorController =
      TextEditingController();

  final TextEditingController _tanggalController =
      TextEditingController();

  final TextEditingController _tujuanController =
      TextEditingController();

  final TextEditingController _perihalController =
      TextEditingController();

  final TextEditingController _fileController =
      TextEditingController();

  String _searchText = '';
  String _statusController = 'Belum Dikirim';
  int? _editingIndex;

  @override
  void initState() {
    super.initState();
    _loadSurat();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _nomorController.dispose();
    _tanggalController.dispose();
    _tujuanController.dispose();
    _perihalController.dispose();
    _fileController.dispose();
    super.dispose();
  }

  // ============================================================
  // LOAD DATA DARI DATABASE
  // ============================================================

  Future<void> _loadSurat() async {
    if (mounted) {
      setState(() => _loading = true);
    }

    try {
      final response = await http.get(Uri.parse(_apiUrl));
      final result = jsonDecode(response.body);

      if (response.statusCode == 200 &&
          result['status'] == true) {
        final List data = result['data'] ?? [];

        final List<Map<String, String>> loadedData =
            data.map<Map<String, String>>((item) {
          return {
            'id': item['id'].toString(),
            'nomor': (item['nomor'] ?? '').toString(),
            'tanggal': (item['tanggal'] ?? '').toString(),
            'tujuan': (item['tujuan'] ?? '').toString(),
            'perihal': (item['perihal'] ?? '').toString(),
            'status': (item['status'] ?? '').toString(),
            'file': (item['file'] ?? '').toString(),
          };
        }).toList();

        if (!mounted) return;

        setState(() {
          _suratKeluar = loadedData;
          _loading = false;
        });
      } else {
        throw Exception(
          result['pesan'] ?? 'Gagal mengambil data surat.',
        );
      }
    } catch (e) {
      if (!mounted) return;

      setState(() => _loading = false);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal mengambil data: $e'),
        ),
      );
    }
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      drawer: _mobileDrawer(context),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth >= 900) {
              return Row(
                children: [
                  _sidebar(context),
                  Expanded(child: _mainContent()),
                ],
              );
            }
            return _mainContent();
          },
        ),
      ),
    );
  }

  // ============================================================
  // SIDEBAR
  // ============================================================

  Widget _sidebar(BuildContext context) {
    return Container(
      width: 260,
      color: Colors.white,
      child: Column(
        children: [
          const SizedBox(height: 22),
          _logo(),
          const SizedBox(height: 22),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Column(
                children: [
                  _menuItem(context, Icons.dashboard_outlined,
                      'Dashboard', false, () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const DashboardPage(),
                      ),
                    );
                  }),
                  _menuItem(context, Icons.people_outline,
                      'Data Siswa', false, () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const SiswaPage(),
                      ),
                    );
                  }),
                  _menuItem(context, Icons.badge_outlined,
                      'Data Guru', false, () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const GuruPage(),
                      ),
                    );
                  }),
                  _menuItem(context, Icons.mail_outline,
                      'Surat Masuk', false, () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const SuratMasukPage(),
                      ),
                    );
                  }),
                  _menuItem(context, Icons.send_outlined,
                      'Surat Keluar', true, () {}),
                  _menuItem(context, Icons.bar_chart,
                      'Laporan', false, () {
                    _comingSoon(context);
                  }),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 20),
            child: _logoutMenuItem(context),
          ),
        ],
      ),
    );
  }

  Widget _logo() {
    return Column(
      children: [
        Container(
          width: 52,
          height: 52,
          decoration: BoxDecoration(
            color: navy,
            borderRadius: BorderRadius.circular(14),
          ),
          child: const Icon(
            Icons.school,
            size: 29,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 10),
        const Text(
          'SIA-TU SEKOLAH',
          style: TextStyle(
            color: navy,
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _menuItem(
    BuildContext context,
    IconData icon,
    String title,
    bool active,
    VoidCallback onTap,
  ) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          width: double.infinity,
          height: 52,
          margin: const EdgeInsets.only(bottom: 8),
          decoration: BoxDecoration(
            color: active ? navy : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              const SizedBox(width: 18),
              Icon(
                icon,
                size: 23,
                color: active
                    ? Colors.white
                    : const Color(0xFF50627A),
              ),
              const SizedBox(width: 15),
              Text(
                title,
                style: TextStyle(
                  color: active ? Colors.white : navy,
                  fontSize: 15,
                  fontWeight:
                      active ? FontWeight.bold : FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _logoutMenuItem(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (_) => const LoginPage(),
            ),
            (route) => false,
          );
        },
        borderRadius: BorderRadius.circular(10),
        child: Container(
          width: double.infinity,
          height: 52,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: const Color(0xFFFFCACA)),
          ),
          child: const Row(
            children: [
              SizedBox(width: 18),
              Icon(Icons.logout, size: 23, color: Color(0xFFE52323)),
              SizedBox(width: 15),
              Text(
                'Keluar',
                style: TextStyle(
                  color: Color(0xFFE52323),
                  fontSize: 15,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ============================================================
  // MOBILE DRAWER
  // ============================================================

  Widget _mobileDrawer(BuildContext context) {
    return Drawer(
      width: 260,
      backgroundColor: Colors.white,
      child: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 22),
            _logo(),
            const SizedBox(height: 22),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Column(
                  children: [
                    _menuItem(context, Icons.dashboard_outlined,
                        'Dashboard', false, () {
                      Navigator.pop(context);
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const DashboardPage(),
                        ),
                      );
                    }),
                    _menuItem(context, Icons.people_outline,
                        'Data Siswa', false, () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const SiswaPage(),
                        ),
                      );
                    }),
                    _menuItem(context, Icons.badge_outlined,
                        'Data Guru', false, () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const GuruPage(),
                        ),
                      );
                    }),
                    _menuItem(context, Icons.mail_outline,
                        'Surat Masuk', false, () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const SuratMasukPage(),
                        ),
                      );
                    }),
                    _menuItem(context, Icons.send_outlined,
                        'Surat Keluar', true, () {
                      Navigator.pop(context);
                    }),
                    _menuItem(context, Icons.bar_chart,
                        'Laporan', false, () {
                      Navigator.pop(context);
                      _comingSoon(context);
                    }),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 20),
              child: _logoutMenuItem(context),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // MAIN CONTENT
  // ============================================================

  Widget _mainContent() {
    return Column(
      children: [
        _header(),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 20, 24, 90),
            child: _content(),
          ),
        ),
      ],
    );
  }

  Widget _header() {
    return Container(
      height: 76,
      padding: const EdgeInsets.symmetric(horizontal: 22),
      color: navy,
      child: Row(
        children: [
          Builder(
            builder: (context) {
              return IconButton(
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
                icon: const Icon(
                  Icons.menu,
                  color: Colors.white,
                  size: 25,
                ),
              );
            },
          ),
          const SizedBox(width: 8),
          const Expanded(
            child: Text(
              'Surat Keluar',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Container(
            width: 42,
            height: 42,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.person, color: navy, size: 23),
          ),
          const SizedBox(width: 10),
          const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Admin TU',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 2),
              Row(
                children: [
                  Icon(Icons.circle, size: 7, color: green),
                  SizedBox(width: 5),
                  Text(
                    'Online',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ============================================================
  // CONTENT
  // ============================================================

  Widget _content() {
    if (_loading) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(50),
          child: CircularProgressIndicator(),
        ),
      );
    }

    final filtered = _filteredSurat();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _pageTitle(),
        const SizedBox(height: 18),
        _statistics(),
        const SizedBox(height: 20),
        _searchAndAdd(),
        const SizedBox(height: 18),
        LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth < 700) {
              return _mobileList(filtered);
            }
            return _desktopTable(filtered);
          },
        ),
      ],
    );
  }

  Widget _pageTitle() {
    return Row(
      children: [
        Container(
          width: 45,
          height: 45,
          decoration: BoxDecoration(
            color: const Color(0xFFEAF3FF),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(
            Icons.send_outlined,
            color: blue,
            size: 24,
          ),
        ),
        const SizedBox(width: 12),
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Data Surat Keluar',
                style: TextStyle(
                  color: textDark,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 3),
              Text(
                'Kelola dan arsipkan surat yang dikirim sekolah.',
                style: TextStyle(color: textGrey, fontSize: 13),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ============================================================
  // STATISTICS
  // ============================================================

  Widget _statistics() {
    final total = _suratKeluar.length;
    final belum = _suratKeluar
        .where((item) => item['status'] == 'Belum Dikirim')
        .length;
    final sudah = _suratKeluar
        .where((item) => item['status'] == 'Sudah Dikirim')
        .length;

    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 650) {
          return GridView.count(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.7,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              _statCard('Total Surat', '$total',
                  Icons.send_outlined, blue),
              _statCard('Belum Dikirim', '$belum',
                  Icons.pending_actions_outlined, orange),
              _statCard('Sudah Dikirim', '$sudah',
                  Icons.mark_email_read_outlined, green),
              _statCard('Arsip', '$total',
                  Icons.archive_outlined, navy),
            ],
          );
        }

        return Row(
          children: [
            Expanded(
              child: _statCard(
                  'Total Surat', '$total', Icons.send_outlined, blue),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: _statCard('Belum Dikirim', '$belum',
                  Icons.pending_actions_outlined, orange),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: _statCard('Sudah Dikirim', '$sudah',
                  Icons.mark_email_read_outlined, green),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: _statCard(
                  'Arsip', '$total', Icons.archive_outlined, navy),
            ),
          ],
        );
      },
    );
  }

  Widget _statCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5EAF0)),
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: color.withOpacity(0.10),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  value,
                  style: TextStyle(
                    color: color,
                    fontSize: 21,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: textGrey,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // SEARCH AND ADD
  // ============================================================

  Widget _searchAndAdd() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5EAF0)),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth < 600) {
            return Column(
              children: [
                _searchBox(),
                const SizedBox(height: 12),
                SizedBox(width: double.infinity, child: _addButton()),
              ],
            );
          }
          return Row(
            children: [
              Expanded(child: _searchBox()),
              const SizedBox(width: 12),
              _addButton(),
            ],
          );
        },
      ),
    );
  }

  Widget _searchBox() {
    return TextField(
      controller: _searchController,
      onChanged: (value) {
        setState(() => _searchText = value.toLowerCase());
      },
      decoration: InputDecoration(
        hintText: 'Cari nomor, tujuan surat, atau perihal...',
        hintStyle: const TextStyle(color: textGrey, fontSize: 13),
        prefixIcon: const Icon(Icons.search, color: textGrey),
        suffixIcon: _searchText.isNotEmpty
            ? IconButton(
                onPressed: () {
                  _searchController.clear();
                  setState(() => _searchText = '');
                },
                icon: const Icon(Icons.close, size: 19),
              )
            : null,
        filled: true,
        fillColor: const Color(0xFFF8FAFC),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: blue, width: 1.5),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
      ),
    );
  }

  Widget _addButton() {
    return ElevatedButton.icon(
      onPressed: () => _openFormDialog(),
      icon: const Icon(Icons.add, size: 20),
      label: const Text(
        'Tambah Surat',
        style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: navy,
        foregroundColor: Colors.white,
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  // ============================================================
  // FILTER
  // ============================================================

  List<Map<String, String>> _filteredSurat() {
    if (_searchText.isEmpty) {
      return List<Map<String, String>>.from(_suratKeluar);
    }

    return _suratKeluar.where((item) {
      final nomor = (item['nomor'] ?? '').toLowerCase();
      final tujuan = (item['tujuan'] ?? '').toLowerCase();
      final perihal = (item['perihal'] ?? '').toLowerCase();

      return nomor.contains(_searchText) ||
          tujuan.contains(_searchText) ||
          perihal.contains(_searchText);
    }).toList();
  }

  // ============================================================
  // DESKTOP TABLE
  // ============================================================

  Widget _desktopTable(List<Map<String, String>> data) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5EAF0)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: data.isEmpty
            ? _emptyState()
            : SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columnSpacing: 25,
                  headingRowHeight: 48,
                  dataRowMinHeight: 65,
                  dataRowMaxHeight: 75,
                  headingRowColor: MaterialStateProperty.all(
                    const Color(0xFFF8FAFC),
                  ),
                  columns: const [
                    DataColumn(label: Text('No')),
                    DataColumn(label: Text('Nomor Surat')),
                    DataColumn(label: Text('Tanggal')),
                    DataColumn(label: Text('Tujuan')),
                    DataColumn(label: Text('Perihal')),
                    DataColumn(label: Text('Status')),
                    DataColumn(label: Text('Aksi')),
                  ],
                  rows: List.generate(data.length, (index) {
                    final item = data[index];
                    final originalIndex = _suratKeluar.indexOf(item);

                    return DataRow(
                      cells: [
                        DataCell(Text('${index + 1}')),
                        DataCell(
                          Text(
                            item['nomor'] ?? '',
                            style: const TextStyle(
                              color: navy,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        DataCell(
                          Text(_formatDate(item['tanggal'] ?? '')),
                        ),
                        DataCell(
                          SizedBox(
                            width: 150,
                            child: Text(
                              item['tujuan'] ?? '',
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                        DataCell(
                          SizedBox(
                            width: 200,
                            child: Text(
                              item['perihal'] ?? '',
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                        DataCell(_statusBox(item['status'] ?? '')),
                        DataCell(_actionButtons(originalIndex)),
                      ],
                    );
                  }),
                ),
              ),
      ),
    );
  }

  // ============================================================
  // MOBILE LIST
  // ============================================================

  Widget _mobileList(List<Map<String, String>> data) {
    if (data.isEmpty) return _emptyState();

    return Column(
      children: List.generate(data.length, (index) {
        final item = data[index];
        final originalIndex = _suratKeluar.indexOf(item);
        return _mobileCard(item, originalIndex);
      }),
    );
  }

  Widget _mobileCard(
    Map<String, String> item,
    int originalIndex,
  ) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5EAF0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: const Color(0xFFEAF3FF),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.send_outlined,
                  color: blue,
                  size: 22,
                ),
              ),
              const SizedBox(width: 11),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item['nomor'] ?? '',
                      style: const TextStyle(
                        color: navy,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      _formatDate(item['tanggal'] ?? ''),
                      style: const TextStyle(
                        color: textGrey,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
              _statusBox(item['status'] ?? ''),
            ],
          ),
          const SizedBox(height: 15),
          _mobileInfo(Icons.business_outlined, 'Tujuan',
              item['tujuan'] ?? ''),
          const SizedBox(height: 9),
          _mobileInfo(Icons.subject, 'Perihal',
              item['perihal'] ?? ''),
          const SizedBox(height: 13),
          if ((item['file'] ?? '').isNotEmpty)
            Row(
              children: [
                const Icon(Icons.attach_file,
                    size: 17, color: textGrey),
                const SizedBox(width: 5),
                Expanded(
                  child: Text(
                    item['file'] ?? '',
                    style: const TextStyle(color: blue, fontSize: 12),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _showDetail(item),
                  icon: const Icon(Icons.visibility_outlined, size: 17),
                  label: const Text('Detail'),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () =>
                      _openFormDialog(index: originalIndex),
                  icon: const Icon(Icons.edit_outlined, size: 17),
                  label: const Text('Edit'),
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                onPressed: () => _deleteSurat(originalIndex),
                style: IconButton.styleFrom(
                  backgroundColor: const Color(0xFFFFF0F2),
                  foregroundColor: red,
                ),
                icon: const Icon(Icons.delete_outline, size: 19),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _mobileInfo(
    IconData icon,
    String title,
    String value,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 17, color: textGrey),
        const SizedBox(width: 8),
        SizedBox(
          width: 65,
          child: Text(
            title,
            style: const TextStyle(color: textGrey, fontSize: 12),
          ),
        ),
        const Text(':', style: TextStyle(color: textGrey)),
        const SizedBox(width: 7),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              color: textDark,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  // ============================================================
  // STATUS
  // ============================================================

  Widget _statusBox(String status) {
    final bool sent = status == 'Sudah Dikirim';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
      decoration: BoxDecoration(
        color: sent
            ? const Color(0xFFE9FBF4)
            : const Color(0xFFFFF5E7),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: sent
              ? const Color(0xFF159A6B)
              : const Color(0xFFC77A16),
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  // ============================================================
  // ACTION BUTTONS
  // ============================================================

  Widget _actionButtons(int index) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          tooltip: 'Detail',
          onPressed: () => _showDetail(_suratKeluar[index]),
          icon: const Icon(Icons.visibility_outlined, size: 19),
          color: navy,
        ),
        IconButton(
          tooltip: 'Edit',
          onPressed: () => _openFormDialog(index: index),
          icon: const Icon(Icons.edit_outlined, size: 19),
          color: blue,
        ),
        IconButton(
          tooltip: 'Hapus',
          onPressed: () => _deleteSurat(index),
          icon: const Icon(Icons.delete_outline, size: 19),
          color: red,
        ),
      ],
    );
  }

  Widget _emptyState() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        vertical: 55,
        horizontal: 20,
      ),
      child: Column(
        children: [
          Container(
            width: 65,
            height: 65,
            decoration: BoxDecoration(
              color: const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(18),
            ),
            child: const Icon(
              Icons.send_outlined,
              size: 31,
              color: textGrey,
            ),
          ),
          const SizedBox(height: 14),
          const Text(
            'Data surat tidak ditemukan',
            style: TextStyle(
              color: textDark,
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 5),
          const Text(
            'Coba gunakan kata pencarian yang berbeda.',
            style: TextStyle(color: textGrey, fontSize: 12),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // FORM DIALOG
  // ============================================================

  void _openFormDialog({int? index}) {
    _editingIndex = index;

    if (index != null) {
      final item = _suratKeluar[index];

      _nomorController.text = item['nomor'] ?? '';
      _tanggalController.text = item['tanggal'] ?? '';
      _tujuanController.text = item['tujuan'] ?? '';
      _perihalController.text = item['perihal'] ?? '';
      _fileController.text = item['file'] ?? '';
      _statusController = item['status'] ?? 'Belum Dikirim';
    } else {
      _clearForm();
    }

    showDialog(
      context: context,
      barrierDismissible: !_saving,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              title: Row(
                children: [
                  Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      color: const Color(0xFFEAF3FF),
                      borderRadius: BorderRadius.circular(9),
                    ),
                    child: const Icon(
                      Icons.send_outlined,
                      color: blue,
                      size: 21,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      index == null
                          ? 'Tambah Surat Keluar'
                          : 'Edit Surat Keluar',
                      style: const TextStyle(
                        color: textDark,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              content: SizedBox(
                width: 600,
                child: SingleChildScrollView(
                  child: _formContent(setDialogState),
                ),
              ),
              actionsPadding:
                  const EdgeInsets.fromLTRB(24, 0, 24, 20),
              actions: [
                TextButton(
                  onPressed: _saving
                      ? null
                      : () => Navigator.pop(dialogContext),
                  child: const Text(
                    'Batal',
                    style: TextStyle(color: textGrey),
                  ),
                ),
                ElevatedButton(
                  onPressed: _saving
                      ? null
                      : () async {
                          setDialogState(() => _saving = true);
                          await _saveSurat(dialogContext);
                          if (mounted && Navigator.canPop(dialogContext)) {
                            setDialogState(() => _saving = false);
                          }
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: navy,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(9),
                    ),
                  ),
                  child: _saving
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : Text(
                          index == null
                              ? 'Simpan'
                              : 'Simpan Perubahan',
                        ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _formContent(StateSetter setDialogState) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _fieldLabel('Nomor Surat'),
        _textField(
          controller: _nomorController,
          hint: 'Masukkan nomor surat',
          icon: Icons.numbers,
        ),
        const SizedBox(height: 15),
        _fieldLabel('Tanggal Surat'),
        _textField(
          controller: _tanggalController,
          hint: 'YYYY-MM-DD',
          icon: Icons.calendar_today_outlined,
        ),
        const SizedBox(height: 15),
        _fieldLabel('Tujuan Surat'),
        _textField(
          controller: _tujuanController,
          hint: 'Masukkan instansi / nama tujuan',
          icon: Icons.business_outlined,
        ),
        const SizedBox(height: 15),
        _fieldLabel('Perihal / Isi Ringkas'),
        _textField(
          controller: _perihalController,
          hint: 'Masukkan perihal surat keluar',
          icon: Icons.subject,
          maxLines: 3,
        ),
        const SizedBox(height: 15),
        _fieldLabel('Status'),
        DropdownButtonFormField<String>(
          value: _statusController,
          decoration: InputDecoration(
            prefixIcon: const Icon(
              Icons.flag_outlined,
              size: 20,
              color: textGrey,
            ),
            filled: true,
            fillColor: const Color(0xFFF8FAFC),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(9),
            ),
          ),
          items: const [
            DropdownMenuItem(
              value: 'Belum Dikirim',
              child: Text('Belum Dikirim'),
            ),
            DropdownMenuItem(
              value: 'Sudah Dikirim',
              child: Text('Sudah Dikirim'),
            ),
          ],
          onChanged: (value) {
            if (value != null) {
              setDialogState(() => _statusController = value);
            }
          },
        ),
        const SizedBox(height: 15),
        _fieldLabel('Nama File'),
        TextField(
          controller: _fileController,
          decoration: InputDecoration(
            hintText: 'Contoh: surat_keluar.pdf',
            hintStyle: const TextStyle(color: textGrey, fontSize: 13),
            prefixIcon: const Icon(
              Icons.attach_file,
              size: 20,
              color: textGrey,
            ),
            filled: true,
            fillColor: const Color(0xFFF8FAFC),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(9),
            ),
          ),
        ),
      ],
    );
  }

  Widget _fieldLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 7),
      child: Text(
        label,
        style: const TextStyle(
          color: textDark,
          fontSize: 13,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _textField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    int maxLines = 1,
  }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: textGrey, fontSize: 13),
        prefixIcon: maxLines == 1
            ? Icon(icon, size: 20, color: textGrey)
            : null,
        filled: true,
        fillColor: const Color(0xFFF8FAFC),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(9),
          borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(9),
          borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(9),
          borderSide: const BorderSide(color: blue, width: 1.5),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 13, vertical: 13),
      ),
    );
  }

  // ============================================================
  // SAVE TO DATABASE
  // ============================================================

  Future<void> _saveSurat(BuildContext dialogContext) async {
    final nomor = _nomorController.text.trim();
    final tanggal = _tanggalController.text.trim();
    final tujuan = _tujuanController.text.trim();
    final perihal = _perihalController.text.trim();

    if (nomor.isEmpty ||
        tanggal.isEmpty ||
        tujuan.isEmpty ||
        perihal.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Mohon lengkapi semua data surat.'),
        ),
      );
      return;
    }

    if (!RegExp(r'^\d{4}-\d{2}-\d{2}$').hasMatch(tanggal)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Format tanggal harus YYYY-MM-DD.'),
        ),
      );
      return;
    }

    final bool isEdit = _editingIndex != null;

    final Map<String, dynamic> data = {
      'nomor': nomor,
      'tanggal': tanggal,
      'tujuan': tujuan,
      'perihal': perihal,
      'status': _statusController,
      'file': _fileController.text.trim(),
    };

    if (isEdit) {
      data['id'] = _suratKeluar[_editingIndex!]['id'];
    }

    try {
      final response = isEdit
          ? await http.put(
              Uri.parse(_apiUrl),
              headers: {'Content-Type': 'application/json'},
              body: jsonEncode(data),
            )
          : await http.post(
              Uri.parse(_apiUrl),
              headers: {'Content-Type': 'application/json'},
              body: jsonEncode(data),
            );

      final result = jsonDecode(response.body);

      if (response.statusCode == 200 &&
          result['status'] == true) {
        if (!mounted) return;

        Navigator.pop(dialogContext);
        _clearForm();
        await _loadSurat();

        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              isEdit
                  ? 'Surat keluar berhasil diperbarui.'
                  : 'Surat keluar berhasil ditambahkan.',
            ),
          ),
        );
      } else {
        throw Exception(
          result['pesan'] ?? 'Gagal menyimpan surat.',
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal menyimpan surat: $e')),
      );
    }
  }

  void _clearForm() {
    _nomorController.clear();
    _tanggalController.clear();
    _tujuanController.clear();
    _perihalController.clear();
    _fileController.clear();
    _statusController = 'Belum Dikirim';
    _editingIndex = null;
  }

  // ============================================================
  // DETAIL
  // ============================================================

  void _showDetail(Map<String, String> item) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: const Text(
            'Detail Surat Keluar',
            style: TextStyle(
              color: textDark,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: SizedBox(
            width: 550,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _detailRow('Nomor Surat', item['nomor'] ?? ''),
                  _detailRow(
                    'Tanggal',
                    _formatDate(item['tanggal'] ?? ''),
                  ),
                  _detailRow('Tujuan Surat', item['tujuan'] ?? ''),
                  _detailRow('Perihal', item['perihal'] ?? ''),
                  _detailRow('Status', item['status'] ?? ''),
                  _detailRow(
                    'File',
                    (item['file'] ?? '').isEmpty
                        ? '-'
                        : item['file']!,
                  ),
                ],
              ),
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () => Navigator.pop(dialogContext),
              style: ElevatedButton.styleFrom(
                backgroundColor: navy,
                foregroundColor: Colors.white,
              ),
              child: const Text('Tutup'),
            ),
          ],
        );
      },
    );
  }

  Widget _detailRow(String label, String value) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Color(0xFFE5EAF0)),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 125,
            child: Text(
              label,
              style: const TextStyle(color: textGrey, fontSize: 13),
            ),
          ),
          const Text(':', style: TextStyle(color: textGrey)),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                color: textDark,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // DELETE FROM DATABASE
  // ============================================================

  void _deleteSurat(int index) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          title: const Text(
            'Hapus Surat?',
            style: TextStyle(
              color: textDark,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: const Text(
            'Data surat keluar ini akan dihapus dari database.',
            style: TextStyle(color: textGrey, fontSize: 13),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text(
                'Batal',
                style: TextStyle(color: textGrey),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                final id = _suratKeluar[index]['id'];

                try {
                  final response = await http.delete(
                    Uri.parse(_apiUrl),
                    headers: {'Content-Type': 'application/json'},
                    body: jsonEncode({'id': id}),
                  );

                  final result = jsonDecode(response.body);

                  if (response.statusCode == 200 &&
                      result['status'] == true) {
                    if (!mounted) return;

                    Navigator.pop(dialogContext);
                    await _loadSurat();

                    if (!mounted) return;

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Surat keluar berhasil dihapus.',
                        ),
                      ),
                    );
                  } else {
                    throw Exception(
                      result['pesan'] ?? 'Gagal menghapus surat.',
                    );
                  }
                } catch (e) {
                  if (!mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Gagal menghapus surat: $e'),
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: red,
                foregroundColor: Colors.white,
              ),
              child: const Text('Hapus'),
            ),
          ],
        );
      },
    );
  }

  // ============================================================
  // FORMAT DATE
  // ============================================================

  String _formatDate(String date) {
    final parts = date.split('-');

    if (parts.length != 3) return date;

    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'Mei',
      'Jun',
      'Jul',
      'Agu',
      'Sep',
      'Okt',
      'Nov',
      'Des',
    ];

    final month = int.tryParse(parts[1]);

    if (month == null || month < 1 || month > 12) {
      return date;
    }

    return '${parts[2]} ${months[month - 1]} ${parts[0]}';
  }

  void _comingSoon(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Fitur laporan sedang dalam pengembangan.'),
      ),
    );
  }
}
