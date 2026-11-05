
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'login_page.dart';
import 'siswa_page.dart';
import 'guru_page.dart';
import 'surat_masuk_page.dart';
import 'laporan_page.dart';
import 'profile_admin_page.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  static const Color navy = Color(0xFF193F68);
  static const Color blue = Color(0xFF287EB4);
  static const Color background = Color(0xFFF1F5F9);
  static const Color textDark = Color(0xFF34445B);
  static const Color textGrey = Color(0xFF71839D);

  static const String baseUrl = 'http://localhost/sia_tu_api';

  int totalSiswa = 0;
  int totalGuru = 0;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _loadDashboardData();
  }

  // Mengambil jumlah siswa dan guru dari API
  Future<int> _getTotal(String endpoint) async {
    final response = await http.get(
      Uri.parse('$baseUrl/$endpoint'),
    );

    if (response.statusCode != 200) {
      throw Exception('Gagal mengambil data $endpoint');
    }

    final decoded = jsonDecode(response.body);

    if (decoded is List) {
      return decoded.length;
    }

    if (decoded is Map) {
      // Jika API mengirimkan total secara langsung
      if (decoded['total'] != null) {
        return int.tryParse(decoded['total'].toString()) ?? 0;
      }

      // Jika API mengirimkan data dalam bentuk List
      for (final key in ['data', 'result', 'results', 'rows']) {
        final value = decoded[key];

        if (value is List) {
          return value.length;
        }

        if (value is Map) {
          for (final nestedKey in ['data', 'rows', 'result']) {
            if (value[nestedKey] is List) {
              return (value[nestedKey] as List).length;
            }
          }
        }
      }
    }

    throw Exception('Format data API tidak dikenali: $endpoint');
  }

  Future<void> _loadDashboardData() async {
    if (mounted) {
      setState(() {
        loading = true;
      });
    }

    try {
      final results = await Future.wait([
        _getTotal('siswa.php'),
        _getTotal('guru.php'),
      ]);

      if (!mounted) return;

      setState(() {
        totalSiswa = results[0];
        totalGuru = results[1];
        loading = false;
      });
    } catch (e) {
      debugPrint('Dashboard API error: $e');

      if (!mounted) return;

      setState(() {
        loading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal memuat statistik: $e'),
          behavior: SnackBarBehavior.floating,
          action: SnackBarAction(
            label: 'Coba lagi',
            onPressed: _loadDashboardData,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth < 900) {
            return _mobileDashboard(context);
          }
          return _desktopDashboard(context);
        },
      ),
    );
  }

  // ============================================================
  // DESKTOP
  // ============================================================

  Widget _desktopDashboard(BuildContext context) {
    return Column(
      children: [
        _topHeader(context),
        Expanded(
          child: Row(
            children: [
              _sidebar(context),
              Expanded(
                child: _dashboardContent(context),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ============================================================
  // MOBILE
  // ============================================================

  Widget _mobileDashboard(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        backgroundColor: navy,
        foregroundColor: Colors.white,
        title: const Text(
          'SIA-TU SEKOLAH',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            tooltip: 'Muat ulang data',
            onPressed: _loadDashboardData,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      drawer: Drawer(
        child: SafeArea(
          child: Column(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(20, 30, 20, 25),
                color: navy,
                child: const Row(
                  children: [
                    CircleAvatar(
                      radius: 27,
                      backgroundColor: Colors.white,
                      child: Icon(
                        Icons.school,
                        color: Color(0xFFE67E22),
                        size: 30,
                      ),
                    ),
                    SizedBox(width: 14),
                    Text(
                      'SIA-TU SEKOLAH',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              _menuItem(context, Icons.dashboard, 'Dashboard', true, () {
                Navigator.pop(context);
              }),
              _menuItem(context, Icons.people_outline, 'Data Siswa', false, () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const SiswaPage()),
                );
              }),
              _menuItem(context, Icons.badge_outlined, 'Data Guru', false, () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const GuruPage()),
                );
              }),
              _menuItem(context, Icons.mail_outline, 'Surat Masuk', false, () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const SuratMasukPage()),
                );
              }),
              _menuItem(context, Icons.send_outlined, 'Surat Keluar', false, () {
                Navigator.pop(context);
                _comingSoon(context, 'Surat Keluar');
              }),
              _menuItem(context, Icons.bar_chart, 'Laporan', false, () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const LaporanPage()),
                );
              }),
              const Spacer(),
              _logoutMenuItem(context),
              const SizedBox(height: 15),
            ],
          ),
        ),
      ),
      body: _dashboardContent(context),
    );
  }

  // ============================================================
  // HEADER
  // ============================================================

  Widget _topHeader(BuildContext context) {
    return Container(
      height: 112,
      color: navy,
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Row(
        children: [
          Container(
            width: 65,
            height: 65,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              border: Border.all(
                color: const Color(0xFFE67E22),
                width: 3,
              ),
            ),
            child: const Icon(
              Icons.school,
              color: Color(0xFFE67E22),
              size: 38,
            ),
          ),
          const SizedBox(width: 20),
          const Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Sistem Informasi Tata Usaha Sekolah',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'Pengelolaan Data Administrasi Sekolah',
                  style: TextStyle(
                    color: Color(0xFF9CC9E8),
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
          InkWell(
            borderRadius: BorderRadius.circular(18),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const ProfileAdminPage(),
                ),
              );
            },
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 15,
                vertical: 10,
              ),
              decoration: BoxDecoration(
                color: const Color(0xFF205B8B),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: const Color(0xFF286D9F),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 45,
                    height: 45,
                    decoration: const BoxDecoration(
                      color: Color(0xFF3C87BE),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.person,
                      color: Colors.white,
                      size: 27,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        ProfileAdminData.nama,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 2),
                      const Row(
                        children: [
                          Icon(
                            Icons.circle,
                            color: Color(0xFF38D39F),
                            size: 8,
                          ),
                          SizedBox(width: 5),
                          Text(
                            'Online',
                            style: TextStyle(
                              color: Color(0xFF38D39F),
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(width: 8),
                  const Icon(
                    Icons.edit_outlined,
                    color: Colors.white70,
                    size: 17,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // SIDEBAR
  // ============================================================

  Widget _sidebar(BuildContext context) {
    return Container(
      width: 340,
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(15, 22, 15, 15),
      child: Column(
        children: [
          _menuItem(context, Icons.dashboard, 'Dashboard', true, () {}),
          _menuItem(context, Icons.people_outline, 'Data Siswa', false, () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const SiswaPage()),
            );
          }),
          _menuItem(context, Icons.badge_outlined, 'Data Guru', false, () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const GuruPage()),
            );
          }),
          _menuItem(context, Icons.mail_outline, 'Surat Masuk', false, () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const SuratMasukPage()),
            );
          }),
          _menuItem(context, Icons.send_outlined, 'Surat Keluar', false, () {
            _comingSoon(context, 'Surat Keluar');
          }),
          _menuItem(context, Icons.bar_chart, 'Laporan', false, () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const LaporanPage()),
            );
          }),
          const Spacer(),
          _logoutMenuItem(context),
        ],
      ),
    );
  }

  // ============================================================
  // MENU ITEM
  // ============================================================

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
          height: 54,
          margin: const EdgeInsets.only(bottom: 10),
          decoration: BoxDecoration(
            color: active ? navy : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              const SizedBox(width: 23),
              Icon(
                icon,
                size: 25,
                color: active ? Colors.white : const Color(0xFF50627A),
              ),
              const SizedBox(width: 20),
              Text(
                title,
                style: TextStyle(
                  color: active ? Colors.white : navy,
                  fontSize: 18,
                  fontWeight: active ? FontWeight.bold : FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _comingSoon(BuildContext context, String title) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$title belum dibuat.'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  // ============================================================
  // LOGOUT
  // ============================================================

  Widget _logoutMenuItem(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const LoginPage()),
          );
        },
        borderRadius: BorderRadius.circular(10),
        child: Container(
          width: double.infinity,
          height: 55,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: const Color(0xFFFFCACA)),
          ),
          child: const Row(
            children: [
              SizedBox(width: 22),
              Icon(Icons.logout, color: Color(0xFFE52323), size: 25),
              SizedBox(width: 20),
              Text(
                'Logout',
                style: TextStyle(
                  color: Color(0xFFE52323),
                  fontSize: 17,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ============================================================
  // DASHBOARD CONTENT
  // ============================================================

  Widget _dashboardContent(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final bool mobile = constraints.maxWidth < 700;

        return SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(
            mobile ? 16 : 32,
            mobile ? 18 : 25,
            mobile ? 16 : 32,
            mobile ? 25 : 30,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (mobile)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.home, color: navy, size: 24),
                        SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'DASHBOARD RINGKASAN DATA',
                            style: TextStyle(
                              color: navy,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    _yearLabel(),
                  ],
                )
              else
                Row(
                  children: [
                    const Icon(Icons.home, color: navy, size: 30),
                    const SizedBox(width: 15),
                    const Expanded(
                      child: Text(
                        'DASHBOARD RINGKASAN DATA',
                        style: TextStyle(
                          color: navy,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    _yearLabel(),
                  ],
                ),
              const SizedBox(height: 15),
              const Divider(color: Color(0xFFD2DAE4)),
              const SizedBox(height: 25),
              if (mobile) ...[
                _studentCard(true),
                const SizedBox(height: 18),
                _teacherCard(true),
              ] else
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: _studentCard(false)),
                    const SizedBox(width: 30),
                    Expanded(child: _teacherCard(false)),
                  ],
                ),
              const SizedBox(height: 25),
              if (mobile) ...[
                _studentChart(true),
                const SizedBox(height: 18),
                _graduationChart(true),
              ] else
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: _studentChart(false)),
                    const SizedBox(width: 30),
                    Expanded(child: _graduationChart(false)),
                  ],
                ),
              const SizedBox(height: 25),
              const CalendarSection(),
            ],
          ),
        );
      },
    );
  }

  Widget _yearLabel() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 9),
      decoration: BoxDecoration(
        color: const Color(0xFFE4EAF2),
        borderRadius: BorderRadius.circular(25),
      ),
      child: const Text(
        'Tahun Ajaran 2025/2026 Ganjil',
        style: TextStyle(
          color: Color(0xFF60728C),
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  // ============================================================
  // KARTU SISWA
  // ============================================================

  Widget _studentCard(bool mobile) {
    return Container(
      height: mobile ? null : 295,
      width: double.infinity,
      padding: EdgeInsets.all(mobile ? 18 : 25),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _iconBox(
                Icons.people,
                const Color(0xFFEAF3FF),
                const Color(0xFF553A91),
              ),
              SizedBox(width: mobile ? 10 : 12),
              Expanded(
                child: Text(
                  'Total Siswa Aktif',
                  style: TextStyle(
                    color: textDark,
                    fontSize: mobile ? 17 : 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 13),
          Text(
            loading ? '...' : '$totalSiswa',
            style: TextStyle(
              color: Colors.black87,
              fontSize: mobile ? 36 : 42,
              height: 1,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(
                Icons.arrow_drop_down,
                color: Color(0xFFE83D62),
                size: 24,
              ),
              const Text(
                '20.8%',
                style: TextStyle(
                  color: Color(0xFFE83D62),
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 5),
              const Text(
                'dari tahun lalu',
                style: TextStyle(color: textGrey, fontSize: 14),
              ),
            ],
          ),
          const SizedBox(height: 13),
          Row(
            children: [
              Expanded(
                child: _statusBox(
                  'Aktif Kelas',
                  loading ? '...' : '$totalSiswa',
                  const Color(0xFFE9FAF2),
                  const Color(0xFF16A77A),
                  const Color(0xFF4BD18F),
                ),
              ),
              SizedBox(width: mobile ? 8 : 10),
              Expanded(
                child: _statusBox(
                  'Cuti',
                  '0',
                  const Color(0xFFF2EFF8),
                  const Color(0xFF6E618A),
                  const Color(0xFFD8CFE7),
                ),
              ),
            ],
          ),
          const SizedBox(height: 7),
          Row(
            children: [
              Expanded(
                child: _statusBox(
                  'Skorsing',
                  '0',
                  const Color(0xFFFFF8E7),
                  const Color(0xFFD98200),
                  const Color(0xFFFFCB58),
                ),
              ),
              SizedBox(width: mobile ? 8 : 10),
              Expanded(
                child: _statusBox(
                  'Non Aktif',
                  '0',
                  const Color(0xFFFFF0F1),
                  const Color(0xFFE0244F),
                  const Color(0xFFE94B69),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ============================================================
  // KARTU GURU
  // ============================================================

  Widget _teacherCard(bool mobile) {
    return Container(
      height: mobile ? null : 295,
      width: double.infinity,
      padding: EdgeInsets.all(mobile ? 18 : 27),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _iconBox(
                Icons.menu_book,
                const Color(0xFFF0F3F7),
                const Color(0xFF3D63A3),
              ),
              SizedBox(width: mobile ? 10 : 12),
              Expanded(
                child: Text(
                  'Tenaga Pengajar (Guru)',
                  style: TextStyle(
                    color: textDark,
                    fontSize: mobile ? 17 : 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: mobile ? 22 : 28),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      loading ? '...' : '$totalGuru',
                      style: TextStyle(
                        color: Colors.black87,
                        fontSize: mobile ? 36 : 42,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Guru Terdaftar Aktif',
                      style: TextStyle(
                        color: textGrey,
                        fontSize: mobile ? 14 : 16,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: mobile ? 75 : 85,
                height: mobile ? 75 : 85,
                child: CustomPaint(painter: DonutPainter()),
              ),
            ],
          ),
          if (!mobile) const Spacer() else const SizedBox(height: 20),
          const Divider(color: Color(0xFFE5EAF0)),
          SizedBox(height: mobile ? 12 : 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Lulus Tahun Ini: 0',
                style: TextStyle(
                  color: textGrey,
                  fontSize: mobile ? 13 : 15,
                ),
              ),
              Text(
                '0% dari tahun lalu',
                style: TextStyle(
                  color: const Color(0xFFFF3030),
                  fontSize: mobile ? 13 : 15,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ============================================================
  // GRAFIK SISWA
  // ============================================================

  Widget _studentChart(bool mobile) {
    return Container(
      height: mobile ? 300 : 335,
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(
        mobile ? 18 : 27,
        mobile ? 20 : 25,
        mobile ? 18 : 27,
        mobile ? 15 : 20,
      ),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'PERKEMBANGAN JUMLAH SISWA',
            style: TextStyle(
              color: textDark,
              fontSize: mobile ? 15 : 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: mobile ? 15 : 20),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  width: 1,
                  color: const Color(0xFFDDE4EC),
                ),
                SizedBox(width: mobile ? 18 : 35),
                Expanded(
                  child: _barChart(
                    values: const [45, 52, 60],
                    labels: const ['2023', '2024', '2025'],
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
  // GRAFIK KELULUSAN
  // ============================================================

  Widget _graduationChart(bool mobile) {
    return Container(
      height: mobile ? 300 : 335,
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(
        mobile ? 18 : 27,
        mobile ? 20 : 25,
        mobile ? 18 : 27,
        mobile ? 15 : 20,
      ),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'TREN STATISTIK KELULUSAN SISWA',
            style: TextStyle(
              color: textDark,
              fontSize: mobile ? 15 : 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: mobile ? 15 : 20),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  width: 1,
                  color: const Color(0xFFDDE4EC),
                ),
                SizedBox(width: mobile ? 18 : 35),
                Expanded(child: _graduationBars()),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // BAR CHART
  // ============================================================

  Widget _barChart({
    required List<int> values,
    required List<String> labels,
  }) {
    const double maxValue = 70;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: List.generate(values.length, (index) {
        final double height = (values[index] / maxValue) * 180;

        return Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              '${values[index]}',
              style: const TextStyle(color: textGrey, fontSize: 14),
            ),
            const SizedBox(height: 7),
            Container(
              width: 44,
              height: height,
              decoration: BoxDecoration(
                color: index == 2 ? navy : blue,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(6),
                  topRight: Radius.circular(6),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              labels[index],
              style: const TextStyle(
                color: textDark,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _graduationBars() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              width: 45,
              height: 120,
              decoration: const BoxDecoration(
                color: Color(0xFF2BB5D0),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(6),
                  topRight: Radius.circular(6),
                ),
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Ganjil',
              style: TextStyle(color: textDark, fontSize: 14),
            ),
          ],
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              width: 45,
              height: 60,
              decoration: const BoxDecoration(
                color: Color(0xFF16B98A),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(6),
                  topRight: Radius.circular(6),
                ),
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Genap',
              style: TextStyle(color: textDark, fontSize: 14),
            ),
          ],
        ),
      ],
    );
  }

  // ============================================================
  // KOMPONEN KARTU
  // ============================================================

  BoxDecoration _cardDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(17),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.05),
          blurRadius: 5,
          offset: const Offset(0, 2),
        ),
      ],
    );
  }

  Widget _iconBox(
    IconData icon,
    Color backgroundColor,
    Color iconColor,
  ) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(11),
      ),
      child: Icon(icon, color: iconColor, size: 25),
    );
  }

  Widget _statusBox(
    String title,
    String value,
    Color backgroundColor,
    Color textColor,
    Color dotColor,
  ) {
    return Container(
      height: 30,
      padding: const EdgeInsets.symmetric(horizontal: 11),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        children: [
          Container(
            width: 13,
            height: 13,
            decoration: BoxDecoration(
              color: dotColor,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 7),
          Expanded(
            child: Text(
              title,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: textColor, fontSize: 14),
            ),
          ),
          const SizedBox(width: 5),
          Text(
            value,
            style: TextStyle(
              color: textColor,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// DONUT CHART
// ============================================================

class DonutPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final backgroundPaint = Paint()
      ..color = const Color(0xFFE1E8F0)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10;

    final bluePaint = Paint()
      ..color = const Color(0xFF193F68)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10;

    final cyanPaint = Paint()
      ..color = const Color(0xFF22BCD4)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10;

    final rect = Offset.zero & size;

    canvas.drawArc(rect, -1.57, 4.7, false, backgroundPaint);
    canvas.drawArc(rect, -1.57, 1.55, false, bluePaint);
    canvas.drawArc(rect, 0.0, 1.2, false, cyanPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

// ============================================================
// KALENDER DASHBOARD
// ============================================================

class CalendarSection extends StatefulWidget {
  const CalendarSection({super.key});

  @override
  State<CalendarSection> createState() => _CalendarSectionState();
}

class _CalendarSectionState extends State<CalendarSection> {
  static const Color navy = Color(0xFF193F68);
  static const Color textDark = Color(0xFF34445B);
  static const Color textGrey = Color(0xFF71839D);

  DateTime displayedMonth = DateTime.now();
  final DateTime today = DateTime.now();

  static const List<String> monthNames = [
    'Januari',
    'Februari',
    'Maret',
    'April',
    'Mei',
    'Juni',
    'Juli',
    'Agustus',
    'September',
    'Oktober',
    'November',
    'Desember',
  ];

  static const List<String> weekdays = [
    'Sen',
    'Sel',
    'Rab',
    'Kam',
    'Jum',
    'Sab',
    'Min',
  ];

  void _changeMonth(int amount) {
    setState(() {
      displayedMonth = DateTime(
        displayedMonth.year,
        displayedMonth.month + amount,
        1,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final firstDay = DateTime(
      displayedMonth.year,
      displayedMonth.month,
      1,
    );

    final startingOffset = firstDay.weekday - 1;

    final daysInMonth = DateTime(
      displayedMonth.year,
      displayedMonth.month + 1,
      0,
    ).day;

    final mobile = MediaQuery.of(context).size.width < 600;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(mobile ? 16 : 25),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(17),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.calendar_month,
                color: navy,
                size: 28,
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  'KALENDER AKADEMIK',
                  style: TextStyle(
                    color: textDark,
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    displayedMonth = DateTime.now();
                  });
                },
                child: const Text('Hari ini'),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              IconButton(
                tooltip: 'Bulan sebelumnya',
                onPressed: () => _changeMonth(-1),
                icon: const Icon(Icons.chevron_left, color: navy),
              ),
              Expanded(
                child: Text(
                  '${monthNames[displayedMonth.month - 1]} ${displayedMonth.year}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: navy,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              IconButton(
                tooltip: 'Bulan berikutnya',
                onPressed: () => _changeMonth(1),
                icon: const Icon(Icons.chevron_right, color: navy),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: weekdays.map((day) {
              return Expanded(
                child: Center(
                  child: Text(
                    day,
                    style: TextStyle(
                      color: day == 'Min' ? Colors.red : textGrey,
                      fontWeight: FontWeight.bold,
                      fontSize: mobile ? 12 : 14,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 10),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 42,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              mainAxisSpacing: 6,
              crossAxisSpacing: 4,
              childAspectRatio: 1.15,
            ),
            itemBuilder: (context, index) {
              final dayNumber = index - startingOffset + 1;

              if (dayNumber < 1 || dayNumber > daysInMonth) {
                return const SizedBox.shrink();
              }

              final date = DateTime(
                displayedMonth.year,
                displayedMonth.month,
                dayNumber,
              );

              final isToday = date.year == today.year &&
                  date.month == today.month &&
                  date.day == today.day;

              final isSunday = date.weekday == DateTime.sunday;

              return Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: isToday ? navy : Colors.transparent,
                  borderRadius: BorderRadius.circular(9),
                  border: isToday
                      ? null
                      : Border.all(color: const Color(0xFFE5EAF0)),
                ),
                child: Text(
                  '$dayNumber',
                  style: TextStyle(
                    color: isToday
                        ? Colors.white
                        : isSunday
                            ? Colors.red
                            : textDark,
                    fontWeight:
                        isToday ? FontWeight.bold : FontWeight.normal,
                    fontSize: mobile ? 12 : 14,
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 15),
          Row(
            children: [
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: navy,
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
              const SizedBox(width: 8),
              const Text(
                'Hari ini',
                style: TextStyle(color: textGrey, fontSize: 12),
              ),
              const SizedBox(width: 16),
              const Icon(Icons.circle, color: Colors.red, size: 10),
              const SizedBox(width: 6),
              const Text(
                'Minggu',
                style: TextStyle(color: textGrey, fontSize: 12),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
