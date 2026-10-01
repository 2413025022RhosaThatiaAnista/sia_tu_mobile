import 'package:flutter/material.dart';

import 'dashboard_page.dart';
import 'guru_page.dart';
import 'login_page.dart';
import 'siswa_page.dart';
import 'surat_masuk_page.dart';

class SuratKeluarPage extends StatefulWidget {
  const SuratKeluarPage({super.key});

  @override
  State<SuratKeluarPage> createState() =>
      _SuratKeluarPageState();
}

class _SuratKeluarPageState
    extends State<SuratKeluarPage> {
  // ============================================================
  // COLORS
  // ============================================================

  static const Color navy =
      Color(0xFF193F68);

  static const Color blue =
      Color(0xFF2F83BA);

  static const Color background =
      Color(0xFFF1F5F9);

  static const Color textDark =
      Color(0xFF26364A);

  static const Color textGrey =
      Color(0xFF718096);

  static const Color green =
      Color(0xFF38D39F);

  static const Color red =
      Color(0xFFE85D75);

  static const Color orange =
      Color(0xFFF4A340);

  // ============================================================
  // DATA SURAT KELUAR
  // ============================================================

  final List<Map<String, String>> _suratKeluar = [
    {
      'nomor': '001/SK/IX/2026',
      'tanggal': '2026-09-02',
      'tujuan': 'Dinas Pendidikan',
      'perihal': 'Undangan Rapat Koordinasi',
      'status': 'Sudah Dikirim',
      'file': 'surat_keluar_001.pdf',
    },
    {
      'nomor': '002/SK/IX/2026',
      'tanggal': '2026-09-07',
      'tujuan': 'Kecamatan',
      'perihal': 'Pemberitahuan Kegiatan Sekolah',
      'status': 'Sudah Dikirim',
      'file': 'surat_keluar_002.pdf',
    },
    {
      'nomor': '003/SK/IX/2026',
      'tanggal': '2026-09-12',
      'tujuan': 'Komite Sekolah',
      'perihal': 'Permohonan Dukungan Kegiatan',
      'status': 'Belum Dikirim',
      'file': 'surat_keluar_003.pdf',
    },
  ];

  // ============================================================
  // SEARCH
  // ============================================================

  final TextEditingController _searchController =
      TextEditingController();

  String _searchText = '';

  // ============================================================
  // FORM CONTROLLER
  // ============================================================

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

  String _statusController =
      'Belum Dikirim';

  int? _editingIndex;

  // ============================================================
  // DISPOSE
  // ============================================================

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
            final bool desktop =
                constraints.maxWidth >= 900;

            if (desktop) {
              return Row(
                children: [
                  _sidebar(context),
                  Expanded(
                    child: _mainContent(),
                  ),
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
  // SAMA DENGAN SURAT MASUK
  // ============================================================

  Widget _sidebar(BuildContext context) {
    return Container(
      width: 260,
      color: Colors.white,
      child: Column(
        children: [
          const SizedBox(height: 22),

          // ======================================================
          // LOGO
          // ======================================================

          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: navy,
              borderRadius:
                  BorderRadius.circular(14),
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
            textAlign: TextAlign.center,
            style: TextStyle(
              color: navy,
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 22),

          // ======================================================
          // MENU
          // ======================================================

          Expanded(
            child: SingleChildScrollView(
              padding:
                  const EdgeInsets.symmetric(
                horizontal: 12,
              ),
              child: Column(
                children: [
                  // DASHBOARD
                  _menuItem(
                    context,
                    Icons.dashboard_outlined,
                    'Dashboard',
                    false,
                    () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              const DashboardPage(),
                        ),
                      );
                    },
                  ),

                  // DATA SISWA
                  _menuItem(
                    context,
                    Icons.people_outline,
                    'Data Siswa',
                    false,
                    () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              const SiswaPage(),
                        ),
                      );
                    },
                  ),

                  // DATA GURU
                  _menuItem(
                    context,
                    Icons.badge_outlined,
                    'Data Guru',
                    false,
                    () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              const GuruPage(),
                        ),
                      );
                    },
                  ),

                  // SURAT MASUK
                  _menuItem(
                    context,
                    Icons.mail_outline,
                    'Surat Masuk',
                    false,
                    () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              const SuratMasukPage(),
                        ),
                      );
                    },
                  ),

                  // SURAT KELUAR
                  _menuItem(
                    context,
                    Icons.send_outlined,
                    'Surat Keluar',
                    true,
                    () {},
                  ),

                  // LAPORAN
                  _menuItem(
                    context,
                    Icons.bar_chart,
                    'Laporan',
                    false,
                    () {
                      _comingSoon(context);
                    },
                  ),
                ],
              ),
            ),
          ),

          // ======================================================
          // KELUAR
          // ======================================================

          Padding(
            padding:
                const EdgeInsets.fromLTRB(
              12,
              0,
              12,
              20,
            ),
            child:
                _logoutMenuItem(context),
          ),
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
        borderRadius:
            BorderRadius.circular(10),
        child: Container(
          width: double.infinity,
          height: 52,
          margin:
              const EdgeInsets.only(
            bottom: 8,
          ),
          decoration: BoxDecoration(
            color: active
                ? navy
                : Colors.transparent,
            borderRadius:
                BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              const SizedBox(width: 18),

              Icon(
                icon,
                size: 23,
                color: active
                    ? Colors.white
                    : const Color(
                        0xFF50627A,
                      ),
              ),

              const SizedBox(width: 15),

              Text(
                title,
                style: TextStyle(
                  color: active
                      ? Colors.white
                      : navy,
                  fontSize: 15,
                  fontWeight: active
                      ? FontWeight.bold
                      : FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ============================================================
  // LOGOUT
  // ============================================================

  Widget _logoutMenuItem(
    BuildContext context,
  ) {
    const Color logoutRed =
        Color(0xFFE52323);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (_) =>
                  const LoginPage(),
            ),
            (route) => false,
          );
        },
        borderRadius:
            BorderRadius.circular(10),
        child: Container(
          width: double.infinity,
          height: 52,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius:
                BorderRadius.circular(10),
            border: Border.all(
              color:
                  const Color(0xFFFFCACA),
            ),
          ),
          child: const Row(
            children: [
              SizedBox(width: 18),

              Icon(
                Icons.logout,
                size: 23,
                color: logoutRed,
              ),

              SizedBox(width: 15),

              Text(
                'Keluar',
                style: TextStyle(
                  color: logoutRed,
                  fontSize: 15,
                  fontWeight:
                      FontWeight.w500,
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

  Widget _mobileDrawer(
    BuildContext context,
  ) {
    return Drawer(
      width: 260,
      backgroundColor: Colors.white,
      child: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 22),

            // LOGO
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: navy,
                borderRadius:
                    BorderRadius.circular(14),
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
              textAlign: TextAlign.center,
              style: TextStyle(
                color: navy,
                fontSize: 15,
                fontWeight:
                    FontWeight.bold,
              ),
            ),

            const SizedBox(height: 22),

            Expanded(
              child:
                  SingleChildScrollView(
                padding:
                    const EdgeInsets
                        .symmetric(
                  horizontal: 12,
                ),
                child: Column(
                  children: [
                    _menuItem(
                      context,
                      Icons
                          .dashboard_outlined,
                      'Dashboard',
                      false,
                      () {
                        Navigator.pop(
                            context);

                        Navigator
                            .pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                const DashboardPage(),
                          ),
                        );
                      },
                    ),

                    _menuItem(
                      context,
                      Icons
                          .people_outline,
                      'Data Siswa',
                      false,
                      () {
                        Navigator.pop(
                            context);

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                const SiswaPage(),
                          ),
                        );
                      },
                    ),

                    _menuItem(
                      context,
                      Icons.badge_outlined,
                      'Data Guru',
                      false,
                      () {
                        Navigator.pop(
                            context);

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                const GuruPage(),
                          ),
                        );
                      },
                    ),

                    _menuItem(
                      context,
                      Icons.mail_outline,
                      'Surat Masuk',
                      false,
                      () {
                        Navigator.pop(
                            context);

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                const SuratMasukPage(),
                          ),
                        );
                      },
                    ),

                    _menuItem(
                      context,
                      Icons.send_outlined,
                      'Surat Keluar',
                      true,
                      () {
                        Navigator.pop(
                            context);
                      },
                    ),

                    _menuItem(
                      context,
                      Icons.bar_chart,
                      'Laporan',
                      false,
                      () {
                        Navigator.pop(
                            context);
                        _comingSoon(
                            context);
                      },
                    ),
                  ],
                ),
              ),
            ),

            Padding(
              padding:
                  const EdgeInsets
                      .fromLTRB(
                12,
                0,
                12,
                20,
              ),
              child:
                  _logoutMenuItem(
                context,
              ),
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
          child:
              SingleChildScrollView(
            padding:
                const EdgeInsets.fromLTRB(
              24,
              20,
              24,
              90,
            ),
            child: _content(),
          ),
        ),
      ],
    );
  }

  // ============================================================
  // HEADER
  // ============================================================

  Widget _header() {
    return Container(
      height: 76,
      padding:
          const EdgeInsets.symmetric(
        horizontal: 22,
      ),
      color: navy,
      child: Row(
        children: [
          Builder(
            builder: (context) {
              return IconButton(
                onPressed: () {
                  Scaffold.of(context)
                      .openDrawer();
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
                fontWeight:
                    FontWeight.bold,
              ),
            ),
          ),

          Container(
            width: 42,
            height: 42,
            decoration:
                const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.person,
              color: navy,
              size: 23,
            ),
          ),

          const SizedBox(width: 10),

          const Column(
            mainAxisAlignment:
                MainAxisAlignment.center,
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              Text(
                'Admin TU',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight:
                      FontWeight.bold,
                ),
              ),
              SizedBox(height: 2),
              Row(
                children: [
                  Icon(
                    Icons.circle,
                    size: 7,
                    color: green,
                  ),
                  SizedBox(width: 5),
                  Text(
                    'Online',
                    style: TextStyle(
                      color:
                          Colors.white70,
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
    final filtered =
        _filteredSurat();

    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        _pageTitle(),

        const SizedBox(height: 18),

        _statistics(),

        const SizedBox(height: 20),

        _searchAndAdd(),

        const SizedBox(height: 18),

        LayoutBuilder(
          builder:
              (context, constraints) {
            if (constraints.maxWidth <
                700) {
              return _mobileList(
                filtered,
              );
            }

            return _desktopTable(
              filtered,
            );
          },
        ),
      ],
    );
  }

  // ============================================================
  // PAGE TITLE
  // ============================================================

  Widget _pageTitle() {
    return Row(
      crossAxisAlignment:
          CrossAxisAlignment.center,
      children: [
        Container(
          width: 45,
          height: 45,
          decoration: BoxDecoration(
            color:
                const Color(0xFFEAF3FF),
            borderRadius:
                BorderRadius.circular(12),
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
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              Text(
                'Data Surat Keluar',
                style: TextStyle(
                  color: textDark,
                  fontSize: 22,
                  fontWeight:
                      FontWeight.bold,
                ),
              ),
              SizedBox(height: 3),
              Text(
                'Kelola dan arsipkan surat yang dikirim sekolah.',
                style: TextStyle(
                  color: textGrey,
                  fontSize: 13,
                ),
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
    final total =
        _suratKeluar.length;

    final belumDikirim =
        _suratKeluar
            .where(
              (item) =>
                  item['status'] ==
                  'Belum Dikirim',
            )
            .length;

    final sudahDikirim =
        _suratKeluar
            .where(
              (item) =>
                  item['status'] ==
                  'Sudah Dikirim',
            )
            .length;

    return LayoutBuilder(
      builder:
          (context, constraints) {
        if (constraints.maxWidth <
            650) {
          return GridView.count(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.7,
            shrinkWrap: true,
            physics:
                const NeverScrollableScrollPhysics(),
            children: [
              _statCard(
                'Total Surat',
                total.toString(),
                Icons.send_outlined,
                blue,
              ),
              _statCard(
                'Belum Dikirim',
                belumDikirim.toString(),
                Icons.pending_actions_outlined,
                orange,
              ),
              _statCard(
                'Sudah Dikirim',
                sudahDikirim.toString(),
                Icons.mark_email_read_outlined,
                green,
              ),
              _statCard(
                'Arsip',
                total.toString(),
                Icons.archive_outlined,
                navy,
              ),
            ],
          );
        }

        return Row(
          children: [
            Expanded(
              child: _statCard(
                'Total Surat',
                total.toString(),
                Icons.send_outlined,
                blue,
              ),
            ),

            const SizedBox(width: 15),

            Expanded(
              child: _statCard(
                'Belum Dikirim',
                belumDikirim.toString(),
                Icons.pending_actions_outlined,
                orange,
              ),
            ),

            const SizedBox(width: 15),

            Expanded(
              child: _statCard(
                'Sudah Dikirim',
                sudahDikirim.toString(),
                Icons.mark_email_read_outlined,
                green,
              ),
            ),

            const SizedBox(width: 15),

            Expanded(
              child: _statCard(
                'Arsip',
                total.toString(),
                Icons.archive_outlined,
                navy,
              ),
            ),
          ],
        );
      },
    );
  }

  // ============================================================
  // STAT CARD
  // ============================================================

  Widget _statCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding:
          const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(12),
        border: Border.all(
          color:
              const Color(0xFFE5EAF0),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color:
                  color.withOpacity(0.10),
              borderRadius:
                  BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              color: color,
              size: 22,
            ),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              mainAxisAlignment:
                  MainAxisAlignment.center,
              children: [
                Text(
                  value,
                  style: TextStyle(
                    color: color,
                    fontSize: 21,
                    fontWeight:
                        FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 2),

                Text(
                  title,
                  maxLines: 1,
                  overflow:
                      TextOverflow.ellipsis,
                  style:
                      const TextStyle(
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
  // SEARCH + ADD
  // ============================================================

  Widget _searchAndAdd() {
    return Container(
      padding:
          const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(12),
        border: Border.all(
          color:
              const Color(0xFFE5EAF0),
        ),
      ),
      child: LayoutBuilder(
        builder:
            (context, constraints) {
          if (constraints.maxWidth <
              600) {
            return Column(
              children: [
                _searchBox(),

                const SizedBox(
                  height: 12,
                ),

                SizedBox(
                  width: double.infinity,
                  child: _addButton(),
                ),
              ],
            );
          }

          return Row(
            children: [
              Expanded(
                child: _searchBox(),
              ),

              const SizedBox(
                width: 12,
              ),

              _addButton(),
            ],
          );
        },
      ),
    );
  }

  // ============================================================
  // SEARCH BOX
  // ============================================================

  Widget _searchBox() {
    return TextField(
      controller:
          _searchController,
      onChanged: (value) {
        setState(() {
          _searchText =
              value.toLowerCase();
        });
      },
      decoration:
          InputDecoration(
        hintText:
            'Cari nomor, tujuan surat, atau perihal...',
        hintStyle:
            const TextStyle(
          color: textGrey,
          fontSize: 13,
        ),
        prefixIcon:
            const Icon(
          Icons.search,
          color: textGrey,
          size: 21,
        ),
        suffixIcon:
            _searchText.isNotEmpty
                ? IconButton(
                    onPressed: () {
                      _searchController
                          .clear();

                      setState(() {
                        _searchText =
                            '';
                      });
                    },
                    icon:
                        const Icon(
                      Icons.close,
                      size: 19,
                    ),
                  )
                : null,
        filled: true,
        fillColor:
            const Color(0xFFF8FAFC),
        border:
            OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(
                  10),
          borderSide:
              const BorderSide(
            color:
                Color(0xFFE2E8F0),
          ),
        ),
        enabledBorder:
            OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(
                  10),
          borderSide:
              const BorderSide(
            color:
                Color(0xFFE2E8F0),
          ),
        ),
        focusedBorder:
            OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(
                  10),
          borderSide:
              const BorderSide(
            color: blue,
            width: 1.5,
          ),
        ),
        contentPadding:
            const EdgeInsets
                .symmetric(
          horizontal: 14,
          vertical: 13,
        ),
      ),
    );
  }

  // ============================================================
  // ADD BUTTON
  // ============================================================

  Widget _addButton() {
    return ElevatedButton.icon(
      onPressed: () {
        _openFormDialog();
      },
      icon: const Icon(
        Icons.add,
        size: 20,
      ),
      label: const Text(
        'Tambah Surat',
        style: TextStyle(
          fontSize: 13,
          fontWeight:
              FontWeight.bold,
        ),
      ),
      style:
          ElevatedButton.styleFrom(
        backgroundColor: navy,
        foregroundColor:
            Colors.white,
        elevation: 0,
        padding:
            const EdgeInsets
                .symmetric(
          horizontal: 18,
          vertical: 14,
        ),
        shape:
            RoundedRectangleBorder(
          borderRadius:
              BorderRadius.circular(
                  10),
        ),
      ),
    );
  }

  // ============================================================
  // FILTER
  // ============================================================

  List<Map<String, String>>
      _filteredSurat() {
    if (_searchText.isEmpty) {
      return List<
          Map<String, String>>.from(
        _suratKeluar,
      );
    }

    return _suratKeluar
        .where(
          (item) {
            final nomor =
                item['nomor']!
                    .toLowerCase();

            final tujuan =
                item['tujuan']!
                    .toLowerCase();

            final perihal =
                item['perihal']!
                    .toLowerCase();

            return nomor.contains(
                  _searchText,
                ) ||
                tujuan.contains(
                  _searchText,
                ) ||
                perihal.contains(
                  _searchText,
                );
          },
        )
        .toList();
  }

  // ============================================================
  // DESKTOP TABLE
  // ============================================================

  Widget _desktopTable(
    List<Map<String, String>> data,
  ) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(12),
        border: Border.all(
          color:
              const Color(0xFFE5EAF0),
        ),
      ),
      child: ClipRRect(
        borderRadius:
            BorderRadius.circular(12),
        child: data.isEmpty
            ? _emptyState()
            : SingleChildScrollView(
                scrollDirection:
                    Axis.horizontal,
                child: DataTable(
                  columnSpacing: 25,
                  headingRowHeight: 48,
                  dataRowMinHeight: 65,
                  dataRowMaxHeight: 75,
                  headingRowColor:
                      MaterialStateProperty.all(
                    const Color(
                      0xFFF8FAFC,
                    ),
                  ),
                  columns: const [
                    DataColumn(
                      label: Text(
                        'No',
                        style:
                            TextStyle(
                          fontWeight:
                              FontWeight
                                  .bold,
                          color:
                              textDark,
                        ),
                      ),
                    ),

                    DataColumn(
                      label: Text(
                        'Nomor Surat',
                        style:
                            TextStyle(
                          fontWeight:
                              FontWeight
                                  .bold,
                          color:
                              textDark,
                        ),
                      ),
                    ),

                    DataColumn(
                      label: Text(
                        'Tanggal',
                        style:
                            TextStyle(
                          fontWeight:
                              FontWeight
                                  .bold,
                          color:
                              textDark,
                        ),
                      ),
                    ),

                    DataColumn(
                      label: Text(
                        'Tujuan',
                        style:
                            TextStyle(
                          fontWeight:
                              FontWeight
                                  .bold,
                          color:
                              textDark,
                        ),
                      ),
                    ),

                    DataColumn(
                      label: Text(
                        'Perihal',
                        style:
                            TextStyle(
                          fontWeight:
                              FontWeight
                                  .bold,
                          color:
                              textDark,
                        ),
                      ),
                    ),

                    DataColumn(
                      label: Text(
                        'Status',
                        style:
                            TextStyle(
                          fontWeight:
                              FontWeight
                                  .bold,
                          color:
                              textDark,
                        ),
                      ),
                    ),

                    DataColumn(
                      label: Text(
                        'Aksi',
                        style:
                            TextStyle(
                          fontWeight:
                              FontWeight
                                  .bold,
                          color:
                              textDark,
                        ),
                      ),
                    ),
                  ],
                  rows:
                      List.generate(
                    data.length,
                    (index) {
                      final item =
                          data[index];

                      final originalIndex =
                          _suratKeluar
                              .indexOf(
                        item,
                      );

                      return DataRow(
                        cells: [
                          DataCell(
                            Text(
                              '${index + 1}',
                              style:
                                  const TextStyle(
                                color:
                                    textGrey,
                                fontSize:
                                    13,
                              ),
                            ),
                          ),

                          DataCell(
                            Text(
                              item[
                                  'nomor']!,
                              style:
                                  const TextStyle(
                                color:
                                    navy,
                                fontSize:
                                    13,
                                fontWeight:
                                    FontWeight
                                        .bold,
                              ),
                            ),
                          ),

                          DataCell(
                            Text(
                              _formatDate(
                                item[
                                    'tanggal']!,
                              ),
                              style:
                                  const TextStyle(
                                color:
                                    textDark,
                                fontSize:
                                    13,
                              ),
                            ),
                          ),

                          DataCell(
                            SizedBox(
                              width: 150,
                              child:
                                  Text(
                                item[
                                    'tujuan']!,
                                maxLines:
                                    2,
                                overflow:
                                    TextOverflow
                                        .ellipsis,
                                style:
                                    const TextStyle(
                                  color:
                                      textDark,
                                  fontSize:
                                      13,
                                ),
                              ),
                            ),
                          ),

                          DataCell(
                            SizedBox(
                              width: 200,
                              child:
                                  Text(
                                item[
                                    'perihal']!,
                                maxLines:
                                    2,
                                overflow:
                                    TextOverflow
                                        .ellipsis,
                                style:
                                    const TextStyle(
                                  color:
                                      textDark,
                                  fontSize:
                                      13,
                                ),
                              ),
                            ),
                          ),

                          DataCell(
                            _statusBox(
                              item[
                                  'status']!,
                            ),
                          ),

                          DataCell(
                            _actionButtons(
                              originalIndex,
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
      ),
    );
  }

  // ============================================================
  // MOBILE LIST
  // ============================================================

  Widget _mobileList(
    List<Map<String, String>> data,
  ) {
    if (data.isEmpty) {
      return _emptyState();
    }

    return Column(
      children:
          List.generate(
        data.length,
        (index) {
          final item =
              data[index];

          final originalIndex =
              _suratKeluar.indexOf(
            item,
          );

          return _mobileCard(
            item,
            originalIndex,
          );
        },
      ),
    );
  }

  // ============================================================
  // MOBILE CARD
  // ============================================================

  Widget _mobileCard(
    Map<String, String> item,
    int originalIndex,
  ) {
    return Container(
      width: double.infinity,
      margin:
          const EdgeInsets.only(
        bottom: 12,
      ),
      padding:
          const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(12),
        border: Border.all(
          color:
              const Color(0xFFE5EAF0),
        ),
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration:
                    BoxDecoration(
                  color:
                      const Color(
                    0xFFEAF3FF,
                  ),
                  borderRadius:
                      BorderRadius
                          .circular(10),
                ),
                child:
                    const Icon(
                  Icons.send_outlined,
                  color: blue,
                  size: 22,
                ),
              ),

              const SizedBox(
                width: 11,
              ),

              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment
                          .start,
                  children: [
                    Text(
                      item[
                          'nomor']!,
                      style:
                          const TextStyle(
                        color: navy,
                        fontSize: 14,
                        fontWeight:
                            FontWeight
                                .bold,
                      ),
                    ),

                    const SizedBox(
                      height: 3,
                    ),

                    Text(
                      _formatDate(
                        item[
                            'tanggal']!,
                      ),
                      style:
                          const TextStyle(
                        color:
                            textGrey,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),

              _statusBox(
                item['status']!,
              ),
            ],
          ),

          const SizedBox(
            height: 15,
          ),

          _mobileInfo(
            Icons.business_outlined,
            'Tujuan',
            item['tujuan']!,
          ),

          const SizedBox(
            height: 9,
          ),

          _mobileInfo(
            Icons.subject,
            'Perihal',
            item['perihal']!,
          ),

          const SizedBox(
            height: 13,
          ),

          if (item['file']!
              .isNotEmpty)
            Row(
              children: [
                const Icon(
                  Icons.attach_file,
                  size: 17,
                  color: textGrey,
                ),

                const SizedBox(
                  width: 5,
                ),

                Expanded(
                  child: Text(
                    item['file']!,
                    style:
                        const TextStyle(
                      color: blue,
                      fontSize: 12,
                    ),
                    overflow:
                        TextOverflow
                            .ellipsis,
                  ),
                ),
              ],
            ),

          const SizedBox(
            height: 14,
          ),

          Row(
            children: [
              Expanded(
                child:
                    OutlinedButton.icon(
                  onPressed: () {
                    _showDetail(
                      item,
                    );
                  },
                  icon:
                      const Icon(
                    Icons
                        .visibility_outlined,
                    size: 17,
                  ),
                  label:
                      const Text(
                    'Detail',
                    style:
                        TextStyle(
                      fontSize: 12,
                    ),
                  ),
                  style:
                      OutlinedButton
                          .styleFrom(
                    foregroundColor:
                        navy,
                    side:
                        const BorderSide(
                      color:
                          Color(
                        0xFFD6DEE8,
                      ),
                    ),
                    padding:
                        const EdgeInsets
                            .symmetric(
                      vertical: 11,
                    ),
                    shape:
                        RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius
                              .circular(
                        8,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(
                width: 8,
              ),

              Expanded(
                child:
                    OutlinedButton.icon(
                  onPressed: () {
                    _openFormDialog(
                      index:
                          originalIndex,
                    );
                  },
                  icon:
                      const Icon(
                    Icons
                        .edit_outlined,
                    size: 17,
                  ),
                  label:
                      const Text(
                    'Edit',
                    style:
                        TextStyle(
                      fontSize: 12,
                    ),
                  ),
                  style:
                      OutlinedButton
                          .styleFrom(
                    foregroundColor:
                        blue,
                    side:
                        const BorderSide(
                      color:
                          Color(
                        0xFFBDD7EC,
                      ),
                    ),
                    padding:
                        const EdgeInsets
                            .symmetric(
                      vertical: 11,
                    ),
                    shape:
                        RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius
                              .circular(
                        8,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(
                width: 8,
              ),

              IconButton(
                onPressed: () {
                  _deleteSurat(
                    originalIndex,
                  );
                },
                style:
                    IconButton
                        .styleFrom(
                  backgroundColor:
                      const Color(
                    0xFFFFF0F2,
                  ),
                  foregroundColor:
                      red,
                ),
                icon:
                    const Icon(
                  Icons
                      .delete_outline,
                  size: 19,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ============================================================
  // MOBILE INFO
  // ============================================================

  Widget _mobileInfo(
    IconData icon,
    String title,
    String value,
  ) {
    return Row(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 17,
          color: textGrey,
        ),

        const SizedBox(
          width: 8,
        ),

        SizedBox(
          width: 65,
          child: Text(
            title,
            style:
                const TextStyle(
              color: textGrey,
              fontSize: 12,
            ),
          ),
        ),

        const Text(
          ':',
          style: TextStyle(
            color: textGrey,
            fontSize: 12,
          ),
        ),

        const SizedBox(
          width: 7,
        ),

        Expanded(
          child: Text(
            value,
            style:
                const TextStyle(
              color: textDark,
              fontSize: 12,
              fontWeight:
                  FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  // ============================================================
  // STATUS
  // ============================================================

  Widget _statusBox(
    String status,
  ) {
    final bool sent =
        status == 'Sudah Dikirim';

    return Container(
      padding:
          const EdgeInsets
              .symmetric(
        horizontal: 9,
        vertical: 6,
      ),
      decoration:
          BoxDecoration(
        color: sent
            ? const Color(
                0xFFE9FBF4,
              )
            : const Color(
                0xFFFFF5E7,
              ),
        borderRadius:
            BorderRadius.circular(
          20,
        ),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: sent
              ? const Color(
                  0xFF159A6B,
                )
              : const Color(
                  0xFFC77A16,
                ),
          fontSize: 10,
          fontWeight:
              FontWeight.bold,
        ),
      ),
    );
  }

  // ============================================================
  // ACTION BUTTON
  // ============================================================

  Widget _actionButtons(
    int index,
  ) {
    return Row(
      mainAxisSize:
          MainAxisSize.min,
      children: [
        IconButton(
          tooltip: 'Detail',
          onPressed: () {
            _showDetail(
              _suratKeluar[index],
            );
          },
          icon:
              const Icon(
            Icons
                .visibility_outlined,
            size: 19,
          ),
          color: navy,
        ),

        IconButton(
          tooltip: 'Edit',
          onPressed: () {
            _openFormDialog(
              index: index,
            );
          },
          icon:
              const Icon(
            Icons
                .edit_outlined,
            size: 19,
          ),
          color: blue,
        ),

        IconButton(
          tooltip: 'Hapus',
          onPressed: () {
            _deleteSurat(
              index,
            );
          },
          icon:
              const Icon(
            Icons
                .delete_outline,
            size: 19,
          ),
          color: red,
        ),
      ],
    );
  }

  // ============================================================
  // EMPTY STATE
  // ============================================================

  Widget _emptyState() {
    return Container(
      width: double.infinity,
      padding:
          const EdgeInsets
              .symmetric(
        vertical: 55,
        horizontal: 20,
      ),
      child: Column(
        children: [
          Container(
            width: 65,
            height: 65,
            decoration:
                BoxDecoration(
              color:
                  const Color(
                0xFFF1F5F9,
              ),
              borderRadius:
                  BorderRadius.circular(
                18,
              ),
            ),
            child:
                const Icon(
              Icons.send_outlined,
              size: 31,
              color: textGrey,
            ),
          ),

          const SizedBox(
            height: 14,
          ),

          const Text(
            'Data surat tidak ditemukan',
            style:
                TextStyle(
              color: textDark,
              fontSize: 15,
              fontWeight:
                  FontWeight.bold,
            ),
          ),

          const SizedBox(
            height: 5,
          ),

          const Text(
            'Coba gunakan kata pencarian yang berbeda.',
            style:
                TextStyle(
              color: textGrey,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // FORM DIALOG
  // ============================================================

  void _openFormDialog({
    int? index,
  }) {
    _editingIndex = index;

    if (index != null) {
      final item =
          _suratKeluar[index];

      _nomorController.text =
          item['nomor'] ?? '';

      _tanggalController.text =
          item['tanggal'] ?? '';

      _tujuanController.text =
          item['tujuan'] ?? '';

      _perihalController.text =
          item['perihal'] ?? '';

      _fileController.text =
          item['file'] ?? '';

      _statusController =
          item['status'] ??
              'Belum Dikirim';
    } else {
      _clearForm();
    }

    showDialog(
      context: context,
      builder:
          (dialogContext) {
        return StatefulBuilder(
          builder:
              (
            context,
            setDialogState,
          ) {
            return AlertDialog(
              backgroundColor:
                  Colors.white,
              shape:
                  RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(
                  15,
                ),
              ),
              title: Row(
                children: [
                  Container(
                    width: 38,
                    height: 38,
                    decoration:
                        BoxDecoration(
                      color:
                          const Color(
                        0xFFEAF3FF,
                      ),
                      borderRadius:
                          BorderRadius
                              .circular(
                        9,
                      ),
                    ),
                    child:
                        const Icon(
                      Icons
                          .send_outlined,
                      color: blue,
                      size: 21,
                    ),
                  ),

                  const SizedBox(
                    width: 10,
                  ),

                  Expanded(
                    child: Text(
                      index == null
                          ? 'Tambah Surat Keluar'
                          : 'Edit Surat Keluar',
                      style:
                          const TextStyle(
                        color:
                            textDark,
                        fontSize: 18,
                        fontWeight:
                            FontWeight
                                .bold,
                      ),
                    ),
                  ),
                ],
              ),

              content: SizedBox(
                width: 600,
                child:
                    SingleChildScrollView(
                  child:
                      _formContent(
                    setDialogState,
                  ),
                ),
              ),

              actionsPadding:
                  const EdgeInsets
                      .fromLTRB(
                24,
                0,
                24,
                20,
              ),

              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(
                      dialogContext,
                    );
                  },
                  child:
                      const Text(
                    'Batal',
                    style:
                        TextStyle(
                      color:
                          textGrey,
                    ),
                  ),
                ),

                ElevatedButton(
                  onPressed: () {
                    _saveSurat(
                      dialogContext,
                    );
                  },
                  style:
                      ElevatedButton
                          .styleFrom(
                    backgroundColor:
                        navy,
                    foregroundColor:
                        Colors.white,
                    elevation: 0,
                    padding:
                        const EdgeInsets
                            .symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                    shape:
                        RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius
                              .circular(
                        9,
                      ),
                    ),
                  ),
                  child: Text(
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

  // ============================================================
  // FORM CONTENT
  // ============================================================

  Widget _formContent(
    StateSetter setDialogState,
  ) {
    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        _fieldLabel(
          'Nomor Surat',
        ),

        _textField(
          controller:
              _nomorController,
          hint:
              'Masukkan nomor surat',
          icon: Icons.numbers,
        ),

        const SizedBox(
          height: 15,
        ),

        _fieldLabel(
          'Tanggal Surat',
        ),

        _textField(
          controller:
              _tanggalController,
          hint: 'YYYY-MM-DD',
          icon:
              Icons.calendar_today_outlined,
        ),

        const SizedBox(
          height: 15,
        ),

        _fieldLabel(
          'Tujuan Surat',
        ),

        _textField(
          controller:
              _tujuanController,
          hint:
              'Masukkan instansi / nama tujuan',
          icon:
              Icons.business_outlined,
        ),

        const SizedBox(
          height: 15,
        ),

        _fieldLabel(
          'Perihal / Isi Ringkas',
        ),

        _textField(
          controller:
              _perihalController,
          hint:
              'Masukkan perihal surat keluar',
          icon: Icons.subject,
          maxLines: 3,
        ),

        const SizedBox(
          height: 15,
        ),

        _fieldLabel(
          'Status',
        ),

        DropdownButtonFormField<
            String>(
          value:
              _statusController,
          decoration:
              InputDecoration(
            prefixIcon:
                const Icon(
              Icons.flag_outlined,
              size: 20,
              color: textGrey,
            ),
            filled: true,
            fillColor:
                const Color(
              0xFFF8FAFC,
            ),
            border:
                OutlineInputBorder(
              borderRadius:
                  BorderRadius.circular(
                9,
              ),
              borderSide:
                  const BorderSide(
                color:
                    Color(
                  0xFFE2E8F0,
                ),
              ),
            ),
            enabledBorder:
                OutlineInputBorder(
              borderRadius:
                  BorderRadius.circular(
                9,
              ),
              borderSide:
                  const BorderSide(
                color:
                    Color(
                  0xFFE2E8F0,
                ),
              ),
            ),
          ),
          items: const [
            DropdownMenuItem(
              value:
                  'Belum Dikirim',
              child: Text(
                'Belum Dikirim',
              ),
            ),
            DropdownMenuItem(
              value:
                  'Sudah Dikirim',
              child: Text(
                'Sudah Dikirim',
              ),
            ),
          ],
          onChanged:
              (value) {
            if (value != null) {
              setDialogState(() {
                _statusController =
                    value;
              });
            }
          },
        ),

        const SizedBox(
          height: 15,
        ),

        _fieldLabel(
          'Nama File',
        ),

        TextField(
          controller:
              _fileController,
          decoration:
              InputDecoration(
            hintText:
                'Contoh: surat_keluar.pdf',
            hintStyle:
                const TextStyle(
              color: textGrey,
              fontSize: 13,
            ),
            prefixIcon:
                const Icon(
              Icons.attach_file,
              size: 20,
              color: textGrey,
            ),
            filled: true,
            fillColor:
                const Color(
              0xFFF8FAFC,
            ),
            border:
                OutlineInputBorder(
              borderRadius:
                  BorderRadius.circular(
                9,
              ),
              borderSide:
                  const BorderSide(
                color:
                    Color(
                  0xFFE2E8F0,
                ),
              ),
            ),
            enabledBorder:
                OutlineInputBorder(
              borderRadius:
                  BorderRadius.circular(
                9,
              ),
              borderSide:
                  const BorderSide(
                color:
                    Color(
                  0xFFE2E8F0,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ============================================================
  // FIELD LABEL
  // ============================================================

  Widget _fieldLabel(
    String label,
  ) {
    return Padding(
      padding:
          const EdgeInsets.only(
        bottom: 7,
      ),
      child: Text(
        label,
        style:
            const TextStyle(
          color: textDark,
          fontSize: 13,
          fontWeight:
              FontWeight.w600,
        ),
      ),
    );
  }

  // ============================================================
  // TEXT FIELD
  // ============================================================

  Widget _textField({
    required
        TextEditingController
            controller,
    required String hint,
    required IconData icon,
    int maxLines = 1,
  }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      decoration:
          InputDecoration(
        hintText: hint,
        hintStyle:
            const TextStyle(
          color: textGrey,
          fontSize: 13,
        ),
        prefixIcon:
            maxLines == 1
                ? Icon(
                    icon,
                    size: 20,
                    color: textGrey,
                  )
                : null,
        filled: true,
        fillColor:
            const Color(
          0xFFF8FAFC,
        ),
        border:
            OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(
            9,
          ),
          borderSide:
              const BorderSide(
            color:
                Color(0xFFE2E8F0),
          ),
        ),
        enabledBorder:
            OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(
            9,
          ),
          borderSide:
              const BorderSide(
            color:
                Color(0xFFE2E8F0),
          ),
        ),
        focusedBorder:
            OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(
            9,
          ),
          borderSide:
              const BorderSide(
            color: blue,
            width: 1.5,
          ),
        ),
        contentPadding:
            const EdgeInsets
                .symmetric(
          horizontal: 13,
          vertical: 13,
        ),
      ),
    );
  }

  // ============================================================
  // SAVE
  // ============================================================

  void _saveSurat(
    BuildContext dialogContext,
  ) {
    if (_nomorController.text
            .trim()
            .isEmpty ||
        _tanggalController.text
            .trim()
            .isEmpty ||
        _tujuanController.text
            .trim()
            .isEmpty ||
        _perihalController.text
            .trim()
            .isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(
        const SnackBar(
          content: Text(
            'Mohon lengkapi semua data surat.',
          ),
        ),
      );

      return;
    }

    final bool isEdit =
        _editingIndex != null;

    final data =
        <String, String>{
      'nomor':
          _nomorController.text
              .trim(),
      'tanggal':
          _tanggalController.text
              .trim(),
      'tujuan':
          _tujuanController.text
              .trim(),
      'perihal':
          _perihalController.text
              .trim(),
      'status':
          _statusController,
      'file':
          _fileController.text
              .trim(),
    };

    setState(() {
      if (_editingIndex ==
          null) {
        _suratKeluar.add(
          data,
        );
      } else {
        _suratKeluar[
            _editingIndex!] = data;
      }
    });

    Navigator.pop(
      dialogContext,
    );

    _clearForm();

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(
      SnackBar(
        content: Text(
          isEdit
              ? 'Surat keluar berhasil diperbarui.'
              : 'Surat keluar berhasil ditambahkan.',
        ),
      ),
    );
  }

  // ============================================================
  // CLEAR FORM
  // ============================================================

  void _clearForm() {
    _nomorController.clear();
    _tanggalController.clear();
    _tujuanController.clear();
    _perihalController.clear();
    _fileController.clear();

    _statusController =
        'Belum Dikirim';

    _editingIndex = null;
  }

  // ============================================================
  // DETAIL
  // ============================================================

  void _showDetail(
    Map<String, String> item,
  ) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor:
              Colors.white,
          shape:
              RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(
              15,
            ),
          ),
          title:
              const Text(
            'Detail Surat Keluar',
            style:
                TextStyle(
              color: textDark,
              fontSize: 18,
              fontWeight:
                  FontWeight.bold,
            ),
          ),
          content: SizedBox(
            width: 550,
            child:
                SingleChildScrollView(
              child: Column(
                children: [
                  _detailRow(
                    'Nomor Surat',
                    item['nomor']!,
                  ),

                  _detailRow(
                    'Tanggal',
                    _formatDate(
                      item[
                          'tanggal']!,
                    ),
                  ),

                  _detailRow(
                    'Tujuan Surat',
                    item['tujuan']!,
                  ),

                  _detailRow(
                    'Perihal',
                    item['perihal']!,
                  ),

                  _detailRow(
                    'Status',
                    item['status']!,
                  ),

                  _detailRow(
                    'File',
                    item['file']!
                            .isEmpty
                        ? '-'
                        : item['file']!,
                  ),
                ],
              ),
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(
                  context,
                );
              },
              style:
                  ElevatedButton
                      .styleFrom(
                backgroundColor:
                    navy,
                foregroundColor:
                    Colors.white,
                elevation: 0,
              ),
              child:
                  const Text(
                'Tutup',
              ),
            ),
          ],
        );
      },
    );
  }

  // ============================================================
  // DETAIL ROW
  // ============================================================

  Widget _detailRow(
    String label,
    String value,
  ) {
    return Container(
      width: double.infinity,
      padding:
          const EdgeInsets
              .symmetric(
        vertical: 12,
      ),
      decoration:
          const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color:
                Color(0xFFE5EAF0),
          ),
        ),
      ),
      child: Row(
        crossAxisAlignment:
            CrossAxisAlignment
                .start,
        children: [
          SizedBox(
            width: 125,
            child: Text(
              label,
              style:
                  const TextStyle(
                color: textGrey,
                fontSize: 13,
              ),
            ),
          ),

          const Text(
            ':',
            style:
                TextStyle(
              color: textGrey,
            ),
          ),

          const SizedBox(
            width: 12,
          ),

          Expanded(
            child: Text(
              value,
              style:
                  const TextStyle(
                color: textDark,
                fontSize: 13,
                fontWeight:
                    FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // DELETE
  // ============================================================

  void _deleteSurat(
    int index,
  ) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(
              14,
            ),
          ),
          title:
              const Text(
            'Hapus Surat?',
            style:
                TextStyle(
              color: textDark,
              fontWeight:
                  FontWeight.bold,
            ),
          ),
          content:
              const Text(
            'Data surat keluar ini akan dihapus dari daftar.',
            style:
                TextStyle(
              color: textGrey,
              fontSize: 13,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(
                  context,
                );
              },
              child:
                  const Text(
                'Batal',
                style:
                    TextStyle(
                  color: textGrey,
                ),
              ),
            ),

            ElevatedButton(
              onPressed: () {
                setState(() {
                  _suratKeluar
                      .removeAt(
                    index,
                  );
                });

                Navigator.pop(
                  context,
                );

                ScaffoldMessenger
                    .of(
                  context,
                ).showSnackBar(
                  const SnackBar(
                    content:
                        Text(
                      'Surat keluar berhasil dihapus.',
                    ),
                  ),
                );
              },
              style:
                  ElevatedButton
                      .styleFrom(
                backgroundColor:
                    red,
                foregroundColor:
                    Colors.white,
                elevation: 0,
              ),
              child:
                  const Text(
                'Hapus',
              ),
            ),
          ],
        );
      },
    );
  }

  // ============================================================
  // FORMAT DATE
  // ============================================================

  String _formatDate(
    String date,
  ) {
    final parts =
        date.split('-');

    if (parts.length != 3) {
      return date;
    }

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

    final month =
        int.tryParse(parts[1]);

    if (month == null ||
        month < 1 ||
        month > 12) {
      return date;
    }

    return '${parts[2]} ${months[month - 1]} ${parts[0]}';
  }

  // ============================================================
  // COMING SOON
  // ============================================================

  void _comingSoon(
    BuildContext context,
  ) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(
      const SnackBar(
        content: Text(
          'Fitur laporan sedang dalam pengembangan.',
        ),
      ),
    );
  }
}