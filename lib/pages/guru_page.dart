import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import 'dashboard_page.dart';
import 'login_page.dart';
import 'siswa_page.dart';

class GuruPage extends StatefulWidget {
  const GuruPage({super.key});

  @override
  State<GuruPage> createState() => _GuruPageState();
}

class _GuruPageState extends State<GuruPage> {
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
  // DATA GURU
  // ============================================================

  final List<Map<String, dynamic>> guruList = [
    {
      'nama': 'Budi Santoso',
      'nip': '198501012010011001',
      'nuptk': '1234567890123456',
      'jk': 'Laki-laki',
      'mapel': 'Matematika',
      'jabatan': 'Guru Mata Pelajaran',
      'noHp': '081234567890',
      'alamat': 'Jakarta',
      'status': 'Aktif',
      'foto': null,
      'sk': null,
      'ijazah': null,
      'ktp': null,
      'sertifikat': null,
      'pembagianTugas': null,
      'lainnya': null,
    },
    {
      'nama': 'Siti Rahmawati',
      'nip': '198702152011012002',
      'nuptk': '1234567890123457',
      'jk': 'Perempuan',
      'mapel': 'Bahasa Indonesia',
      'jabatan': 'Guru Mata Pelajaran',
      'noHp': '081234567891',
      'alamat': 'Bandung',
      'status': 'Aktif',
      'foto': null,
      'sk': null,
      'ijazah': null,
      'ktp': null,
      'sertifikat': null,
      'pembagianTugas': null,
      'lainnya': null,
    },
    {
      'nama': 'Andi Wijaya',
      'nip': '199001102015031003',
      'nuptk': '1234567890123458',
      'jk': 'Laki-laki',
      'mapel': 'Bahasa Inggris',
      'jabatan': 'Guru Mata Pelajaran',
      'noHp': '081234567892',
      'alamat': 'Depok',
      'status': 'Aktif',
      'foto': null,
      'sk': null,
      'ijazah': null,
      'ktp': null,
      'sertifikat': null,
      'pembagianTugas': null,
      'lainnya': null,
    },
  ];

  String searchText = '';

  // ============================================================
  // FILTER
  // ============================================================

  List<Map<String, dynamic>> get filteredGuru {
    if (searchText.trim().isEmpty) {
      return guruList;
    }

    final query = searchText.toLowerCase();

    return guruList.where((guru) {
      return guru['nama']
              .toString()
              .toLowerCase()
              .contains(query) ||
          guru['nip']
              .toString()
              .toLowerCase()
              .contains(query) ||
          guru['mapel']
              .toString()
              .toLowerCase()
              .contains(query);
    }).toList();
  }

  int get jumlahAktif {
    return guruList.where((g) => g['status'] == 'Aktif').length;
  }

  int get jumlahLaki {
    return guruList.where((g) => g['jk'] == 'Laki-laki').length;
  }

  int get jumlahPerempuan {
    return guruList.where((g) => g['jk'] == 'Perempuan').length;
  }

  // ============================================================
  // FILE PICKER
  // ============================================================

