import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class SuratMasukPage extends StatefulWidget {
  const SuratMasukPage({super.key});

  @override
  State<SuratMasukPage> createState() => _SuratMasukPageState();
}

class _SuratMasukPageState extends State<SuratMasukPage> {
  static const Color navy = Color(0xFF193F68);
  static const Color blue = Color(0xFF287EB4);
  static const Color background = Color(0xFFF1F5F9);
  static const Color textDark = Color(0xFF34445B);
  static const Color textGrey = Color(0xFF71839D);
  static const Color orange = Color(0xFFE67E22);

  final TextEditingController _searchController = TextEditingController();

  final List<Map<String, dynamic>> _suratList = [
    {
      'nomor': '001/SM/IX/2026',
      'tanggal': '01 September 2026',
      'asal': 'Dinas Pendidikan',
      'perihal': 'Undangan Rapat Koordinasi',
      'penerima': 'Kepala Sekolah',
      'status': 'Baru',
      'file': null,
    },
    {
      'nomor': '002/SM/IX/2026',
      'tanggal': '03 September 2026',
      'asal': 'SMP Negeri 1',
      'perihal': 'Surat Permohonan Kerja Sama',
      'penerima': 'Kepala Sekolah',
      'status': 'Diproses',
      'file': null,
    },
    {
      'nomor': '003/SM/IX/2026',
      'tanggal': '05 September 2026',
      'asal': 'Komite Sekolah',
      'perihal': 'Pemberitahuan Kegiatan Sekolah',
      'penerima': 'Wakil Kepala Sekolah',
      'status': 'Selesai',
      'file': null,
    },
  ];

  String _searchQuery = '';

  List<Map<String, dynamic>> get _filteredSurat {
    if (_searchQuery.isEmpty) {
      return _suratList;
    }

    return _suratList.where((surat) {
      final nomor = surat['nomor'].toString().toLowerCase();
      final asal = surat['asal'].toString().toLowerCase();
      final perihal = surat['perihal'].toString().toLowerCase();

      return nomor.contains(_searchQuery.toLowerCase()) ||
          asal.contains(_searchQuery.toLowerCase()) ||
          perihal.contains(_searchQuery.toLowerCase());
    }).toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Future<void> _pickFile(
    void Function(String name, Uint8List bytes) onSelected,
  ) async {
    final List<PlatformFile> files = await FilePicker.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png', 'doc', 'docx'],
      withData: true,
    );

    if (files.isEmpty) return;

    final PlatformFile file = files.first;

    if (file.xFile == null) {
      _showMessage('File tidak dapat dibaca.');
      return;
    }

    final Uint8List bytes = await file.xFile!.readAsBytes();

    onSelected(file.name, bytes);
  }

