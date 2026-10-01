import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'login_page.dart';
import 'siswa_page.dart';
import 'guru_page.dart';
import 'dashboard_page.dart';

class SuratMasukPage extends StatefulWidget {
  const SuratMasukPage({super.key});

  @override
  State<SuratMasukPage> createState() => _SuratMasukPageState();
}

class _SuratMasukPageState extends State<SuratMasukPage> {
  // =========================================================
  // WARNA
  // =========================================================

  static const Color navy = Color(0xFF193F68);
  static const Color blue = Color(0xFF287EB4);
  static const Color background = Color(0xFFF1F5F9);
  static const Color textDark = Color(0xFF34445B);
  static const Color textGrey = Color(0xFF71839D);
  static const Color orange = Color(0xFFE67E22);
  static const Color green = Color(0xFF27AE60);
  static const Color red = Color(0xFFE74C3C);

  // =========================================================
  // DATA SURAT
  // =========================================================

  final List<Map<String, dynamic>> _suratList = [
    {
      'nomor': '001/SM/IX/2026',
      'tanggal': '01 September 2026',
      'asal': 'Dinas Pendidikan',
      'perihal': 'Undangan Rapat Koordinasi',
      'ditujukan': 'Kepala Sekolah',
      'status': 'Baru',
      'file': '',
    },
    {
      'nomor': '002/SM/IX/2026',
      'tanggal': '03 September 2026',
      'asal': 'SMP Negeri 1',
      'perihal': 'Surat Permohonan Kerja Sama',
      'ditujukan': 'Kepala Sekolah',
      'status': 'Diproses',
      'file': '',
    },
    {
      'nomor': '003/SM/IX/2026',
      'tanggal': '05 September 2026',
      'asal': 'Komite Sekolah',
      'perihal': 'Pemberitahuan Kegiatan Sekolah',
      'ditujukan': 'Wakil Kepala Sekolah',
      'status': 'Selesai',
      'file': '',
    },
  ];

  final TextEditingController _searchController = TextEditingController();

  String _searchQuery = '';

  // =========================================================
  // INIT
  // =========================================================

