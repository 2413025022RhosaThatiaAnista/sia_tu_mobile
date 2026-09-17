import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import 'dashboard_page.dart';
import 'login_page.dart';
import 'guru_page.dart';

class SiswaPage extends StatefulWidget {
  const SiswaPage({super.key});

  @override
  State<SiswaPage> createState() => _SiswaPageState();
}

class _SiswaPageState extends State<SiswaPage> {
  // ============================================================
  // COLORS
  // ============================================================

  static const Color navy = Color(0xFF193F68);
  static const Color blue = Color(0xFF2F83BA);
  static const Color lightBlue = Color(0xFFF2F7FB);
  static const Color textDark = Color(0xFF26364A);
  static const Color textGrey = Color(0xFF718096);
  static const Color green = Color(0xFF38D39F);
  static const Color red = Color(0xFFE85D75);
  static const Color orange = Color(0xFFF4A340);

  // ============================================================
  // DATA SISWA
  // ============================================================

  final List<Map<String, dynamic>> siswaList = [
    {
      'nama': 'Ahmad Fauzan',
      'nis': '2026001',
      'nisn': '0087654321',
      'kelas': 'X IPA 1',
      'jk': 'Laki-laki',
      'tempatLahir': 'Jakarta',
      'tanggalLahir': '12 Januari 2010',
      'agama': 'Islam',
      'alamat': 'Jakarta',
      'namaOrtu': 'Budi Santoso',
      'noHp': '081234567890',
      'status': 'Aktif',
      'foto': null,
      'kk': null,
      'akta': null,
      'kartu': null,
      'ijazah': null,
      'lainnya': null,
    },
    {
      'nama': 'Siti Aisyah',
      'nis': '2026002',
      'nisn': '0087654322',
      'kelas': 'X IPA 1',
      'jk': 'Perempuan',
      'tempatLahir': 'Bandung',
      'tanggalLahir': '20 Februari 2010',
      'agama': 'Islam',
      'alamat': 'Bandung',
      'namaOrtu': 'Andi Wijaya',
      'noHp': '081234567891',
      'status': 'Aktif',
      'foto': null,
      'kk': null,
      'akta': null,
      'kartu': null,
      'ijazah': null,
      'lainnya': null,
    },
    {
      'nama': 'Rizky Pratama',
      'nis': '2026003',
      'nisn': '0087654323',
      'kelas': 'X IPS 1',
      'jk': 'Laki-laki',
      'tempatLahir': 'Depok',
      'tanggalLahir': '15 Maret 2010',
      'agama': 'Islam',
      'alamat': 'Depok',
      'namaOrtu': 'Rudi Pratama',
      'noHp': '081234567892',
      'status': 'Aktif',
      'foto': null,
      'kk': null,
      'akta': null,
      'kartu': null,
      'ijazah': null,
      'lainnya': null,
    },
  ];

  String searchText = '';

  // ============================================================
  // FILTER
  // ============================================================

  List<Map<String, dynamic>> get filteredSiswa {
    if (searchText.trim().isEmpty) {
      return siswaList;
    }

    final query = searchText.toLowerCase();

    return siswaList.where((siswa) {
      return siswa['nama']
              .toString()
              .toLowerCase()
              .contains(query) ||
          siswa['nis']
              .toString()
              .toLowerCase()
              .contains(query) ||
          siswa['kelas']
              .toString()
              .toLowerCase()
              .contains(query);
    }).toList();
  }

  int get jumlahAktif {
    return siswaList.where((s) => s['status'] == 'Aktif').length;
  }

  int get jumlahLaki {
    return siswaList.where((s) => s['jk'] == 'Laki-laki').length;
  }

  int get jumlahPerempuan {
    return siswaList.where((s) => s['jk'] == 'Perempuan').length;
  }

  // ============================================================
  // FILE PICKER
  // ============================================================

  Future<Uint8List?> _pickFile({
    bool imageOnly = false,
  }) async {
    try {
      final List<PlatformFile> files =
          await FilePicker.pickFiles(
        type: imageOnly
            ? FileType.image
            : FileType.custom,
        allowedExtensions: imageOnly
            ? null
            : [
                'pdf',
                'jpg',
                'jpeg',
                'png',
              ],
      );

      if (files.isEmpty) {
        return null;
      }

      final PlatformFile file = files.first;

      final Uint8List bytes =
          await file.xFile.readAsBytes();

      return bytes;
    } catch (e) {
      if (!mounted) {
        return null;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Gagal memilih file: $e',
          ),
          behavior: SnackBarBehavior.floating,
        ),
      );

