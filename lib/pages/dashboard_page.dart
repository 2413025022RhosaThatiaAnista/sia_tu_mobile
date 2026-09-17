import 'package:flutter/material.dart';
import 'login_page.dart';
import 'siswa_page.dart';
import 'guru_page.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  static const Color navy = Color(0xFF193F68);
  static const Color blue = Color(0xFF287EB4);
  static const Color background = Color(0xFFF1F5F9);
  static const Color textDark = Color(0xFF34445B);
  static const Color textGrey = Color(0xFF71839D);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      body: LayoutBuilder(
        builder: (context, constraints) {
          final bool mobile = constraints.maxWidth < 900;

          if (mobile) {
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
        _topHeader(),
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
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      drawer: Drawer(
        child: SafeArea(
          child: Column(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(
                  20,
                  30,
                  20,
                  25,
                ),
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

              // DASHBOARD
              _menuItem(
                context,
                Icons.dashboard,
                'Dashboard',
                true,
                () {
                  Navigator.pop(context);
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
                      builder: (_) => const SiswaPage(),
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
                      builder: (_) => const GuruPage(),
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
                  Navigator.pop(context);

                  _comingSoon(
                    context,
                    'Surat Masuk',
                  );
                },
              ),

              // SURAT KELUAR
              _menuItem(
                context,
                Icons.send_outlined,
                'Surat Keluar',
                false,
                () {
                  Navigator.pop(context);

                  _comingSoon(
                    context,
                    'Surat Keluar',
                  );
                },
              ),

              // LAPORAN
              _menuItem(
                context,
                Icons.bar_chart,
                'Laporan',
                false,
                () {
                  Navigator.pop(context);

                  _comingSoon(
                    context,
                    'Laporan',
                  );
                },
              ),

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

  Widget _topHeader() {
    return Container(
      height: 112,
      color: navy,
      padding: const EdgeInsets.symmetric(
        horizontal: 30,
      ),
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
              mainAxisAlignment:
                  MainAxisAlignment.center,
              crossAxisAlignment:
                  CrossAxisAlignment.start,
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

          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 15,
              vertical: 10,
            ),
            decoration: BoxDecoration(
              color: const Color(0xFF205B8B),
              borderRadius:
                  BorderRadius.circular(18),
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

                const Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Admin TU',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 2),
                    Row(
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
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // SIDEBAR DESKTOP
  // ============================================================

  Widget _sidebar(BuildContext context) {
    return Container(
      width: 340,
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(
        15,
        22,
        15,
        15,
      ),
      child: Column(
        children: [
          // DASHBOARD
          _menuItem(
            context,
            Icons.dashboard,
            'Dashboard',
            true,
            () {},
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
                  builder: (_) => const SiswaPage(),
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
                  builder: (_) => const GuruPage(),
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
              _comingSoon(
                context,
                'Surat Masuk',
              );
            },
          ),

          // SURAT KELUAR
          _menuItem(
            context,
            Icons.send_outlined,
            'Surat Keluar',
            false,
            () {
              _comingSoon(
                context,
                'Surat Keluar',
              );
            },
          ),

          // LAPORAN
          _menuItem(
            context,
            Icons.bar_chart,
            'Laporan',
            false,
            () {
              _comingSoon(
                context,
                'Laporan',
              );
            },
          ),

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
          margin: const EdgeInsets.only(
            bottom: 10,
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
              const SizedBox(width: 23),

              Icon(
                icon,
                size: 25,
                color: active
                    ? Colors.white
                    : const Color(0xFF50627A),
              ),

              const SizedBox(width: 20),

              Text(
                title,
                style: TextStyle(
                  color: active
                      ? Colors.white
                      : navy,
                  fontSize: 18,
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
  // COMING SOON
  // ============================================================

  void _comingSoon(
    BuildContext context,
    String title,
  ) {
    ScaffoldMessenger.of(context)
        .showSnackBar(
      SnackBar(
        content: Text(
          '$title belum dibuat.',
        ),
        behavior:
            SnackBarBehavior.floating,
      ),
    );
  }

  // ============================================================
  // LOGOUT
  // ============================================================

  Widget _logoutMenuItem(
    BuildContext context,
  ) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) =>
                  const LoginPage(),
            ),
          );
        },
        borderRadius:
            BorderRadius.circular(10),
        child: Container(
          width: double.infinity,
          height: 55,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius:
                BorderRadius.circular(10),
            border: Border.all(
              color: const Color(0xFFFFCACA),
            ),
          ),
          child: const Row(
            children: [
              SizedBox(width: 22),

              Icon(
                Icons.logout,
                color: Color(0xFFE52323),
                size: 25,
              ),

              SizedBox(width: 20),

              Text(
                'Logout',
                style: TextStyle(
                  color: Color(0xFFE52323),
                  fontSize: 17,
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
  // DASHBOARD CONTENT
  // ============================================================

  Widget _dashboardContent(
    BuildContext context,
  ) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final bool mobile =
            constraints.maxWidth < 700;

        return SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(
            mobile ? 16 : 32,
            mobile ? 18 : 25,
            mobile ? 16 : 32,
            mobile ? 25 : 30,
          ),
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              // ==================================================
              // TITLE
              // ==================================================

              if (mobile)
                Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.home,
                          color: navy,
                          size: 24,
                        ),
                        const SizedBox(width: 10),
                        const Expanded(
                          child: Text(
                            'DASHBOARD RINGKASAN DATA',
                            style: TextStyle(
                              color: navy,
                              fontSize: 20,
                              fontWeight:
                                  FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    Container(
                      padding:
                          const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 8,
                      ),
                      decoration:
                          BoxDecoration(
                        color:
                            const Color(0xFFE4EAF2),
                        borderRadius:
                            BorderRadius.circular(
                          25,
                        ),
                      ),
                      child: const Text(
                        'Tahun Ajaran 2025/2026 Ganjil',
                        style: TextStyle(
                          color:
                              Color(0xFF60728C),
                          fontSize: 12,
                          fontWeight:
                              FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                )
              else
                Row(
                  children: [
                    const Icon(
                      Icons.home,
                      color: navy,
                      size: 30,
                    ),

                    const SizedBox(width: 15),

                    const Expanded(
                      child: Text(
                        'DASHBOARD RINGKASAN DATA',
                        style: TextStyle(
                          color: navy,
                          fontSize: 28,
                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),
                    ),

                    Container(
                      padding:
                          const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 9,
                      ),
                      decoration:
                          BoxDecoration(
                        color:
                            const Color(0xFFE4EAF2),
                        borderRadius:
                            BorderRadius.circular(
                          25,
                        ),
                      ),
                      child: const Text(
                        'Tahun Ajaran 2025/2026 Ganjil',
                        style: TextStyle(
                          color:
                              Color(0xFF60728C),
                          fontSize: 16,
                          fontWeight:
                              FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),

              const SizedBox(height: 15),

              const Divider(
                color: Color(0xFFD2DAE4),
              ),

              const SizedBox(height: 25),

              // ==================================================
              // STUDENT + TEACHER
              // ==================================================

              if (mobile) ...[
                _studentCardMobile(),

                const SizedBox(height: 18),

                _teacherCardMobile(),
              ] else
                Row(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: _studentCard(),
                    ),

                    const SizedBox(width: 30),

                    Expanded(
                      child: _teacherCard(),
                    ),
                  ],
                ),

              const SizedBox(height: 25),

              // ==================================================
              // CHARTS
              // ==================================================

              if (mobile) ...[
                _studentChartMobile(),

                const SizedBox(height: 18),

                _graduationChartMobile(),
              ] else
                Row(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: _studentChart(),
                    ),

                    const SizedBox(width: 30),

                    Expanded(
                      child:
                          _graduationChart(),
                    ),
                  ],
                ),
            ],
          ),
        );
      },
    );
  }

  // ============================================================
  // STUDENT CARD DESKTOP
  // ============================================================

  Widget _studentCard() {
    return Container(
      height: 295,
      padding:
          const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(17),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(
              alpha: 0.05,
            ),
            blurRadius: 5,
            offset:
                const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _iconBox(
                Icons.people,
                const Color(0xFFEAF3FF),
                const Color(0xFF553A91),
              ),

              const SizedBox(width: 12),

              const Expanded(
                child: Text(
                  'Total Siswa Aktif',
                  style: TextStyle(
                    color: textDark,
                    fontSize: 20,
                    fontWeight:
                        FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 13),

          const Text(
            '4',
            style: TextStyle(
              color: Colors.black87,
              fontSize: 42,
              height: 1,
              fontWeight:
                  FontWeight.bold,
            ),
          ),

          const SizedBox(height: 12),

          const Row(
            children: [
              Icon(
                Icons.arrow_drop_down,
                color: Color(0xFFE83D62),
                size: 24,
              ),

              Text(
                '20.8%',
                style: TextStyle(
                  color:
                      Color(0xFFE83D62),
                  fontSize: 15,
                  fontWeight:
                      FontWeight.bold,
                ),
              ),

              SizedBox(width: 5),

              Text(
                'dari tahun lalu',
                style: TextStyle(
                  color: textGrey,
                  fontSize: 15,
                ),
              ),
            ],
          ),

          const SizedBox(height: 13),

          Row(
            children: [
              Expanded(
                child: _statusBox(
                  'Aktif Kelas',
                  '4',
                  const Color(0xFFE9FAF2),
                  const Color(0xFF16A77A),
                  const Color(0xFF4BD18F),
                ),
              ),

              const SizedBox(width: 10),

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

              const SizedBox(width: 10),

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
  // STUDENT CARD MOBILE
  // ============================================================

  Widget _studentCardMobile() {
    return Container(
      width: double.infinity,
      padding:
          const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(17),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(
              alpha: 0.05,
            ),
            blurRadius: 5,
            offset:
                const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _iconBox(
                Icons.people,
                const Color(0xFFEAF3FF),
                const Color(0xFF553A91),
              ),

              const SizedBox(width: 10),

              const Expanded(
                child: Text(
                  'Total Siswa Aktif',
                  style: TextStyle(
                    color: textDark,
                    fontSize: 17,
                    fontWeight:
                        FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          const Text(
            '4',
            style: TextStyle(
              color: Colors.black87,
              fontSize: 36,
              height: 1,
              fontWeight:
                  FontWeight.bold,
            ),
          ),

          const SizedBox(height: 10),

          const Row(
            children: [
              Icon(
                Icons.arrow_drop_down,
                color: Color(0xFFE83D62),
                size: 22,
              ),

              Text(
                '20.8%',
                style: TextStyle(
                  color:
                      Color(0xFFE83D62),
                  fontSize: 13,
                  fontWeight:
                      FontWeight.bold,
                ),
              ),

              SizedBox(width: 5),

              Text(
                'dari tahun lalu',
                style: TextStyle(
                  color: textGrey,
                  fontSize: 13,
                ),
              ),
            ],
          ),

          const SizedBox(height: 13),

          Row(
            children: [
              Expanded(
                child: _statusBox(
                  'Aktif Kelas',
                  '4',
                  const Color(0xFFE9FAF2),
                  const Color(0xFF16A77A),
                  const Color(0xFF4BD18F),
                ),
              ),

              const SizedBox(width: 8),

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

              const SizedBox(width: 8),

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
  // TEACHER DESKTOP
  // ============================================================

  Widget _teacherCard() {
    return Container(
      height: 295,
      padding:
          const EdgeInsets.all(27),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(17),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(
              alpha: 0.05,
            ),
            blurRadius: 5,
            offset:
                const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _iconBox(
                Icons.menu_book,
                const Color(0xFFF0F3F7),
                const Color(0xFF3D63A3),
              ),

              const SizedBox(width: 12),

              const Text(
                'Tenaga Pengajar (Guru)',
                style: TextStyle(
                  color: textDark,
                  fontSize: 20,
                  fontWeight:
                      FontWeight.bold,
                ),
              ),
            ],
          ),

          const SizedBox(height: 28),

          Row(
            crossAxisAlignment:
                CrossAxisAlignment.center,
            children: [
              const Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Text(
                      '1',
                      style: TextStyle(
                        color:
                            Colors.black87,
                        fontSize: 42,
                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),

                    SizedBox(height: 2),

                    Text(
                      'Guru Terdaftar Aktif',
                      style: TextStyle(
                        color: textGrey,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(
                width: 85,
                height: 85,
                child: CustomPaint(
                  painter:
                      DonutPainter(),
                ),
              ),
            ],
          ),

          const Spacer(),

          const Divider(
            color: Color(0xFFE5EAF0),
          ),

          const SizedBox(height: 16),

          const Row(
            mainAxisAlignment:
                MainAxisAlignment
                    .spaceBetween,
            children: [
              Text(
                'Lulus Tahun Ini: 0',
                style: TextStyle(
                  color: textGrey,
                  fontSize: 15,
                ),
              ),

              Text(
                '0% dari tahun lalu',
                style: TextStyle(
                  color:
                      Color(0xFFFF3030),
                  fontSize: 15,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ============================================================
  // TEACHER MOBILE
  // ============================================================

  Widget _teacherCardMobile() {
    return Container(
      width: double.infinity,
      padding:
          const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(17),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(
              alpha: 0.05,
            ),
            blurRadius: 5,
            offset:
                const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _iconBox(
                Icons.menu_book,
                const Color(0xFFF0F3F7),
                const Color(0xFF3D63A3),
              ),

              const SizedBox(width: 10),

              const Expanded(
                child: Text(
                  'Tenaga Pengajar (Guru)',
                  style: TextStyle(
                    color: textDark,
                    fontSize: 17,
                    fontWeight:
                        FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 22),

          Row(
            children: [
              const Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Text(
                      '1',
                      style: TextStyle(
                        color:
                            Colors.black87,
                        fontSize: 36,
                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),

                    SizedBox(height: 2),

                    Text(
                      'Guru Terdaftar Aktif',
                      style: TextStyle(
                        color: textGrey,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(
                width: 75,
                height: 75,
                child: CustomPaint(
                  painter:
                      DonutPainter(),
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          const Divider(
            color: Color(0xFFE5EAF0),
          ),

          const SizedBox(height: 12),

          const Row(
            mainAxisAlignment:
                MainAxisAlignment
                    .spaceBetween,
            children: [
              Text(
                'Lulus Tahun Ini: 0',
                style: TextStyle(
                  color: textGrey,
                  fontSize: 13,
                ),
              ),

              Text(
                '0% dari tahun lalu',
                style: TextStyle(
                  color:
                      Color(0xFFFF3030),
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ============================================================
  // STUDENT CHART DESKTOP
  // ============================================================

  Widget _studentChart() {
    return Container(
      height: 335,
      padding:
          const EdgeInsets.fromLTRB(
        27,
        25,
        27,
        20,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(17),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(
              alpha: 0.05,
            ),
            blurRadius: 5,
            offset:
                const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          const Text(
            'PERKEMBANGAN JUMLAH SISWA',
            style: TextStyle(
              color: textDark,
              fontSize: 18,
              fontWeight:
                  FontWeight.bold,
            ),
          ),

          const SizedBox(height: 20),

          Expanded(
            child: Row(
              crossAxisAlignment:
                  CrossAxisAlignment.end,
              children: [
                Container(
                  width: 1,
                  color:
                      const Color(0xFFDDE4EC),
                ),

                const SizedBox(width: 35),

                Expanded(
                  child: _barChart(
                    values: const [
                      45,
                      52,
                      60,
                    ],
                    labels: const [
                      '2023',
                      '2024',
                      '2025',
                    ],
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
  // STUDENT CHART MOBILE
  // ============================================================

  Widget _studentChartMobile() {
    return Container(
      width: double.infinity,
      height: 300,
      padding:
          const EdgeInsets.fromLTRB(
        18,
        20,
        18,
        15,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(17),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(
              alpha: 0.05,
            ),
            blurRadius: 5,
            offset:
                const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          const Text(
            'PERKEMBANGAN JUMLAH SISWA',
            style: TextStyle(
              color: textDark,
              fontSize: 15,
              fontWeight:
                  FontWeight.bold,
            ),
          ),

          const SizedBox(height: 15),

          Expanded(
            child: Row(
              crossAxisAlignment:
                  CrossAxisAlignment.end,
              children: [
                Container(
                  width: 1,
                  color:
                      const Color(0xFFDDE4EC),
                ),

                const SizedBox(width: 18),

                Expanded(
                  child: _barChart(
                    values: const [
                      45,
                      52,
                      60,
                    ],
                    labels: const [
                      '2023',
                      '2024',
                      '2025',
                    ],
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
  // GRADUATION CHART DESKTOP
  // ============================================================

  Widget _graduationChart() {
    return Container(
      height: 335,
      padding:
          const EdgeInsets.fromLTRB(
        27,
        25,
        27,
        20,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(17),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(
              alpha: 0.05,
            ),
            blurRadius: 5,
            offset:
                const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          const Text(
            'TREN STATISTIK KELULUSAN SISWA',
            style: TextStyle(
              color: textDark,
              fontSize: 18,
              fontWeight:
                  FontWeight.bold,
            ),
          ),

          const SizedBox(height: 20),

          Expanded(
            child: Row(
              crossAxisAlignment:
                  CrossAxisAlignment.end,
              children: [
                Container(
                  width: 1,
                  color:
                      const Color(0xFFDDE4EC),
                ),

                const SizedBox(width: 35),

                Expanded(
                  child:
                      _graduationBars(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // GRADUATION CHART MOBILE
  // ============================================================

  Widget _graduationChartMobile() {
    return Container(
      width: double.infinity,
      height: 300,
      padding:
          const EdgeInsets.fromLTRB(
        18,
        20,
        18,
        15,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(17),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(
              alpha: 0.05,
            ),
            blurRadius: 5,
            offset:
                const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          const Text(
            'TREN STATISTIK KELULUSAN SISWA',
            style: TextStyle(
              color: textDark,
              fontSize: 15,
              fontWeight:
                  FontWeight.bold,
            ),
          ),

          const SizedBox(height: 15),

          Expanded(
            child: Row(
              crossAxisAlignment:
                  CrossAxisAlignment.end,
              children: [
                Container(
                  width: 1,
                  color:
                      const Color(0xFFDDE4EC),
                ),

                const SizedBox(width: 18),

                Expanded(
                  child:
                      _graduationBars(),
                ),
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
      crossAxisAlignment:
          CrossAxisAlignment.end,
      mainAxisAlignment:
          MainAxisAlignment.spaceAround,
      children: List.generate(
        values.length,
        (index) {
          final double height =
              (values[index] / maxValue) *
                  180;

          return Column(
            mainAxisAlignment:
                MainAxisAlignment.end,
            children: [
              Text(
                '${values[index]}',
                style: const TextStyle(
                  color: textGrey,
                  fontSize: 14,
                ),
              ),

              const SizedBox(height: 7),

              Container(
                width: 44,
                height: height,
                decoration:
                    BoxDecoration(
                  color: index == 2
                      ? navy
                      : blue,
                  borderRadius:
                      const BorderRadius.only(
                    topLeft:
                        Radius.circular(6),
                    topRight:
                        Radius.circular(6),
                  ),
                ),
              ),

              const SizedBox(height: 12),

              Text(
                labels[index],
                style: const TextStyle(
                  color: textDark,
                  fontSize: 14,
                  fontWeight:
                      FontWeight.w600,
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  // ============================================================
  // GRADUATION BARS
  // ============================================================

  Widget _graduationBars() {
    return Row(
      crossAxisAlignment:
          CrossAxisAlignment.end,
      mainAxisAlignment:
          MainAxisAlignment.spaceEvenly,
      children: [
        Column(
          mainAxisAlignment:
              MainAxisAlignment.end,
          children: [
            Container(
              width: 45,
              height: 120,
              decoration:
                  const BoxDecoration(
                color:
                    Color(0xFF2BB5D0),
                borderRadius:
                    BorderRadius.only(
                  topLeft:
                      Radius.circular(6),
                  topRight:
                      Radius.circular(6),
                ),
              ),
            ),

            const SizedBox(height: 12),

            const Text(
              'Ganjil',
              style: TextStyle(
                color: textDark,
                fontSize: 14,
              ),
            ),
          ],
        ),

        Column(
          mainAxisAlignment:
              MainAxisAlignment.end,
          children: [
            Container(
              width: 45,
              height: 60,
              decoration:
                  const BoxDecoration(
                color:
                    Color(0xFF16B98A),
                borderRadius:
                    BorderRadius.only(
                  topLeft:
                      Radius.circular(6),
                  topRight:
                      Radius.circular(6),
                ),
              ),
            ),

            const SizedBox(height: 12),

            const Text(
              'Genap',
              style: TextStyle(
                color: textDark,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ],
    );
  }

  // ============================================================
  // ICON BOX
  // ============================================================

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
        borderRadius:
            BorderRadius.circular(11),
      ),
      child: Icon(
        icon,
        color: iconColor,
        size: 25,
      ),
    );
  }

  // ============================================================
  // STATUS BOX
  // ============================================================

  Widget _statusBox(
    String title,
    String value,
    Color backgroundColor,
    Color textColor,
    Color dotColor,
  ) {
    return Container(
      height: 30,
      padding:
          const EdgeInsets.symmetric(
        horizontal: 11,
      ),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius:
            BorderRadius.circular(6),
      ),
      child: Row(
        children: [
          Container(
            width: 13,
            height: 13,
            decoration:
                BoxDecoration(
              color: dotColor,
              shape: BoxShape.circle,
            ),
          ),

          const SizedBox(width: 7),

          Expanded(
            child: Text(
              title,
              overflow:
                  TextOverflow.ellipsis,
              style: TextStyle(
                color: textColor,
                fontSize: 14,
              ),
            ),
          ),

          const SizedBox(width: 5),

          Text(
            value,
            style: TextStyle(
              color: textColor,
              fontSize: 14,
              fontWeight:
                  FontWeight.bold,
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
  void paint(
    Canvas canvas,
    Size size,
  ) {
    final Paint backgroundPaint =
        Paint()
          ..color =
              const Color(0xFFE1E8F0)
          ..style =
              PaintingStyle.stroke
          ..strokeWidth = 10;

    final Paint bluePaint =
        Paint()
          ..color =
              const Color(0xFF193F68)
          ..style =
              PaintingStyle.stroke
          ..strokeWidth = 10;

    final Paint cyanPaint =
        Paint()
          ..color =
              const Color(0xFF22BCD4)
          ..style =
              PaintingStyle.stroke
          ..strokeWidth = 10;

    final Rect rect =
        Offset.zero & size;

    canvas.drawArc(
      rect,
      -1.57,
      4.7,
      false,
      backgroundPaint,
    );

    canvas.drawArc(
      rect,
      -1.57,
      1.55,
      false,
      bluePaint,
    );

    canvas.drawArc(
      rect,
      0.0,
      1.2,
      false,
      cyanPaint,
    );
  }

  @override
  bool shouldRepaint(
    covariant CustomPainter oldDelegate,
  ) {
    return false;
  }
}