  void _showSuratForm({
    Map<String, dynamic>? surat,
    int? index,
  }) {
    final bool isEdit = surat != null;

    final nomorController = TextEditingController(
      text: surat?['nomor'] ?? '',
    );

    final tanggalController = TextEditingController(
      text: surat?['tanggal'] ?? '',
    );

    final asalController = TextEditingController(
      text: surat?['asal'] ?? '',
    );

    final perihalController = TextEditingController(
      text: surat?['perihal'] ?? '',
    );

    final penerimaController = TextEditingController(
      text: surat?['penerima'] ?? '',
    );

    String status = surat?['status'] ?? 'Baru';

    String? fileName = surat?['file'];

    Uint8List? fileBytes = surat?['fileBytes'];

    showDialog(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Text(
                isEdit ? 'Edit Surat Masuk' : 'Tambah Surat Masuk',
                style: const TextStyle(
                  color: navy,
                  fontWeight: FontWeight.bold,
                ),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
              content: SizedBox(
                width: 550,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _formField(
                        controller: nomorController,
                        label: 'Nomor Surat',
                        hint: 'Contoh: 001/SM/IX/2026',
                        icon: Icons.numbers_outlined,
                      ),
                      const SizedBox(height: 14),
                      _formField(
                        controller: tanggalController,
                        label: 'Tanggal Surat',
                        hint: 'Contoh: 01 September 2026',
                        icon: Icons.calendar_today_outlined,
                      ),
                      const SizedBox(height: 14),
                      _formField(
                        controller: asalController,
                        label: 'Asal Surat',
                        hint: 'Contoh: Dinas Pendidikan',
                        icon: Icons.business_outlined,
                      ),
                      const SizedBox(height: 14),
                      _formField(
                        controller: perihalController,
                        label: 'Perihal',
                        hint: 'Masukkan perihal surat',
                        icon: Icons.subject_outlined,
                      ),
                      const SizedBox(height: 14),
                      _formField(
                        controller: penerimaController,
                        label: 'Ditujukan Kepada',
                        hint: 'Contoh: Kepala Sekolah',
                        icon: Icons.person_outline,
                      ),
                      const SizedBox(height: 14),
                      DropdownButtonFormField<String>(
                        initialValue: status,
                        decoration: InputDecoration(
                          labelText: 'Status Surat',
                          prefixIcon: const Icon(Icons.flag_outlined),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
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
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: background,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.grey.shade300,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Dokumen Surat',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: textDark,
                              ),
                            ),
                            const SizedBox(height: 10),
                            if (fileName != null)
                              Row(
                                children: [
                                  const Icon(
                                    Icons.insert_drive_file_outlined,
                                    color: blue,
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      fileName!,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      setDialogState(() {
                                        fileName = null;
                                        fileBytes = null;
                                      });
                                    },
                                    icon: const Icon(
                                      Icons.close,
                                      color: Colors.red,
                                    ),
                                  ),
                                ],
                              ),
                            const SizedBox(height: 4),
                            OutlinedButton.icon(
                              onPressed: () async {
                                await _pickFile(
                                  (name, bytes) {
                                    setDialogState(() {
                                      fileName = name;
                                      fileBytes = bytes;
                                    });
                                  },
                                );
                              },
                              icon: const Icon(
                                Icons.upload_file_outlined,
                              ),
                              label: Text(
                                fileName == null
                                    ? 'Pilih File'
                                    : 'Ganti File',
                              ),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: blue,
                              ),
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
                    Navigator.pop(dialogContext);
                  },
                  child: const Text('Batal'),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (nomorController.text.trim().isEmpty ||
                        tanggalController.text.trim().isEmpty ||
                        asalController.text.trim().isEmpty ||
                        perihalController.text.trim().isEmpty ||
                        penerimaController.text.trim().isEmpty) {
                      _showMessage(
                        'Mohon lengkapi semua data surat.',
                      );
                      return;
                    }

                    final data = {
                      'nomor': nomorController.text.trim(),
                      'tanggal': tanggalController.text.trim(),
                      'asal': asalController.text.trim(),
                      'perihal': perihalController.text.trim(),
                      'penerima': penerimaController.text.trim(),
                      'status': status,
                      'file': fileName,
                      'fileBytes': fileBytes,
                    };

                    setState(() {
                      if (isEdit && index != null) {
                        _suratList[index] = data;
                      } else {
                        _suratList.add(data);
                      }
                    });

                    Navigator.pop(dialogContext);

                    _showMessage(
                      isEdit
                          ? 'Data surat berhasil diperbarui.'
                          : 'Surat masuk berhasil ditambahkan.',
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: blue,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 22,
                      vertical: 13,
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

  Widget _formField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
  }) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  void _showDetail(Map<String, dynamic> surat) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            'Detail Surat Masuk',
            style: TextStyle(
              color: navy,
              fontWeight: FontWeight.bold,
            ),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          content: SizedBox(
            width: 500,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _detailItem(
                    'Nomor Surat',
                    surat['nomor'],
                    Icons.numbers_outlined,
                  ),
                  _detailItem(
                    'Tanggal',
                    surat['tanggal'],
                    Icons.calendar_today_outlined,
                  ),
                  _detailItem(
                    'Asal Surat',
                    surat['asal'],
                    Icons.business_outlined,
                  ),
                  _detailItem(
                    'Perihal',
                    surat['perihal'],
                    Icons.subject_outlined,
                  ),
                  _detailItem(
                    'Ditujukan Kepada',
                    surat['penerima'],
                    Icons.person_outline,
                  ),
                  _detailItem(
                    'Status',
                    surat['status'],
                    Icons.flag_outlined,
                  ),
                  _detailItem(
                    'Dokumen',
                    surat['file'] ?? 'Tidak ada dokumen',
                    Icons.insert_drive_file_outlined,
                  ),
                ],
              ),
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: blue,
                foregroundColor: Colors.white,
              ),
              child: const Text('Tutup'),
            ),
          ],
        );
      },
    );
  }

  Widget _detailItem(
    String label,
    dynamic value,
    IconData icon,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: 22,
            color: blue,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 12,
                    color: textGrey,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  value.toString(),
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: textDark,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _deleteSurat(int index) {
    final surat = _filteredSurat[index];

    final originalIndex = _suratList.indexOf(surat);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Hapus Surat'),
          content: Text(
            'Apakah kamu yakin ingin menghapus surat '
            '${surat['nomor']}?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _suratList.removeAt(originalIndex);
                });

                Navigator.pop(context);

                _showMessage(
                  'Surat berhasil dihapus.',
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: const Text('Hapus'),
            ),
          ],
        );
      },
    );
  }

  Widget _statusBadge(String status) {
    Color color;

    switch (status) {
      case 'Selesai':
        color = Colors.green;
        break;
      case 'Diproses':
        color = orange;
        break;
      default:
        color = blue;
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
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

  Widget _buildDesktopTable() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
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
              const Color(0xFFF8FAFC),
            ),
            columnSpacing: 25,
            dataRowMinHeight: 70,
            dataRowMaxHeight: 80,
            columns: const [
              DataColumn(
                label: Text(
                  'No.',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: textDark,
                  ),
                ),
              ),
              DataColumn(
                label: Text(
                  'Nomor Surat',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: textDark,
                  ),
                ),
              ),
              DataColumn(
                label: Text(
                  'Tanggal',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: textDark,
                  ),
                ),
              ),
              DataColumn(
                label: Text(
                  'Asal Surat',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: textDark,
                  ),
                ),
              ),
              DataColumn(
                label: Text(
                  'Perihal',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: textDark,
                  ),
                ),
              ),
              DataColumn(
                label: Text(
                  'Status',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: textDark,
                  ),
                ),
              ),
              DataColumn(
                label: Text(
                  'Aksi',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: textDark,
                  ),
                ),
              ),
            ],
            rows: List.generate(
              _filteredSurat.length,
              (index) {
                final surat = _filteredSurat[index];
                final originalIndex =
                    _suratList.indexOf(surat);

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
                      SizedBox(
                        width: 150,
                        child: Text(
                          surat['nomor'],
                          style: const TextStyle(
                            color: textDark,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    DataCell(
                      Text(
                        surat['tanggal'],
                        style: const TextStyle(
                          color: textGrey,
                        ),
                      ),
                    ),
                    DataCell(
                      SizedBox(
                        width: 150,
                        child: Text(
                          surat['asal'],
                          style: const TextStyle(
                            color: textDark,
                          ),
                        ),
                      ),
                    ),
                    DataCell(
                      SizedBox(
                        width: 220,
                        child: Text(
                          surat['perihal'],
                          style: const TextStyle(
                            color: textDark,
                          ),
                        ),
                      ),
                    ),
                    DataCell(
                      _statusBadge(surat['status']),
                    ),
                    DataCell(
                      Row(
                        children: [
                          IconButton(
                            tooltip: 'Detail',
                            onPressed: () {
                              _showDetail(surat);
                            },
                            icon: const Icon(
                              Icons.visibility_outlined,
                              color: blue,
                            ),
                          ),
                          IconButton(
                            tooltip: 'Edit',
                            onPressed: () {
                              _showSuratForm(
                                surat: surat,
                                index: originalIndex,
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
                              color: Colors.red,
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

  Widget _buildMobileCard(
    Map<String, dynamic> surat,
    int index,
  ) {
    final originalIndex = _suratList.indexOf(surat);

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 45,
                height: 45,
                decoration: BoxDecoration(
                  color: blue.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.mail_outline,
                  color: blue,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Text(
                      surat['nomor'],
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: textDark,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      surat['tanggal'],
                      style: const TextStyle(
                        fontSize: 12,
                        color: textGrey,
                      ),
                    ),
                  ],
                ),
              ),
              _statusBadge(surat['status']),
            ],
          ),
          const SizedBox(height: 16),
          _mobileInfo(
            'Asal Surat',
            surat['asal'],
          ),
          _mobileInfo(
            'Perihal',
            surat['perihal'],
          ),
          _mobileInfo(
            'Ditujukan Kepada',
            surat['penerima'],
          ),
          const Divider(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton.icon(
                onPressed: () => _showDetail(surat),
                icon: const Icon(
                  Icons.visibility_outlined,
                  size: 18,
                ),
                label: const Text('Detail'),
              ),
              TextButton.icon(
                onPressed: () {
                  _showSuratForm(
                    surat: surat,
                    index: originalIndex,
                  );
                },
                icon: const Icon(
                  Icons.edit_outlined,
                  size: 18,
                ),
                label: const Text('Edit'),
              ),
              TextButton.icon(
                onPressed: () => _deleteSurat(index),
                icon: const Icon(
                  Icons.delete_outline,
                  size: 18,
                  color: Colors.red,
                ),
                label: const Text(
                  'Hapus',
                  style: TextStyle(
                    color: Colors.red,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _mobileInfo(
    String label,
    String value,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 115,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                color: textGrey,
              ),
            ),
          ),
          const Text(':  '),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 13,
                color: textDark,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _searchBox() {
    return Container(
      width: 380,
      height: 48,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        controller: _searchController,
        onChanged: (value) {
          setState(() {
            _searchQuery = value;
          });
        },
        decoration: const InputDecoration(
          hintText: 'Cari nomor, asal, atau perihal...',
          prefixIcon: Icon(
            Icons.search,
            color: textGrey,
          ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(
            vertical: 14,
          ),
        ),
      ),
    );
  }

  Widget _headerActions() {
    return Row(
      children: [
        Expanded(
          child: _searchBox(),
        ),
        const SizedBox(width: 12),
        ElevatedButton.icon(
          onPressed: () => _showSuratForm(),
          icon: const Icon(Icons.add),
          label: const Text('Tambah Surat'),
          style: ElevatedButton.styleFrom(
            backgroundColor: blue,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(
              horizontal: 18,
              vertical: 14,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      ],
    );
  }

  Widget _mobileHeaderActions() {
    return Column(
      children: [
        _searchBox(),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () => _showSuratForm(),
            icon: const Icon(Icons.add),
            label: const Text('Tambah Surat'),
            style: ElevatedButton.styleFrom(
              backgroundColor: blue,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(
                vertical: 14,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        backgroundColor: navy,
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Row(
          children: [
            Icon(Icons.mail_outline),
            SizedBox(width: 10),
            Text(
              'Surat Masuk',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final bool isMobile = constraints.maxWidth < 800;

          return Padding(
            padding: EdgeInsets.all(
              isMobile ? 16 : 28,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (!isMobile) ...[
                  const Text(
                    'Data Surat Masuk',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: textDark,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Kelola surat masuk yang diterima oleh sekolah.',
                    style: TextStyle(
                      color: textGrey,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 24),
                  _headerActions(),
                ] else ...[
                  const Text(
                    'Data Surat Masuk',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: textDark,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Kelola surat masuk sekolah.',
                    style: TextStyle(
                      color: textGrey,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 20),
                  _mobileHeaderActions(),
                ],
                const SizedBox(height: 24),
                Expanded(
                  child: _filteredSurat.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment:
                                MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.mail_outline,
                                size: 70,
                                color: Colors.grey.shade300,
                              ),
                              const SizedBox(height: 14),
                              const Text(
                                'Data surat tidak ditemukan.',
                                style: TextStyle(
                                  color: textGrey,
                                  fontSize: 15,
                                ),
                              ),
                            ],
                          ),
                        )
                      : isMobile
                          ? ListView.builder(
                              itemCount: _filteredSurat.length,
                              itemBuilder: (context, index) {
                                return _buildMobileCard(
                                  _filteredSurat[index],
                                  index,
                                );
                              },
                            )
                          : SingleChildScrollView(
                              child: _buildDesktopTable(),
                            ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}