      return null;
    }
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightBlue,
      drawer: _mobileDrawer(),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final bool desktop =
                constraints.maxWidth >= 900;

            if (desktop) {
              return Row(
                children: [
                  _sidebar(),
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
      floatingActionButton: LayoutBuilder(
        builder: (context, constraints) {
          return FloatingActionButton.extended(
            backgroundColor: blue,
            foregroundColor: Colors.white,
            onPressed: () {
              _showSiswaDialog();
            },
            icon: const Icon(Icons.person_add_alt_1),
            label: const Text('Tambah Siswa'),
          );
        },
      ),
    );
  }

  // ============================================================
  // SIDEBAR DESKTOP
  // ============================================================

  Widget _sidebar() {
    return Container(
      width: 260,
      color: Colors.white,
      child: Column(
        children: [
          const SizedBox(height: 25),

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
              color: Colors.white,
              size: 29,
            ),
          ),

          const SizedBox(height: 12),

          const Text(
            'SIA-TU SEKOLAH',
            style: TextStyle(
              color: navy,
              fontSize: 17,
              fontWeight: FontWeight.bold,
              letterSpacing: .7,
            ),
          ),

          const SizedBox(height: 35),

          Expanded(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(
                horizontal: 14,
              ),
              child: Column(
                children: [
                  _menuItem(
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

                  _menuItem(
                    Icons.people_outline,
                    'Data Siswa',
                    true,
                    () {},
                  ),

                  // ==================================================
                  // DATA GURU
                  // ==================================================

                  _menuItem(
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

                  _menuItem(
                    Icons.mail_outline,
                    'Surat Masuk',
                    false,
                    () {
                      _comingSoon('Surat Masuk');
                    },
                  ),

                  _menuItem(
                    Icons.send_outlined,
                    'Surat Keluar',
                    false,
                    () {
                      _comingSoon('Surat Keluar');
                    },
                  ),

                  _menuItem(
                    Icons.bar_chart,
                    'Laporan',
                    false,
                    () {
                      _comingSoon('Laporan');
                    },
                  ),

                  const Spacer(),

                  _menuItem(
                    Icons.logout,
                    'Keluar',
                    false,
                    () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              const LoginPage(),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 15),
                ],
              ),
            ),
          ),
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
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 52,
        margin:
            const EdgeInsets.only(bottom: 8),
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
                  : const Color(0xFF50627A),
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
    );
  }

  // ============================================================
  // MOBILE DRAWER
  // ============================================================

  Widget _mobileDrawer() {
    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 25),

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
                color: Colors.white,
                size: 29,
              ),
            ),

            const SizedBox(height: 12),

            const Text(
              'SIA-TU SEKOLAH',
              style: TextStyle(
                color: navy,
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 30),

            _drawerItem(
              Icons.dashboard_outlined,
              'Dashboard',
              () {
                Navigator.pop(context);

                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        const DashboardPage(),
                  ),
                );
              },
            ),

            _drawerItem(
              Icons.people_outline,
              'Data Siswa',
              () {
                Navigator.pop(context);
              },
              active: true,
            ),

            // ==================================================
            // DATA GURU MOBILE
            // ==================================================

            _drawerItem(
              Icons.badge_outlined,
              'Data Guru',
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

            _drawerItem(
              Icons.mail_outline,
              'Surat Masuk',
              () {
                Navigator.pop(context);
                _comingSoon('Surat Masuk');
              },
            ),

            _drawerItem(
              Icons.send_outlined,
              'Surat Keluar',
              () {
                Navigator.pop(context);
                _comingSoon('Surat Keluar');
              },
            ),

            _drawerItem(
              Icons.bar_chart,
              'Laporan',
              () {
                Navigator.pop(context);
                _comingSoon('Laporan');
              },
            ),

            const Spacer(),

            _drawerItem(
              Icons.logout,
              'Keluar',
              () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        const LoginPage(),
                  ),
                );
              },
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _drawerItem(
    IconData icon,
    String title,
    VoidCallback onTap, {
    bool active = false,
  }) {
    return ListTile(
      onTap: onTap,
      leading: Icon(
        icon,
        color: active ? blue : textGrey,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: active ? navy : textDark,
          fontWeight:
              active ? FontWeight.bold : FontWeight.w500,
        ),
      ),
      tileColor:
          active ? const Color(0xFFEAF4FA) : null,
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
            padding: const EdgeInsets.fromLTRB(
              24,
              20,
              24,
              90,
            ),
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                _pageTitle(),
                const SizedBox(height: 22),
                _statistics(),
                const SizedBox(height: 24),
                _studentSection(),
              ],
            ),
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
      width: double.infinity,
      padding:
          const EdgeInsets.symmetric(horizontal: 22),
      decoration: const BoxDecoration(
        color: navy,
      ),
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
                ),
              );
            },
          ),

          const SizedBox(width: 10),

          const Expanded(
            child: Text(
              'Data Siswa',
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
              color: blue,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.person,
              color: Colors.white,
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
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 2),
              Row(
                children: [
                  Icon(
                    Icons.circle,
                    color: green,
                    size: 7,
                  ),
                  SizedBox(width: 4),
                  Text(
                    'Online',
                    style: TextStyle(
                      color: green,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(width: 15),
        ],
      ),
    );
  }

  // ============================================================
  // PAGE TITLE
  // ============================================================

  Widget _pageTitle() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final bool mobile =
            constraints.maxWidth < 600;

        if (mobile) {
          return Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              const Text(
                'Data Siswa',
                style: TextStyle(
                  color: navy,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 5),
              const Text(
                'Kelola data siswa sekolah',
                style: TextStyle(
                  color: textGrey,
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 15),
              _searchBox(),
            ],
          );
        }

        return Row(
          children: [
            const Expanded(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Text(
                    'Data Siswa',
                    style: TextStyle(
                      color: navy,
                      fontSize: 27,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    'Kelola data siswa sekolah',
                    style: TextStyle(
                      color: textGrey,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: 300,
              child: _searchBox(),
            ),
          ],
        );
      },
    );
  }

  Widget _searchBox() {
    return TextField(
      onChanged: (value) {
        setState(() {
          searchText = value;
        });
      },
      decoration: InputDecoration(
        hintText: 'Cari nama, NIS, atau kelas...',
        hintStyle: const TextStyle(
          color: textGrey,
          fontSize: 13,
        ),
        prefixIcon: const Icon(
          Icons.search,
          color: textGrey,
          size: 21,
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding:
            const EdgeInsets.symmetric(
          vertical: 12,
          horizontal: 12,
        ),
        border: OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  // ============================================================
  // STATISTICS
  // ============================================================

  Widget _statistics() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final bool mobile =
            constraints.maxWidth < 650;

        final cards = [
          _statCard(
            'Total Siswa',
            siswaList.length.toString(),
            Icons.people_outline,
            blue,
          ),
          _statCard(
            'Siswa Aktif',
            jumlahAktif.toString(),
            Icons.check_circle_outline,
            green,
          ),
          _statCard(
            'Laki-laki',
            jumlahLaki.toString(),
            Icons.male,
            navy,
          ),
          _statCard(
            'Perempuan',
            jumlahPerempuan.toString(),
            Icons.female,
            orange,
          ),
        ];

        if (mobile) {
          return GridView.count(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.7,
            shrinkWrap: true,
            physics:
                const NeverScrollableScrollPhysics(),
            children: cards,
          );
        }

        return Row(
          children: [
            Expanded(child: cards[0]),
            const SizedBox(width: 15),
            Expanded(child: cards[1]),
            const SizedBox(width: 15),
            Expanded(child: cards[2]),
            const SizedBox(width: 15),
            Expanded(child: cards[3]),
          ],
        );
      },
    );
  }

  Widget _statCard(
    String title,
    String value,
    IconData icon,
    Color iconColor,
  ) {
    return Container(
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(
              alpha: .04,
            ),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 45,
            height: 45,
            decoration: BoxDecoration(
              color: iconColor.withValues(
                alpha: .10,
              ),
              borderRadius:
                  BorderRadius.circular(11),
            ),
            child: Icon(
              icon,
              color: iconColor,
              size: 23,
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
                  title,
                  maxLines: 1,
                  overflow:
                      TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: textGrey,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    color: navy,
                    fontSize: 21,
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

  // ============================================================
  // STUDENT SECTION
  // ============================================================

  Widget _studentSection() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(
              alpha: .04,
            ),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Expanded(
                  child: Text(
                    'Daftar Siswa',
                    style: TextStyle(
                      color: navy,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Text(
                  '${filteredSiswa.length} siswa',
                  style: const TextStyle(
                    color: textGrey,
                    fontSize: 12,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 17),

            LayoutBuilder(
              builder:
                  (context, constraints) {
                if (constraints.maxWidth <
                    700) {
                  return _mobileStudentList();
                }

                return _desktopStudentTable();
              },
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // DESKTOP TABLE
  // ============================================================

  Widget _desktopStudentTable() {
    if (filteredSiswa.isEmpty) {
      return _emptyData();
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columnSpacing: 25,
        headingRowHeight: 48,
        dataRowMinHeight: 65,
        dataRowMaxHeight: 75,
        headingTextStyle:
            const TextStyle(
          color: navy,
          fontSize: 13,
          fontWeight: FontWeight.bold,
        ),
        columns: const [
          DataColumn(label: Text('SISWA')),
          DataColumn(label: Text('NIS')),
          DataColumn(label: Text('NISN')),
          DataColumn(label: Text('KELAS')),
          DataColumn(label: Text('JENIS KELAMIN')),
          DataColumn(label: Text('STATUS')),
          DataColumn(label: Text('AKSI')),
        ],
        rows: filteredSiswa.map((siswa) {
          return DataRow(
            cells: [
              DataCell(
                GestureDetector(
                  onTap: () =>
                      _showDetailSiswa(siswa),
                  child: Row(
                    mainAxisSize:
                        MainAxisSize.min,
                    children: [
                      _photoWidget(
                        siswa['foto']
                            as Uint8List?,
                        size: 40,
                      ),
                      const SizedBox(width: 10),
                      SizedBox(
                        width: 130,
                        child: Text(
                          siswa['nama']
                              .toString(),
                          overflow:
                              TextOverflow.ellipsis,
                          style:
                              const TextStyle(
                            color: navy,
                            fontSize: 13,
                            fontWeight:
                                FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              DataCell(
                Text(
                  siswa['nis'].toString(),
                  style:
                      const TextStyle(
                    fontSize: 12,
                  ),
                ),
              ),
              DataCell(
                Text(
                  siswa['nisn'].toString(),
                  style:
                      const TextStyle(
                    fontSize: 12,
                  ),
                ),
              ),
              DataCell(
                Text(
                  siswa['kelas'].toString(),
                  style:
                      const TextStyle(
                    fontSize: 12,
                  ),
                ),
              ),
              DataCell(
                Text(
                  siswa['jk'].toString(),
                  style:
                      const TextStyle(
                    fontSize: 12,
                  ),
                ),
              ),
              DataCell(
                _statusBadge(
                  siswa['status'].toString(),
                ),
              ),
              DataCell(
                Row(
                  mainAxisSize:
                      MainAxisSize.min,
                  children: [
                    IconButton(
                      tooltip: 'Lihat',
                      onPressed: () {
                        _showDetailSiswa(
                          siswa,
                        );
                      },
                      icon: const Icon(
                        Icons.visibility_outlined,
                        size: 19,
                        color: blue,
                      ),
                    ),
                    IconButton(
                      tooltip: 'Edit',
                      onPressed: () {
                        _showSiswaDialog(
                          siswa: siswa,
                        );
                      },
                      icon: const Icon(
                        Icons.edit_outlined,
                        size: 19,
                        color: orange,
                      ),
                    ),
                    IconButton(
                      tooltip: 'Hapus',
                      onPressed: () {
                        _deleteSiswa(siswa);
                      },
                      icon: const Icon(
                        Icons.delete_outline,
                        size: 19,
                        color: red,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }

  // ============================================================
  // MOBILE LIST
  // ============================================================

  Widget _mobileStudentList() {
    if (filteredSiswa.isEmpty) {
      return _emptyData();
    }

    return Column(
      children:
          filteredSiswa.map((siswa) {
        return GestureDetector(
          onTap: () {
            _showDetailSiswa(siswa);
          },
          child: Container(
            width: double.infinity,
            margin:
                const EdgeInsets.only(
              bottom: 12,
            ),
            padding:
                const EdgeInsets.all(13),
            decoration: BoxDecoration(
              color: lightBlue,
              borderRadius:
                  BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                _photoWidget(
                  siswa['foto']
                      as Uint8List?,
                  size: 48,
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      Text(
                        siswa['nama']
                            .toString(),
                        maxLines: 1,
                        overflow:
                            TextOverflow.ellipsis,
                        style:
                            const TextStyle(
                          color: navy,
                          fontSize: 14,
                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'NIS: ${siswa['nis']}',
                        style:
                            const TextStyle(
                          color: textGrey,
                          fontSize: 11,
                        ),
                      ),
                      Text(
                        '${siswa['kelas']} • ${siswa['jk']}',
                        style:
                            const TextStyle(
                          color: textGrey,
                          fontSize: 11,
                        ),
                      ),
                      const SizedBox(height: 5),
                      _statusBadge(
                        siswa['status']
                            .toString(),
                      ),
                    ],
                  ),
                ),

                PopupMenuButton<String>(
                  onSelected: (value) {
                    if (value == 'detail') {
                      _showDetailSiswa(
                        siswa,
                      );
                    } else if (value == 'edit') {
                      _showSiswaDialog(
                        siswa: siswa,
                      );
                    } else if (value == 'hapus') {
                      _deleteSiswa(siswa);
                    }
                  },
                  itemBuilder: (context) {
                    return const [
                      PopupMenuItem(
                        value: 'detail',
                        child: Text(
                          'Lihat Detail',
                        ),
                      ),
                      PopupMenuItem(
                        value: 'edit',
                        child: Text('Edit'),
                      ),
                      PopupMenuItem(
                        value: 'hapus',
                        child: Text(
                          'Hapus',
                        ),
                      ),
                    ];
                  },
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  // ============================================================
  // PHOTO
  // ============================================================

  Widget _photoWidget(
    Uint8List? bytes, {
    double size = 45,
  }) {
    if (bytes != null) {
      return ClipRRect(
        borderRadius:
            BorderRadius.circular(10),
        child: Image.memory(
          bytes,
          width: size,
          height: size,
          fit: BoxFit.cover,
        ),
      );
    }

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: const Color(0xFFE7F1F8),
        borderRadius:
            BorderRadius.circular(10),
      ),
      child: Icon(
        Icons.person,
        color: blue,
        size: size * .55,
      ),
    );
  }

  // ============================================================
  // STATUS
  // ============================================================

  Widget _statusBadge(String status) {
    Color color;

    if (status == 'Aktif') {
      color = green;
    } else if (status == 'Cuti') {
      color = orange;
    } else if (status == 'Skorsing') {
      color = red;
    } else {
      color = textGrey;
    }

    return Container(
      padding:
          const EdgeInsets.symmetric(
        horizontal: 9,
        vertical: 5,
      ),
      decoration: BoxDecoration(
        color: color.withValues(
          alpha: .11,
        ),
        borderRadius:
            BorderRadius.circular(20),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _emptyData() {
    return Container(
      width: double.infinity,
      padding:
          const EdgeInsets.symmetric(
        vertical: 45,
      ),
      child: const Column(
        children: [
          Icon(
            Icons.people_outline,
            size: 45,
            color: Color(0xFFB7C3CF),
          ),
          SizedBox(height: 10),
          Text(
            'Data siswa tidak ditemukan',
            style: TextStyle(
              color: textGrey,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // TAMBAH / EDIT SISWA
  // ============================================================

  Future<void> _showSiswaDialog({
    Map<String, dynamic>? siswa,
  }) async {
    final bool edit = siswa != null;

    final namaController =
        TextEditingController(
      text: edit ? siswa['nama'].toString() : '',
    );

    final nisController =
        TextEditingController(
      text: edit ? siswa['nis'].toString() : '',
    );

    final nisnController =
        TextEditingController(
      text:
          edit ? siswa['nisn'].toString() : '',
    );

    final tempatController =
        TextEditingController(
      text: edit
          ? siswa['tempatLahir'].toString()
          : '',
    );

    final tanggalController =
        TextEditingController(
      text: edit
          ? siswa['tanggalLahir'].toString()
          : '',
    );

    final alamatController =
        TextEditingController(
      text:
          edit ? siswa['alamat'].toString() : '',
    );

    final ortuController =
        TextEditingController(
      text:
          edit ? siswa['namaOrtu'].toString() : '',
    );

    final hpController =
        TextEditingController(
      text: edit ? siswa['noHp'].toString() : '',
    );

    String kelas =
        edit ? siswa['kelas'].toString() : 'X IPA 1';

    String jk =
        edit ? siswa['jk'].toString() : 'Laki-laki';

    String agama =
        edit ? siswa['agama'].toString() : 'Islam';

    String status =
        edit ? siswa['status'].toString() : 'Aktif';

    Uint8List? foto =
        edit ? siswa['foto'] as Uint8List? : null;

    Uint8List? kk =
        edit ? siswa['kk'] as Uint8List? : null;

    Uint8List? akta =
        edit ? siswa['akta'] as Uint8List? : null;

    Uint8List? kartu =
        edit ? siswa['kartu'] as Uint8List? : null;

    Uint8List? ijazah =
        edit ? siswa['ijazah'] as Uint8List? : null;

    Uint8List? lainnya =
        edit ? siswa['lainnya'] as Uint8List? : null;

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder:
              (context, setDialogState) {
            return AlertDialog(
              backgroundColor: Colors.white,
              title: Row(
                children: [
                  Container(
                    width: 38,
                    height: 38,
                    decoration:
                        BoxDecoration(
                      color: blue.withValues(
                        alpha: .1,
                      ),
                      borderRadius:
                          BorderRadius.circular(
                        10,
                      ),
                    ),
                    child: Icon(
                      edit
                          ? Icons.edit
                          : Icons.person_add,
                      color: blue,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    edit
                        ? 'Edit Data Siswa'
                        : 'Tambah Data Siswa',
                    style: const TextStyle(
                      color: navy,
                      fontSize: 18,
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),
                ],
              ),
              content: SizedBox(
                width: 650,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      _sectionTitle(
                        'Data Pribadi',
                      ),

                      _dialogTextField(
                        namaController,
                        'Nama Lengkap',
                        Icons.person_outline,
                      ),

                      _dialogTextField(
                        nisController,
                        'NIS',
                        Icons.badge_outlined,
                      ),

                      _dialogTextField(
                        nisnController,
                        'NISN',
                        Icons.credit_card_outlined,
                      ),

                      LayoutBuilder(
                        builder:
                            (context,
                                constraints) {
                          if (constraints
                                  .maxWidth <
                              500) {
                            return Column(
                              children: [
                                _dropdownField(
                                  'Kelas',
                                  kelas,
                                  [
                                    'X IPA 1',
                                    'X IPA 2',
                                    'X IPS 1',
                                    'X IPS 2',
                                    'XI IPA 1',
                                    'XI IPA 2',
                                    'XI IPS 1',
                                    'XI IPS 2',
                                    'XII IPA 1',
                                    'XII IPS 1',
                                  ],
                                  (value) {
                                    setDialogState(
                                      () {
                                        kelas =
                                            value!;
                                      },
                                    );
                                  },
                                ),
                                _dropdownField(
                                  'Jenis Kelamin',
                                  jk,
                                  [
                                    'Laki-laki',
                                    'Perempuan',
                                  ],
                                  (value) {
                                    setDialogState(
                                      () {
                                        jk =
                                            value!;
                                      },
                                    );
                                  },
                                ),
                              ],
                            );
                          }

                          return Row(
                            children: [
                              Expanded(
                                child:
                                    _dropdownField(
                                  'Kelas',
                                  kelas,
                                  [
                                    'X IPA 1',
                                    'X IPA 2',
                                    'X IPS 1',
                                    'X IPS 2',
                                    'XI IPA 1',
                                    'XI IPA 2',
                                    'XI IPS 1',
                                    'XI IPS 2',
                                    'XII IPA 1',
                                    'XII IPS 1',
                                  ],
                                  (value) {
                                    setDialogState(
                                      () {
                                        kelas =
                                            value!;
                                      },
                                    );
                                  },
                                ),
                              ),
                              const SizedBox(
                                width: 12,
                              ),
                              Expanded(
                                child:
                                    _dropdownField(
                                  'Jenis Kelamin',
                                  jk,
                                  [
                                    'Laki-laki',
                                    'Perempuan',
                                  ],
                                  (value) {
                                    setDialogState(
                                      () {
                                        jk =
                                            value!;
                                      },
                                    );
                                  },
                                ),
                              ),
                            ],
                          );
                        },
                      ),

                      LayoutBuilder(
                        builder:
                            (context,
                                constraints) {
                          if (constraints
                                  .maxWidth <
                              500) {
                            return Column(
                              children: [
                                _dialogTextField(
                                  tempatController,
                                  'Tempat Lahir',
                                  Icons.location_city,
                                ),
                                _dialogTextField(
                                  tanggalController,
                                  'Tanggal Lahir',
                                  Icons.calendar_today,
                                ),
                              ],
                            );
                          }

                          return Row(
                            children: [
                              Expanded(
                                child:
                                    _dialogTextField(
                                  tempatController,
                                  'Tempat Lahir',
                                  Icons.location_city,
                                ),
                              ),
                              const SizedBox(
                                width: 12,
                              ),
                              Expanded(
                                child:
                                    _dialogTextField(
                                  tanggalController,
                                  'Tanggal Lahir',
                                  Icons.calendar_today,
                                ),
                              ),
                            ],
                          );
                        },
                      ),

                      _dropdownField(
                        'Agama',
                        agama,
                        [
                          'Islam',
                          'Kristen',
                          'Katolik',
                          'Hindu',
                          'Buddha',
                          'Konghucu',
                        ],
                        (value) {
                          setDialogState(
                            () {
                              agama = value!;
                            },
                          );
                        },
                      ),

                      _dialogTextField(
                        alamatController,
                        'Alamat',
                        Icons.home_outlined,
                        maxLines: 3,
                      ),

                      const SizedBox(height: 10),

                      _sectionTitle(
                        'Data Orang Tua / Wali',
                      ),

                      _dialogTextField(
                        ortuController,
                        'Nama Orang Tua / Wali',
                        Icons.family_restroom,
                      ),

                      _dialogTextField(
                        hpController,
                        'Nomor HP',
                        Icons.phone_outlined,
                        keyboardType:
                            TextInputType.phone,
                      ),

                      _sectionTitle(
                        'Status Siswa',
                      ),

                      _dropdownField(
                        'Status',
                        status,
                        [
                          'Aktif',
                          'Cuti',
                          'Skorsing',
                          'Non Aktif',
                        ],
                        (value) {
                          setDialogState(
                            () {
                              status = value!;
                            },
                          );
                        },
                      ),

                      _sectionTitle(
                        'Dokumen Siswa',
                      ),

                      _uploadTile(
                        title: 'Foto Siswa',
                        icon: Icons.image_outlined,
                        file: foto,
                        image: true,
                        onTap: () async {
                          final result =
                              await _pickFile(
                            imageOnly: true,
                          );

                          if (result != null) {
                            setDialogState(
                              () {
                                foto = result;
                              },
                            );
                          }
                        },
                      ),

                      _uploadTile(
                        title:
                            'Kartu Keluarga (KK)',
                        icon:
                            Icons.description_outlined,
                        file: kk,
                        onTap: () async {
                          final result =
                              await _pickFile();

                          if (result != null) {
                            setDialogState(
                              () {
                                kk = result;
                              },
                            );
                          }
                        },
                      ),

                      _uploadTile(
                        title:
                            'Akta Kelahiran',
                        icon:
                            Icons.description_outlined,
                        file: akta,
                        onTap: () async {
                          final result =
                              await _pickFile();

                          if (result != null) {
                            setDialogState(
                              () {
                                akta = result;
                              },
                            );
                          }
                        },
                      ),

                      _uploadTile(
                        title:
                            'Kartu Pelajar',
                        icon:
                            Icons.credit_card_outlined,
                        file: kartu,
                        onTap: () async {
                          final result =
                              await _pickFile();

                          if (result != null) {
                            setDialogState(
                              () {
                                kartu = result;
                              },
                            );
                          }
                        },
                      ),

                      _uploadTile(
                        title:
                            'Ijazah / SKHU',
                        icon:
                            Icons.school_outlined,
                        file: ijazah,
                        onTap: () async {
                          final result =
                              await _pickFile();

                          if (result != null) {
                            setDialogState(
                              () {
                                ijazah = result;
                              },
                            );
                          }
                        },
                      ),

                      _uploadTile(
                        title:
                            'Berkas Lainnya',
                        icon:
                            Icons.folder_outlined,
                        file: lainnya,
                        onTap: () async {
                          final result =
                              await _pickFile();

                          if (result != null) {
                            setDialogState(
                              () {
                                lainnya = result;
                              },
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(
                      dialogContext,
                    );
                  },
                  child: const Text(
                    'Batal',
                    style: TextStyle(
                      color: textGrey,
                    ),
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    if (namaController
                        .text
                        .trim()
                        .isEmpty) {
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Nama siswa wajib diisi.',
                          ),
                        ),
                      );
                      return;
                    }

                    final data = {
                      'nama':
                          namaController.text.trim(),
                      'nis':
                          nisController.text.trim(),
                      'nisn':
                          nisnController.text.trim(),
                      'kelas': kelas,
                      'jk': jk,
                      'tempatLahir':
                          tempatController.text
                              .trim(),
                      'tanggalLahir':
                          tanggalController.text
                              .trim(),
                      'agama': agama,
                      'alamat':
                          alamatController.text
                              .trim(),
                      'namaOrtu':
                          ortuController.text
                              .trim(),
                      'noHp':
                          hpController.text.trim(),
                      'status': status,
                      'foto': foto,
                      'kk': kk,
                      'akta': akta,
                      'kartu': kartu,
                      'ijazah': ijazah,
                      'lainnya': lainnya,
                    };

                    setState(() {
                      if (edit) {
                        final index =
                            siswaList.indexOf(
                          siswa,
                        );

                        if (index >= 0) {
                          siswaList[index] =
                              data;
                        }
                      } else {
                        siswaList.add(data);
                      }
                    });

                    Navigator.pop(
                      dialogContext,
                    );

                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(
                      SnackBar(
                        content: Text(
                          edit
                              ? 'Data siswa berhasil diperbarui.'
                              : 'Data siswa berhasil ditambahkan.',
                        ),
                        behavior:
                            SnackBarBehavior
                                .floating,
                      ),
                    );
                  },
                  icon: Icon(
                    edit
                        ? Icons.save_outlined
                        : Icons.add,
                    size: 18,
                  ),
                  label: Text(
                    edit
                        ? 'Simpan Perubahan'
                        : 'Tambah Siswa',
                  ),
                  style:
                      ElevatedButton.styleFrom(
                    backgroundColor: blue,
                    foregroundColor:
                        Colors.white,
                    padding:
                        const EdgeInsets
                            .symmetric(
                      horizontal: 17,
                      vertical: 12,
                    ),
                    shape:
                        RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(
                        9,
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );

    namaController.dispose();
    nisController.dispose();
    nisnController.dispose();
    tempatController.dispose();
    tanggalController.dispose();
    alamatController.dispose();
    ortuController.dispose();
    hpController.dispose();
  }

  // ============================================================
  // FORM HELPERS
  // ============================================================

  Widget _sectionTitle(String title) {
    return Padding(
      padding:
          const EdgeInsets.only(
        top: 12,
        bottom: 10,
      ),
      child: Text(
        title,
        style: const TextStyle(
          color: navy,
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _dialogTextField(
    TextEditingController controller,
    String label,
    IconData icon, {
    int maxLines = 1,
    TextInputType? keyboardType,
  }) {
    return Padding(
      padding:
          const EdgeInsets.only(bottom: 10),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        keyboardType: keyboardType,
        style: const TextStyle(
          fontSize: 13,
          color: textDark,
        ),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(
            fontSize: 12,
            color: textGrey,
          ),
          prefixIcon: Icon(
            icon,
            size: 19,
            color: blue,
          ),
          filled: true,
          fillColor: lightBlue,
          contentPadding:
              const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 12,
          ),
          border: OutlineInputBorder(
            borderRadius:
                BorderRadius.circular(9),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  Widget _dropdownField(
    String label,
    String value,
    List<String> items,
    ValueChanged<String?> onChanged,
  ) {
    return Padding(
      padding:
          const EdgeInsets.only(bottom: 10),
      child: DropdownButtonFormField<String>(
        initialValue: value,
        items: items.map((item) {
          return DropdownMenuItem<String>(
            value: item,
            child: Text(
              item,
              style: const TextStyle(
                fontSize: 13,
              ),
            ),
          );
        }).toList(),
        onChanged: onChanged,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(
            fontSize: 12,
            color: textGrey,
          ),
          filled: true,
          fillColor: lightBlue,
          contentPadding:
              const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 5,
          ),
          border: OutlineInputBorder(
            borderRadius:
                BorderRadius.circular(9),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  Widget _uploadTile({
    required String title,
    required IconData icon,
    required Uint8List? file,
    required VoidCallback onTap,
    bool image = false,
  }) {
    return Container(
      margin:
          const EdgeInsets.only(bottom: 9),
      decoration: BoxDecoration(
        color: lightBlue,
        borderRadius:
            BorderRadius.circular(9),
      ),
      child: ListTile(
        dense: true,
        leading: Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            color: blue.withValues(
              alpha: .10,
            ),
            borderRadius:
                BorderRadius.circular(8),
          ),
          child: Icon(
            image && file != null
                ? Icons.check_circle_outline
                : icon,
            color: file != null
                ? green
                : blue,
            size: 20,
          ),
        ),
        title: Text(
          title,
          style: const TextStyle(
            color: textDark,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(
          file != null
              ? 'File sudah dipilih'
              : 'Belum ada file',
          style: TextStyle(
            color: file != null
                ? green
                : textGrey,
            fontSize: 10,
          ),
        ),
        trailing: OutlinedButton(
          onPressed: onTap,
          style:
              OutlinedButton.styleFrom(
            foregroundColor: blue,
            side: const BorderSide(
              color: blue,
            ),
            padding:
                const EdgeInsets.symmetric(
              horizontal: 10,
            ),
            minimumSize:
                const Size(65, 34),
            shape:
                RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.circular(7),
            ),
          ),
          child: Text(
            file != null
                ? 'Ganti'
                : 'Upload',
            style: const TextStyle(
              fontSize: 11,
            ),
          ),
        ),
      ),
    );
  }

  // ============================================================
  // DETAIL SISWA
  // ============================================================

  void _showDetailSiswa(
    Map<String, dynamic> siswa,
  ) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Row(
            children: [
              _photoWidget(
                siswa['foto'] as Uint8List?,
                size: 48,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  siswa['nama'].toString(),
                  style: const TextStyle(
                    color: navy,
                    fontSize: 18,
                    fontWeight:
                        FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          content: SizedBox(
            width: 550,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _detailRow(
                    'NIS',
                    siswa['nis'],
                  ),
                  _detailRow(
                    'NISN',
                    siswa['nisn'],
                  ),
                  _detailRow(
                    'Kelas',
                    siswa['kelas'],
                  ),
                  _detailRow(
                    'Jenis Kelamin',
                    siswa['jk'],
                  ),
                  _detailRow(
                    'Tempat Lahir',
                    siswa['tempatLahir'],
                  ),
                  _detailRow(
                    'Tanggal Lahir',
                    siswa['tanggalLahir'],
                  ),
                  _detailRow(
                    'Agama',
                    siswa['agama'],
                  ),
                  _detailRow(
                    'Alamat',
                    siswa['alamat'],
                  ),
                  _detailRow(
                    'Orang Tua / Wali',
                    siswa['namaOrtu'],
                  ),
                  _detailRow(
                    'No. HP',
                    siswa['noHp'],
                  ),
                  Padding(
                    padding:
                        const EdgeInsets
                            .symmetric(
                      vertical: 8,
                    ),
                    child: Row(
                      children: [
                        const SizedBox(
                          width: 125,
                          child: Text(
                            'Status',
                            style: TextStyle(
                              color: textGrey,
                              fontSize: 12,
                            ),
                          ),
                        ),
                        _statusBadge(
                          siswa['status']
                              .toString(),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(
                'Tutup',
                style: TextStyle(
                  color: blue,
                ),
              ),
            ),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.pop(context);
                _showSiswaDialog(
                  siswa: siswa,
                );
              },
              icon: const Icon(
                Icons.edit_outlined,
                size: 17,
              ),
              label: const Text('Edit'),
              style:
                  ElevatedButton.styleFrom(
                backgroundColor: blue,
                foregroundColor:
                    Colors.white,
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _detailRow(
    String title,
    dynamic value,
  ) {
    return Padding(
      padding:
          const EdgeInsets.symmetric(
        vertical: 7,
      ),
      child: Row(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 125,
            child: Text(
              title,
              style: const TextStyle(
                color: textGrey,
                fontSize: 12,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value?.toString() ?? '-',
              style: const TextStyle(
                color: textDark,
                fontSize: 12,
                fontWeight:
                    FontWeight.w600,
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

  void _deleteSiswa(
    Map<String, dynamic> siswa,
  ) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            'Hapus Data Siswa?',
            style: TextStyle(
              color: navy,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            'Data ${siswa['nama']} akan dihapus dari daftar siswa.',
            style: const TextStyle(
              fontSize: 13,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(
                'Batal',
              ),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  siswaList.remove(siswa);
                });

                Navigator.pop(context);

                ScaffoldMessenger.of(
                  this.context,
                ).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Data siswa berhasil dihapus.',
                    ),
                  ),
                );
              },
              style:
                  ElevatedButton.styleFrom(
                backgroundColor: red,
                foregroundColor:
                    Colors.white,
              ),
              child: const Text(
                'Hapus',
              ),
            ),
          ],
        );
      },
    );
  }

  // ============================================================
  // COMING SOON
  // ============================================================

  void _comingSoon(String pageName) {
    ScaffoldMessenger.of(context)
        .showSnackBar(
      SnackBar(
        content: Text(
          '$pageName sedang dalam tahap pengembangan.',
        ),
        behavior:
            SnackBarBehavior.floating,
      ),
    );
  }
}