  Future<Uint8List?> _pickFile({
    bool imageOnly = false,
  }) async {
    try {
      final List<PlatformFile> files = await FilePicker.pickFiles(
        type: imageOnly ? FileType.image : FileType.custom,
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

      final Uint8List bytes = await file.xFile.readAsBytes();

      return bytes;
    } catch (e) {
      if (!mounted) {
        return null;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal memilih file: $e'),
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
            final bool desktop = constraints.maxWidth >= 900;

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
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: blue,
        foregroundColor: Colors.white,
        onPressed: () {
          _showGuruDialog();
        },
        icon: const Icon(Icons.person_add_alt_1),
        label: const Text('Tambah Guru'),
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
              borderRadius: BorderRadius.circular(14),
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
              padding: const EdgeInsets.symmetric(
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
                          builder: (_) => const DashboardPage(),
                        ),
                      );
                    },
                  ),

                  _menuItem(
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

                  _menuItem(
                    Icons.badge_outlined,
                    'Data Guru',
                    true,
                    () {},
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
                          builder: (_) => const LoginPage(),
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
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
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
                borderRadius: BorderRadius.circular(14),
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
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const DashboardPage(),
                  ),
                );
              },
            ),

            _drawerItem(
              Icons.people_outline,
              'Data Siswa',
              () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const SiswaPage(),
                  ),
                );
              },
            ),

            _drawerItem(
              Icons.badge_outlined,
              'Data Guru',
              () {},
              active: true,
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
                    builder: (_) => const LoginPage(),
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _pageTitle(),

                const SizedBox(height: 22),

                _statistics(),

                const SizedBox(height: 24),

                _teacherSection(),
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
      padding: const EdgeInsets.symmetric(
        horizontal: 22,
      ),
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
              'Data Guru',
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
        final bool mobile = constraints.maxWidth < 600;

        if (mobile) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Data Guru',
                style: TextStyle(
                  color: navy,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 5),

              const Text(
                'Kelola data guru sekolah',
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Data Guru',
                    style: TextStyle(
                      color: navy,
                      fontSize: 27,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  SizedBox(height: 5),

                  Text(
                    'Kelola data guru sekolah',
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
        hintText: 'Cari nama, NIP, atau mapel...',
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
        contentPadding: const EdgeInsets.symmetric(
          vertical: 12,
          horizontal: 12,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
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
        final bool mobile = constraints.maxWidth < 650;

        final cards = [
          _statCard(
            'Total Guru',
            guruList.length.toString(),
            Icons.badge_outlined,
            blue,
          ),
          _statCard(
            'Guru Aktif',
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
        borderRadius: BorderRadius.circular(14),
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
              borderRadius: BorderRadius.circular(11),
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
                  overflow: TextOverflow.ellipsis,
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
  // TEACHER SECTION
  // ============================================================

  Widget _teacherSection() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
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
                    'Daftar Guru',
                    style: TextStyle(
                      color: navy,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                Text(
                  '${filteredGuru.length} guru',
                  style: const TextStyle(
                    color: textGrey,
                    fontSize: 12,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 17),

            LayoutBuilder(
              builder: (context, constraints) {
                if (constraints.maxWidth < 700) {
                  return _mobileTeacherList();
                }

                return _desktopTeacherTable();
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

  Widget _desktopTeacherTable() {
    if (filteredGuru.isEmpty) {
      return _emptyData();
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columnSpacing: 25,
        headingRowHeight: 48,
        dataRowMinHeight: 65,
        dataRowMaxHeight: 75,
        headingTextStyle: const TextStyle(
          color: navy,
          fontSize: 13,
          fontWeight: FontWeight.bold,
        ),
        columns: const [
          DataColumn(
            label: Text('GURU'),
          ),
          DataColumn(
            label: Text('NIP'),
          ),
          DataColumn(
            label: Text('NUPTK'),
          ),
          DataColumn(
            label: Text('JABATAN'),
          ),
          DataColumn(
            label: Text('MAPEL'),
          ),
          DataColumn(
            label: Text('STATUS'),
          ),
          DataColumn(
            label: Text('AKSI'),
          ),
        ],
        rows: filteredGuru.map((guru) {
          return DataRow(
            cells: [
              // GURU
              DataCell(
                GestureDetector(
                  onTap: () {
                    _showDetailGuru(guru);
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _photoWidget(
                        guru['foto'] as Uint8List?,
                        size: 40,
                      ),

                      const SizedBox(width: 10),

                      SizedBox(
                        width: 150,
                        child: Text(
                          guru['nama'].toString(),
                          overflow:
                              TextOverflow.ellipsis,
                          style: const TextStyle(
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

              // NIP
              DataCell(
                SizedBox(
                  width: 150,
                  child: Text(
                    guru['nip'].toString(),
                    style: const TextStyle(
                      fontSize: 12,
                    ),
                  ),
                ),
              ),

              // NUPTK
              DataCell(
                SizedBox(
                  width: 150,
                  child: Text(
                    guru['nuptk'].toString(),
                    style: const TextStyle(
                      fontSize: 12,
                    ),
                  ),
                ),
              ),

              // JABATAN
              DataCell(
                SizedBox(
                  width: 150,
                  child: Text(
                    guru['jabatan'].toString(),
                    overflow:
                        TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 12,
                    ),
                  ),
                ),
              ),

              // MAPEL
              DataCell(
                SizedBox(
                  width: 120,
                  child: Text(
                    guru['mapel'].toString(),
                    overflow:
                        TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 12,
                    ),
                  ),
                ),
              ),

              // STATUS
              DataCell(
                _statusBadge(
                  guru['status'].toString(),
                ),
              ),

              // AKSI
              DataCell(
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      tooltip: 'Lihat',
                      onPressed: () {
                        _showDetailGuru(guru);
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
                        _showGuruDialog(
                          guru: guru,
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
                        _deleteGuru(guru);
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

  Widget _mobileTeacherList() {
    if (filteredGuru.isEmpty) {
      return _emptyData();
    }

    return Column(
      children: filteredGuru.map((guru) {
        return GestureDetector(
          onTap: () {
            _showDetailGuru(guru);
          },
          child: Container(
            width: double.infinity,
            margin: const EdgeInsets.only(
              bottom: 12,
            ),
            padding: const EdgeInsets.all(13),
            decoration: BoxDecoration(
              color: lightBlue,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                _photoWidget(
                  guru['foto'] as Uint8List?,
                  size: 48,
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      Text(
                        guru['nama'].toString(),
                        maxLines: 1,
                        overflow:
                            TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: navy,
                          fontSize: 14,
                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 4),

                      Text(
                        'NIP: ${guru['nip']}',
                        maxLines: 1,
                        overflow:
                            TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: textGrey,
                          fontSize: 11,
                        ),
                      ),

                      Text(
                        '${guru['mapel']} • ${guru['jk']}',
                        maxLines: 1,
                        overflow:
                            TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: textGrey,
                          fontSize: 11,
                        ),
                      ),

                      const SizedBox(height: 5),

                      _statusBadge(
                        guru['status'].toString(),
                      ),
                    ],
                  ),
                ),

                PopupMenuButton<String>(
                  onSelected: (value) {
                    if (value == 'detail') {
                      _showDetailGuru(guru);
                    } else if (value == 'edit') {
                      _showGuruDialog(
                        guru: guru,
                      );
                    } else if (value == 'hapus') {
                      _deleteGuru(guru);
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
                        child: Text('Hapus'),
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
        borderRadius: BorderRadius.circular(10),
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
        borderRadius: BorderRadius.circular(10),
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
    } else if (status == 'Non Aktif') {
      color = red;
    } else {
      color = textGrey;
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 9,
        vertical: 5,
      ),
      decoration: BoxDecoration(
        color: color.withValues(
          alpha: .11,
        ),
        borderRadius: BorderRadius.circular(20),
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
      padding: const EdgeInsets.symmetric(
        vertical: 45,
      ),
      child: const Column(
        children: [
          Icon(
            Icons.badge_outlined,
            size: 45,
            color: Color(0xFFB7C3CF),
          ),

          SizedBox(height: 10),

          Text(
            'Data guru tidak ditemukan',
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
  // TAMBAH / EDIT GURU
  // ============================================================

  Future<void> _showGuruDialog({
    Map<String, dynamic>? guru,
  }) async {
    final bool edit = guru != null;

    final namaController = TextEditingController(
      text: edit ? guru['nama'].toString() : '',
    );

    final nipController = TextEditingController(
      text: edit ? guru['nip'].toString() : '',
    );

    final nuptkController = TextEditingController(
      text: edit ? guru['nuptk'].toString() : '',
    );

    final hpController = TextEditingController(
      text: edit ? guru['noHp'].toString() : '',
    );

    final alamatController = TextEditingController(
      text: edit ? guru['alamat'].toString() : '',
    );

    String jk = edit
        ? guru['jk'].toString()
        : 'Laki-laki';

    String mapel = edit
        ? guru['mapel'].toString()
        : 'Matematika';

    String jabatan = edit
        ? guru['jabatan'].toString()
        : 'Guru Mata Pelajaran';

    String status = edit
        ? guru['status'].toString()
        : 'Aktif';

    Uint8List? foto =
        edit ? guru['foto'] as Uint8List? : null;

    Uint8List? sk =
        edit ? guru['sk'] as Uint8List? : null;

    Uint8List? ijazah =
        edit ? guru['ijazah'] as Uint8List? : null;

    Uint8List? ktp =
        edit ? guru['ktp'] as Uint8List? : null;

    Uint8List? sertifikat =
        edit ? guru['sertifikat'] as Uint8List? : null;

    Uint8List? pembagianTugas =
        edit ? guru['pembagianTugas'] as Uint8List? : null;

    Uint8List? lainnya =
        edit ? guru['lainnya'] as Uint8List? : null;

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              backgroundColor: Colors.white,

              title: Row(
                children: [
                  Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      color: blue.withValues(
                        alpha: .1,
                      ),
                      borderRadius:
                          BorderRadius.circular(10),
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
                        ? 'Edit Data Guru'
                        : 'Tambah Data Guru',
                    style: const TextStyle(
                      color: navy,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
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
                        'Data Guru',
                      ),

                      _dialogTextField(
                        namaController,
                        'Nama Lengkap',
                        Icons.person_outline,
                      ),

                      _dialogTextField(
                        nipController,
                        'NIP',
                        Icons.badge_outlined,
                      ),

                      _dialogTextField(
                        nuptkController,
                        'NUPTK',
                        Icons.credit_card_outlined,
                      ),

                      LayoutBuilder(
                        builder:
                            (context, constraints) {
                          if (constraints.maxWidth <
                              500) {
                            return Column(
                              children: [
                                _dropdownField(
                                  'Jenis Kelamin',
                                  jk,
                                  [
                                    'Laki-laki',
                                    'Perempuan',
                                  ],
                                  (value) {
                                    if (value == null) {
                                      return;
                                    }

                                    setDialogState(() {
                                      jk = value;
                                    });
                                  },
                                ),

                                _dropdownField(
                                  'Mapel',
                                  mapel,
                                  [
                                    'Matematika',
                                    'Bahasa Indonesia',
                                    'Bahasa Inggris',
                                    'IPA',
                                    'IPS',
                                    'Pendidikan Agama',
                                    'PJOK',
                                    'Seni Budaya',
                                    'Informatika',
                                  ],
                                  (value) {
                                    if (value == null) {
                                      return;
                                    }

                                    setDialogState(() {
                                      mapel = value;
                                    });
                                  },
                                ),
                              ],
                            );
                          }

                          return Row(
                            children: [
                              Expanded(
                                child: _dropdownField(
                                  'Jenis Kelamin',
                                  jk,
                                  [
                                    'Laki-laki',
                                    'Perempuan',
                                  ],
                                  (value) {
                                    if (value == null) {
                                      return;
                                    }

                                    setDialogState(() {
                                      jk = value;
                                    });
                                  },
                                ),
                              ),

                              const SizedBox(width: 12),

                              Expanded(
                                child: _dropdownField(
                                  'Mapel',
                                  mapel,
                                  [
                                    'Matematika',
                                    'Bahasa Indonesia',
                                    'Bahasa Inggris',
                                    'IPA',
                                    'IPS',
                                    'Pendidikan Agama',
                                    'PJOK',
                                    'Seni Budaya',
                                    'Informatika',
                                  ],
                                  (value) {
                                    if (value == null) {
                                      return;
                                    }

                                    setDialogState(() {
                                      mapel = value;
                                    });
                                  },
                                ),
                              ),
                            ],
                          );
                        },
                      ),

                      _dropdownField(
                        'Jabatan',
                        jabatan,
                        [
                          'Guru Mata Pelajaran',
                          'Wali Kelas',
                          'Guru BK',
                          'Kepala Sekolah',
                          'Wakil Kepala Sekolah',
                          'Staf',
                        ],
                        (value) {
                          if (value == null) {
                            return;
                          }

                          setDialogState(() {
                            jabatan = value;
                          });
                        },
                      ),

                      _dialogTextField(
                        hpController,
                        'Nomor HP',
                        Icons.phone_outlined,
                        keyboardType:
                            TextInputType.phone,
                      ),

                      _dialogTextField(
                        alamatController,
                        'Alamat',
                        Icons.home_outlined,
                        maxLines: 3,
                      ),

                      _sectionTitle(
                        'Status Guru',
                      ),

                      _dropdownField(
                        'Status',
                        status,
                        [
                          'Aktif',
                          'Cuti',
                          'Non Aktif',
                        ],
                        (value) {
                          if (value == null) {
                            return;
                          }

                          setDialogState(() {
                            status = value;
                          });
                        },
                      ),

                      _sectionTitle(
                        'Dokumen Guru',
                      ),

                      _uploadTile(
                        title: 'Foto Guru',
                        icon: Icons.image_outlined,
                        file: foto,
                        image: true,
                        onTap: () async {
                          final result =
                              await _pickFile(
                            imageOnly: true,
                          );

                          if (result != null) {
                            setDialogState(() {
                              foto = result;
                            });
                          }
                        },
                      ),

                      _uploadTile(
                        title: 'SK Pengangkatan',
                        icon:
                            Icons.description_outlined,
                        file: sk,
                        onTap: () async {
                          final result =
                              await _pickFile();

                          if (result != null) {
                            setDialogState(() {
                              sk = result;
                            });
                          }
                        },
                      ),

                      _uploadTile(
                        title: 'Ijazah Terakhir',
                        icon:
                            Icons.school_outlined,
                        file: ijazah,
                        onTap: () async {
                          final result =
                              await _pickFile();

                          if (result != null) {
                            setDialogState(() {
                              ijazah = result;
                            });
                          }
                        },
                      ),

                      _uploadTile(
                        title: 'KTP',
                        icon:
                            Icons.credit_card_outlined,
                        file: ktp,
                        onTap: () async {
                          final result =
                              await _pickFile();

                          if (result != null) {
                            setDialogState(() {
                              ktp = result;
                            });
                          }
                        },
                      ),

                      _uploadTile(
                        title:
                            'Sertifikat Pendidik',
                        icon:
                            Icons.workspace_premium_outlined,
                        file: sertifikat,
                        onTap: () async {
                          final result =
                              await _pickFile();

                          if (result != null) {
                            setDialogState(() {
                              sertifikat = result;
                            });
                          }
                        },
                      ),

                      _uploadTile(
                        title:
                            'SK Pembagian Tugas',
                        icon:
                            Icons.assignment_outlined,
                        file: pembagianTugas,
                        onTap: () async {
                          final result =
                              await _pickFile();

                          if (result != null) {
                            setDialogState(() {
                              pembagianTugas = result;
                            });
                          }
                        },
                      ),

                      _uploadTile(
                        title: 'Dokumen Lainnya',
                        icon:
                            Icons.folder_outlined,
                        file: lainnya,
                        onTap: () async {
                          final result =
                              await _pickFile();

                          if (result != null) {
                            setDialogState(() {
                              lainnya = result;
                            });
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
                    Navigator.pop(dialogContext);
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
                    if (namaController.text
                        .trim()
                        .isEmpty) {
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Nama guru wajib diisi.',
                          ),
                        ),
                      );
                      return;
                    }

                    final data = {
                      'nama':
                          namaController.text.trim(),
                      'nip':
                          nipController.text.trim(),
                      'nuptk':
                          nuptkController.text.trim(),
                      'jk': jk,
                      'mapel': mapel,
                      'jabatan': jabatan,
                      'noHp':
                          hpController.text.trim(),
                      'alamat':
                          alamatController.text.trim(),
                      'status': status,
                      'foto': foto,
                      'sk': sk,
                      'ijazah': ijazah,
                      'ktp': ktp,
                      'sertifikat': sertifikat,
                      'pembagianTugas':
                          pembagianTugas,
                      'lainnya': lainnya,
                    };

                    setState(() {
                      if (edit) {
                        final index =
                            guruList.indexOf(guru);

                        if (index >= 0) {
                          guruList[index] = data;
                        }
                      } else {
                        guruList.add(data);
                      }
                    });

                    Navigator.pop(dialogContext);

                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(
                      SnackBar(
                        content: Text(
                          edit
                              ? 'Data guru berhasil diperbarui.'
                              : 'Data guru berhasil ditambahkan.',
                        ),
                        behavior:
                            SnackBarBehavior.floating,
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
                        : 'Tambah Guru',
                  ),
                  style:
                      ElevatedButton.styleFrom(
                    backgroundColor: blue,
                    foregroundColor: Colors.white,
                    padding:
                        const EdgeInsets.symmetric(
                      horizontal: 17,
                      vertical: 12,
                    ),
                    shape:
                        RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(9),
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
    nipController.dispose();
    nuptkController.dispose();
    hpController.dispose();
    alamatController.dispose();
  }

  // ============================================================
  // FORM HELPERS
  // ============================================================

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(
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
      padding: const EdgeInsets.only(
        bottom: 10,
      ),
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
    final String selectedValue =
        items.contains(value)
            ? value
            : items.first;

    return Padding(
      padding: const EdgeInsets.only(
        bottom: 10,
      ),
      child: DropdownButtonFormField<String>(
        initialValue: selectedValue,
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
      margin: const EdgeInsets.only(
        bottom: 9,
      ),
      decoration: BoxDecoration(
        color: lightBlue,
        borderRadius: BorderRadius.circular(9),
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
          style: OutlinedButton.styleFrom(
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
  // DETAIL GURU
  // ============================================================

  void _showDetailGuru(
    Map<String, dynamic> guru,
  ) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,

          title: Row(
            children: [
              _photoWidget(
                guru['foto'] as Uint8List?,
                size: 48,
              ),

              const SizedBox(width: 12),

              Expanded(
                child: Text(
                  guru['nama'].toString(),
                  style: const TextStyle(
                    color: navy,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
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
                    'NIP',
                    guru['nip'],
                  ),

                  _detailRow(
                    'NUPTK',
                    guru['nuptk'],
                  ),

                  _detailRow(
                    'Jenis Kelamin',
                    guru['jk'],
                  ),

                  _detailRow(
                    'Mata Pelajaran',
                    guru['mapel'],
                  ),

                  _detailRow(
                    'Jabatan',
                    guru['jabatan'],
                  ),

                  _detailRow(
                    'No. HP',
                    guru['noHp'],
                  ),

                  _detailRow(
                    'Alamat',
                    guru['alamat'],
                  ),

                  Padding(
                    padding:
                        const EdgeInsets.symmetric(
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
                          guru['status']
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

                _showGuruDialog(
                  guru: guru,
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
                foregroundColor: Colors.white,
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
      padding: const EdgeInsets.symmetric(
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
                fontWeight: FontWeight.w600,
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

  void _deleteGuru(
    Map<String, dynamic> guru,
  ) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text(
            'Hapus Data Guru?',
            style: TextStyle(
              color: navy,
              fontWeight: FontWeight.bold,
            ),
          ),

          content: Text(
            'Data ${guru['nama']} akan dihapus dari daftar guru.',
            style: const TextStyle(
              fontSize: 13,
            ),
          ),

          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: const Text(
                'Batal',
              ),
            ),

            ElevatedButton(
              onPressed: () {
                setState(() {
                  guruList.remove(guru);
                });

                Navigator.pop(dialogContext);

                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Data guru berhasil dihapus.',
                    ),
                  ),
                );
              },
              style:
                  ElevatedButton.styleFrom(
                backgroundColor: red,
                foregroundColor: Colors.white,
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
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '$pageName sedang dalam tahap pengembangan.',
        ),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}