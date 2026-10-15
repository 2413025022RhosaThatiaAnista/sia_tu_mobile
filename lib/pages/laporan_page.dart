
import 'dart:convert';
import 'dart:html' as html;

import 'package:flutter/material.dart';

import 'login_page.dart';
import 'dashboard_page.dart';
import 'siswa_page.dart';
import 'guru_page.dart';
import 'surat_masuk_page.dart';

class LaporanPage extends StatefulWidget {
  const LaporanPage({super.key});

  @override
  State<LaporanPage> createState() => _LaporanPageState();
}

class _LaporanPageState extends State<LaporanPage> {
  static const Color navy = Color(0xFF193F68);
  static const Color blue = Color(0xFF287EB4);
  static const Color background = Color(0xFFF1F5F9);
  static const Color textDark = Color(0xFF34445B);
  static const Color textGrey = Color(0xFF71839D);
  static const Color orange = Color(0xFFE67E22);
  static const Color green = Color(0xFF27AE60);
  static const Color red = Color(0xFFE74C3C);

  final TextEditingController _searchController =
      TextEditingController();

  String _jenisLaporan = 'Semua';
  String _statusFilter = 'Semua';

  // Data contoh untuk tampilan laporan.
  // Ganti dengan data sebenarnya dari modul surat project kamu.
  final List<Map<String, String>> _dataLaporan = [
    {
      'jenis': 'Surat Masuk',
      'nomor': '001/SM/X/2026',
      'tanggal': '01-10-2026',
      'perihal': 'Undangan Rapat',
      'asalTujuan': 'Dinas Pendidikan',
      'status': 'Diterima',
    },
    {
      'jenis': 'Surat Masuk',
      'nomor': '002/SM/X/2026',
      'tanggal': '05-10-2026',
      'perihal': 'Informasi Kegiatan',
      'asalTujuan': 'Instansi Terkait',
      'status': 'Diproses',
    },
    {
      'jenis': 'Surat Keluar',
      'nomor': '001/SK/X/2026',
      'tanggal': '03-10-2026',
      'perihal': 'Surat Undangan',
      'asalTujuan': 'Orang Tua Siswa',
      'status': 'Terkirim',
    },
    {
      'jenis': 'Surat Keluar',
      'nomor': '002/SK/X/2026',
      'tanggal': '08-10-2026',
      'perihal': 'Surat Pemberitahuan',
      'asalTujuan': 'Dinas Pendidikan',
      'status': 'Disiapkan',
    },
  ];

  List<Map<String, String>> get _filteredData {
    final query = _searchController.text.toLowerCase();

    return _dataLaporan.where((data) {
      final cocokJenis = _jenisLaporan == 'Semua' ||
          data['jenis'] == _jenisLaporan;

      final cocokStatus = _statusFilter == 'Semua' ||
          data['status'] == _statusFilter;

      final cocokPencarian = data.values.any(
        (value) => value.toLowerCase().contains(query),
      );

      return cocokJenis && cocokStatus && cocokPencarian;
    }).toList();
  }

  int get _jumlahMasuk => _dataLaporan
      .where((e) => e['jenis'] == 'Surat Masuk')
      .length;

  int get _jumlahKeluar => _dataLaporan
      .where((e) => e['jenis'] == 'Surat Keluar')
      .length;