  @override
  void initState() {
    super.initState();

    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text.toLowerCase();
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // =========================================================
  // FILTER DATA
  // =========================================================

  List<Map<String, dynamic>> get _filteredSurat {
    if (_searchQuery.isEmpty) {
      return List<Map<String, dynamic>>.from(_suratList);
    }

    return _suratList.where((surat) {
      final nomor = surat['nomor'].toString().toLowerCase();
      final asal = surat['asal'].toString().toLowerCase();
      final perihal = surat['perihal'].toString().toLowerCase();

      return nomor.contains(_searchQuery) ||
          asal.contains(_searchQuery) ||
          perihal.contains(_searchQuery);
    }).toList();
  }

  // =========================================================
  // PILIH FILE
  // =========================================================

  Future<String?> _pickFile() async {
    try {
      final files = await FilePicker.pickFiles(
        type: FileType.custom,
        allowedExtensions: [
          'pdf',
          'jpg',
          'jpeg',
          'png',
          'doc',
          'docx',
        ],
      );

      if (files.isEmpty) {
        return null;
      }

      return files.first.name;
    } catch (e) {
      if (!mounted) return null;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal memilih file: $e'),
          backgroundColor: red,
        ),
      );

      return null;
    }
  }

  // =========================================================
  // TAMBAH SURAT
  // =========================================================

  void _showAddDialog() {
    _showSuratDialog();
  }

  // =========================================================
  // EDIT SURAT
  // =========================================================

  void _showEditDialog(Map<String, dynamic> surat, int index) {
    _showSuratDialog(
      surat: surat,
      index: index,
    );
  }

  // =========================================================
  // FORM SURAT
  // =========================================================

  void _showSuratDialog({
    Map<String, dynamic>? surat,
    int? index,
  }) {
    final bool isEdit = surat != null;

    final nomorController = TextEditingController(
      text: surat?['nomor']?.toString() ?? '',
    );

    final tanggalController = TextEditingController(
      text: surat?['tanggal']?.toString() ?? '',
    );

    final asalController = TextEditingController(
      text: surat?['asal']?.toString() ?? '',
    );

    final perihalController = TextEditingController(
      text: surat?['perihal']?.toString() ?? '',
    );

    final ditujukanController = TextEditingController(
      text: surat?['ditujukan']?.toString() ?? '',
    );

    String status = surat?['status']?.toString() ?? 'Baru';

    String fileName = surat?['file']?.toString() ?? '';

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              title: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: blue.withOpacity(0.10),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.mail_outline,
                      color: blue,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    isEdit ? 'Edit Surat Masuk' : 'Tambah Surat Masuk',
                    style: const TextStyle(
                      color: navy,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
              content: SizedBox(
                width: 600,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      _buildTextField(
                        controller: nomorController,
                        label: 'Nomor Surat',
                        hint: 'Contoh: 004/SM/IX/2026',
                        icon: Icons.numbers,
                      ),

                      const SizedBox(height: 14),

                      _buildTextField(
                        controller: tanggalController,
                        label: 'Tanggal Surat',
                        hint: 'Contoh: 10 September 2026',
                        icon: Icons.calendar_today_outlined,
                      ),

                      const SizedBox(height: 14),

                      _buildTextField(
                        controller: asalController,
                        label: 'Asal Surat',
                        hint: 'Contoh: Dinas Pendidikan',
                        icon: Icons.business_outlined,
                      ),

                      const SizedBox(height: 14),

                      _buildTextField(
                        controller: perihalController,
                        label: 'Perihal',
                        hint: 'Masukkan perihal surat',
                        icon: Icons.subject,
                        maxLines: 2,
                      ),

                      const SizedBox(height: 14),

                      _buildTextField(
                        controller: ditujukanController,
                        label: 'Ditujukan Kepada',
                        hint: 'Contoh: Kepala Sekolah',
                        icon: Icons.person_outline,
                      ),

                      const SizedBox(height: 14),

                      // STATUS
                      DropdownButtonFormField<String>(
                        initialValue: status,
                        decoration: InputDecoration(
                          labelText: 'Status',
                          prefixIcon: const Icon(
                            Icons.flag_outlined,
                            color: blue,
                          ),
                          filled: true,
                          fillColor: background,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        items: const [
                          DropdownMenuItem(
                            value: 'Baru',
                            child: Text('Baru'),
                          ),
                          DropdownMenuItem(
                            value: 'Diproses',
                            child: Text('Diproses'),
                          ),
                          DropdownMenuItem(
                            value: 'Selesai',
                            child: Text('Selesai'),
                          ),
                        ],
                        onChanged: (value) {
                          if (value != null) {
                            setDialogState(() {
                              status = value;
                            });
                          }
                        },
                      ),

                      const SizedBox(height: 16),

                      // FILE
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: background,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: const Color(0xFFE0E6ED),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Lampiran Surat',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: textDark,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                ElevatedButton.icon(
                                  onPressed: () async {
                                    final result = await _pickFile();

                                    if (result != null) {
                                      setDialogState(() {
                                        fileName = result;
                                      });
                                    }
                                  },
                                  icon: const Icon(Icons.upload_file),
                                  label: const Text('Pilih File'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: blue,
                                    foregroundColor: Colors.white,
                                    elevation: 0,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 12,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(10),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    fileName.isEmpty
                                        ? 'Belum ada file'
                                        : fileName,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: fileName.isEmpty
                                          ? textGrey
                                          : textDark,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            const Text(
                              'Format: PDF, JPG, JPEG, PNG, DOC, DOCX',
                              style: TextStyle(
                                fontSize: 12,
                                color: textGrey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              actionsPadding: const EdgeInsets.fromLTRB(
                24,
                0,
                24,
                20,
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
                ElevatedButton(
                  onPressed: () {
                    if (nomorController.text.trim().isEmpty ||
                        tanggalController.text.trim().isEmpty ||
                        asalController.text.trim().isEmpty ||
                        perihalController.text.trim().isEmpty ||
                        ditujukanController.text.trim().isEmpty) {
                      ScaffoldMessenger.of(this.context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Mohon lengkapi semua data surat.',
                          ),
                          backgroundColor: red,
                        ),
                      );
                      return;
                    }

                    final data = {
                      'nomor': nomorController.text.trim(),
                      'tanggal': tanggalController.text.trim(),
                      'asal': asalController.text.trim(),
                      'perihal': perihalController.text.trim(),
                      'ditujukan': ditujukanController.text.trim(),
                      'status': status,
                      'file': fileName,
                    };

                    setState(() {
                      if (isEdit && index != null) {
                        _suratList[index] = data;
                      } else {
                        _suratList.add(data);
                      }
                    });

                    Navigator.pop(dialogContext);

                    ScaffoldMessenger.of(this.context).showSnackBar(
                      SnackBar(
                        content: Text(
                          isEdit
                              ? 'Data surat berhasil diperbarui.'
                              : 'Surat masuk berhasil ditambahkan.',
                        ),
                        backgroundColor: green,
                      ),
                    );
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
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    isEdit ? 'Simpan Perubahan' : 'Simpan',
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  // =========================================================
  // TEXT FIELD
  // =========================================================

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    int maxLines = 1,
  }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      style: const TextStyle(
        color: textDark,
      ),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(
          icon,
          color: blue,
        ),
        filled: true,
        fillColor: background,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: blue,
            width: 1.5,
          ),
        ),
      ),
    );
  }

  // =========================================================
  // DETAIL SURAT
  // =========================================================

  void _showDetailDialog(Map<String, dynamic> surat) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: blue.withOpacity(0.10),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.mail_outline,
                  color: blue,
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  'Detail Surat Masuk',
                  style: TextStyle(
                    color: navy,
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
                  _detailItem(
                    'Nomor Surat',
                    surat['nomor'].toString(),
                    Icons.numbers,
                  ),
                  _detailItem(
                    'Tanggal',
                    surat['tanggal'].toString(),
                    Icons.calendar_today_outlined,
                  ),
                  _detailItem(
                    'Asal Surat',
                    surat['asal'].toString(),
                    Icons.business_outlined,
                  ),
                  _detailItem(
                    'Perihal',
                    surat['perihal'].toString(),
                    Icons.subject,
                  ),
                  _detailItem(
                    'Ditujukan Kepada',
                    surat['ditujukan'].toString(),
                    Icons.person_outline,
                  ),
                  _detailItem(
                    'Status',
                    surat['status'].toString(),
                    Icons.flag_outlined,
                  ),
                  _detailItem(
                    'Lampiran',
                    surat['file'].toString().isEmpty
                        ? 'Tidak ada lampiran'
                        : surat['file'].toString(),
                    Icons.attach_file,
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
                'Tutup',
                style: TextStyle(
                  color: navy,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  // =========================================================
  // DETAIL ITEM
  // =========================================================

  Widget _detailItem(
    String title,
    String value,
    IconData icon,
  ) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: 21,
            color: blue,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 12,
                    color: textGrey,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 14,
                    color: textDark,
                    fontWeight: FontWeight.w600,
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
  // HAPUS
  // =========================================================

  void _deleteSurat(int index) {
    final surat = _filteredSurat[index];

    final realIndex = _suratList.indexOf(surat);

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          title: const Text(
            'Hapus Surat?',
            style: TextStyle(
              color: navy,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            'Data surat "${surat['nomor']}" akan dihapus. Apakah kamu yakin?',
            style: const TextStyle(
              color: textDark,
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
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _suratList.removeAt(realIndex);
                });

                Navigator.pop(dialogContext);

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Data surat berhasil dihapus.',
                    ),
                    backgroundColor: green,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: red,
                foregroundColor: Colors.white,
                elevation: 0,
              ),
              child: const Text('Hapus'),
            ),
          ],
        );
      },
    );
  }

  // =========================================================
  // STATUS BADGE
  // =========================================================

  Widget _statusBadge(String status) {
    Color color;

    if (status == 'Baru') {
      color = blue;
    } else if (status == 'Diproses') {
      color = orange;
    } else {
      color = green;
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
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  // =========================================================
  // SEARCH BAR
  // =========================================================

  Widget _buildSearchBar() {
    return TextField(
      controller: _searchController,
      decoration: InputDecoration(
        hintText: 'Cari nomor, asal, atau perihal surat...',
        hintStyle: const TextStyle(
          color: textGrey,
          fontSize: 14,
        ),
        prefixIcon: const Icon(
          Icons.search,
          color: blue,
        ),
        suffixIcon: _searchController.text.isNotEmpty
            ? IconButton(
                onPressed: () {
                  _searchController.clear();
                },
                icon: const Icon(
                  Icons.clear,
                  color: textGrey,
                ),
              )
            : null,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(
            color: blue,
            width: 1.2,
          ),
        ),
      ),
    );
  }

  // =========================================================
  // MOBILE CARD
  // =========================================================

  Widget _buildMobileCard(
    Map<String, dynamic> surat,
    int index,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: blue.withOpacity(0.10),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.mail_outline,
                  color: blue,
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      surat['nomor'].toString(),
                      style: const TextStyle(
                        color: navy,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      surat['tanggal'].toString(),
                      style: const TextStyle(
                        color: textGrey,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              _statusBadge(
                surat['status'].toString(),
              ),
            ],
          ),

          const SizedBox(height: 16),

          _mobileInfo(
            'Asal Surat',
            surat['asal'].toString(),
          ),

          const SizedBox(height: 9),

          _mobileInfo(
            'Perihal',
            surat['perihal'].toString(),
          ),

          const SizedBox(height: 9),

          _mobileInfo(
            'Ditujukan',
            surat['ditujukan'].toString(),
          ),

          if (surat['file'].toString().isNotEmpty) ...[
            const SizedBox(height: 10),
            Row(
              children: [
                const Icon(
                  Icons.attach_file,
                  size: 17,
                  color: blue,
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    surat['file'].toString(),
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: blue,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ],

          const SizedBox(height: 14),

          const Divider(
            height: 1,
            color: Color(0xFFE8EDF2),
          ),

          const SizedBox(height: 10),

          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                tooltip: 'Detail',
                onPressed: () {
                  _showDetailDialog(surat);
                },
                icon: const Icon(
                  Icons.visibility_outlined,
                  color: blue,
                ),
              ),
              IconButton(
                tooltip: 'Edit',
                onPressed: () {
                  final realIndex = _suratList.indexOf(surat);
                  _showEditDialog(
                    surat,
                    realIndex,
                  );
                },
                icon: const Icon(
                  Icons.edit_outlined,
                  color: orange,
                ),
              ),
              IconButton(
                tooltip: 'Hapus',
                onPressed: () {
                  _deleteSurat(index);
                },
                icon: const Icon(
                  Icons.delete_outline,
                  color: red,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _mobileInfo(
    String title,
    String value,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 95,
          child: Text(
            title,
            style: const TextStyle(
              color: textGrey,
              fontSize: 12,
            ),
          ),
        ),
        const Text(
          ':',
          style: TextStyle(
            color: textGrey,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              color: textDark,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  // =========================================================
  // DESKTOP TABLE
  // =========================================================

  Widget _buildDesktopTable() {
    final data = _filteredSurat;

    if (data.isEmpty) {
      return _buildEmptyState();
    }

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            headingRowColor: WidgetStateProperty.all(
              const Color(0xFFF7F9FC),
            ),
            columnSpacing: 30,
            horizontalMargin: 20,
            dataRowMinHeight: 68,
            dataRowMaxHeight: 80,
            columns: const [
              DataColumn(
                label: Text(
                  'No',
                  style: TextStyle(
                    color: navy,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              DataColumn(
                label: Text(
                  'Nomor Surat',
                  style: TextStyle(
                    color: navy,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              DataColumn(
                label: Text(
                  'Tanggal',
                  style: TextStyle(
                    color: navy,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              DataColumn(
                label: Text(
                  'Asal Surat',
                  style: TextStyle(
                    color: navy,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              DataColumn(
                label: Text(
                  'Perihal',
                  style: TextStyle(
                    color: navy,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              DataColumn(
                label: Text(
                  'Ditujukan',
                  style: TextStyle(
                    color: navy,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              DataColumn(
                label: Text(
                  'Status',
                  style: TextStyle(
                    color: navy,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              DataColumn(
                label: Text(
                  'Aksi',
                  style: TextStyle(
                    color: navy,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
            rows: List.generate(
              data.length,
              (index) {
                final surat = data[index];

                return DataRow(
                  cells: [
                    DataCell(
                      Text(
                        '${index + 1}',
                        style: const TextStyle(
                          color: textDark,
                        ),
                      ),
                    ),
                    DataCell(
                      Text(
                        surat['nomor'].toString(),
                        style: const TextStyle(
                          color: navy,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    DataCell(
                      Text(
                        surat['tanggal'].toString(),
                        style: const TextStyle(
                          color: textDark,
                        ),
                      ),
                    ),
                    DataCell(
                      Text(
                        surat['asal'].toString(),
                        style: const TextStyle(
                          color: textDark,
                        ),
                      ),
                    ),
                    DataCell(
                      SizedBox(
                        width: 220,
                        child: Text(
                          surat['perihal'].toString(),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: textDark,
                          ),
                        ),
                      ),
                    ),
                    DataCell(
                      Text(
                        surat['ditujukan'].toString(),
                        style: const TextStyle(
                          color: textDark,
                        ),
                      ),
                    ),
                    DataCell(
                      _statusBadge(
                        surat['status'].toString(),
                      ),
                    ),
                    DataCell(
                      Row(
                        children: [
                          IconButton(
                            tooltip: 'Detail',
                            onPressed: () {
                              _showDetailDialog(surat);
                            },
                            icon: const Icon(
                              Icons.visibility_outlined,
                              color: blue,
                              size: 20,
                            ),
                          ),
                          IconButton(
                            tooltip: 'Edit',
                            onPressed: () {
                              final realIndex =
                                  _suratList.indexOf(surat);

                              _showEditDialog(
                                surat,
                                realIndex,
                              );
                            },
                            icon: const Icon(
                              Icons.edit_outlined,
                              color: orange,
                              size: 20,
                            ),
                          ),
                          IconButton(
                            tooltip: 'Hapus',
                            onPressed: () {
                              _deleteSurat(index);
                            },
                            icon: const Icon(
                              Icons.delete_outline,
                              color: red,
                              size: 20,
                            ),
                          ),
                        ],
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

  // =========================================================
  // EMPTY STATE
  // =========================================================

  Widget _buildEmptyState() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        vertical: 60,
        horizontal: 20,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: blue.withOpacity(0.08),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.mail_outline,
              size: 40,
              color: blue,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Data surat tidak ditemukan',
            style: TextStyle(
              color: navy,
              fontSize: 17,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Coba gunakan kata kunci pencarian yang berbeda.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: textGrey,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  // =========================================================
  // HEADER
  // =========================================================

  Widget _buildHeader() {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Surat Masuk',
                style: TextStyle(
                  color: navy,
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                'Kelola data surat masuk sekolah',
                style: TextStyle(
                  color: textGrey,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
        ElevatedButton.icon(
          onPressed: _showAddDialog,
          icon: const Icon(
            Icons.add,
            size: 20,
          ),
          label: const Text(
            'Tambah Surat',
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: navy,
            foregroundColor: Colors.white,
            elevation: 0,
            padding: const EdgeInsets.symmetric(
              horizontal: 18,
              vertical: 14,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ],
    );
  }

  // =========================================================
  // SIDEBAR DESKTOP
  // =========================================================

  Widget _sidebar(BuildContext context) {
    return Container(
      width: 260,
      color: Colors.white,
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
              letterSpacing: .7,
            ),
          ),

          const SizedBox(height: 35),

          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: Column(
                children: [
                  _menuItem(
                    context,
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
                  _menuItem(
                    context,
                    Icons.mail_outline,
                    'Surat Masuk',
                    true,
                    () {},
                  ),
                  _menuItem(
                    context,
                    Icons.send_outlined,
                    'Surat Keluar',
                    false,
                    () {
                      _comingSoon(context, 'Surat Keluar');
                    },
                  ),
                  _menuItem(
                    context,
                    Icons.bar_chart,
                    'Laporan',
                    false,
                    () {
                      _comingSoon(context, 'Laporan');
                    },
                  ),

                  const Spacer(),

                  _logoutMenuItem(context),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // =========================================================
  // MENU ITEM
  // =========================================================

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
                color: active
                    ? Colors.white
                    : const Color(0xFF50627A),
              ),
              const SizedBox(width: 20),
              Text(
                title,
                style: TextStyle(
                  color: active ? Colors.white : navy,
                  fontSize: 18,
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

  // =========================================================
  // COMING SOON
  // =========================================================

  void _comingSoon(BuildContext context, String title) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$title belum dibuat.'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  // =========================================================
  // LOGOUT
  // =========================================================

  Widget _logoutMenuItem(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => const LoginPage(),
            ),
          );
        },
        borderRadius: BorderRadius.circular(10),
        child: Container(
          width: double.infinity,
          height: 55,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
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
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // =========================================================
  // HEADER DESKTOP
  // =========================================================

  Widget _desktopHeader() {
    return Container(
      height: 112,
      color: navy,
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Row(
        children: [
          const Expanded(
            child: Text(
              'Surat Masuk',
              style: TextStyle(
                color: Colors.white,
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 10,
            ),
            decoration: BoxDecoration(
              color: const Color(0xFF205B8B),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: const Color(0xFF286D9F),
              ),
            ),
            child: const Row(
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundColor: Color(0xFF3C87BE),
                  child: Icon(
                    Icons.person,
                    color: Colors.white,
                    size: 27,
                  ),
                ),
                SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
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

  // =========================================================
  // MOBILE DRAWER
  // =========================================================

  Widget _mobileDrawer(BuildContext context) {
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
                letterSpacing: .7,
              ),
            ),

            const SizedBox(height: 35),

            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                child: Column(
                  children: [
                    _menuItem(
                      context,
                      Icons.dashboard_outlined,
                      'Dashboard',
                      false,
                      () {
                        Navigator.pop(context);
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const DashboardPage(),
                          ),
                        );
                      },
                    ),
                    _menuItem(
                      context,
                      Icons.people_outline,
                      'Data Siswa',
                      false,
                      () {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const SiswaPage(),
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
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const GuruPage(),
                          ),
                        );
                      },
                    ),
                    _menuItem(
                      context,
                      Icons.mail_outline,
                      'Surat Masuk',
                      true,
                      () {
                        Navigator.pop(context);
                      },
                    ),
                    _menuItem(
                      context,
                      Icons.send_outlined,
                      'Surat Keluar',
                      false,
                      () {
                        Navigator.pop(context);
                        _comingSoon(context, 'Surat Keluar');
                      },
                    ),
                    _menuItem(
                      context,
                      Icons.bar_chart,
                      'Laporan',
                      false,
                      () {
                        Navigator.pop(context);
                        _comingSoon(context, 'Laporan');
                      },
                    ),

                    const Spacer(),

                    _logoutMenuItem(context),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // =========================================================
  // MAIN CONTENT
  // =========================================================

  Widget _mainContent() {
    return Column(
      children: [
        _header(),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 20, 24, 90),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _pageTitle(),
                const SizedBox(height: 22),
                _buildSearchBar(),
                const SizedBox(height: 20),
                LayoutBuilder(
                  builder: (context, constraints) {
                    if (_filteredSurat.isEmpty) {
                      return _buildEmptyState();
                    }

                    if (constraints.maxWidth < 700) {
                      return Column(
                        children: List.generate(
                          _filteredSurat.length,
                          (index) => _buildMobileCard(
                            _filteredSurat[index],
                            index,
                          ),
                        ),
                      );
                    }

                    return _buildDesktopTable();
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // =========================================================
  // HEADER
  // =========================================================

  Widget _header() {
    return Container(
      height: 76,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 22),
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
              'Surat Masuk',
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

  // =========================================================
  // PAGE TITLE
  // =========================================================

  Widget _pageTitle() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final bool mobile = constraints.maxWidth < 600;

        if (mobile) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Surat Masuk',
                style: TextStyle(
                  color: navy,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 5),
              const Text(
                'Kelola data surat masuk sekolah',
                style: TextStyle(
                  color: textGrey,
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 15),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _showAddDialog,
                  icon: const Icon(Icons.add, size: 20),
                  label: const Text('Tambah Surat'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: navy,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(
                      vertical: 13,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
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
                    'Surat Masuk',
                    style: TextStyle(
                      color: navy,
                      fontSize: 27,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    'Kelola data surat masuk sekolah',
                    style: TextStyle(
                      color: textGrey,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            ElevatedButton.icon(
              onPressed: _showAddDialog,
              icon: const Icon(Icons.add, size: 20),
              label: const Text('Tambah Surat'),
              style: ElevatedButton.styleFrom(
                backgroundColor: navy,
                foregroundColor: Colors.white,
                elevation: 0,
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 14,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  // =========================================================
  // MAIN BUILD
  // =========================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      drawer: _mobileDrawer(context),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final bool desktop = constraints.maxWidth >= 900;

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
}