  // Mengunduh data laporan yang sedang tampil (mengikuti pencarian dan filter).
  // Fitur ini ditujukan untuk Flutter Web yang dijalankan melalui browser.
  void _downloadCsv() {
    final data = _filteredData;

    if (data.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Tidak ada data laporan untuk diunduh.'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    String escapeCsv(String value) {
      final escaped = value.replaceAll('"', '""');
      return '"$escaped"';
    }

    final rows = <List<String>>[
      ['No.', 'Jenis Surat', 'Nomor Surat', 'Tanggal', 'Perihal', 'Asal / Tujuan', 'Status'],
      for (var i = 0; i < data.length; i++)
        [
          '${i + 1}',
          data[i]['jenis'] ?? '',
          data[i]['nomor'] ?? '',
          data[i]['tanggal'] ?? '',
          data[i]['perihal'] ?? '',
          data[i]['asalTujuan'] ?? '',
          data[i]['status'] ?? '',
        ],
    ];

    final csv = rows
        .map((row) => row.map(escapeCsv).join(','))
        .join('\r\n');

    // BOM membantu Microsoft Excel mengenali teks UTF-8 dengan benar.
    final bytes = utf8.encode('\uFEFF$csv');
    final blob = html.Blob([bytes], 'text/csv;charset=utf-8;');
    final url = html.Url.createObjectUrlFromBlob(blob);

    html.AnchorElement(href: url)
      ..setAttribute('download', 'laporan_surat.csv')
      ..style.display = 'none'
      ..click();

    html.Url.revokeObjectUrl(url);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('File laporan berhasil disiapkan untuk diunduh.'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _bukaHalaman(Widget halaman) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => halaman),
    );
  }

  void _belumTersedia(String nama) {
    Navigator.popUntil(context, (route) => route.isFirst);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Halaman $nama belum dihubungkan.'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _logout() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginPage()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth < 900) {
            return _buildMobileLayout();
          }

          return Column(
            children: [
              _buildTopHeader(),
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildSidebar(),
                    Expanded(child: _buildContent()),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  // =========================================================
  // HEADER DESKTOP
  // =========================================================

  Widget _buildTopHeader() {
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
              border: Border.all(color: orange, width: 3),
            ),
            child: const Icon(
              Icons.school,
              color: orange,
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
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Pengelolaan Data Administrasi Sekolah',
                  style: TextStyle(
                    color: Color(0xFF9CC9E8),
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 15,
              vertical: 10,
            ),
            decoration: BoxDecoration(
              color: const Color(0xFF205B8B),
              borderRadius: BorderRadius.circular(18),
            ),
            child: const Row(
              children: [
                CircleAvatar(
                  backgroundColor: Color(0xFF3C87BE),
                  child: Icon(Icons.person, color: Colors.white),
                ),
                SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Admin TU',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 3),
                    Text(
                      '● Online',
                      style: TextStyle(
                        color: Color(0xFF38D39F),
                        fontSize: 12,
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

  // =========================================================
  // SIDEBAR DESKTOP
  // =========================================================

  Widget _buildSidebar() {
    return Container(
      width: 340,
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(15, 22, 15, 15),
      child: Column(
        children: [
          _menuItem(
            Icons.dashboard,
            'Dashboard',
            false,
            () => _bukaHalaman(const DashboardPage()),
          ),
          _menuItem(
            Icons.people_outline,
            'Data Siswa',
            false,
            () => _bukaHalaman(const SiswaPage()),
          ),
          _menuItem(
            Icons.badge_outlined,
            'Data Guru',
            false,
            () => _bukaHalaman(const GuruPage()),
          ),
          _menuItem(
            Icons.mail_outline,
            'Surat Masuk',
            false,
            () => _bukaHalaman(const SuratMasukPage()),
          ),
          _menuItem(
            Icons.send_outlined,
            'Surat Keluar',
            false,
            () => _belumTersedia('Surat Keluar'),
          ),
          _menuItem(
            Icons.bar_chart,
            'Laporan',
            true,
            () {},
          ),
          const Spacer(),
          _buildLogoutButton(),
        ],
      ),
    );
  }

  Widget _menuItem(
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
                  fontSize: 17,
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

  Widget _buildLogoutButton() {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: _logout,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          width: double.infinity,
          height: 55,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: const Color(0xFFFFCACA)),
          ),
          child: const Row(
            children: [
              SizedBox(width: 22),
              Icon(Icons.logout, color: red, size: 24),
              SizedBox(width: 20),
              Text(
                'Logout',
                style: TextStyle(
                  color: red,
                  fontSize: 17,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // =========================================================
  // LAYOUT MOBILE
  // =========================================================

  Widget _buildMobileLayout() {
    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        backgroundColor: navy,
        foregroundColor: Colors.white,
        title: const Text(
          'Laporan',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      drawer: Drawer(
        child: SafeArea(
          child: Column(
            children: [
              Container(
                width: double.infinity,
                color: navy,
                padding: const EdgeInsets.all(24),
                child: const Row(
                  children: [
                    CircleAvatar(
                      radius: 27,
                      backgroundColor: Colors.white,
                      child: Icon(
                        Icons.school,
                        color: orange,
                        size: 30,
                      ),
                    ),
                    SizedBox(width: 14),
                    Expanded(
                      child: Text(
                        'SIA-TU SEKOLAH',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 15),
              _mobileMenuItem(
                Icons.dashboard,
                'Dashboard',
                () => _bukaHalaman(const DashboardPage()),
              ),
              _mobileMenuItem(
                Icons.people_outline,
                'Data Siswa',
                () => _bukaHalaman(const SiswaPage()),
              ),
              _mobileMenuItem(
                Icons.badge_outlined,
                'Data Guru',
                () => _bukaHalaman(const GuruPage()),
              ),
              _mobileMenuItem(
                Icons.mail_outline,
                'Surat Masuk',
                () => _bukaHalaman(const SuratMasukPage()),
              ),
              _mobileMenuItem(
                Icons.send_outlined,
                'Surat Keluar',
                () => _belumTersedia('Surat Keluar'),
              ),
              _mobileMenuItem(
                Icons.bar_chart,
                'Laporan',
                () => Navigator.pop(context),
                active: true,
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.all(16),
                child: _buildLogoutButton(),
              ),
            ],
          ),
        ),
      ),
      body: _buildContent(),
    );
  }

  Widget _mobileMenuItem(
    IconData icon,
    String title,
    VoidCallback onTap, {
    bool active = false,
  }) {
    return ListTile(
      selected: active,
      selectedTileColor: navy,
      leading: Icon(
        icon,
        color: active ? Colors.white : navy,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: active ? Colors.white : navy,
          fontWeight: active ? FontWeight.bold : FontWeight.w500,
        ),
      ),
      onTap: onTap,
    );
  }

  // =========================================================
  // KONTEN LAPORAN
  // =========================================================

  Widget _buildContent() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final bool mobile = constraints.maxWidth < 700;

        return SingleChildScrollView(
          padding: EdgeInsets.all(mobile ? 16 : 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildPageTitle(mobile),
              const SizedBox(height: 24),
              _buildSummaryCards(mobile),
              const SizedBox(height: 28),
              _buildReportPanel(mobile),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPageTitle(bool mobile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.bar_chart, color: navy, size: 30),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'LAPORAN ADMINISTRASI',
                style: TextStyle(
                  color: navy,
                  fontSize: mobile ? 20 : 27,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        const Text(
          'Ringkasan dan rekapitulasi data persuratan sekolah.',
          style: TextStyle(color: textGrey, fontSize: 14),
        ),
      ],
    );
  }

  // =========================================================
  // KARTU RINGKASAN
  // =========================================================

  Widget _buildSummaryCards(bool mobile) {
    final cards = [
      _SummaryItem(
        title: 'Total Surat',
        value: '${_dataLaporan.length}',
        subtitle: 'Seluruh data contoh',
        icon: Icons.description_outlined,
        color: navy,
      ),
      _SummaryItem(
        title: 'Surat Masuk',
        value: '$_jumlahMasuk',
        subtitle: 'Data surat diterima',
        icon: Icons.mark_email_read_outlined,
        color: blue,
      ),
      _SummaryItem(
        title: 'Surat Keluar',
        value: '$_jumlahKeluar',
        subtitle: 'Data surat dikeluarkan',
        icon: Icons.outgoing_mail,
        color: orange,
      ),
    ];

    if (mobile) {
      return Column(
        children: cards
            .map(
              (item) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _buildSummaryCard(item),
              ),
            )
            .toList(),
      );
    }

    return Row(
      children: cards
          .map(
            (item) => Expanded(
              child: Padding(
                padding: const EdgeInsets.only(right: 14),
                child: _buildSummaryCard(item),
              ),
            ),
          )
          .toList(),
    );
  }

  Widget _buildSummaryCard(_SummaryItem item) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE4EAF2)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.025),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 54,
            height: 54,
            decoration: BoxDecoration(
              color: item.color.withOpacity(0.10),
              borderRadius: BorderRadius.circular(13),
            ),
            child: Icon(item.icon, color: item.color, size: 29),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: const TextStyle(
                    color: textGrey,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  item.value,
                  style: const TextStyle(
                    color: navy,
                    fontSize: 27,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  item.subtitle,
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

  // =========================================================
  // PANEL DATA LAPORAN
  // =========================================================

  Widget _buildReportPanel(bool mobile) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(mobile ? 15 : 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE4EAF2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Rekapitulasi Surat',
            style: TextStyle(
              color: navy,
              fontSize: 19,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Cari dan saring data laporan surat.',
            style: TextStyle(color: textGrey, fontSize: 13),
          ),
          const SizedBox(height: 20),
          _buildFilters(mobile),
          const SizedBox(height: 20),
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Data Laporan',
                  style: TextStyle(
                    color: textDark,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Text(
                '${_filteredData.length} data',
                style: const TextStyle(
                  color: textGrey,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton.icon(
              onPressed: _filteredData.isEmpty ? null : _downloadCsv,
              icon: const Icon(Icons.download, size: 19),
              label: const Text('Download CSV'),
              style: ElevatedButton.styleFrom(
                backgroundColor: navy,
                foregroundColor: Colors.white,
                disabledBackgroundColor: const Color(0xFFCBD5E1),
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 13,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
          const SizedBox(height: 14),
          if (_filteredData.isEmpty)
            _buildEmptyState()
          else if (mobile)
            ..._filteredData.map(_buildReportCard)
          else
            _buildDesktopTable(),
          const SizedBox(height: 14),
          const Text(
            '* Data pada halaman ini merupakan data contoh. '
            'Hubungkan dengan sumber data modul surat untuk '
            'menampilkan laporan yang sebenarnya.',
            style: TextStyle(
              color: textGrey,
              fontSize: 11,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilters(bool mobile) {
    final search = TextField(
      controller: _searchController,
      onChanged: (_) => setState(() {}),
      decoration: InputDecoration(
        hintText: 'Cari nomor surat atau perihal...',
        hintStyle: const TextStyle(fontSize: 13),
        prefixIcon: const Icon(Icons.search, color: textGrey),
        suffixIcon: IconButton(
          onPressed: () {
            _searchController.clear();
            setState(() {});
          },
          icon: const Icon(Icons.close, size: 19),
        ),
        filled: true,
        fillColor: const Color(0xFFF8FAFC),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFFE4EAF2)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFFE4EAF2)),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 14,
        ),
      ),
    );

    final jenis = _buildDropdown(
      value: _jenisLaporan,
      label: 'Jenis Surat',
      options: const ['Semua', 'Surat Masuk', 'Surat Keluar'],
      onChanged: (value) {
        setState(() => _jenisLaporan = value!);
      },
    );

    final status = _buildDropdown(
      value: _statusFilter,
      label: 'Status',
      options: const [
        'Semua',
        'Diterima',
        'Diproses',
        'Terkirim',
        'Disiapkan',
      ],
      onChanged: (value) {
        setState(() => _statusFilter = value!);
      },
    );

    if (mobile) {
      return Column(
        children: [
          search,
          const SizedBox(height: 12),
          jenis,
          const SizedBox(height: 12),
          status,
        ],
      );
    }

    return Row(
      children: [
        Expanded(flex: 3, child: search),
        const SizedBox(width: 12),
        Expanded(flex: 2, child: jenis),
        const SizedBox(width: 12),
        Expanded(flex: 2, child: status),
      ],
    );
  }

  Widget _buildDropdown({
    required String value,
    required String label,
    required List<String> options,
    required ValueChanged<String?> onChanged,
  }) {
    return DropdownButtonFormField<String>(
      value: value,
      isExpanded: true,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(fontSize: 12),
        filled: true,
        fillColor: const Color(0xFFF8FAFC),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 12,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFFE4EAF2)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFFE4EAF2)),
        ),
      ),
      items: options
          .map(
            (option) => DropdownMenuItem(
              value: option,
              child: Text(
                option,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 12),
              ),
            ),
          )
          .toList(),
      onChanged: onChanged,
    );
  }

  // =========================================================
  // TABEL DESKTOP
  // =========================================================

  Widget _buildDesktopTable() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        headingRowColor: WidgetStateProperty.all(
          const Color(0xFFF1F5F9),
        ),
        columnSpacing: 25,
        horizontalMargin: 14,
        dataRowMinHeight: 62,
        dataRowMaxHeight: 76,
        columns: const [
          DataColumn(label: Text('No.')),
          DataColumn(label: Text('Jenis')),
          DataColumn(label: Text('Nomor Surat')),
          DataColumn(label: Text('Tanggal')),
          DataColumn(label: Text('Perihal')),
          DataColumn(label: Text('Asal / Tujuan')),
          DataColumn(label: Text('Status')),
        ],
        rows: List.generate(
          _filteredData.length,
          (index) {
            final data = _filteredData[index];

            return DataRow(
              cells: [
                DataCell(Text('${index + 1}')),
                DataCell(
                  SizedBox(
                    width: 100,
                    child: Text(
                      data['jenis']!,
                      style: const TextStyle(fontSize: 12),
                    ),
                  ),
                ),
                DataCell(Text(data['nomor']!)),
                DataCell(Text(data['tanggal']!)),
                DataCell(
                  SizedBox(
                    width: 140,
                    child: Text(data['perihal']!),
                  ),
                ),
                DataCell(
                  SizedBox(
                    width: 150,
                    child: Text(data['asalTujuan']!),
                  ),
                ),
                DataCell(_buildStatusBadge(data['status']!)),
              ],
            );
          },
        ),
      ),
    );
  }

  // =========================================================
  // KARTU MOBILE
  // =========================================================

  Widget _buildReportCard(Map<String, String> data) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: const Color(0xFFFAFCFE),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE4EAF2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  data['jenis']!,
                  style: const TextStyle(
                    color: navy,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              _buildStatusBadge(data['status']!),
            ],
          ),
          const Divider(height: 22),
          _detailRow('Nomor Surat', data['nomor']!),
          _detailRow('Tanggal', data['tanggal']!),
          _detailRow('Perihal', data['perihal']!),
          _detailRow('Asal / Tujuan', data['asalTujuan']!),
        ],
      ),
    );
  }

  Widget _detailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 9),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 105,
            child: Text(
              label,
              style: const TextStyle(
                color: textGrey,
                fontSize: 12,
              ),
            ),
          ),
          const Text(': ', style: TextStyle(color: textGrey)),
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
      ),
    );
  }

  // =========================================================
  // STATUS DAN EMPTY STATE
  // =========================================================

  Widget _buildStatusBadge(String status) {
    Color color;

    switch (status) {
      case 'Diterima':
        color = green;
        break;
      case 'Terkirim':
        color = blue;
        break;
      case 'Diproses':
        color = orange;
        break;
      case 'Disiapkan':
        color = textGrey;
        break;
      default:
        color = textGrey;
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.10),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 40),
      child: const Column(
        children: [
          Icon(
            Icons.inbox_outlined,
            size: 48,
            color: Color(0xFFB0BDCD),
          ),
          SizedBox(height: 12),
          Text(
            'Data laporan tidak ditemukan',
            style: TextStyle(
              color: textDark,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 5),
          Text(
            'Coba ubah kata pencarian atau filter.',
            style: TextStyle(
              color: textGrey,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryItem {
  final String title;
  final String value;
  final String subtitle;
  final IconData icon;
  final Color color;

  const _SummaryItem({
    required this.title,
    required this.value,
    required this.subtitle,
    required this.icon,
    required this.color,
  });
}
